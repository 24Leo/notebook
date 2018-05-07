##[规范名](http://blog.xieyc.com/differences-between-a-record-and-cname-record/)
     * A纪录IP指向：域名映射到IP地址;
     * CNAME别名纪录：多个域名映射到另外一个域名（如一台服务器提供多个服务或者网站）;
         * 这个域名需要做A纪录；
         * 所以当IP变更时，仅需要更新A纪录，多个别名即可完成映射；
     * 因此如果一个IP提供多个服务（如www和mail），域名就需要提供www前缀，而A纪录不需要；
         * 可以返回301跳转也可以解决

##DNS
当主机A要访问a.b.com的时候，他会提交dns查询到他所设定的dns服务器，dns
服务器会进行以下工作：  
    * 先查看本身有没有相关记录，有的话返回结果给主机A，没有的话就继续进行下一步。 
    * dns服务器提交查询到顶级域(root)，root会返回**管理.com服务器的地址**(B)。 
    * dns服务器去B进行查询，得到**管理.b.com的dns主机的IP地址**(C)。 
    * dns服务器去(C)查询，得到a.b.com的IP地址返回结果给主机A，然后存入本地缓存中(a/ns)，对于相同域名的查询经直接提供结果。 

请求[www.baidu.com](http://blog.csdn.net/meimingming/article/details/9038223)
	* 本机向local dns请求www.baidu.com
	* local dns向根域请求www.baidu.com，根域返回com.域的服务器IP
	* 向com.域请求www.baidu.com，com.域返回baidu.com域的服务器IP
	* 向baidu.com请求www.baidu.com，返回cname www.a.shifen.com和a.shifen.com域的服务器IP
	* 向root域请求www.a.shifen.com
	* 向com.域请求www.a.shife.com
	* 向shifen.com请求
	* 向a.shifen.com域请求
	* 拿到www.a.shifen.com的IP
	* localdns返回本机www.baidu.com cname www.a.shifen.com 以及 www.a.shifen.com的IP
  
    * 用户发起搜索请求后先采用**递归的方式**请求本地DNS服务器进行域名解析，本地DNS先查缓存，若查到则直接返回，否则采用迭代的方式向更高层的DNS请求服务，比我先请求根域名服务器，根域名服务返回com DNS地址，
    * 然后本地DNS再向com DNS请求，直到请求到百度的DNS，百度的DNS根据CNAME对应到shifen域的NS，时分域上NS装有CDNDNS模块，根据A标签和TDO表来返回BGW的VIP，用户得到VIP后发起HTTP请求。

#HTTP-Protocol
* 
电脑上访问一个网页，整个过程是怎么样的：DNS、HTTP、TCP、OSPF、IP、ARP。

HTTP协议（HyperText TransferProtocol，超文本传输协议）是用于从WWW服务器传输超文本到本地浏览器的传送协议。是一个无状态的协议，处于应用层。

![](TCPIP.jpg)

HTTP只能由客户端发起请求，然后服务器端相应

![](5657919_2.jpg)

### 工作流程：


1. 
建立连接
1. 
客户机发送请求    格式如下：Method Request-URI HTTP-Version CRLF  
1. 
服务器得到请求，发送相应的响应信息           HTTP-Version Status-Code Reason-Phrase CRLF
1. 
客户机解析并显示

注：
1. 
请求方法：<br
GET     请求获取Request-URI所标识的资源<br>
POST    在Request-URI所标识的资源后附加新的数据<br>
HEAD    请求获取由Request-URI所标识的资源的响应消息报头<br>
PUT     请求服务器存储一个资源，并用Request-URI作为其标识<br>
DELETE  请求服务器删除Request-URI所标识的资源<br>
TRACE   请求服务器回送收到的请求信息，主要用于测试或诊断<br>
CONNECT 保留将来使用<br>
OPTIONS 请求查询服务器的性能，或者查询与资源相关的选项和需求
1. 
响应状态：<br>
1xx：指示信息--表示请求已接收，继续处理<br>
2xx：成功--表示请求已被成功接收、理解、接受<br>
3xx：重定向--要完成请求必须进行更进一步的操作<br>
    * 301 永久重定向
    * 302 暂时重定向

4xx：客户端错误--请求有语法错误或请求无法实现<br>
5xx：服务器端错误--服务器未能实现合法的请求<br>
常见状态代码、状态描述、说明：<br>
200 OK      //客户端请求成功<br>
400 Bad Request  //客户端请求有语法错误，不能被服务器所理解<br>
401 Unauthorized //请求未经授权，这个状态代码必须和WWW-Authenticate报头域一起使用 <br>
403 Forbidden  //服务器收到请求，但是拒绝提供服务<br>
404 Not Found  //请求资源不存在，eg：输入了错误的URL<br>
500 Internal Server Error //服务器发生不可预期的错误<br>
503 Server Unavailable  //服务器当前不能处理客户端的请求，一段时间后可能恢复正常<br>



---



### 消息：
请求消息和响应消息都是由开始行（对于请求消息，开始行就是请求行，对于响应消息，开始行就是状态行），消息报头（可选），空行（只有CRLF的行），消息正文（可选）组成<br>HTTP消息报头包括**普通报头、请求报头、响应报头、实体报头。**
每一个报头域都是由**名字+“：”+空格+值 **组成，消息报头域的名字是大小写无关的。<br>
[参考](http://www.cnblogs.com/li0803/archive/2008/11/03/1324746.html)

##Request
Request对象的作用是与客户端交互，收集客户端的Form、Cookies、超链接，或者收集服务器端的环境变量。

[返回目录](README.md)