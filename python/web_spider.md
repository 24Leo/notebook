
## Web-spider:[网络爬虫](http://cuiqingcai.com/1052.html)

所谓网页抓取，就是“伪装”成浏览器把URL地址中指定的网络资源从网络流中读取出来，保存到本地。<hr>
**1、URI和URL的概念和举例**
<br>简单的来讲，URL就是在浏览器端输入的    http://www.baidu.com    这个字符串。
<br>Web上每种可用的资源，如 HTML文档、图像、视频片段、程序等都由一个通用资源标志符(Universal Resource Identifier， **URI**)进行定位。 
URI通常由三部分组成：<br>
①访问资源的命名机制；<br>
②存放资源的主机名；<br>
③资源自身 的名称，由路径表示。<br>
**总结：**<br>
URI属于URL更低层次的抽象，一种字符串文本标准。
换句话说，URI属于父类，而URL属于URI的子类。URL是URI的一个子集。
URI的定义是：统一资源标识符；
URL的定义是：统一资源定位符。<br>
二者的区别在于，URI表示请求服务器的路径，定义这么一个资源；
而URL同时说明要如何访问这个资源（http://）。<br>

### 2、抓取网页（urllib2）

```python
import urllib2  
response = urllib2.urlopen('http://www.baidu.com/')  
html = response.read()            #response.read().decode("utf-8")
print html  

urlopen一般接受三个参数：
        urlopen(url, data, timeout)```
##### 一般浏览器发送的**HTTP**是基于请求和应答机制的：    urllib2用一个**Request对象**来映射你提出的HTTP请求。#####
```python
import urllib2    
req = urllib2.Request('http://www.baidu.com')    
response = urllib2.urlopen(req)    
the_page = response.read()       
print the_page  
                //同理：req = urllib2.Request('ftp://example.com/')  建立ftp请求
        
    Request()一般接受三个参数:        
        Request(url,data,headers)```
但是，除此之外，我们可能还要做其他事，比如：
* 
post表单提交
* 
headers设置
* urlopen是一个特殊的opener
* 多用request


####**===>post表单提交** Request():数据参数
**urllib**用来处理表单数据  

```python
1 POST方式:
import urllib    
import urllib2    
  
url = 'http://www.someserver.com/register.cgi'    
values = {'name' : 'WHY',    
          'location' : 'SDU',    
          'language' : 'Python' }    
data = urllib.urlencode(values)     # 编码工作  
req = urllib2.Request(url, data)    # 发送请求同时传data表单  
response = urllib2.urlopen(req)     #接受反馈的信息  
the_page = response.read()          #读取反馈的内容

2 GET方式：
至于GET方式我们可以直接把参数写到网址上面，直接构建一个带参数的URL出来即可。
import urllib
import urllib2
 
values={}
values['username'] = "1016903103@qq.com"
values['password']="XXXX"
data = urllib.urlencode(values) 
url = "http://passport.csdn.net/account/login"
geturl = url + "?"+data
request = urllib2.Request(geturl)
response = urllib2.urlopen(request)
print response.read()```

**扩展：**GET参数传递： Request():headers参数
```python
import urllib2    
import urllib  
  
data = {}  
  
data['name'] = 'WHY'    
data['location'] = 'SDU'    
data['language'] = 'Python'  
  
url_values = urllib.urlencode(data)    
url = 'http://www.example.com/example.cgi'    
full_url = url + '?' + url_values  
  
data = urllib2.open(full_url)  ```  

####**===>headers设置**

浏览器确认自己身份是通过**User-Agent头**
防盗链，服务器会识别headers中的**referer**，

```python
import urllib    
import urllib2    
  
url = 'http://www.someserver.com/cgi-bin/register.cgi'  
user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'    
values = {'name' : 'WHY',    
          'location' : 'SDU',    
          'language' : 'Python' }    
headers = { 'User-Agent' : user_agent }         //headers

data = urllib.urlencode(values)                 //参数
req = urllib2.Request(url, data, headers)       //参数和headers传递
response = urllib2.urlopen(req)    
the_page = response.read() ```
**urlopen返回**的应答对象response(或者HTTPError实例)有几个很有用的方法info()、geturl()、getcode()
```python
from urllib2 import Request, urlopen, URLError, HTTPError  

old_url = 'http://rrurl.cn/b1UZuP'  
req = Request(old_url)  
response = urlopen(req)    
print 'Old url :' + old_url                     //request地址
print 'Real url :' + response.geturl()          //处理后的响应地址(和上面的可能不同)
print 'info:'+response.info()
print 'status'+response.getcode()```


## 升级


**Openers**<br>
当你获取一个URL你使用一个opener(一个urllib2.OpenerDirector的实例),Opener对象有一个open方法:该方法可以像urlopen函数那样直接用来获取urls
<br>
**Handles**
处理

* 
添加头信息：
```python
import urllib2  
request = urllib2.Request('http://www.baidu.com/')  
request.add_header('User-Agent', 'fake-client')         #添加
response = urllib2.urlopen(request)  
print response.read()               #response.read().decode("utf-8") ```
特别的头信息：<br>
User-Agent : 有些服务器或 Proxy 会通过该值来判断是否是浏览器发出的请求<br>
Referer:对付防盗链，服务器会识别headers中的referer<br>
Content-Type : 在使用 REST 接口时，服务器会检查该值，确定 HTTP Body 中的内容该怎样解析。常见的取值有：<br>
　　application/xml ： 在 XML RPC，如 RESTful/SOAP 调用时使用<br>
　　application/json ： 在 JSON RPC 调用时使用<br>
　　application/x-www-form-urlencoded ： 浏览器提交 Web 表单时使用<br>
在使用服务器提供的 RESTful 或 SOAP 服务时， Content-Type 设置错误会导致服务器拒绝服务

* 
Redirect<br>
urllib2 默认情况下会针对 HTTP 3XX 返回码自动进行 redirect 动作，无需手动配置
```python
import urllib2  
my_url = 'http://www.google.cn'  
response = urllib2.urlopen(my_url)  
redirected = response.geturl() == my_url  
print redirected  ```
* 
Cookie  　　 import cookielib  <br>
urllib2 对 Cookie 的处理也是自动的
```python
import urllib2  
import cookielib  
cookie = cookielib.CookieJar()  
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookie))  
response = opener.open('http://www.baidu.com')             #request object也行
for item in cookie:  
    print 'Name = '+item.name  
    print 'Value = '+item.value  
~
cookie信息保存到文本文件中:
import urllib
import urllib2
import cookielib
filename = 'cookie.txt'
    #声明一个MozillaCookieJar对象实例来保存cookie，之后写入文件
cookie = cookielib.MozillaCookieJar(filename)
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookie))
postdata = urllib.urlencode({
			'stuid':'201200131012',
			'pwd':'23342321'
		})
#登录教务系统的URL
loginUrl = 'http://jwxt.sdu.edu.cn:7890/pls/wwwbks/bks_login2.login'
#模拟登录，并把cookie保存到变量
result = opener.open(loginUrl,postdata)
#保存cookie到cookie.txt中
cookie.save(ignore_discard=True, ignore_expires=True)
#利用cookie请求访问另一个网址，此网址是成绩查询网址
gradeUrl = 'http://jwxt.sdu.edu.cn:7890/pls/wwwbks/bkscjcx.curscopre'
#请求访问成绩查询网址
result = opener.open(gradeUrl)
print result.read()```
* 
代理 <br>
urllib2 默认会使用环境变量 http_proxy 来设置 HTTP Proxy。假如一个网站它会检测某一段时间某个IP 的访问次数，如果访问次数过多，它会禁止你的访问。
```python
import urllib2
enable_proxy = True
proxy_handler = urllib2.ProxyHandler({"http" : 'http://some-proxy.com:8080'})
null_proxy_handler = urllib2.ProxyHandler({})
if enable_proxy:
    opener = urllib2.build_opener(proxy_handler)
else:
    opener = urllib2.build_opener(null_proxy_handler)
urllib2.install_opener(opener)
urllib2.urlopen(url)
 ```
    这里要注意的一个细节，使用 urllib2.install_opener() 会设置 urllib2 的全局 opener。这样后面的使用会很方便，但不能做更细粒度的控制，比如想在程序中使用两个不同的 Proxy 设置等。比较好的做法是不使用 install_opener 去更改全局的设置，而只是直接调用 opener 的 open 方法代替全局的 urlopen 方法。
```python
import urllib2
enable_proxy = True
proxy_handler = urllib2.ProxyHandler({"http" : 'http://some-proxy.com:8080'})
null_proxy_handler = urllib2.ProxyHandler({})
if enable_proxy:
    opener1 = urllib2.build_opener(proxy_handler)
else:
    opener1 = urllib2.build_opener(null_proxy_handler)
opener1.open(url)
```
* 
异常 <br>
HTTPError的父类是URLError，如果子类捕获不到，那么可以捕获父类的异常.
```python
import urllib2
req = urllib2.Request('http://blog.csdn.net/cqcre')
try:
    urllib2.urlopen(req)
except urllib2.HTTPError, e:
    print e.code
except urllib2.URLError, e:
    print e.reason
else:
    print "OK"
```
## 安装[scrapy](http://blog.csdn.net/ahywg/article/details/23842685)
sudo apt-get install python-scrapy
1. setuptool```https://pypi.python.org/packages/2.7/s/setuptools/```  easy_install
2. win32api ```http://sourceforge.net/projects/pywin32/files%2Fpywin32/```  
3. zope.interface  ```https://pypi.python.org/pypi/zope.interface/4.1.0#downloads``` 
4. Twisted : pip install twisted
5. pyOpenSSL : pip install pyOpenSSL
6. lxml ```https://pypi.python.org/pypi/lxml/3.3.1```输入 import lxml 测试安装
7. scrapy : pip install scrapy         pip install scrapy==1.1.0rc3


[返回目录](README.md)