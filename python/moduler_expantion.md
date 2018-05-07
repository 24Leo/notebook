## 模块分类

```C
核心模块
	1. 介绍
	2. _ _builtin_ _ 模块
	3. exceptions 模块
	4. os 模块
	5. os.path 模块
	6. stat 模块
	7. string 模块：包含大量有用的常量和函数用来处理字符串
	8. re 模块
	9. math 模块：定义了标准的数学方法
	10. cmath 模块
	11. operator 模块：提供了访问python内置的操作和解析器提供的特殊方法
	12. copy 模块：提供了对复合（compound）对象（list，tuple，dict，custom-class）进行浅拷贝和深拷贝的功能
	13. sys 模块：包含了跟python解析器和环境相关的变量和函数
	14. atexit 模块
	15. time 模块
	16. types 模块
	17. gc 模块
	18. collections模块：包含了一些有用的容器的高性能实现，各种容器的抽象基类，和创建name-tuple对象的函数。
	19. datetime模块 :提供了各种类型来表示和处理日期和时间。
	20. logging模块:    灵活方便地对应用程序记录events，errors，warnings，和debuging 信息
更多标准模块
	1. 概览
	2. fileinput 模块
	3. shutil 模块：用来执行更高级别的文件操作，例如拷贝，删除，改名
	4. tempfile 模块：用来产生临时文件和文件名。
	5. StringIO 模块
	6. cStringIO 模块
	7. mmap 模块
	8. UserDict 模块
	9. UserList 模块
	10. UserString 模块
	11. traceback 模块
	12. errno 模块
	13. getopt 模块
	14. getpass 模块
	15. glob 模块：可以获得匹配的文件列表。
	16. fnmatch 模块：提供了使用UNIX shell-style的通配符来匹配文件名。这个模块只是用来匹配
	17. random 模块：提供了各种方法用来产生随机数
	18. whrandom 模块
	19. md5 模块
	20. sha 模块
	21. crypt 模块
	22. rotor 模块
	23. zlib 模块
	24. code 模块
线程和进程
	1. 概览
	2. threading 模块
	3. Queue 模块
	4. thread 模块
	5. commands 模块:执行简单的系统命令，以字符串的形式传入，同时以字符串的形式返回输出。但只在UNI上可用。
	6. pipes 模块
	7. popen2 模块
	8. signal 模块
数据表示
	1. 概览
	2. array 模块：代表数组，类似与list，与list不同的是只能存储相同类型的对象
	3. struct 模块：用来在python和二进制结构间实现转化
	4. xdrlib 模块
	5. marshal 模块
	6. pickle 模块:用来序列化python的对象到bytes流，从而适合存储到文件，网络传输，或数据库存储.又称serializing
	7. cPickle 模块
	8. copy_reg 模块
	9. pprint 模块
	10. repr 模块
	11. base64 模块
	12. binhex 模块
	13. quopri 模块
	14. uu 模块
	15. binascii 模块
	16. decimal 模块:能表示更大范围的数字，更精确地四舍五入例如0.1(实际上内存中为0.100000000000000001)
文件格式
	1. 概览
	2. xmllib 模块
	3. xml.parsers.expat 模块
	4. sgmllib 模块
	5. htmllib 模块
	6. htmlentitydefs 模块
	7. formatter 模块
	8. ConfigParser 模块:用来读写配置文件。
	9. netrc 模块
	10. shlex 模块
	11. zipfile 模块
	12. gzip 模块
	11. csv模块: 用来读写comma-separated values（CSV）文件。
	12. json模块: 被用类序列化或饭序列化Javascript object notation（JSON）对象。
邮件和新闻消息处理
	1. 概览
	2. rfc822 模块
	3. mimetools 模块
	4. MimeWriter 模块
	5. mailbox 模块
	6. mailcap 模块
	7. mimetypes 模块
	8. packmail 模块
	9. mimify 模块
	10. multifile 模块
网络协议
	1. 概览
	2. socket 模块
	3. select 模块
	4. asyncore 模块
	5. asynchat 模块
	6. urllib 模块
	6.e urllib2模块
	7. urlparse 模块
	8. cookie 模块
	9. robotparser 模块
	10. ftplib 模块
	11. gopherlib 模块
	12. httplib 模块
	13. poplib 模块
	14. imaplib 模块
	15. smtplib 模块
	15.e requests模块
	16. telnetlib 模块
	17. nntplib 模块
	18. SocketServer 模块:提供了类型简化了TCP，UDP和UNIX领域的socket server的实现。
	19. BaseHTTPServer 模块
	20. SimpleHTTPServer 模块
	21. CGIHTTPServer 模块
	22. cgi 模块
	23. webbrowser 模块
国际化
	1. locale 模块
	2. unicodedata 模块
	3. ucnhash 模块
多媒体相关模块
	1. 概览
	2. imghdr 模块
	3. sndhdr 模块
	4. whatsound 模块
	5. aifc 模块
	6. sunau 模块
	7. sunaudio 模块
	8. wave 模块
	9. audiodev 模块
	10. winsound 模块
数据储存
	1. 概览
	2. anydbm 模块
	3. whichdb 模块
	4. shelve 模块
	5. dbhash 模块
	6. dbm 模块
	7. dumbdbm 模块
	8. gdbm 模块
工具和实用程序
	1. dis 模块
	2. pdb 模块
	3. bdb 模块
	4. profile 模块
	5. pstats 模块
	6. tabnanny 模块
其他模块
	1. 概览
	2. fcntl 模块
	3. pwd 模块
	4. grp 模块
	5. nis 模块
	6. curses 模块
	7. termios 模块
	8. tty 模块
	9. resource 模块
	10. syslog 模块
	11. msvcrt 模块
	12. nt 模块
	13. _winreg 模块
	14. posix 模块
	15. tushare 模块: 金融
执行支持模块
	1. dospath 模块
	2. macpath 模块
	3. ntpath 模块
	4. posixpath 模块
	5. strop 模块
	6. imp 模块
	7. new 模块
	8. pre 模块
	9. sre 模块
	10. py_compile 模块
	11. compileall 模块
	12. ihooks 模块
	13. linecache 模块
	14. macurl2path 模块
	15. nturl2path 模块
	16. tokenize 模块
	17. keyword 模块
	18. parser 模块
	19. symbol 模块
	20. token 模块
其他模块
	1. 概览
	2. pyclbr 模块
	3. filecmp 模块 : 提供了函数来比较文件和目录。
	4. cmd 模块
	5. rexec 模块
	6. Bastion 模块
	7. readline 模块
	8. rlcompleter 模块
	9. statvfs 模块
	10. calendar 模块
	11. sched 模块
	12. statcache 模块
	13. grep 模块
	14. dircache 模块
	15. dircmp 模块
	16. cmp 模块
	17. cmpcache 模块
	18. util 模块
	19. soundex 模块
	20. timing 模块
	21. posixfile 模块
	22. bisect 模块
	23. knee 模块
	24. tzparse 模块
	25. regex 模块
	26. regsub 模块
	27. reconvert 模块
	28. regex_syntax 模块
	29. find 模块```
### 使用其它国内的源：
但是可能不是最新的

虽然用easy_install和pip来安装第三方库很方便,它们的原理其实就是从Python的官方源http://pypi.python.org/pypi 下载到本地，然后解包安装。不过因为某些原因，访问官方的pypi不稳定，很慢甚至有些还时不时的访问不了。 
```python
豆瓣的源：
    http://pypi.douban.com/simple/
阿里的源：
    http://mirrors.aliyun.com/pypi/simple/
注意后面要有/simple目录
使用镜像源很简单，用-i指定就行了： 
    sudo easy_install -i http://pypi.douban.com/simple/ saltTesting 
    sudo pip install -i http://pypi.douban.com/simple/ saltTesting```
把其设置为**默认源**：
```shell
1.linux 
    ~/.pip/pip.conf 
2.windows 
    %HOME%\pip\pip.ini 
添加：
[global] 
index-url = http://pypi.douban.com/simple
[install]
trusted-host = pypi.douban.com
```


[返回目录](README.md)