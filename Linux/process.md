5. linux下如何修改进程优先级？（nice命令的使用）。
6. linux下性能监控命令uptime介绍，平均负载的具体含义是什么？建议看server load概念。

## ps: 终端下所有程序及进程
```C
ps a 显示现行终端机下的所有程序，包括其他用户的程序。
ps -A   显示所有程序。
ps c    列出程序时，显示每个程序真正的指令名称，而不包含路径，参数或常驻服务的标示。
ps -e  此参数的效果和指定"A"参数相同。
ps e   列出程序时，显示每个程序所使用的环境变量。
ps f    详细信息。
ps -H    显示树状结构，表示程序间的相互关系。
ps -N   显示所有的程序，除了执行ps指令终端机下的程序之外。
ps s     采用程序信号的格式显示程序状况。
ps S     列出程序时，包括已中断的子程序资料。
ps -t <终端机编号> 　指定终端机编号，并列出属于该终端机的程序的状况。
ps u 　 以用户为主的格式来显示程序状况。
ps x 　 显示当前用户所有程序，不以终端机来区分。
ps -l     較長,較詳細的顯示該PID的信息

最常用的方法是ps -aux,然后再利用一个管道符号导向到grep去查找特定的进程,然后再对特定的进程进行操作。
STATz状态位位常見的状态字符
D 无法中断的休眠状态（通常 IO 的进程）；
R 正在运行可中在队列中可过行的；
S 处于休眠状态；
T 停止或被追踪；
W 进入内存交换  （从内核2.6开始无效）；
X 死掉的进程   （基本很少見）；
Z 僵尸进程；
< 优先级高的进程
N 优先级较低的进程
L 有些页被锁进内存；
s 进程的领导者（在它之下有子进程）；
l 多进程的（使用 CLONE_THREAD, 类似 NPTL pthreads）；
+ 位于后台的进程组；
```

###netstat：查看网络服务
```C
-a (all)显示所有选项，默认不显示LISTEN相关
-t (tcp)仅显示tcp相关选项
-u (udp)仅显示udp相关选项
-n 拒绝显示别名，能显示数字的全部转化成数字。
-l 仅列出有在 Listen (监听) 的服务状态

-p 显示建立相关链接的程序名
-r 显示路由信息，路由表
-e 显示扩展信息，例如uid等
-s 按各个协议进行统计
-c 每隔一个固定时间，执行该netstat命令。

netstat -apn显示所有

提示：LISTEN和LISTENING的状态只有用-a或者-l才能看到

找出运行在指定端口的进程： netstat -an | grep ':80'
lsof -i:#port       谁在使用#port

```

###lsof：显示系统打开的文件（linux一切都是文件）
```C
lsof语法格式是：
lsof ［options］ [filename]

lsof abc.txt 显示开启文件abc.txt的进程
lsof -c abc 显示abc进程现在打开的文件
lsof -c -p 1234 列出进程号为1234的进程所打开的文件
lsof -g gid 显示归属gid的进程情况
lsof +d /usr/local/ 显示目录下被进程开启的文件
lsof +D /usr/local/ 同上，但是会搜索目录下的目录，时间较长
lsof -d 4 显示使用fd为4的进程
lsof -i 用以显示符合条件的进程情况
lsof -i[46] [protocol][@hostname|hostaddr]:[service|port]
46 --> IPv4 or IPv6
protocol --> TCP or UDP
hostname --> Internet host name
hostaddr --> IPv4地址
service --> /etc/service中的 service name (可以不止一个)
port --> 端口号 (可以不止一个)
```
##查看进程所在目录
Linux在启动一个进程时，系统会在/proc下创建一个以PID命名的文件夹，在该文件夹下会有我们的进程的信息，其中包括一个名为exe的文件即记录了绝对路径，通过ll或ls –l命令即可查看。

ll /proc/PID
        * cwd符号链接的是进程运行目录；
        * exe符号连接就是执行程序的绝对路径；
        * cmdline就是程序运行时输入的命令行命令；
        * environ记录了进程运行时的环境变量；
        * fd目录下是进程打开或使用的文件的符号连接。

## top:实时显示系统中各个进程的资源占用状况


##[kill](http://www.cnblogs.com/peida/archive/2012/12/20/2825837.html):[终止](http://www.cnblogs.com/wangkangluo1/archive/2012/05/26/2518857.html)指定的进程
#### 杀死进程最安全的方法是单纯使用kill命令，不加修饰符，不带标志。 

```
root用户将影响用户的进程，非root用户只能影响自己的进程。
init进程是不可杀的

kill[参数][进程号]:
        发送指定的信号到相应进从而终结他们。不指定型号将发送SIGTERM（15）终止指定进程。
-l  信号，若果不加信号的编号参数，则“-l”参数会列出全部的信号名称
-a  当处理当前进程时，不限制命令名和进程号的对应关系
-p  指定kill 命令只打印相关进程的进程号，而不发送任何信号
-s  指定发送信号
-u  指定用户 

kill -l：列出所有的信号名称
kill -l [信号名称]：返回信号对应的数值

kill -2 123
kill -9 $(ps -ef | grep peidalinux) ：过滤出hnlinux用户进程并杀死
```

##df   
查看磁盘使用情况
df可以查看一级文件夹大小、使用比例、档案系统及其挂入点，但对文件却无能为力。

du可以查看文件及文件夹的大小。
```
du  --max-dep=1 | sort -nr
df -h   磁盘空间
du –max-depth=1 -h .    当然文件夹中个文件大小
du -sh file/dir        某个文件夹、文件大小

du -sh /* | sort -nr   可以得到 / 目录下所有文件和目录的大小的排序结果。

从中找出最大的，使用上面的命令继续追踪：
du -sh /var/* | sort -nr 
du -sh /var/log/* | sort -nr 
du -sh /var/log/httpd/* | sort -nr 
一层一层往下追踪，最后发现是 httpd/目录下的ssl_error_log占据了超大磁盘空间，看了下文件内容，估计是某次链接导致了大量错误信息被一遍遍的循环写入。
```
##du  
查看目录大小，或者文件大小
 * 查看当前文件、目录大小
         * df -sm dir
         * s 仅展示总量，不展示各子目录大小
         * m g k 分别对应MB、GB、KB单位展示
 * 查看当前模块以及子目录大小
         * df -a dir
         * a递归，展示块数
 * 查看某一个子目录大小 
         * df -ch dir | tail -n 1
         * c统计某个目录大小
 * du --max-depth=1 -h | sort -nr
         * 文件夹下所有文件、子文件夹大小并排序（-h代表带有单位的）。
         
##ifconfig  
##uname 
输出当前系统信息：版本、架构、系统等
 * 无参数显示系统用户名
 * a 所有信息
 * m 电脑类型

##cat /proc/meminfo  

##shutdown
关机
 * r 关机重启 
 * h 关机不重启
 * c 取消关机命令
 * ＋now 立刻关机  shutdown -h now
 * ＋timestamp 多久关机  shutdown -h 10 (分钟)
 * ＋time 具体关机时间  shutdown -h 23:32


[return](README.md)