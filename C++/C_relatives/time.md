
## time.h

 是C标准函数库中获取时间与日期、对时间与日期数据操作及格式化的头文件。

```C
1、 /* Returned by `time'. */    精确度：秒；由函数time()获取；
    typedef __time_t time_t;

2、 /* A time value that is accurate to the nearest
       microsecond but also has a range of years. */
    struct timeval              精确度：微秒(10E-6)
    {
        __time_t tv_sec;       /* Seconds. */
        __suseconds_t tv_usec; /* Microseconds. */
    };

3、 struct timespec             精确度：纳秒(10E-9秒)
    {
        __time_t tv_sec;        /* Seconds. */
        long int tv_nsec;       /* Nanoseconds. */
    };
4、 struct tm                   时间日期表示方法                 
    {
      int tm_sec;            /* Seconds.    [0-60] (1 leap second) */
      int tm_min;            /* Minutes.    [0-59] */
      int tm_hour;           /* Hours.    [0-23] */
      int tm_mday;           /* Day.        [1-31] */
      int tm_mon;            /* Month.    [0-11] */
      int tm_year;           /* Year    - 1900. */
      int tm_wday;           /* Day of week.    [0-6] */
      int tm_yday;           /* Days in year.[0-365]    */
      int tm_isdst;          /* DST.        [-1/0/1]*/

    #ifdef    __USE_BSD
      long int tm_gmtoff;        /* Seconds east of UTC. */
      __const char *tm_zone;     /* Timezone abbreviation. */
    #else
      long int __tm_gmtoff;       /* Seconds east of UTC. */
      __const char *__tm_zone;    /* Timezone abbreviation. */
    #endif
    };
5、struct timezone  
    {  
        int tz_minuteswest; /*和Greenwich 时间差了多少分钟*/  
        int tz_dsttime; /*日光节约时间的状态*/  
    }; 
6、struct _timeb                毫秒(10E-3秒)
    {  
        time_t time;  
        unsigned short millitm;  
        short timezone;  
        short dstflag;  
    }; 
7、 typedef long clock_t;     以微秒的方式返回CPU的时间

其中：
time_t 是一个长整型，用来表示秒数。
struct timeval 结构体是用秒和微妙来表示时间。
struct timespec 结构体是用秒和纳秒来表示时间。
struct tm 直接用秒、分、小时、天、月、年等来表示时间。
struct timezone  当地时区的信息
很显然它们的精度是各不相同的。位各种不同的需要提供各种不同的选择。```
**struct tm 结构体**
```C
#include <sys/time.h>
宏：
NULL null是一个null指针常量的值
CLOCKS_PER_SEC 每秒的时钟数

变量：
typedef size_t  类型定义
typedef clock_t 类型定义

struct tm 结构体
struct tm {
    int tm_sec; /* 秒 – 取值区间为[0,59] */
    int tm_min; /* 分 - 取值区间为[0,59] */
    int tm_hour; /* 时 - 取值区间为[0,23] */
    int tm_mday; /* 一个月中的日期 - 取值区间为[1,31] */
    int tm_mon; /* 月份（从一月开始，0代表一月） - 取值区间为[0,11] */
    int tm_year; /* 年份，其值等于实际年份减去1900 */
    int tm_wday; /* 星期 – 取值区间为[0,6]，其中0代表星期天，1代表星期一，以此类推 */
    int tm_yday; /* 从每年的1月1日开始的天数 – 取值区间为[0,365]，其中0代表1月1日，1代表1月2日，以此类推 */
    int tm_isdst; /* 夏令时标识符，实行夏令时的时候，tm_isdst为正。不实行夏令时的进候，tm_isdst为0；
                    不了解情况时，tm_isdst()为负。*/ 
};

函数：
char *asctime(const struct tm* timeptr)   将时间和日期以字符串格式表示
clock()     确定处理器时间
char *ctime(const time_t* timep);    把日期和时间转换为字符串
double difftime(time_t time1, time_t time2);  计算两个时刻之间的时间差
struct tm* gmtime(const time_t* timep);    把日期和时间转换为(GMT)时间(将time_t转换成struct tm) 
struct tm* localtime(const time_t* timep);  取得当地目前时间和日期
time_t mktime(struct tm* timeptr);    将时间结构数据转换成经过的秒数
size_t strftime(char *strDest,size_t maxsize, const char *format,const struct tm *timeptr); 
                    将时间格式化，返回向strDest指向的字符串中放置的字符数。
time_t time(time_t* t);      取得目前的时间的秒数
int gettimeofday(struct timeval* tv,struct timezone* tz);当前距离1970年的秒数和微妙数，一般不用后面的时区tz
```
**struct timeval 结构体**
```C
#include <sys/time.h>

struct timeval
    {
        __time_t tv_sec;       /* Seconds. */
        __suseconds_t tv_usec; /* Microseconds. */
    };
    
    struct timeval start,end;
	gettimeofday(&start,NULL);
	gettimeofday(&end,NULL);
	
	连续两次使用gettimeofday时，会以一种小概率出现"时光倒流"的现象，第二次函数调用得到的时间要小于或说早于第一次
	调用得到的时间。gettimeofday函数并不是那么稳定，没有times或clock计时准确，但它们用法相似。clock有计时限制，
	据说是596.5+小时，一般情况足以应付。”
```
**常用函数：**
```C
5种不同精度的时间

#include <time.h>    time_t
time_t time(time_t *t);
    可以获取精确到秒的 当前距离1970-01-01 00:00:00 +0000 (UTC)的秒数。
    使用:time_t t = time(NULL) 或者 time(&t)

#include <sys/time.h>    struct timeval
int gettimeofday(struct timeval *tv, struct timezone *tz);
    可以获取精确到微秒 当前距离1970-01-01 00:00:00 +0000 (UTC)的微秒数。时区的信息放到tz结构中(可用NULL)
    使用：gettimeofday(&start,NULL/&zone);

#include <time.h>     struct timespec
int clock_gettime(clockid_t clk_id, struct timespec *tp);
    可以获取精确到纳秒 当前距离1970-01-01 00:00:00 +0000 (UTC)的纳秒数。
    clockid_t clk_id 用于指定计时时钟的类型，有以下4种：  
        CLOCK_REALTIME:系统实时时间,随系统实时时间改变而改变,即从UTC1970-1-1 0:0:0开始计时,
                        中间时刻如果系统时间被用户该成其他,则对应的时间相应改变  
        CLOCK_MONOTONIC:从系统启动这一刻起开始计时,不受系统时间被用户改变的影响  
        CLOCK_PROCESS_CPUTIME_ID:本进程到当前代码系统CPU花费的时间  
        CLOCK_THREAD_CPUTIME_ID:本线程到当前代码系统CPU花费的时间 
    使用：clock_gettime(CLOCK_REALTIME, &tp); 

#include <sys/types.h> and <sys/timeb.h>    struct _timeb 
void _ftime(struct _timeb *timeptr); 
    提供毫秒级的精确度
    
#include <time.h><sys/types.h>
clock_t clock(void); 用于计时
    返回CPU的时间
    使用：clock_t t start,end; start=clock()
    CLOCKS_PER_SEC，它用来表示一秒钟会有多少个时钟计时单元
    (end-start)/CLOCKS_PER_SEC
```
**控制各类型时间的输出格式**
1. 
首先将struct timeval, struct timespec等转换成time_t表示的秒数；
1. 
然后利用下列函数将time_t转换成struct tm: gmtime( localtime()
1. 
最后利用strftime()函数进行格式化，得到最后的时间字符串。
        至于毫秒、微秒、纳秒另外用进行输出。
```C
例子

    #include <time.h>
    #include <sys/time.h>
    #include <stdio.h>

    int main()
    {
            struct timeval tv;
            char strTime[32];

            gettimeofday(&tv, NULL);
            struct tm *ptm = gmtime(&tv.tv_sec);    //将秒转换成struct tm的形式
            strftime(strTime, 32, "%F %T", ptm);
            printf("%s ", strTime);                 //输出精确到秒
            printf("%ld Micorseconds\n", (long)tv.tv_usec); //输出微秒

            return 0;
    }
    输出结果：2011-09-14 03:22:42 427880 Micorseconds
    
    ctime和asctime等函数得到的时间字符串，它具有指定的形如（"Wed Jun 30 21:49:08 1993\n"）的格式，
    所以不利与我们进行格式化。注意该格式的最后具有换行符：'\n'.```
**strftime()函数输出格式：**
```C 
strftime(...)
    size_t strftime(char *strDest,size_t maxsize,const char *format,const struct tm *timeptr);
        我们根据format指向字符串中格式把timeptr中保存的时间信息放在strDest指向的字符串中，最多向strDest中存放
        maxsize个字符。该函数返回向strDest指向的字符串中放置的字符数。
    %a 星期几的简写
    %A 星期几的全称
    %b 月分的简写
    %B 月份的全称
    %c 标准的日期的时间串
    %C 年份的后两位数字
    %d 十进制表示的每月的第几天
    %D 月/天/年
    %e 在两字符域中，十进制表示的每月的第几天
    %F 年-月-日
    %g 年份的后两位数字，使用基于周的年
    %G 年分，使用基于周的年
    %h 简写的月份名
    %H 24小时制的小时
    %I 12小时制的小时
    %j 十进制表示的每年的第几天
    %m 十进制表示的月份
    %M 十时制表示的分钟数
    %n 新行符
    %p 本地的AM或PM的等价显示
    %r 12小时的时间
    %R 显示小时和分钟：hh:mm
    %S 十进制的秒数
    %t 水平制表符
    %T 显示时分秒：hh:mm:ss
    %u 每周的第几天，星期一为第一天 （值从0到6，星期一为0）
    %U 第年的第几周，把星期日做为第一天（值从0到53）
    %V 每年的第几周，使用基于周的年
    %w 十进制表示的星期几（值从0到6，星期天为0）
    %W 每年的第几周，把星期一做为第一天（值从0到53）
    %x 标准的日期串
    %X 标准的时间串
    %y 不带世纪的十进制年份（值从0到99）
    %Y 带世纪部分的十进制年份
    %z，%Z 时区名称，如果不能得到时区名称则返回空字符。
    %% 百分号
      
  strftime(str,60, "%Y-%m-%d %H:%M:%S",struct tm *ptr);
  ```
  
  [返回目录](README.md)