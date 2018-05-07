##[SHA](http://blog.csdn.net/gszhy/article/details/20533733)
* 
不可以从消息摘要中复原信息；
* 
两个不同的消息不会产生同样的消息摘要。

Secure Hash Algorithm (安全散列算法) 的缩写，它用来产生 20 个字节 (160位) 的散列值，该算法常用于数字签名，以防止数据遭到篡改。Linux下一般使用 openssl 提供 API 计算数据的 SHA1 值。

SHA1始终把消息当成一个位（bit）字符串来处理。一个“字”（Word）是32位，而一个“字节”（Byte）是8位。比如，字符串“abc”可以被转换成一个位字符串：01100001 01100010 01100011，即表示成16进制字符串: 0x616263.
###例子
```C
#include <openssl/sha.h>
    unsigned char *SHA1(const unsigned char *d, unsigned long n,unsigned char *md);```

函数中的
* 
第 1 个参数 d 表示要处理的数据；
* 
第 2 个参数 n 表示该数据的长度；
* 
第 3 个参数 md 表示计算出的 sha 值的存放地方，如果为 NULL，那么系统会安排一个静态缓冲区对其存储。
```C++
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>
　
#define SHA1LEN SHA_DIGEST_LENGTH
　
static const char hex_chars[] = "0123456789abcdef";
　
void convert_hex(unsigned char *md, unsigned char *mdstr)
{
        int i;
        int j = 0;
        unsigned int c;
        
        for (i = 0; i < 20; i++) {
            c = (md[i] >> 4) & 0x0f;
            mdstr[j++] = hex_chars[c];
            mdstr[j++] = hex_chars[md[i] & 0x0f];
        }
        mdstr[40] = '\0';
}
　
int main(int argc, char **argv)
{
        if (argc != 2) {
            fprintf (stderr, "usage: %s your-string\n", argv[0]);
            exit (EXIT_FAILURE);
        }
        
        char md[SHA_DIGEST_LENGTH];
        char mdstr[40];
        
        bzero(md, SHA_DIGEST_LENGTH);
        bzero(mdstr, 40);
        
        SHA1(argv[1], strlen(argv[1]), md);
        
        convert_hex(md, mdstr);
        
        printf ("Result of SHA1 : %s\n", mdstr);
        
        return 0;
}
Result of SHA1 : f6f80b59f1b25c82b64d857594fee53cd0df3604
```
###升级：
* 
缺陷：就是32位系统下不能对超过4G的文件计算HASH值(参考第一个指针，指向的空间)
* 
改进：
```C++
#include <openssl/sha.h>  
int SHA1_Init(SHA_CTX *c);  
int SHA1_Update(SHA_CTX *c, const void *data, unsigned long len);  
int SHA1_Final(unsigned char *md, SHA_CTX *c);  
　
SHA1_Init() 初始化一个 SHA_CTX 结构，该结构存放弄了生成 SHA1 散列值的一些参数，在应用中可以不用关系该结构的内容。
SHA1_Update() 函数正是可以处理大文件的关键。它可以反复调用，比如说我们要计算一个 5G 文件的散列值，
    我们可以将该文件分割成多个小的数据块，对每个数据块分别调用一次该函数，这样在最后就能够应用 
SHA1_Final() 函数正确计算出这个大文件的 sha1 散列值。
```

####例子：
```C++
#include <stdio.h>  
#include <stdlib.h>  
#include <string.h>  
#include <openssl/sha.h>  
　   
static const char hex_chars[] = "0123456789abcdef";  
　   
void convert_hex(unsigned char *md, unsigned char *mdstr)  
{  
    int i;  
    int j = 0;  
    unsigned int c;  
   
    for (i = 0; i < 20; i++) {  
        c = (md[i] >> 4) & 0x0f;  
        mdstr[j++] = hex_chars[c];  
        mdstr[j++] = hex_chars[md[i] & 0x0f];  
    }  
    mdstr[40] = '\0';  
}  
　   
int main(int argc, char **argv)  
{  
    SHA_CTX shactx;  
    char data[] = "hello groad.net";  
    char md[SHA_DIGEST_LENGTH];  
    char mdstr[40];  
  
    SHA1_Init(&shactx);  
    SHA1_Update(&shactx, data, 6);  
    SHA1_Update(&shactx, data+6, 9);  
    SHA1_Final(md, &shactx);  
    convert_hex(md, mdstr);  
    printf ("Result of SHA1 : %s\n", mdstr);  
    return 0;  
}    
Result of SHA1 : 048b371b37fd824645a54718461ae5fe84f1805c  
在上面函数中，我们将要处理的字串 "hello groad.net" 分割成 2 部分进行处理，第 1 部分处理前 6 个字节，
    第 2 部分处理剩下的字节。
```


[返回目录](README.md)