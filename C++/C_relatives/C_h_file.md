
## C常用头文件
* 
—很多人被灌输了这样一种概念：要写面向对象程序，那么就需要学习一种面向对象编程语言，例如C++、Java、C#等等，而C语言是用来编写结构化程序的。
* 
—事实上，面向对象只是一种编程思想，不是一种编程语言。换句话说，面向对象是一种游戏规则，它不是游戏。

1.      
定义单行宏：主要有以下三种用法．
```C
1) 前加##或后加##(连接符，两个Token连接成一个)，将标记作为一个合法的标识符的一部分．
      注意，不是字符串．多用于多行的宏定义中．例如：
       #define A(x)  T_##x
则 int A(1) = 10; //等效于int T_1 = 10;
#define A(x)  Tx##__
则 int A(1) = 10; //等效于int T1__ = 10;
    2) 前加#@，将标记转换为相应的字符，注意：仅对单一标记转换有效
        #define B(x) #@x
 则B(a)即’a’，B(1)即’1’．但B(abc)却不甚有效．
   3) 前加#，将标记转换为字符串．
 #define C(x) #x
 则C(1+1) 即 ”1+1”．
 ```


```C
格式：
    导入头文件：     #include <name.h>/"name.h"   C++中不用 .h
    define:          #define VAR VALUE
    类型重命名：     typedef TYPE SELFTYPE;       别忘了 '；'
<assert.h>      断言
<ctype.h>       字符类测试
<errno.h>       库函数抛出的错误代码（部分）
<float.h>       浮点数运算
<limits.h>      检测整型数据类型值范围
<locale.h>      本土化
<math.h>        数学函数
<setjmp.h>      “非局部跳转”
<signal.h>      信号
<stdarg.h>      可变参数列表
<stddef.h>      一些常数，类型和变量
<stdio.h>       输入和输出
<stdlib.h>      实用功能
<string.h>      字符串函数
<time.h>        时间和日期函数```

| assert.h | ctype.h | errno.h | float.h |
| -- | -- | -- | -- |
| limits.h | [locale.h](locale.md) | [math.h](math.md) | setjmp.h |
| stdarg.h | stddef.h | [stdio.h](stdio.md) | [stdlib.h](stdlib.md) |
| [string.h](../string.md) | [time.h](time.md) | signal.h |  |



### assert.h

头文件 assert.h 唯一的目的是提供**宏assert的定义**。如果断言非真（expression==0），则程序会在标准错误流输出提示信息，并使程序异常中止调用abort() 。
```C
定义：void assert (int expression);
//#define NDEBUG
#include <assert.h>	
int main(int argc, char* argv[]){
	int a = 12;
	int b = 24;
	assert( a > b );
	printf("a is larger than b!");
	return 0;
}```
上面的程序会发现程序中止，printf并未执行，且有这样的输出： main: Assertion `a > b' failed. 原因就是因为a其实小于b，导致断言失败，assert 输出错误信息，并调用abort()中止了程序执行。


## ctype.h

该ctype.h 主要提供两类重要的函数：字符测试函数和字符大小转化函数。提供的函数中都以int类型为参数，并返回一个int类型的值。实参类型应该隐式转换或者显示转换为int类型。
```C
int isalnum(int c); 判断是否是字母或数字。
int isalpha(int c); 判断是否是字母。
int iscntrl(int c); 判断是否是控制字符。
int isdigit(int c); 判断是否是数字。
int isgraph(int c); 判断是否是可显示字符。
int islower(int c); 判断是否是小写字母。
int isupper(int c); 判断是否是大写字母。
int isprint(int c); 判断是否是可显示字符。
int ispunct(int c); 判断是否是标点字符。
int isspace(int c); 判断是否是空白字符
int isxdigit(int c); 判断字符是否为16进制。
int tolower(int c); 转换为小写字母。
int toupper(int c); 转换为大写字母。```

## errno.h
error.h 是 C语言 C标准函式库里的头文件，定义了通过错误码来返回错误信息的宏：

```C
errno 宏定义为一个int型态的左值, 包含任何函数使用errno功能所产生的上一个错误码。

一些表示错误码，定义为整数值的宏：
EDOM 源自于函数的参数超出范围,例如 sqrt(-1)
ERANGE 源自于函数的结果超出范围,例如s trtol("0xfffffffff",NULL,0)
EILSEQ 源自于不合​​法的字符顺序,例如 wcstombs(str, L"\xffff", 2)```

## float.h

float头文件定义了浮点型数值的最大最小限 浮点型数值以下面的方式定义：符号-value E 指数 符号是正负，value是数字的值 
下面的值是用#define定义的，这些值是详细的实现，但是可能没有比这里给出的更详细，
在所有实例里FLT指的是float，DBL是double，LDBL指的是long double
```C
FLT_ROUNDS
定义浮点型数值四舍五入的方式，-1是不确定，0是向0，1是向最近，2是向正无穷大，3是负无穷大
FLT_RADIX 2
定义指数的基本表示（比如base-2是二进制，base-10是十进制表示法，16是十六进制）
FLT_MANT_DIG，DBL_MANT_DIG，LDBL_MANT_DIG
定义数值里数字的个数
FLT_DIG 6，DBL_DIG 10，LDBL_DIG 10
在四舍五入之后能不更改表示的最大小数位
FLT_MIN_EXP，DBL_MIN_EXP，LDBL_MIN_EXP
FLT_RADIX 的指数的最小负整数值
FLT_MIN_10_EXP -37，DBL_MIN_10_EXP -37，LDBL_MIN_10_EXP -37
10进制表示法的的指数的最小负整数值
FLT_MAX_EXP ,DBL_MAX_EXP ,LDBL_MAX_EXP
FLT_RADIX 的指数的最大整数值
FLT_MAX_10_EXP +37 ,DBL_MAX_10_EXP ,LDBL_MAX_10_EXP +37 +37
10进制表示法的的指数的最大整数值
FLT_MAX 1E+37，DBL_MAX 1E+37，LDBL_MAX 1E+37
浮点型的最大限
FLT_EPSILON 1E-5，DBL_EPSILON 1E-9，LDBL_EPSILON 1E-9
能表示的最小有符号数```

## limits.h

```C
CHAR_BIT 一个ASCII字符长度
SCHAR_MIN 字符型最小值
SCHAR_MAX 字符型最大值
UCHAR_MAX 无符号字符型最大值
CHAR_MIN
CHAR_MAX 
    char字符的最大最小值，如果char字符正被表示有符号整数。它们的值就跟有符号整数一样。 
    否则char字符的最小值就是0，最大值就是无符号char字符的最大值。
MB_LEN_MAX 一个字符所占最大字节数
SHRT_MIN 最小短整型
SHRT_MAX 最大短整形
USHRT_MAX 最大无符号短整型
INT_MIN 最小整型
INT_MAX 最大整形
UINT_MAX 最大无符号整型
LONG_MIN 最小长整型
LONG_MAX 最大长整型
ULONG_MAX 无符号长整型```

## stddef.h

stddef.h 头文件定义了一些标准定义，许多定义也会出现在其他的头文件里
宏命令：NULL 和 offsetof() 

变量：
```C
typedef ptrdiff_t         是两个指针相减的结果
typedef size_t            是sizeof一个关键词得到的无符号整数值
typedef wchar_t           是一个宽字符常量的大小，是整数类型
```
NULL是空指针的常量值

```C
offsetof(type, member-designator)
    这个宏返回一个结构体成员相对于结构体起始地址的偏移量（字节为单位），type是结构体的名字，
    member-designator是结构体成员的名字。```
    
[返回目录](README.md)