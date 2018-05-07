[resource](http://www.jianshu.com/p/33461b619d53)
[resource2](http://www.cnblogs.com/ymy124/archive/2012/04/04/2432432.html)
上述两个一起看，效果更好

    * 公钥私钥互相加解密，成对出现。
    * 公钥加密，私钥解密。
    * 私钥数字签名，公钥验证。

##摘要算法
    * 使用单向HASH加密算法，对一段字符串进行摘要计算，生成不可逆的固定长度符号串（64B），称为**数字指纹**。
    * 注意编码问题导致不一致。
    * 如果中间传递过程中变化了，那么对内容重新计算得到的值肯定不同（随着科技发展，现在不一定）。
    * 常见算法：MD5、SHA、SHA1、MAC。
    
##加解密 
    * 对称加密：密钥加解密，客户端、服务端一样。**存在泄漏风险**
    * 非对称加密：公钥私钥成对出现，可相互解密。公钥分布在客户端，私钥仅自己有
    * 
    
##签名验证
数字签名可以理解摘要算法和加密算法的综合体。对内容应用摘要算法，对摘要加密。
    * 将公钥释放，用于加密，生成密文；
    * 接收端获得密文，用私钥解密，得到明文
    * 加密的对象可以是明文，亦可以是摘要
    * RSA、DSA、ECDSA等，**多是使用非对称加密算法**
    
### ssh登陆后自动断开
1. 服务器
    * 修改/etc/ssh/**sshd_config**配置文件，设置ClientAliveCountMax(指如果发现客户端没有相应，则判断超时次数)值大一点。然后重启ssh服务使生效：service sshd reload
    * 修改找到 ClientAliveInterval参数（每隔多久需要客户端相应一次，单位秒） 
1. 客户端
    * 修改/etc/ssh/**ssh_config**文件，ServerAliveInterval参数（每隔多久向服务器发送一次相应）
1. 客户端
利用expect 模拟键盘动作，在闲置时间之内模拟地给个键盘响应,将下列代码保存为xxx，然后用expect执行
```C
#!/usr/bin/expect  
set timeout 60  
spawn ssh user@host   
      interact {          
            timeout 300 {send "\x20"}  
      } 
expect xxx
```
接着按提示输入密码就可以了，这样每隔300秒就会自动打一个空格(\x20)，具体的时间间隔可以根据具体情况设置。

1. Windows下ssh工具的设置：
secureCRT：选项---终端---反空闲 中设置每隔多少秒发送一个字符串，或者是NO-OP协议包
putty：putty -> Connection -> Seconds between keepalives ( 0 to turn off ), 默认为0, 改为300.


[return](README.md)