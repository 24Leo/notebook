[参考](https://blog.csdn.net/u011784767/article/details/76824822)
Redis对客户端响应请求的工作模型是单进程和单线程的。
##两种
除了官方的两种，还可以自定义。
###RDB
* RDB模式下就是生成一个数据库的快照snapshot，默认名dump.rdb。
* 频率：
    * 在redis.conf中可以配置
        * save 900 1 ： 代表每900S内至少1个key更改即需要快照
    * 手动出发save、bgsave命令
    * 如果配置save "" 或者手动 save "" ，那么会停止快照
* save、bgsave
    * save直接在主进程生成快照文件并且fsync到磁盘

###AOF
###对比




[return](README.md)