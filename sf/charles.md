* charles破解:
    * https://www.zzzmode.com/mytools/charles/
    
* 代理手机-抓包
    * 保证手机和电脑在一个wifi中
    * charles配置：
        * https支持：charles-proxy-ssh proxy Setting 
            * 配置为：*:443
        * 端口设置：charles-proxy-proxySetting    
            * 设置端口号，并启用http透明传输

    * 手机连上相同wifi，设置wifi代理IP：PORT
        * IP代理为charlesIP：charles-help-localIpAddress
        * PORT为上述charles配置
    * 手机设置：
        * 连接相同wifi，设置代理IP和PORT即可
    * charles弹出弹框，选择allow即可
    * 如果想选择某一个域名，右击选择focus即可；
    * 如果仅想抓起某些域名：
        * 

##charles + Chrome + switchOmega [参考](http://blog.csdn.net/liu251/article/details/52096142)
    * proxy - mac os proxy （启用系统代理）
    * proxy - proxy settings - proxies - port : 8888（可自定义）
        * enable transparent http proxying
    * proxy(/ help) - sslproxying - install charless root certificate （安装ssl代理）
    * proxy - ssl proxying settings - ssl proxying
        * add : host(*) & port (443)
    * 
    * chrome
        * 添加omega新配置
        * http  127.0.0.1  8888 (对应上面自定义)
    * 手机客户端安装：charles-proxy(/ help) - sslproxying - install on remote...
        * 手机设置好代理，输入网址安装证书并信任
        * 手机设置-通用-关于本机-信任证书设置-开通即可
        * *****************************
    #########################    
    
[return](README.md)