主死从上，主恢复过来后需要和从同步。
    * slave 会记住旧 master 的旧 replication ID 和复制偏移量

##同步过程
* 下载redis源码，然后编译两份redis放到不同的目录下，其中一份当作server端口为9000，另一份为客户端端口为8999。。

我们可以执行slaveof IP:PORT之后，就会发现返回就完事了，但是redis客户端需要和服务器进行复杂的底层交互，这个对用户是透明的。
###从服务器状态机
###主服务器状态机


[return](README.md)