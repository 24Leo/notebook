rewrite:
先执行server层的rewrite，然后执行location层。
Server: 不管标识是last、break，在server层匹配后，都会去location层匹配。所以可以留空。

location：
如果没有last、break，会遍历继续执行；
* break：url地址栏不变，匹配结束，不在执行后续rewrite
* last：url地址栏不变，马上发起新请求，再次进入server层，重定向超过10次报500错误。
* redirect：url地址栏变，302临时重定向，爬虫不变；
* permanent：url地址栏变，301永久重定向，爬虫变；

参数
    * 如果rewrite时不想要参数：后面加上 “?”

[return](README.md)