##安装
```C 
brew install redis (brew uninstall redis rm ~/Library/LaunchAgents/homebrew.mxcl.redis.plist  )

yum install redis  yum install epel-release
```
####启动
```C
启动： redis-server /usr/local/etc/redis.conf
连接： redis-cli
```
####PHP扩展
    * brew install php70-redis
        * 70代表PHP版本
    * php.ini（/usr/local/etc/php/7.1/php.ini ）中添加：
        * extension=redis.so
    * 重启php-fpm
        * 先杀，后启动
            * kill -9 +pid
            * php-fpm
        * 测试 php -m | grep redis    
    * 案例
        * ```php
        <?php  
        $redis = new redis();  
        $redis->connect('127.0.0.1', 6379);  
        $redis->set('test',"11111111111");  
        $result = $redis->get('test');  
        var_dump($result);  
        ``` 

####写过程
首先我们来看一下Redis数据库在进行写操作时到底做了哪些事，主要有下面五个过程： 
    * 客户端向服务端发送写操作（数据在客户端的内存中，后面通过网络发送）。
    * 数据库服务端接收到写请求的数据（数据在服务端的内存中）。
    * 服务端调用write这个系统调用，将数据往磁盘上写（数据在系统内存的缓冲区中）。
    * 操作系统将缓冲区中的数据转移到磁盘控制器上fsync（数据在磁盘缓存中）。
    * 磁盘控制器将数据写到磁盘的物理介质中（数据真正落到磁盘上）。
 
####时延
![](/assets/3058512795-56763f622894f_articlex.png)

####方案
![](/assets/2939844570-567640281dcc5_articlex.png)


[return](README.md)