#时间相关
##Time
```python
import time
```
可以直接调用一些C 函数

```
start=time.time()
#time.sleep(4)
end=time.time()
print end-start
print time.clock()
print time.gmtime()     
print time.localtime()
print int(time.time())  #当前时间的整数

## dd/mm/yyyy格式
print (time.strftime("%d/%m/%Y"))
```
gmtime()和localtime()返回一个时间结构体struct_time

```python 
strftime(...)
  strftime(format[, tuple]) -> string
  将指定的struct_time(默认为当前时间)，根据指定的格式化字符串输出
  python中时间日期格式化符号：
  %y 两位数的年份表示（00-99）
  %Y 四位数的年份表示（000-9999）
  %m 月份（01-12）
  %d 月内中的一天（0-31）
  %H 24小时制小时数（0-23）
  %I 12小时制小时数（01-12） 
  %M 分钟数（00=59）
  %S 秒（00-59）
  
  %a 本地简化星期名称
  %A 本地完整星期名称
  %b 本地简化的月份名称
  %B 本地完整的月份名称
  %c 本地相应的日期表示和时间表示
  %j 年内的一天（001-366）
  %p 本地A.M.或P.M.的等价符
  %U 一年中的星期数（00-53）星期天为星期的开始
  %w 星期（0-6），星期天为星期的开始
  %W 一年中的星期数（00-53）星期一为星期的开始
  %x 本地相应的日期表示
  %X 本地相应的时间表示
  %Z 当前时区的名称
  %% %号本身
  
  timeArray = time.strptime(a, "%Y-%m-%d %H:%M:%S")
  ```
  
  #DateTime
  对time的封装
  ```python
import datetime
```

    datetime.date：表示日期的类。常用的属性有year, month, day；
    datetime.time：表示时间的类。常用的属性有hour, minute, second, microsecond；
    datetime.datetime：表示日期时间。
    datetime.timedelta：表示时间间隔，即两个时间点之间的长度。
    datetime.tzinfo：与时区有关的相关信息。（这里不详细充分讨论该类，感兴趣的童鞋可以参考python手册）

    注：上面这些类型的对象都是不可变（immutable）的。

1. 
date属性和方法

```python
    date.year、date.month、date.day：年、月、日；
    date.replace(year, month, day)：生成一个新的日期对象。（原有对象仍保持不变）
    date.timetuple()：返回日期对应的time.struct_time对象；
    date.toordinal()：返回日期对应的Gregorian Calendar日期；
    date.weekday()：返回weekday，如果是星期一，返回0；如果是星期2，返回1，以此类推；
    data.isoweekday()：返回weekday，如果是星期一，返回1；如果是星期2，返回2，以此类推；
    date.isocalendar()：返回格式如(year，month，day)的元组；
    date.isoformat()：返回格式如'YYYY-MM-DD’的字符串；
    date.strftime(fmt)：自定义格式化字符串。在下面详细讲解。
```
2.
time

```python
    time.min、time.max：time类所能表示的最小、最大时间。
    time.resolution：时间的最小单位，这里是1微秒；

    time.hour、time.minute、time.second、time.microsecond：时、分、秒、微秒；
    time.tzinfo：时区信息；
    time.replace([hour[, minute[,second[,microsecond[,tzinfo]]]]])：创建新的时间对象（原有对象仍不变）
    time.isoformat()：返回型如"HH:MM:SS"格式的字符串表示；
    time.strftime(fmt)：返回自定义格式化字符串。在下面详细介绍；

```
3.
datetime

```python
    datetime.min、datetime.max：datetime所能表示的最小值与最大值；
    datetime.resolution：datetime最小单位；
    datetime.today()：返回一个表示当前本地时间的datetime对象；
    datetime.now([tz])：返回一个表示当前本地时间的datetime对象，获取tz参数所指时区的本地时间；
    datetime.utcnow()：返回一个当前utc时间的datetime对象；
    datetime.fromtimestamp(timestamp[, tz])：根据时间戮创建一个datetime对象，参数tz指定时区信息；
    datetime.utcfromtimestamp(timestamp)：根据时间戮创建一个datetime对象；
    datetime.combine(date, time)：根据date和time，创建一个datetime对象；
    datetime.strptime(date_string, format)：将格式字符串转换为datetime对象；
    
    datetime.year、month、day、hour、minute、second、microsecond、tzinfo：
    datetime.date()：获取date对象；
    datetime.time()：获取time对象；
    datetime.replace([year[, month[, day[, hour[, minute[, second[, microsecond[, tzinfo]]]]]]]])
    datetime.timetuple()
    datetime.utctimetuple()
    datetime.toordinal()
    datetime.weekday()
    datetime.isocalendar()
    datetime.isoformat([sep])
    datetime.ctime()：返回一个日期时间的C格式字符串，等效于time.ctime(time.mktime(dt.timetuple()))；
    datetime.strftime(format)

```

    datetime、date、time都提供了**strftime()**方法，该方法接收一个格式字符串，输出日期时间的字符串表示:
```python
    dt = datetime.now()  
    print '(%Y-%m-%d %H:%M:%S %f): ', dt.strftime('%Y-%m-%d %H:%M:%S %f')  
    print '(%Y-%m-%d %H:%M:%S %p): ', dt.strftime('%y-%m-%d %I:%M:%S %p')  
    print '%%a: %s ' % dt.strftime('%a')  
```
4.
timedelta
```python
    d1 = datetime.datetime.now()
    d3 = d1 + datetime.timedelta(days =10)
            [days, seconds, microseconds, milliseconds, minutes, hours, weeks]
    ```
5.
tzinfo  与时区有关的相关信息

[返回目录](README.md)