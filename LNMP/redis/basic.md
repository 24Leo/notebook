##安装
```C 
brew install redis (brew uninstall redis rm ~/Library/LaunchAgents/homebrew.mxcl.redis.plist  )
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


[return](README.md)