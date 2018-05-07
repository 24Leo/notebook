## 网页版微信登录模拟

[转载 http://www.tanhao.me/talk/1466.html/](http://www.tanhao.me/talk/1466.html/)

下面就详细解说一下微信Web版的流程：

1.与服务器建立一个会话ID:
```C
微信Web版本不使用用户名和密码登录，而是采用二维码登录，所以服务器需要首先分配一个唯一的会话ID：用来标识当前的一次登录
通过请求地址：

https://login.weixin.qq.com/jslogin?appid=wx782c26e4c19acffb&redirect_uri=https%3A%2F%2
    Fwx.qq.com%2Fcgi-bin%2Fmmwebwx-bin%2Fwebwxnewloginpage&fun=new&lang=zh_CN&_=1377482012272
    （其中1377482012272这个值是当前距离林威治标准时间的毫秒）

服务器会返回如下的字符串：
window.QRLogin.code = 200; window.QRLogin.uuid = “DeA6idundY9VKn”;
而这个DeA6idundY9VKn（每一次都不同）字符串就是微信服务器返回给我们这次会话的ID。
```

2.通过会话ID获得二维码
```C
既然微信Web版本是通过二维码进行登录，如何获得这个随机的二维码呢？答案就是利用刚才获得的ID去请求服务器生成的二维码，
通过上面的ID我们组合得到以下的URL地址：
    https://login.weixin.qq.com/qrcode/DeA6idundY9VKn?t=webwx
该请求返回的便是我们需要的二维码，此时需要用户在微信的手机版本中扫描这个二维码
```

3.**轮询**手机端是否已经扫描二维码并确认在Web端登录
```C
当获得二维码之后，就需要用户去手机端去扫描二维码，并获得用户的授权，此时我们并不知道用户何时完成这个操作，
所以我们只有轮询，而轮询的地址就是：
https://login.weixin.qq.com/cgi-bin/mmwebwx-bin/login?uuid=DeA6idundY9VKn&tip=1&_=1377482045264
    （注意UUID和最后时间这两个参数，tip=1代表未扫描）
如果服务器返回：
    window.code=201;    则说明此时用户在手机端已经完成扫描，但还没有点击确认；
如果服务器返回200：
    window.redirect_uri=[URL]    则说明此时用户已经在手机端完成了授权过程，保存下这个URL地址下一步骤中使用。
```

4.访问登录地址，获得uin和sid

```C
通过访问上一步骤中获得的URL地址，可以在服务器返回的Cookies中获得到wxuin和wxsid这两个值，这两值在后续的通信过程中
都要使用到这两个值，并且Cookies中也需要包括这两项。
```

5.初使化微信信息
```C
前面的步骤算是完成了这个复杂的登录过程，如果我们需要使用微信就需要获得当前用户的信息、好友列表等，还有一个关键的就是
同步信息（后续与服务器轮询中需要使用同步信息），通过访问以下的链接：
    https://wx.qq.com/cgi-bin/mmwebwx-bin/webwxinit?r=1377482058764（r依然是时间）
访问该链接需要使用POST，并且在Body中带上以下的JSON信息：
{"BaseRequest":{"Uin":"2545437902","Sid":"QfLp+Z+FePzvOFoG","Skey":"","DeviceID":"e1615250492"}}
这个JSON串中Uin和Sid分别是上面步骤中获得的那两个Cookie值，DeviceID是一个本地生成的随机字符串
    （分析了官方的总是e+一串数字，所以我们也保持这样的格式）。
服务器就会返回一个很长的JSON串，这其中包括：BaseResponse中的值用来表示请求状态码，ContactList主要用来表示联系人
（此列表不全，只包括了类似通讯录助手、文件助手、微信团队和一些公众帐号等，后面会通过另一接口去获得更全面的信息），
SyncKey是用户与服务器同步的信息，User就是当前登录用户自己的信息。
```

6.获得所有的好友列表
```C
在上一步骤中已经获得了部分好友和公众帐号，如果需要获得完整的好友信息，就需要访问以下的链接：
    https://wx.qq.com/cgi-bin/mmwebwx-bin/webwxgetcontact?r=1377482079876（r依然是时间）
访问该链接同样需要POST方式，但Body为空JSON：{}，服务器对身份的判定是通过Cookies，所以需要保持之前访问的Cookies
不被修改（在Objective-C中会自动保存相关的Cookies，无需程序特殊处理），在返回的JSON串中，MemberList中就包含了
所有的好友信息。
```
7.保持与服务器的信息同步
```C
与服务器保持同步需要在客户端做轮询，该轮询的URL如下：
 https://webpush.weixin.qq.com/cgi-bin/mmwebwx-bin/synccheck?callback=jQuery18309326978388708085_
    1377482079946&r=1377482079876&sid=QfLp+Z+FePzvOFoG&uin=2545437902&deviceid=e1615250492&
    synckey=(见以下说明)&_=1377482079876
其中的参数r和_都是time，sid，uin，deviceid与上面步骤的值相对应，此处的synkey是上步步骤获得的同步键值，
但需要按一定的规则组合成以下的字符串：

1_124125|2_452346345|3_65476547|1000_5643635

就是将键和值用_隔开，不同的键值对用|隔开，但记得|需要URL编码成%7C，通过访问上面的地址，会返回如下的字符串：
    window.synccheck={retcode:”0”,selector:”0”}
如果retcode中的值不为0，则说明与服务器的通信有问题了，但具体问题我就无法预测了，selector中的值表示客户端需要
作出的处理，目前已经知道当为6的时候表示有消息来了，就需要去访问另一个接口获得新的消息。
```
8.获得别人发来的消息
```C
当一个步骤中知道有新消息时，就需要去获取消息内容，通过访问以下的链接：
    https://wx.qq.com/cgi-bin/mmwebwx-bin/webwxsync?sid=QfLp+Z+FePzvOFoG&r=1377482079876
上面链接中的参数sid对应上面步骤中的值，r为时间，访问链接需要使用POST方式，Body中包括JSON串，该JSON串格式如下：```
```python
{"BaseRequest" : {"Uin":2545437902,"Sid":"QfLp+Z+FePzvOFoG"},
"SyncKey" : {"Count":4,"List":[{"Key":1,"Val":620310295},
        {"Key":2,"Val":620310303},{"Key":3,"Val":620310285},{"Key":1000,"Val":1377479086}]},
"rr" :1377482079876};
```
信息中BaseRequest中包括的Uin与Sid与上面步骤中的值对应，SyncKey也是上面步骤中获得的同步键值对，rr为时间，访问成功之后服务器会返回一个JSON串，其中AddMsgList中是一个数组，包含了所有新消息。

9.向用户发送消息
```C
用户主动发送消息，通过以下的URL地址：
https://wx.qq.com/cgi-bin/mmwebwx-bin/webwxsendmsg?sid=QfLp+Z+FePzvOFoG&r=1377482079876
上面的sid和r参数不再解释了，访问该URL采用POST方式，在Body中的JSON串形如以下的格式：```
```python
{
    "BaseRequest":{
        "DeviceID" : "e441551176",
        "Sid" : "S8wNi91Zry3024eg",
        "Skey" : "F820928BBA5D8ECA23448F076D2E8A915E1349E9FB4F4332",
        "Uin" : "2545437902"
    },
    "Msg" : {
        "ClientMsgId" : 1377504862158,
        "Content" : "hello",
        "FromUserName" : "wxid_2rrz8g8ezuox22",
        "LocalID" : 1377504862158,
        "ToUserName" : "wxid_j4nu420ojhsr21",
        "Type" : 1
    },
    "rr" = 1377504864463
}```
```C
其中BaseRequest都是授权相关的值，与上面的步骤中的值对应，Msg是对消息的描述，包括了发送人与接收人，消息内容，
消息的类型(1为文本)，ClientMsgId和LocalID由本地生成。rr可用当前的时间。
在返回JSON结果中BaseResponse描述了发送情况，Ret为0表示发送成功。```

##实战：微信找”非好友“
```python
#!/usr/bin/env python
# coding=utf-8

import os
import urllib, urllib2
import re
import cookielib
import time
import xml.dom.minidom
import json
import sys
import math

DEBUG = False
MAX_GROUP_NUM = 35 # 每组人数
QRImagePath = os.getcwd() + '/qrcode.jpg'
tip = 0
uuid = ''
base_uri = ''
redirect_uri = ''
skey = ''
wxsid = ''
wxuin = ''
pass_ticket = ''
deviceId = 'e000000000000000'
BaseRequest = {}
ContactList = []
My = []

#获得当前登录的ID
def getUUID():
	global uuid
	url = 'https://login.weixin.qq.com/jslogin'
	params = {
		'appid': 'wx782c26e4c19acffb',
		'fun': 'new',
		'lang': 'zh_CN',
		'_': int(time.time()),
	}
	request = urllib2.Request(url = url, data = urllib.urlencode(params))
	response = urllib2.urlopen(request)
	data = response.read()
	# print data
	# window.QRLogin.code = 200; window.QRLogin.uuid = "oZwt_bFfRg==";
	regx = r'window.QRLogin.code = (\d+); window.QRLogin.uuid = "(\S+?)"'
	pm = re.search(regx, data)
	code = pm.group(1)
	uuid = pm.group(2)
	if code == '200':
		return True
	return False
#保存二维码图片到本地用于扫描
def showQRImage():
	global tip
	url = 'https://login.weixin.qq.com/qrcode/' + uuid
	params = {
		't': 'webwx',
		'_': int(time.time()),
	}
	request = urllib2.Request(url = url, data = urllib.urlencode(params))
	response = urllib2.urlopen(request)
	tip = 1
	f = open(QRImagePath, 'wb')
	f.write(response.read())
	f.close()
	if sys.platform.find('darwin') >= 0:
		os.system('open %s' % QRImagePath)
	elif sys.platform.find('linux') >= 0:
		os.system('xdg-open %s' % QRImagePath)
	else:
		os.system('call %s' % QRImagePath)
	print '请使用微信扫描二维码以登录'
def waitForLogin():
	global tip, base_uri, redirect_uri
	url = 'https://login.weixin.qq.com/cgi-bin/mmwebwx-bin/login?tip=%s&uuid=%s&_=%s' % 
	                            (tip, uuid, int(time.time()))
	request = urllib2.Request(url = url)
	response = urllib2.urlopen(request)
	data = response.read()
	# print data
	# window.code=500;
	regx = r'window.code=(\d+);'
	pm = re.search(regx, data)
	code = pm.group(1)
	if code == '201': #已扫描
		print '成功扫描,请在手机上点击确认以登录'
		tip = 0
	elif code == '200': #已登录
		print '正在登录...'
		regx = r'window.redirect_uri="(\S+?)";'
		pm = re.search(regx, data)
		redirect_uri = pm.group(1) + '&fun=new'
		base_uri = redirect_uri[:redirect_uri.rfind('/')]
	elif code == '408': #超时
		pass
	# elif code == '400' or code == '500':
	return code

def login():
	global skey, wxsid, wxuin, pass_ticket, BaseRequest

	request = urllib2.Request(url = redirect_uri)
	response = urllib2.urlopen(request)
	data = response.read()

	# print data

	'''
		<error>
			<ret>0</ret>
			<message>OK</message>
			<skey>xxx</skey>
			<wxsid>xxx</wxsid>
			<wxuin>xxx</wxuin>
			<pass_ticket>xxx</pass_ticket>
			<isgrayscale>1</isgrayscale>
		</error>
	'''

	doc = xml.dom.minidom.parseString(data)
	root = doc.documentElement

	for node in root.childNodes:
		if node.nodeName == 'skey':
			skey = node.childNodes[0].data
		elif node.nodeName == 'wxsid':
			wxsid = node.childNodes[0].data
		elif node.nodeName == 'wxuin':
			wxuin = node.childNodes[0].data
		elif node.nodeName == 'pass_ticket':
			pass_ticket = node.childNodes[0].data

	# print 'skey: %s, wxsid: %s, wxuin: %s, pass_ticket: %s'%(skey, wxsid, wxuin, pass_ticket)

	if skey == '' or wxsid == '' or wxuin == '' or pass_ticket == '':
		return False

	BaseRequest = {
		'Uin': int(wxuin),
		'Sid': wxsid,
		'Skey': skey,
		'DeviceID': deviceId,
	}

	return True

def webwxinit():
	url = base_uri+'/webwxinit?pass_ticket=%s&skey=%s&r=%s'%(pass_ticket, skey, int(time.time()))
	params = {
		'BaseRequest': BaseRequest
	}

	request = urllib2.Request(url = url, data = json.dumps(params))
	request.add_header('ContentType', 'application/json; charset=UTF-8')
	response = urllib2.urlopen(request)
	data = response.read()

	if DEBUG == True:
		f = open(os.getcwd() + '/webwxinit.json', 'wb')
		f.write(data)
		f.close()

	# print data

	global ContactList, My
	dic = json.loads(data)
	ContactList = dic['ContactList']
	My = dic['User']

	ErrMsg = dic['BaseResponse']['ErrMsg']
	if len(ErrMsg) > 0:
		print ErrMsg

	Ret = dic['BaseResponse']['Ret']
	if Ret != 0:
		return False
		
	return True

def webwxgetcontact():	
	url = base_uri + '/webwxgetcontact?pass_ticket=%s&skey=%s&r=%s' % 
	                    (pass_ticket, skey, int(time.time()))

	request = urllib2.Request(url = url)
	request.add_header('ContentType', 'application/json; charset=UTF-8')
	response = urllib2.urlopen(request)
	data = response.read()

	if DEBUG == True:
		f = open(os.getcwd() + '/webwxgetcontact.json', 'wb')
		f.write(data)
		f.close()

	# print data

	dic = json.loads(data)
	MemberList = dic['MemberList']

	# 倒序遍历,不然删除的时候出问题..
	SpecialUsers = ['newsapp', 'fmessage', 'filehelper', 'weibo', 'qqmail', 'fmessage', 
	'tmessage', 'qmessage', 'qqsync', 'floatbottle', 'lbsapp', 'shakeapp', 'medianote', 
	'qqfriend', 'readerapp', 'blogapp', 'facebookapp', 'masssendapp', 'meishiapp', 'feedsapp', 
	'voip', 'blogappweixin', 'weixin', 'brandsessionholder', 'weixinreminder', 
	'wxid_novlwrv3lqwv11', 'gh_22b87fa7cb3c', 'officialaccounts', 'notification_messages',
	'wxid_novlwrv3lqwv11', 'gh_22b87fa7cb3c', 'wxitil', 'userexperience_alarm',
	'notification_messages']
	for i in xrange(len(MemberList) - 1, -1, -1):
		Member = MemberList[i]
		if Member['VerifyFlag'] & 8 != 0: # 公众号/服务号
			MemberList.remove(Member)
		elif Member['UserName'] in SpecialUsers: # 特殊账号
			MemberList.remove(Member)
		elif Member['UserName'].find('@@') != -1: # 群聊
			MemberList.remove(Member)
		elif Member['UserName'] == My['UserName']: # 自己
			MemberList.remove(Member)

	return MemberList

def createChatroom(UserNames):
	MemberList = []
	for UserName in UserNames:
		MemberList.append({'UserName': UserName})


	url = base_uri+'/webwxcreatechatroom?pass_ticket=%s&r=%s'%(pass_ticket, int(time.time()))
	params = {
		'BaseRequest': BaseRequest,
		'MemberCount': len(MemberList),
		'MemberList': MemberList,
		'Topic': '',
	}

	request = urllib2.Request(url = url, data = json.dumps(params))
	request.add_header('ContentType', 'application/json; charset=UTF-8')
	response = urllib2.urlopen(request)
	data = response.read()

	# print data

	dic = json.loads(data)
	ChatRoomName = dic['ChatRoomName']
	MemberList = dic['MemberList']
	DeletedList = []
	for Member in MemberList:
		if Member['MemberStatus'] == 4: #被对方删除了
			DeletedList.append(Member['UserName'])

	ErrMsg = dic['BaseResponse']['ErrMsg']
	if len(ErrMsg) > 0:
		print ErrMsg

	return (ChatRoomName, DeletedList)

def deleteMember(ChatRoomName, UserNames):
	url = base_uri + '/webwxupdatechatroom?fun=delmember&pass_ticket=%s' % (pass_ticket)
	params = {
		'BaseRequest': BaseRequest,
		'ChatRoomName': ChatRoomName,
		'DelMemberList': ','.join(UserNames),
	}

	request = urllib2.Request(url = url, data = json.dumps(params))
	request.add_header('ContentType', 'application/json; charset=UTF-8')
	response = urllib2.urlopen(request)
	data = response.read()

	# print data

	dic = json.loads(data)
	ErrMsg = dic['BaseResponse']['ErrMsg']
	if len(ErrMsg) > 0:
		print ErrMsg

	Ret = dic['BaseResponse']['Ret']
	if Ret != 0:
		return False
		
	return True

def addMember(ChatRoomName, UserNames):
	url = base_uri + '/webwxupdatechatroom?fun=addmember&pass_ticket=%s' % (pass_ticket)
	params = {
		'BaseRequest': BaseRequest,
		'ChatRoomName': ChatRoomName,
		'AddMemberList': ','.join(UserNames),
	}

	request = urllib2.Request(url = url, data = json.dumps(params))
	request.add_header('ContentType', 'application/json; charset=UTF-8')
	response = urllib2.urlopen(request)
	data = response.read()

	# print data

	dic = json.loads(data)
	MemberList = dic['MemberList']
	DeletedList = []
	for Member in MemberList:
		if Member['MemberStatus'] == 4: #被对方删除了
			DeletedList.append(Member['UserName'])

	ErrMsg = dic['BaseResponse']['ErrMsg']
	if len(ErrMsg) > 0:
		print ErrMsg

	return DeletedList

def main():
	opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookielib.CookieJar()))
	urllib2.install_opener(opener)
	if getUUID() == False:
		print '获取uuid失败'
		return
	showQRImage()
	time.sleep(1)
	while waitForLogin() != '200':
		pass
	os.remove(QRImagePath)
	if login() == False:
		print '登录失败'
		return
	if webwxinit() == False:
		print '初始化失败'
		return
	MemberList = webwxgetcontact()
	MemberCount = len(MemberList)
	print '通讯录共%s位好友' % MemberCount
	ChatRoomName = ''
	result = []
	for i in xrange(0, int(math.ceil(MemberCount / float(MAX_GROUP_NUM)))):
		UserNames = []
		NickNames = []
		DeletedList = ''
		for j in xrange(0, MAX_GROUP_NUM):
			if i * MAX_GROUP_NUM + j >= MemberCount:
				break

			Member = MemberList[i * MAX_GROUP_NUM + j]
			UserNames.append(Member['UserName'])
			NickNames.append(Member['NickName'].encode('utf-8'))
		print '第%s组...' % (i + 1)
		print ', '.join(NickNames)
		print '回车键继续...'
		raw_input()
		# 新建群组/添加成员
		if ChatRoomName == '':
			(ChatRoomName, DeletedList) = createChatroom(UserNames)
		else:
			DeletedList = addMember(ChatRoomName, UserNames)

		DeletedCount = len(DeletedList)
		if DeletedCount > 0:
			result += DeletedList
		print '找到%s个被删好友' % DeletedCount
		# raw_input()
		# 删除成员
		deleteMember(ChatRoomName, UserNames)
	# todo 删除群组
	resultNames = []
	for Member in MemberList:
		if Member['UserName'] in result:
			NickName = Member['NickName']
			if Member['RemarkName'] != '':
				NickName += '(%s)' % Member['RemarkName']
			resultNames.append(NickName.encode('utf-8'))
	print '---------- 被删除的好友列表 ----------'
	print '\n'.join(resultNames)
	print '-----------------------------------'

# windows下编码问题修复:window的编码标准是CP936
# 核心：首先记录目标的编码标准(比如CP936),然后对于每一次的写操作，都先解码到一个公共的编码形式(比如UTF-8)成为字符串
# 然后在编码到目标标准然后按照目标标准解码出来即可。
class UnicodeStreamFilter:  
	def __init__(self, target):  
		self.target = target  
		self.encoding = 'utf-8'  
		self.errors = 'replace'  
		self.encode_to = self.target.encoding  
	def write(self, s):  
		if type(s) == str:  
			s = s.decode('utf-8')  	#先把要输出的内容转换成字符串：bytes-->str。
		s = s.encode(self.encode_to, self.errors).decode(self.encode_to)  
		                #把内容encode后decode即可得到CP936格式
		                #（这两步：任何编码格式-普通字符串-encode('CP936')-decode('CP936')） 
		self.target.write(s)
		  
if sys.stdout.encoding == 'cp936':  
	sys.stdout = UnicodeStreamFilter(sys.stdout)

if __name__ == '__main__' :

	print '本程序的查询结果可能会引起一些心理上的不适,请小心使用...'
	print '回车键继续...'
	raw_input()
	main()
	print '回车键结束'
	raw_input()```
	
[返回目录](README.md)