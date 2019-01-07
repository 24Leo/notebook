##概述
LNMP代表的就是：Linux系统下Nginx+MySQL+PHP这种网站服务器架构。**均是Mac环境**
1. Linux是一类Unix计算机操作系统的统称，是目前最流行的免费操作系统。代表版本有：debian、centos、ubuntu、fedora、gentoo等。
2. Nginx是一个高性能的HTTP和反向代理服务器，也是一个IMAP/POP3/SMTP代理服务器。
3. Mysql是一个小型关系型数据库管理系统。
4. PHP是一种在服务器端执行的嵌入HTML文档的脚本语言。
这四种软件均为免费开源软件，组合到一起，成为一个免费、高效、扩展性强的网站服务系统。
##安装
####Mac特殊安装homebrew：
使用Mac的程序员必不可少的一步便是安装Homebrew，他就像是centOS的yum命令和ubuntu的apt-get命令一样，通过brew命令，我们可以快速的安装一些软件包。 使用命令行安装Homebrew的命令如下：
```C 
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

使用brew doctor检查是否存在冲突，然后使用brew update && brew upgrade对brew进行升级。
```

####安装PHP、PHP-FPM
注意：brew没有PHP-FPM的源，因此需要添加源。
```C
brew tap homebrew/homebrew-php
坑：
brew tap homebrew/dupes
brew tap homebrew/versions
```
**上述两个命令执行，给出了警告**：
Warning: homebrew/dupes was deprecated. This tap is now empty as all its formulae were migrated.
因为：dupes、versions已经安装或者被迁移到homebrew/core、homebrew-core，安装此即可。
#####安装PHP-FPM
```shell
brew install php71 --with-fpm --with-gmp --with-imap --with-tidy --with-debug --with-mysql --with-libmysql
```
安装后** php.ini 以及fpm的配置文件均在/usr/local/etc/php/7.1/**目录下。
#添加环境变量－－－PHP
在~/.bash_profile、~/.bashrc文件中
```C
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin"
export PATH=$PATH:/usr/local/sbin/php71-fpm

如果不对，那么下面可以借鉴：
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"
export PATH="$(brew --prefix homebrew/php/php56)/sbin:$PATH"
注意：
$(brew --prefix homebrew/php/php56)/bin是使用homebrew下载的php
$(brew --prefix homebrew/php/php56)/sbin是使用homebrew下载的php-fpm
/usr/bin是MAC自带的php
/usr/sbin是MAC自带php-fpm
```
然后：source .bash_profile\.bashrc。echo $PATH，**确认/usr/local/bin, /usr/local/sbin是否存在且排在/usr/sbin之前即可。不满足修改或者添加。
**
修改php-fpm配置文件，vim /usr/local/etc/php/7.1/php-fpm.conf，找到pid相关大概在25行，去掉注释 pid = run/php-fpm.pid, 那么php-fpm的pid文件就会自动产生在/usr/local/var/run/php-fpm.pid，下面要安装的Nginx pid文件也放在这里。

php-fpm -t : 测试语法是否正确。

#####启动
brew services start php71   或者直接 php-fpm -D
#####查询是否启动成功
ps aux | grep php-fpm 或者  lsof -Pni4 | grep LISTEN | grep php。存在相关进程即可
###设置开机启动
```C
ln -sfv /usr/local/opt/php56/homebrew.mxcl.php56.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
如果没有该文件夹，则新建即可。：mkdir -p ~/Library/LaunchAgents
```
###安装PHP composer
composer可以对php项目进行依赖管理，具体用法和内容可以查看官网.
首先安装依赖包： brew search phalcon  ＝＝＝＝》 brew install homebrew/php/php71-phalcon
composer -v 查看
##安装mysql
命令：brew install mysql
启动：brew services start mysql
开机启动： 
```C
ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
```
通过jumbo安装的mysql没有启动权限，需要root或者添加mysql用户
####安全机制设置
**/usr/local/opt/mysql/bin/mysql_secure_installation**
```C
> Enter current password for root (enter for none):     //默认没有密码，直接回车即可
> Change the root password? [Y/n]                       //是否更改root密码，选择是，然后输入并确认密码
> Remove anonymous users? [Y/n]                         //是否删除匿名用户，选择是
> Disallow root login remotely? [Y/n]                   //是否禁止远程登录，选择是
> Remove test database and access to it? [Y/n]          //是否删除test数据库，选择是
> Reload privilege tables now? [Y/n]                    //是否重载表格数据，选择是

查看：ps aux | grep mysql
登录：mysql -uroot -ppasswd
```
####安装phpmyadmin
brew install autoconf 
// 之前安装常用软件，可能已经安装过了
brew install phpmyadmin
// 安装phpmyadmin
###源码安装
在https://dev.mysql.com/downloads/mysql/下载指定GA版本，选择source code下载即可
进入目录后：sudo cmake .
### 编译失败
* g++: internal compiler error: Killed (program cc1plus)Please submit a full bug report ====》内存不足， 在linux下增加临时swap空间
        * dd if=/dev/zero of=/home/swap bs=1024 count=500000
        of=/home/swap,放置swap的空间; count的大小就是增加的swap空间的大小，1024就是块大小，这里是1K，所以总共空间就是bs*count=500M
mkswap /home/swap
把刚才空间格式化成swap各式
不支持的话：/sbin/mkswap
swapon /home/swap
使刚才创建的swap空间
如果想关闭刚开辟的swap空间，只需命令：#swapoff
如果命令不存在：/sbin/mkswap，加上/sbin/即可

##安装nginx
brew install nginx。
**配置文件位置：/usr/local/etc/nginx**
**默认启动页面：/usr/local/Cellar/nginx/1.12.1/html/index.html**
使用命令启动nginx服务：
sudo nginx

默认监听8080端口，如果需要使用**80端口的话，需要将nginx加入root组当**中：
    sudo cp -v /usr/local/opt/nginx/*.plist /Library/LaunchDaemons/
    sudo chown root:wheel /Library/LaunchDaemons/homebrew.mxcl.nginx.plist

测试nginx是否安装成功，因为默认配置文件监听的是8080端口，所以先对8080端口发起请求：curl -IL http://127.0.0.1:8080
####相关操作：
sudo nginx //启动nginx
sudo nginx -s reload|reopen|quit //重新加载|重启|退出
或者：
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
开机启动
ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist

##配置nginx
####配置nginx.conf
```C
mkdir -p /usr/local/var/logs/nginx
mkdir -p /usr/local/etc/nginx/sites-available
mkdir -p /usr/local/etc/nginx/sites-enabled
mkdir -p /usr/local/etc/nginx/conf.d
mkdir -p /usr/local/etc/nginx/ssl
sudo mkdir -p /var/www
sudo chown :staff /var/www
sudo chmod 775 /var/www
```
#####修改配置文件nginx.conf
vim /usr/local/etc/nginx/nginx.conf 输入以下内容：
```C
worker_processes  1;

error_log   /usr/local/var/logs/nginx/error.log debug;

pid        /usr/local/var/run/nginx.pid;

events {
    worker_connections  256;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /usr/local/var/logs/access.log  main;

    sendfile        on;
    keepalive_timeout  65;
    port_in_redirect off;

    include /usr/local/etc/nginx/sites-enabled/*;
}```
####设置nginx php-fpm配置文件
vim /usr/local/etc/nginx/conf.d/php-fpm
```C
#proxy the php scripts to php-fpm
location ~ \.php$ {
    try_files                   $uri = 404;
    fastcgi_pass                127.0.0.1:9000;
    fastcgi_index               index.php;
    fastcgi_intercept_errors    on;
    include /usr/local/etc/nginx/fastcgi.conf;
}```
nginx虚拟主机准备工作

####创建虚拟项目
 info.php index.html 404.html 403.html文件到** /var/www 下面**
vi /var/www/info.php
vi /var/www/index.html
vi /var/www/403.html
vi /var/www/404.html
####创建默认虚拟主机default
vim /usr/local/etc/nginx/sites-available/default输入：
```C
server {
    listen       80;
    server_name  localhost;
    root         /var/www/;

    access_log  /usr/local/var/logs/nginx/default.access.log  main;

    location / {
        index  index.html index.htm index.php;
        autoindex   on;
        include     /usr/local/etc/nginx/conf.d/php-fpm;
    }

    location = /info {
        allow   127.0.0.1;
        deny    all;
        rewrite (.*) /.info.php;
    }

    error_page  404     /404.html;
    error_page  403     /403.html;
}```
####创建ssl默认虚拟主机default-ssl
vim /usr/local/etc/nginx/sites-available/default-ssl输入：
```C
server {
    listen       443;
    server_name  localhost;
    root       /var/www/;

    access_log  /usr/local/var/logs/nginx/default-ssl.access.log  main;

    ssl                  on;
    ssl_certificate      ssl/localhost.crt;
    ssl_certificate_key  ssl/localhost.key;

    ssl_session_timeout  5m;

    ssl_protocols  SSLv2 SSLv3 TLSv1;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers   on;

    location / {
        include   /usr/local/etc/nginx/conf.d/php-fpm;
    }

    location = /info {
        allow   127.0.0.1;
        deny    all;
        rewrite (.*) /.info.php;
    }

    error_page  404     /404.html;
    error_page  403     /403.html;
}
```
####创建phpmyadmin虚拟主机
vim /usr/local/etc/nginx/sites-available/phpmyadmin 
```C
server {
    listen       306;
    server_name  localhost;
    root    /usr/local/share/phpmyadmin;

    error_log   /usr/local/var/logs/nginx/phpmyadmin.error.log;
    access_log  /usr/local/var/logs/nginx/phpmyadmin.access.log main;

    ssl                  on;
    ssl_certificate      ssl/phpmyadmin.crt;
    ssl_certificate_key  ssl/phpmyadmin.key;

    ssl_session_timeout  5m;

    ssl_protocols  SSLv2 SSLv3 TLSv1;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers   on;

    location / {
        index  index.html index.htm index.php;
        include   /usr/local/etc/nginx/conf.d/php-fpm;
    }
}```
####设置SSL
```C
mkdir -p /usr/local/etc/nginx/ssl
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=localhost" -keyout /usr/local/etc/nginx/ssl/localhost.key -out /usr/local/etc/nginx/ssl/localhost.crt
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=phpmyadmin" -keyout /usr/local/etc/nginx/ssl/phpmyadmin.key -out /usr/local/etc/nginx/ssl/phpmyadmin.crt
```
####创建虚拟主机软连接，开启虚拟主机
```C
ln -sfv /usr/local/etc/nginx/sites-available/default /usr/local/etc/nginx/sites-enabled/default
ln -sfv /usr/local/etc/nginx/sites-available/default-ssl /usr/local/etc/nginx/sites-enabled/default-ssl
ln -sfv /usr/local/etc/nginx/sites-available/phpmyadmin /usr/local/etc/nginx/sites-enabled/phpmyadmin
```
###语法是否正确：nginx -t
####访问：
```C
http://localhost/ -> index.html
http://localhost/info.php -> info.php via phpinfo();
http://localhost/404 -> 404.html
https://localhost/ -> index.html(SSL)
https://localhost/info.php -> info.php via phpinfo();(SSL)
https://localhost/404 -> 404.html(SSL)
https://localhost:306 -> phpmyadmin(SSL)
```
##设置快捷服务控制命令
为了后面管理方便，将命令 alias 下，vim ~/.bash_aliases 输入一下内容：
```C
alias nginx.start='launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx.stop='launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx.restart='nginx.stop && nginx.start'
alias php-fpm.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist"
alias php-fpm.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist"
alias php-fpm.restart='php-fpm.stop && php-fpm.start'
alias mysql.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
alias mysql.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
alias mysql.restart='mysql.stop && mysql.start'
alias redis.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
alias redis.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
alias redis.restart='redis.stop && redis.start'
alias memcached.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"
alias memcached.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"
alias memcached.restart='memcached.stop && memcached.start'
```
####让快捷命令生效
echo "[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases" >> ~/.bash_profile     
source ~/.bash_profile
####创建站点目录到主目录，方便快捷访问
ln -sfv /var/www ~/htdocs

[返回目录](README.md)