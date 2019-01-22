crontab
    * crontab –e : 修改 crontab 文件，如果文件不存在会自动创建。 
    * crontab –l : 显示 crontab 文件。 
    * crontab -r : 删除 crontab 文件。
    * crontab -ir : 删除 crontab 文件前提醒用户。
    
minute   hour   day   month   week   command
每两个小时 
``` 0 */2 * * * echo "Have a break now." >> /tmp/test.txt```  
![](/assets/08090352-4e0aa3fe4f404b3491df384758229be1.png)

1. 调试程序。bt显示栈信息，-g添加所有信息
1. 查看cpu信息：cat /proc/cpiinfo
1. 查看Linux版本：cat /etc/issue
1. 查看系统是32位还是64位
    * 查看long的位数，返回32或64 getconf LONG_BIT
    * file /sbin/init

## ping：查看网络通路情况
* 
通信双方提前知道一些异常比如延迟、报文丢失等，就可以即使调整和控制，提供传输的效率和成功率。
* 
网际控制报文协议ICMP就是实现的该机制：主机或者路由发送ICMP报文来探测网络传输中的差错和异常。封装在IP数据包中
* 
ICMP分为两种：**差错报告报文和询问报文**
    * 
差错报文分为：终点不可达(3)、源点抑制(4)、时间超时(11)、参数问题(12)、改变路由(5)
    * 
询问报文分为：
        * 
回送请求(8)和回答(0)**<**源点向目地主机连续发送4条ICMP回送请求报文；目地主机接收到后会立即发送回送回答报文；源主机统计多少请求报文被发送、多少回答报文收到、往返时间、被丢弃多少报文等信息**>**
        * 
时间戳请求(13)和回答(14)：用于请求时间，做时间同步


##tree
 wget ftp://mama.indstate.edu/linux/tree/tree-1.6.0.tgz
tar xzvf tree-1.6.0.tgz
cd tree-1.6.0
make && make install

## 远程登录
ssh username@IP

##传输文件scp
1. 从服务器上下载文件
scp username@servername:/path/filename /var/www/local_dir（本地目录）

 例如scp root@192.168.0.101:/var/www/test.txt  把192.168.0.101上的/var/www/test.txt 的文件下载到/var/www/local_dir（本地目录）
2. 上传本地文件到服务器
scp /path/filename username@servername:/path
    
    例如scp /var/www/test.php  root@192.168.0.101:/var/www/  把本机/var/www/目录下的test.php文件上传到192.168.0.101这台服务器上的/var/www/目录中
3. 从服务器下载整个目录
scp -r username@servername:/var/www/remote_dir/（远程目录） /var/www/local_dir（本地目录）
    
    例如:scp -r root@192.168.0.101:/var/www/test  /var/www/  

4. 上传目录到服务器
scp  -r local_dir username@servername:remote_dir
    例如：scp -r test  root@192.168.0.101:/var/www/   把当前目录下的test目录上传到服务器的/var/www/ 目录


###同步数据到硬盘：sync
###显示开机信息：dmesg
```C
dmesg [-cns]

补充说明：kernel会将开机信息存储在ring buffer中。您若是开机时来不及查看信息，可利用dmesg来查看。
开机信息亦保存在/var/log目录中，名称为dmesg的文件里。

参　　数：
　-c 　显示信息后，清除ring buffer中的内容。
　-s <缓冲区大小>预设置为8196，刚好等于ring buffer的大小。
　-n 　设置记录信息的层级。
　
demsg | more/less/head/tail/grep str/-num...
```



[return](README.md)