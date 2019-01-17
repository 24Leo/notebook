###AES
我们知道在网络传输中，为了安全性发送方往往会对传输的数据进行加密，然后接受方在解密获得对应的数据。从早期对称加密方式（发送方、接收方都有私钥、公钥），所以如果多人合作时很难保证所有人的私钥都不会丢失或者被盗，一个出现漏洞那么整个网络就都完了。因此顺势而为出现了非对称加密（自己才有私钥，别人都是公钥），一般用公钥加密 & 私钥解密，私钥签名 & 公钥验证，所有只要服务方保存好自己的私钥就可了。

我们今天重点介绍的AES就是对称加密算法的新秀，也是目前可获得的**最安全的加密算法**
####概览
在学习之前，我们需要知道一个常识就是**越长的字符串加密复杂度越高或者说代价更大**。因此对于字符串加密AES选择的方式是分块加密然后合到一起。因此涉及到两个问题：
    * 每一块加密密钥key是否需要相同？
    * 最后一块如何填充。

| 模式 | IV | PADDING | 备注 |
| - | - | - | - |
| ECB | 无 | PKCS5, PKCS7, NOPADDING | |
| CBC | 需要 | PKCS5, PKCS7, NOPADDING | |
| CFB | 需要 | PKCS5, PKCS7, NOPADDING | |
对于加密模式就不详细介绍了因为涉及到底层原理，有兴趣可以查看[链接](https://blog.csdn.net/chence19871/article/details/27653805)。
####加密模式
AES分为几种模式，比如ECB，CBC，CFB等等，这些模式除了ECB由于没有使用IV而不太安全，其他模式差别并没有太明显，大部分的区别在IV和KEY来计算密文的方法略有区别。
####IV
针对第一个问题，每一块的加密key是否相同？答案是key是相同的，但是IV的作用是在存在加密key的前提下：只有第一个块的IV是用户提供的，其他块IV都是自动生成。 
* V称为初始向量，不同的IV加密后的字符串是不同的，加密和解密需要相同的IV。
* IV的长度为16字节。超过或者不足，可能实现的库都会进行补齐或截断。但是由于块的长度是16字节，所以一般可以认为需要的IV是16字节。
    * 前一组的密文是下一组的IV
![](/assets/1116725-76f308b0bdbaa71d.jpg)

####PADDING
填充最后一块。
####实例
所以，在设计AES加密的时候 
* 对于加密端，应该包括：加密秘钥长度，秘钥，IV值，加密模式，PADDING方式。 
* 对于解密端，应该包括：解密秘钥长度，秘钥，IV值，解密模式，PADDING方式。
    * 密钥长度：密钥key长度。

```nodejs
var crypto = require("crypto");

var algorithm='aes-256-cbc';
var key = new Buffer("aaaabbbbccccddddeeeeffffgggghhhh");
var iv = new Buffer("1234567812345678");
function encrypt(text){
    var cipher=crypto.createCipheriv(algorithm,key,iv);
    cipher.update(text,"utf8");
    return cipher.final("base64");
}
function decrypt(text){
    var cipher=crypto.createDecipheriv(algorithm,key,iv);
    cipher.update(text,"base64");
    return cipher.final("utf8");
}

var text="ni你好hao";
var encoded=encrypt(text)
console.log(encoded);
console.log(decrypt(encoded))
```

**********




[return](README.md)