参数：
```C++
-A/--user-agent <string>              设置用户代理发送给服务器
-b/--cookie <name=string/file>        cookie字符串或文件读取位置
-c/--cookie-jar <file>                操作结束后把cookie写入到这个文件中
-C/--continue-at <offset>             断点续转
-D/--dump-header <file>               把header信息写入到该文件中
-d/--data <data>                      HTTP POST方式传送数据
-e/--referer                          来源网址
-f/--fail                             连接失败时不显示http错误
-o/--output                           把输出写到该文件中
-O/--remote-name                      把输出写到该文件中，保留远程文件的文件名
-r/--range <range>                    检索来自HTTP/1.1或FTP服务器字节范围
-s/--silent                           静音模式。不输出任何东西
-T/--upload-file <file>               上传文件
-u/--user <user[:password]>           设置服务器的用户和密码
-w/--write-out [format]               什么输出完成后
-x/--proxy <host[:port]>              在给定的端口上使用HTTP代理
-#/--progress-bar                     进度条显示当前的传送状态
```
例子：