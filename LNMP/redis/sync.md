* 主死从上，主恢复过来后需要和从同步。
* 主从同步原理：**从服务器命令流追赶主服务器的命令流**。
    * 主服务器维护一个默认1M大小的repl_backlog，所有的dirty命令都会放到这里面，然后通信时发送给所有laves。
    * slave 会记住master  的replication ID（唯一标识从服务器自身） 和复制偏移量
        * 这两个都是主服务器返回的。如果没有怎么办，第一次同步的时候通过发送**“psync ? -1”**来实现全量同步以及获得RID、offset。
    * 调用函数sendSynchronousCommand发送psync命令（第一次参数-1，以后带有server.master对应offset），如果返回：
        * strncmp(reply,"+FULLRESYNC",11) ：代表全量同步
        * strncmp(reply,"+CONTINUE",9) ：代表部分同步
    
##同步过程
* 下载redis源码，然后编译两份redis放到不同的目录下，其中一份当作server端口为9000，另一份为从服务器端口为8999。
* 当然为了方便追踪，我们可以在编译源代码之前添加一些日志或其他返回值，这样方便跟踪。

我们在从服务器执行slaveof IP:PORT之后，就会发现返回OK完事了，但是redis从服务器需要和主服务器进行复杂的底层交互，这个对用户是透明的，涉及到的命令有ping、psync（以前是sync，现在两者都支持）。
    * 另外同步后接下来主从也会一直保持通信。这个也是透明的。
        * 因为服务器需要将新命令流发送过来。
    
###从服务器状态机
每1s同步一下
* 定时调用replicationCron方法
    * 频率可以设置，默认是1s一次
    * 发送当前的offset
    
    
* 从服务器会定时发送psync命令来告诉主服务器我同步到哪里了（```REPLCONF ACK <replication-offset>```），
    
    
    
    
###主服务器状态机
每10s同步一下：发送ping命令.
通过“info replication“ 可以看到当前同步情况。
* 预同步阶段，发送一个新行（\n，啥都没有）给所有客户端：标记即将进行同步，等待主服务器创建rdb文件。
    * 刷新从服务器最后通信交互时间


####备注
* 发送rdb文件、命令流时，不管从服务器是否处理直接返回：只负责发送。
    * 从服务器收到后才会加上对应的offset
* 即使没有数据，主服务器也会发送数据，因为从服务器维护上次通信时间，防止从认为发现timeout。
* 同步时发生连接异常：从服务器会检测到，主动关闭。主服务器仅仅关注OS的sockent error。（主服务器依然认为已经完成同步，但是从服务器没有收到最新的offset，所以不影响）。
* replication offset（64bit全局计数器） 是随着redis2.8 的psync命令出现。所有slave是一套。


#####参考
* [源代码解析](http://blog.51cto.com/sofar/1413024)
* [挤压队列](https://blog.csdn.net/gqtcgq/article/details/51287116)

[return](README.md)
****