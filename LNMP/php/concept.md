##名字
PHP：语言名字
php：PHP解释器
HHVM：FB开发的开源PHP解释器
## 一 cgi、fastcgi、php-cgi、php-fpm [link](https://segmentfault.com/q/1010000000256516)
####1. cgi
CGI全称是“公共网关接口”(Common Gateway Interface)，HTTP服务器(apache、nginx)与你的或其它机器上的web应用程序(php、java、.net)进行“交谈”的一种工具，其程序须运行在网络服务器上,**保证web server传递过来的数据是标准格式的，方便CGI程序的编写者**。CGI可以用任何一种语言编写，只要这种语言具有标准输入、输出和环境变量。**它是网页的表单和你写的程序之间通信的一种协议**
####注意：cgi不传输数据，由socket负责穿。
**web server（比如说nginx）只是内容的分发者**。比如，如果请求/index.html，那么web server会去文件系统中找到这个文件，发送给浏览器，这里分发的是静态数据。好了，如果现在请求的是/index.php，根据配置文件，nginx知道这个不是静态文件，需要去找PHP解析器来处理，那么他会把这个请求简单处理后交给PHP解析器。Nginx会传哪些数据给PHP解析器呢？url要有吧，查询字符串也得有吧，POST数据也要有，HTTP header不能少吧，好的，**CGI就是规定要传哪些数据、以什么样的格式传递给后方处理这个请求的协议**。仔细想想，你在PHP代码中使用的用户从哪里来的。当web server收到/index.php这个请求后，会启动对应的CGI程序，这里就是PHP的解析器。接下来PHP解析器会解析php.ini文件，初始化执行环境，然后处理请求，再以规定CGI规定的格式返回处理后的结果，退出进程。web server再把结果返回给浏览器。
**典型的CGI脚本做了如下的事情**：
 * 读取用户提交表单的信息:当用户填写完表单，点击提交按钮的时候。CGI脚本接收用户表单的数据，这些数据都是k－v的集合的形式.**不仅有用户提交信息还有http参数等**
 * 处理这些信息（也就是实现业务）。
 * 输出，返回html响应（返回处理完的数据）。

=======
* 客户端访问某个 URL 地址之后，通过 GET/POST/PUT 等方式提交数据，并通过 HTTP 协议向 Web 服务器发出请求。
* 服务器端的 HTTP Daemon（守护进程）启动一个子进程。然后在子进程中，将 HTTP 请求里描述的信息通过标准输入 stdin 和环境变量传递给 URL 指定的 CGI 程序（这个CGI是由PHP、python等对应实现），并启动此应用程序进行处理，处理结果通过标准输出 stdout 返回给 HTTP Daemon 子进程。
* 再由 HTTP Daemon 子进程通过 HTTP 协议返回给客户端。

 
<hr>
CGI是个协议:** Web Server(nginx)与 Web Application(php、.net) **之间数据交换的一种协议，跟进程什么的没关系。那fastcgi又是什么呢？
      **Fastcgi是用来提高CGI程序性能的。**
<hr>
####2 fastcgi
提高性能，那么CGI程序的性能问题在哪呢?“ PHP解析器会解析php.ini文件，初始化执行环境 “，就是这里了。**标准的CGI对每个请求都会执行这些步骤**（不闲累啊！启动进程很累的说！），所以处理每个时间的时间会比较长。这明显不合理嘛！那么Fastcgi是怎么做的呢？首先，**Fastcgi会先启一个master，解析配置文件，初始化执行环境，然后再启动多个worker。**当请求过来时，master会传递给一个worker，然后立即可以接受下一个请求。这样就避免了重复的劳动，效率自然是高。而且当worker不够用时，master可以根据配置预先启动几个worker等着；当然空闲worker太多时，也会停掉一些，这样就提高了性能，也节约了资源。这就是fastcgi的对进程的管理。
####3. php-cgi
**PHP的解释器是php,而实现cgi协议的PHP解释器：php-cgi**。php-cgi只是个CGI程序，他自己本身只能解析请求，返回结果，不会进程管理（皇上，臣妾真的做不到啊！）所以就出现了一些能够调度php-cgi进程的程序，＝＝＝＝》php-fpm
<hr>php-cgi仅仅是php的解释器，解释PHP脚本的程序。
fastcgi是一个协议，php-fpm实现了这个协议

**CGI是一个协议，为了更好地性能出现了FastCGI协议。php-fpm实现了fastcgi协议，同时可以平滑重启！PHPcgi是PHP解释器，不能管理进程，而且更新配置后需要重启，php－fpm也解决该问题。**
<hr>
####4. php-fpm
php-fpm的管理对象是php-cgi。但不能说php-fpm是fastcgi进程的管理器，因为前面说了fastcgi是个协议，似乎没有这么个进程存在，就算存在php-fpm也管理不了他,实现而已！
#####修改了php.ini配置文件后，没办法平滑重启，所以就诞生了php-fpm
是的，修改php.ini之后，php-cgi进程的确是没办法平滑重启的。php-fpm对此的处理机制是**新的worker用新的配置**，已经存在的worker处理完手上的活就可以歇着了，通过这种机制来平滑过度。
<hr>
当Web Server收到 index.php 这个请求后，会启动对应的 CGI 程序（传什么），这里就是PHP的解析器。接下来PHP解析器会解析php.ini文件，初始化执行环境，然后处理请求，再以规定CGI规定的格式返回处理后的结果，退出进程，Web server再把结果返回给浏览器。

![](/assets/下单流程-v2.1.png)
1. Web Server启动时载入FastCGI进程管理器（Apache Module或IIS ISAPI等)
2. FastCGI进程管理器自身初始化，启动多个CGI解释器进程(可建多个php-cgi)，并等待来自Web Server的连接。
3. 用户通过浏览器访问PHP页面时候，流程是首先请求到了Nginx服务器，服务器发现是动态请求，Nginx通过Fast-cgi接口来跟动态脚本PHP通信，Fast-cgi在Linux下是socket（文件或者Ip类型）,通信过程中由FastCGI的wrapper（wrapper可理解为用于启动另外一个线程的程序）进而启动一个CGI的解析器.Web server将CGI环境变量和标准输入发送到FastCGI子进程php-cgi
4. FastCGI子进程完成处理后将标准输出和错误信息从同一连接返回Web Server再返回给用户。当FastCGI子进程关闭连接时，请求便告处理完成。FastCGI子进程接着等待并处理来自FastCGI进程管理器(运行在Web Server中)的下一个连接。 在CGI模式中，php-cgi在此便退出了，在php-cgi启动的过程中，会有守护者或者说管理者（PHP-fpm）,防止php-cgi的崩溃.

[返回目录](README.md)