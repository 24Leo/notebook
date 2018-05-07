
## stdlib.h 头文件里包含了C语言的中最常用的系统函数

```C
宏：
NULL 空
EXIT_FAILURE 失败状态码
EXIT_SUCCESS 成功状态码
RAND_MAX rand的最大返回值
MB_CUR_MAX 多字节字符中的最大字节数

变量：
typedef size_t是unsigned integer类型
typedef wchar_t 一个宽字符的大小
struct div_t 是结构体类型 作为div函数的返回类型
struct ldiv_t是结构体类型 作为ldiv函数的返回类型

函数：

字符串函数
atof(); 将字符串转换成浮点型数
atoi(); 将字符串转换成整型数(第一个非空格字符是数字或者‘-’，否则为0,，之后检测到非数字(包括结束符\0)时停止转换
atol(); 将字符串转换成长整型数
strtod(); 将字符串转换成浮点数
strtol(); 将字符串转换成长整型数
strtoul(); 将字符串转换成无符号长整型数

内存控制函数
calloc(); 配置内存空间:自动初始化该内存空间为零，而malloc不初始化，里边数据是随机的垃圾数据。
free(); 释放原先配置的内存
malloc(); 配置内存空间(字节数):返回类型是 void*指向被分配内存的指针(此存储区中的初始值不确定)，否则返回空指针NULL
realloc(); 重新分配主存:新的大小小于原内存大小，可能会导致数据丢失，慎用！
        calloc比malloc 多了对内存的写零操作，而写零这个操作我们有时候需要，而大部分时间不需要
环境函数
abort(); 异常终止一个进程
atexit();设置程序正常结束前调用的函数
exit(); 正常结束进程
getenv(); 取得环境变量内容
system(); 执行shell 命令

搜索和排序函数
bsearch(); 二元搜索
qsort(); 利用快速排序法排列数组

数学函数
abs(); 计算整型数的绝对值
div(); 将两个整数相除, 返回商和余数
labs(); 取长整型绝对值
rand(); 随机数发生器
srand(); 设置随机数种子

多字节函数
mblen(); 根据locale的设置确定字符的字节数
mbstowcs(); 把多字节字符串转换为宽字符串
mbtowc(); 把多字节字符转换为宽字符
wcstombs(); 把宽字符串转换为多字节字符串
wctomb(); 把宽字符转换为多字节字符```


### 内存分配与释放(malloc、calloc、realloc、free)


**内存区域**
在程序的执行期间经常需要动态的分配内存。
具体表现有在函数体内声明了一个变量、结构体或数组等，这样的内存是分配是由系统操作分配在栈上的，在执行完函数后，函数体内开头所声明的变量、结构体或数组所持有的内存空间都会被释放。所以要将函数体内的执行结果返回或反映到函数体外，一般是行不通的(不考虑全局变量)。
还有一种是由coder们调用malloc()等内存分配函数在堆上开辟新内存块，这些内存块会一起存在直至调用free()函数去释放。作用域广了，但也引入了潜在的内存泄露(程序卡顿)和野指针(程序crash)问题。

**函数讲解**
```C
#include <stdlib.h>

   void *malloc(size_t size);
   void *calloc(size_t nmemb, size_t size);
   void *realloc(void *ptr, size_t size);

   void free(void *ptr);```
引入stdlib.h头文件后可以在代码中操作内存的分配与释放。
下面来一一讲解下内存分配函数：

**void *malloc(size_t size);**
malloc()函数分配了指定大小为size的字节数，这些字节块**是没有被初始化的**，也就是说有可能是非\0有值的。这也正是malloc()的缺点。如果size为0，则函数返回NULL；否则返回一个指向该内存块的指针，该指针可随后被free()调用释放。
函数的返回类型是void *，即任意类型，虽然很多编译器会把malloc()返回的地址自动转换成赋值语句左边的指针类型，但在编码中，习惯在malloc()赋值前做一次强制转换。
另外，由于可能在执行内存分配时刚好内存不足，函数也会返回一个NULL，所以对所返回的指针做非空判断。如下所示：

       char* p = (char*)malloc(10 * sizeof(char));
       if (p == NULL) {
            // handle null error
       } else {
            // go on
       }
**void *calloc(size_t nmemb, size_t size);**
calloc()解决了malloc()分配的内存块无初始化的问题，**每个字节都被强制赋值为\0。还有另一个特点是把内存块分配为给定了大小的数组**。即第一个参数nmemb指定了分配的元素个数，第二个参数size指定了单个元素的指定大小。
刚才malloc()的示例代码可以使用calloc()的话则可修改为：

       char* p = (char*)calloc(10, sizeof(char));
       if (p == NULL) {
            // handle null error
       } else {
            // go on
       }
**void *realloc(void *ptr, size_t size)**
在程序运行中，碰到新的数据需要继续填充处理时发现原来的内存块已经不够了，则要开辟新更大的内存块以处理更多的数据，则就需要使用到realloc()函数了。
realloc()函数的第一个参数ptr表示指向老的内存块的指针，第二个参数sizt则表示新的内存块大小。
开辟出新的内存块后，会把老内存块的数据复制到新内存块中；老内存块的空间会自动被系统回收。
所以如果新开辟的内存块比较老的内存块大，则前部分是老内存块的数据，后半部分则是未初始化的数据，即内容具有不确定性；如果新开辟的内存块比老的内存块小，则相当于复制了老内存块前半部分的内存到新的内存块中去了；
函数正常执行时，返回新内存块的首地址指针；如果函数执行失败，则返回NULL。
如果指定的ptr是NULL，则函数的作用相当于malloc(size);
如果指定的size值为0，则相当于调用了free(ptr)去释放了原有的内存块；

**void free(void *ptr)**
释放指针ptr所指向的内存块。如果ptr是NULL，则相当于什么也没做。
当对ptr执行free()操作后，要及时对ptr赋值为空，避免野指针的出现或误操作。

realloc的内存泄露陷井
说是内存泄露陷井，其实是想说一个编码不规范的现象。挺多人在使用realloc()是这么写的：

        char * p = (char *)malloc(10 * size(char));
        ... ...
        // 发现内存不够用了
        p = realloc(p, 20 * size(char));
这样子的代码，如果realloc()因某种原因执行失败导致返回NULL对p赋值，则失去了指向原先分配的10 * size(char)这个老内存块的指针，该老内存块再也无法通过free()函数释放了，导致内存泄露。
正确的写法应该是这样子的：

        char * p = (char *)malloc(10 * size(char));
        ... ...
        // 发现内存不够用了
        char * tmp = realloc(p, 20 * size(char));
        if (tmp == NULL) {
          // realloc() do failed. do some action
          return; // 这里选择return,也可以再尝试realloc一次或其它
        } else {
            p = tmp;
        }
        // go on do something...
示例代码
以下代码演示从命令行终端中不断获取输入字符的过程。
由于一开始内存分配仅分配够存储两个字符，当执行操作时就会出现空间不足需要调用realloc()再开辟更大的空间。

其中示例代码中的函数get_string()见sodino另一篇文章【C/C++】使用getchar()实现gets()功能

```C
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//  Created by sodino on 15-3-13.
//  Copyright (c) 2015年 sodino. All rights reserved.
int main/*04*/ (int argc, char ** argv) {
    long cache = 2;
    long max_content = 2;
    long max_memory = max_content + 1; // 最后一个位置留给字符串终止符
    char * pStore = calloc(max_memory, sizeof(char));
    if (pStore == NULL) {
        printf("calloc() failed.\n");
        return EXIT_FAILURE;
    }
    long lenStore = 0;
    long remain = max_content;
    
    while (1) {
        printf("input char or input 'exit' to exit: \n");
        // 从命令行终端获取输入的字符，每次最多获取10个字符
        char * pChar = get_string(10);
        if (strcmp(pChar, "exit") == 0) {
            break;
        }
        
        unsigned long t_len = strlen(pChar);
        if (t_len > remain) {
            printf("not enough memory. \n");
            long increase = t_len - remain;
            max_memory = max_memory + increase + cache;
            char * pClone = pStore;
            
            // 开辟更大的内存块...
            pClone = realloc(pClone, max_memory * sizeof(char));
            if (pClone == NULL) {
                //
                printf("OOM, break; pStore=%s \n", pStore);
                break;
            } else {
                // 开拓内存成功
                pStore = pClone;
                remain = remain + increase + cache;
                max_content = max_memory - 1;
                printf("realloc(), new memory size=%lu max=%lu remain=%lu go to append string.\n", max_memory * sizeof(char), max_content, remain);
            }
            
            strlcat(pStore, pChar, max_memory);
        } else {
            if (strlen(pStore) == 0) {
                strcat(pStore, pChar);
            } else {
                strlcat(pStore, pChar, max_memory);
            }
        }
        lenStore = strlen(pStore);
        remain = max_content - lenStore;
        printf("lenStore=%lu max=%lu remain=%lu content:%s \n", lenStore, max_content, remain, pStore);
    }
    printf("end.");
    
    // 程序终止后释放内存
    free(pStore);
    // 保持习惯，及时置空
    pStore = NULL;
    return EXIT_SUCCESS;
}```

[返回目录](README.md)