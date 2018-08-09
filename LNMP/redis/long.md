[参考](https://blog.csdn.net/u011784767/article/details/76824822)
Redis对客户端响应请求的工作模型是单进程和单线程的。
再次确定一个问题，客户端发起更新操作时：
    * 客户端将数据发送（此时数据在客户端内存中）
    * 服务器收到数据（服务器内存中）
    * 服务器调用write写入磁盘（操作系统缓存中）
    * save等方法促使fsync写入磁盘（磁盘缓存中）
    * 写入磁盘（磁盘中）。

所以可以明确一点：
    * **redis服务器主进程在处理客户端请求时也会占用操作系统IO**
    * 所以子进程备份时有可能会相互阻塞：主进程服务可能受到影响。
    
##两种
除了官方的两种，还可以自定义。
###RDB
* RDB模式下就是生成一个数据库的快照snapshot，默认名dump.rdb。
* 频率：
    * 在redis.conf中可以配置
        * save 900 1 ： 代表每900S内至少1个key更改即需要快照
    * 手动触发save、bgsave命令
    * 如果配置save "" 或者手动 save "" ，那么会停止快照
* save、bgsave
    * 两者其实都是调用的阻塞接口rdbsave，不同的是父进程还是子进程被阻塞！
    * save直接在主进程生成快照文件并且fsync到磁盘。
        * 主进程阻塞：不会接受任何客户端请求。
    * bgsave通过**fork一个子进程**，由子进程去生成快照并写入fsync磁盘。然后通知父进程。
        * 子进程阻塞但是父进程正常。

#####伪代码
```python
// rdbSave是阻塞的～
def SAVE():
    rdbSave()
   
def BGSAVE():
    pid = fork()
    if pid == 0:
        # 子进程保存RDB
        rdbSave()
    elif pid > 0:
        # 父进程继续处理请求，并等待子进程的完成信号
        handle_request()
    else:
        # pid == -1
        # 处理fork 错误
        handle_fork_error()
```
####优缺点
#####优点
* 文件较少较紧凑，方便备份
* 性能最优：最大化redis性能。
    * 备份时fork一个子进程，不影响主进程
* 拷贝RDB文件是完全安全的

#####缺点
* 可能数据不完整：每隔多少时间备份就有可能少多少时间的。
    * 完整数据备份，所以工作不轻松。间隔时间不应太短。
* 数据量大备份时内存占用*2，由于内存不足可能影响主进程性能。
* CPU是瓶颈时：fork耗时。
    * 虽然AOF也需要fork子进程，但是数据持久性不会有影响。

###AOF
* 是将数据库内容以协议文本的形式将所有更改命令**追加**到文件中（类似于redo log）。
* 配置：
    * no     
        * 操作系统控制：Redis 被关闭、AOF 功能被关闭、系统的写缓存被刷新（可能是缓存已经被写满，或者定期保存操作被执行）
        * 主进程save。
    * everysec 
        * 子进程调用save。
    * always
        * 每次变更都由主进程调用save
* 随着命令越来越多，那么aof文件也会越来越大，redis提供bgrewriteaof命令：先以快照的方式将数据按命令形式保存，然后替换原aof文件，后续命令追加进来。
    * **fork子进程，有两个进程**
    * 子进程根据数据库数据快照往临时文件中写入**重建数据库状态的命令集**
        * 新 AOF 文件包括了恢复当前数据集所需的最小命令集合。
    * 父进程继续处理，新命令写入原备份AOF文件，同时缓存这些命令集。
    * 子进程写完了，信号通知父进程：然后父进程将缓存的命令集写入该临时文件
    * 父进程将临时文件替换原备份AOF文件并重命名文件，后续命令继续写入该文件。
* 后台备份
    * 启动子进程进行持久化，将当前数据以命令形式保存到临时文件。
    * 主进程继续服务，将变动命令保存到server.aof_rewrite_buf_blocks，等子进程结束后，将命令写入对应文件。
    * 然后主进程重命名临时文件替换原备份文件。
    
有两个步骤：
* 后台备份（如有正在备份的子进程，直接警告返回）
    * 此时子进程负责生成中间文件，主进程处理请求同时将变更命令放到 server.aof_rewrite_buf_blocks链表中。
    * 子进程备份结束，更新文件名，然后通知父进程
    * 父进程调用backgroundRewriteDoneHandler回调函数将链表中命令追加到备份文件。
* 备份过程fsync
    * 此时的命令写入server.aof_buf中，然后根据配置的更新时机写入磁盘。
* 综上：更新缓存可以存储在 server.aof_buf 中，可以存储在server.server.aof_rewrite_buf_blocks 链表中。
    * 它们的关系是：每一次数据变更记录都会写入 server.aof_buf 中，同时如果后台子进程在持久化，变更记录还会被写入 server.aof_rewrite_buf_blocks 中。server.aof_buf 会在特定时期写入指定文件，server.aof_rewrite_buf_blocks 会在后台持久化结束后追加到文件。
    * Redis 源码中是这么实现的：propagate() -> feedAppendOnlyFile() -> aofRewriteBufferAppend()
        * 如果是变更命令，调用redis的propagate命令，然后feedAppendOnlyFile添加到server.aof_buf中，下面会有一个判断，如果当前有AOF子进程备份，则调用aofRewriteBufferAppend将aof_buf所有数据写入aof_rewrite_buf_blocks链表
        * 对了propagrate会向 AOF 和从机发布数据更新。
            * AOF：feedAppendOnlyFile
            * 从服务器：replicationFeedSlaves
![](/assets/wKioL1NTm3KRVaqbAAD825sYnIs316.jpg)


* 这里有一个疑问，两条主线都会涉及文件的写：后台执行会写一个 AOF 文件，边服务边备份也会写一个，以哪个为准？
    * 后台持久化的数据首先会被写入「temp-rewriteaof-bg-%d.aof」，其中「%d」是 AOF 子进程 id；待 AOF 子进程结束后，「temp-rewriteaof-bg-%d.aof」会被以追加的方式打开，继而写入 server.aof_rewrite_buf_blocks 中的更新缓存，最后「temp-rewriteaof-bg-%d.aof」文件被命名为 server.aof_filename，所以之前的名为 server.aof_filename 的文件会被删除，也就是说边服务边备份写入的文件会被删除。边服务边备份的数据会被一直写入到 server.aof_filename 文件中。
    * 因此，确实会产生两个文件，但是最后都会变成 server.aof_filename 文件。
    * 这里还有一个疑问，既然有了后台持久化，为什么还要边服务边备份？边服务边备份时间长了会产生数据冗余甚至备份过旧的数据，而后台持久化可以消除这些东西。看，这里是 Redis 的双保险。

####优缺点
#####优点
* 持久性保证（不完全，只是相对RDB来说）
    * 设置每秒同步，至多丢失一秒数据。
    * 持久化过程的更新操作会保存起来，然后完成后强制写入文件中。
* 重启时恢复较快

#####缺点
* 备份文件很大
* 性能不如RDB高
    * 每秒的话依然很高，如果关闭可以打到和RDB一样性能。

###对比
rdb

###学习
可以新建一个机器当作slave，不处理任何请求，仅两个功能：
    * 同步master
    * 生成rdb、aof文件
        * 这样主服务器就不需要生成快照、dump文件了，不会抢占IO。

主服务器就用来处理更新请求，某个slave专门备份，剩下slave专门处理读请求～～～
    * 主服务器禁止持久化～
    
    

[return](README.md)