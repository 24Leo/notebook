##理论知识
###cookie
一种机制：在浏览器保存数据来跟踪和识别用户。
    * 由浏览器管理，但是各种语言都可以读取：PHP、Java、JS等
    * 可以保存在文件、内存、Falsh Shared，最后一种在硬盘上，**不受浏览器管理 **。
    * cookie不能跨域共享
    * cookie可能存在于上行、下行流量中，所以过多肯定不好；

###session
一种会话：持续性、双向的连接
    * session由服务器管理，存在于一次连接中，**时间概念**
    * 默认用文件存储，当然也有DB存储如redis 等
    * session的ID存放在cookie中，这样来保证每次的通信
    
##CAS
###背景
一个用户在同一个公司的某个应用登陆后，我们认为其他应用可以默认自动登录，但是实际不是，因为 不同应用可能域名不同，cookie不能共享，所以也就无法记住用户登录态
![](/assets/568f318f00018e5e06680341.png)
* 
###SSO
Single Sign On 即单点登录。
    * web sso
    * OS sso：登录一个用户，整个操作系统都登录。
    
###CAS(Central Authentication Service) 
以下请看完资料后再来学习：
    * Ticket Granting ticket (TGT) ：可以认为是CAS Server根据用户名密码生成的一张票，存在server端。（可以简单的抽象成session）
    * Ticket-granting cookie (TGC) ：其实就是一个cookie，存放用户身份信息，由server发给client端，保存TGT-ID，如果客户端有，那么请求server时会带上；
    * Service ticket (ST) ：由TGT生成的一次性票据，用于验证，**只能用一次**。
    * Proxy Granting Ticket（PGT）：代理模式时，CAS server跟进用户信息生产，    存在于server中。
    * Proxy Granting Cookie（PGC）：代理模式时，一个cookie，同TGC。
    * PGTIOU ： 代理模式时，一次性票据。

####普通CAS
![](/assets/cas_protocol-1.jpg)

* 用户访问网站，URL中未带有ST，重定向到 CAS Server，发现没有TGC cookie，所以再重定向到CAS Server端的登录页面，并且URL带有网站地址，便于认证成功后跳转,形如
```
http ://cas-server:8100/login?service=http ://localhost:8081
service后面这个地址就是登录成功后要重定向的下游系统URL```
* 在登陆页面输入用户名密码认证，认证成功后cas-server生成TGT，再用TGT生成一个ST。 然后再第三次重定向并返回ST和cookie(TGC)到浏览器(即图中黑色线框)
* 浏览器带着ST再访问想要访问的地址（server第三次重定向时给出）
```
http ://localhost:8081/?ticket=ST-25939-sqbDVZcuSvrvBC6MQlg5
ticket后面那一串就是ST```
* CAS客户端即网站收到ST后再去cas-server验证一下是否为自己签发的，验证通过后就会显示页面信息，也就是重定向到第1步service后面的那个URL：首次登陆完毕。

#####已经登录
前提：CAS server已经有TGT了（我们假定时间间隔较小，还未失效），客户浏览器已有TGC了。如果失效那就相当于退出。
* 用户访问网站，URL中未带有ST，重定向到CAS Server，发现有TGC cookie，用户已经登录，那么跟进TGT生产一次性票据ST，返回重定向地址：
```
http ://localhost:8081/?ticket=ST-25939-sqbDVZcuSvrvBC6MQlg5
ticket后面那一串就是ST```
* CAS客户端即网站收到ST后再去cas-server验证一下是否为自己签发的，验证通过后就会显示页面信息，也就是重定向到第1步service后面的那个URL：首次登陆完毕。

####代理模式
代理模式假定，访问网站A时，需要访问另一个网站B的受保护资源，那么如果让用户频繁登陆，肯定不好 -----> CAS client就会代理用户去访问。
    * 那么CAS client就需要用户身份信息
    * PGT就是对代理一种认证凭证，PGTIOU就是一次性票据
    ![](/assets/7f6e09a2-2234-3d79-9f4a-06feed9837ac.jpg)

###登出
如果一个应用退出了，那么其他的应该也是退出状态。
    * 类似于登陆，那么退出时也是去CAS server，那么cas server结束和用户浏览器通话，同时通知所有应用退出。
    
###安全
TGT、PGT保存在CAS server中，TGC、PGC等保存在客户端，由ssl保证。


[return](README.md)