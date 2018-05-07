#常用函数：

### 1. 内置函数[python.org](https://docs.python.org/3.5/library/functions.html)：

```python
Python内置(built-in)函数随着python解释器的运行而创建。在Python的程序中，你可以随时调用这些函数，不需要定义.

isinstance([x],[type])          判断x是否是某种类型对象
dir()             输出对象的所有方法和属性
help(func/comm)   用法帮助

1、数学运算

abs(-5)                           取绝对值，也就是5
round(2.6)                        四舍五入取整，也就是3.0
pow(2, 3)                         相当于2**3，如果是pow(2, 3, 5)，相当于2**3 % 5
cmp(2.3, 3.2)                     比较两个数的大小：   负数 0 正数(第一个大)
divmod(9,2)                       返回除法结果和余数
max([1,5,2,9])                    求最大值
min([9,2,-4,2])                   求最小值
sum([2,-1,9,12])                  求和
range(i,j,k)            在[i,j)中隔k个的序列
len([])                 对象的长度
type([])                对象的类型
abs()                   绝对值
round(x,y）             对x按小数点后y位取值
divmod(x,y)             返回两个值：x/y,x%y
pow(x,y)                x的y次方
max/min()               最大／最小的元素
sqrt(n)                 求n次根
hex([])                 返回16进制数

2、类型转换

int("5")                         # 转换为整数 integer
float(2)                         # 转换为浮点数 float
long("23")                       # 转换为长整数 long integer
str(2.3)                         # 转换为字符串 string
complex(3, 9)                    # 返回复数 3 + 9i

ord("A")                         # "A"字符对应的数值
chr(65)                          # 数值65对应的字符
unichr(65)                       # 数值65对应的unicode字符

bool(0)                          # 转换为相应的真假值，Python中False：** [], (), {}, 0, None, 0.0, '' 

bin(56)                          # 返回一个字符串，表示56的二进制数
hex(56)                          # 返回一个字符串，表示56的十六进制数
oct(56)                          # 返回一个字符串，表示56的八进制数

list((1,2,3))                    # 转换为表 list
tuple([2,3,4])                   # 转换为定值表 tuple
slice(5,2,-1)                    # 构建下标对象 slice
dict(a=1,b="hello",c=[1,2,3])    # 构建词典 dictionary

enumerate(seq)          返回一个下标和对应值的元组[(i,v1),...]  for i,v in enumerate(list)
zip(seq1,seq2)        两个合成的元组   [(s1[0],s2[0]),..]  按最短的为基准长度

3、序列操作

all([True, 1, "hello!"])         # 是否所有的元素都相当于True值
any(["", 0, False, [], None])    # 是否有任意一个元素相当于True值

sorted([1,5,3])                  # 返回正序的序列，也就是[1,3,5]
reversed([1,5,3])                # 返回反序的序列，也就是[3,5,1]
max/min(seq)                最大/最小的值

4、文件操作

file()/open(dir,mode)    打开文件
        dir:目标文件路径
        mode:打开模式，有如下几种
            r   rb    w   w+/a   wb   wb+
file对象有自己的属性和方法。先来看看file的属性：
    closed #标记文件是否已经关闭，由close()改写
    encoding #文件编码
    mode #打开模式
    name #文件名
    newlines #文件中用到的换行模式，是一个tuple
    softspace #boolean型，一般为0，据说用于print
file的读写方法：
    read([size])      读取内容
    readline()        读一行
    readlines()       每行以list形式返回
    write(str)        写入
    writelines()      行写入           #写入多行在性能上会比使用write一次性写入要高，
                #都不会在str后加上一个换行符,只是忠实地写入
    close()           关闭
    flush()           缓冲区写入硬盘
    tell()            当前位置(相对开头)
    next()            标记下一行
    seek(offset,where_start) 定位       #0表示从头开始，1表示以当前位置为原点。2表示以文件末尾为原点进行计算。
    
    读大文件：
        file = open("test.log")
        with line in file:
            ...

5、类、对象、属性

# define class
class Me(object):
    def test(self):
        print "Hello!"

def new_test():
    print "New Hello!"

me = Me()
hasattr(me, "test")               # 检查me对象是否有test属性
getattr(me, "test")               # 返回test属性
setattr(me, "test", new_test)     # 将test属性设置为new_test
delattr(me, "test")               # 删除test属性
isinstance(me, Me)                # me对象是否为Me类生成的对象 (一个instance)
issubclass(Me, object)            # Me类是否为object类的子类

5、编译、执行
repr(me)                          # 返回对象的字符串表达
compile("print('Hello')",'test.py','exec')       # 编译字符串成为code对象
eval("1 + 1")                     # 解释字符串表达式。参数也可以是compile()返回的code对象
exec("print('Hello')")            # 解释并执行字符串，print('Hello')。参数也可以是compile()返回的code对象

6、其他
input("Please input:")            # 等待输入
globals()                         # 返回全局命名空间，比如全局变量名，全局函数名
locals()                          # 返回局部命名空间
callable(object)            对象是否可以调用
eval(expression)            计算表达式的值并返回
exec(str)              执行python语句的字符串
execfile(file)              执行文件
compile(str,filename,kind)   str为python代码字符串  文件    编译成供执行的对象类型
    s = 'for i in range(10): print(i)'
    c1 = compile(s,'','exec')        c2 = compile(s,'','eval')
    exec(c1)                         result = eval(c2)
```


## 模块及例子


**[os](os.md) 模块提供了很多与操作系统交互的函数:**
```python
import os
>>> import os
>>> os.getcwd()      # Return the current working directory
'C:\\Python27'
>>> os.chdir('/server/accesslogs')   # Change current working directory
>>> os.system('mkdir today')   # Run the command mkdir in the system shell
0

应该用 import os 风格而非 from os import * : 这样可以保证随操作系统不同而有所变化的 

在使用一些像 os 这样的大型模块时内置的 dir() 和 help() 函数非常有用:

>>> import os
>>> dir(os)
<returns a list of all module functions>
>>> help(os)
<returns an extensive manual page created from the module's docstrings>

针对日常的文件和目录管理任务，shutil 模块提供了一个易于使用的高级接口:

>>> import shutil
>>> shutil.copyfile('data.db', 'archive.db')
>>> shutil.move('/build/executables', 'installdir')
```
**glob 模块用于搜索文件:**
```python
>>> import glob
>>> glob.glob('*.py')
['primes.py', 'random.py', 'quote.py']

命令行参数

    通用工具脚本经常调用命令行参数。这些命令行参数以链表形式存储于 sys 模块的 argv 变量。
    例如在命令行中执行 python demo.py one two three 后可以得到以下输出结果:

>>> import sys
>>> print sys.argv
['demo.py', 'one', 'two', 'three']

getopt 模块使用 Unix getopt() 函数处理 sys.argv。更多的复杂命令行处理由 argparse 模块提供。
```
**inspect 模块:详细调试信息**
```python
import logging, inspect
  
logging.basicConfig(level=logging.INFO,
    format='%(asctime)s %(levelname)-8s %(filename)s:%(lineno)-4d: %(message)s',
    datefmt='%m-%d %H:%M',
    )
logging.debug('A debug message')
logging.info('Some information')
logging.warning('A shot across the bow')
  
def test():
    frame,filename,line_number,function_name,lines,index=\
        inspect.getouterframes(inspect.currentframe())[1]
    print(frame,filename,line_number,function_name,lines,index)
  
test()
==========》
# Should print the following (with current date/time of course)
#10-19 19:57 INFO     test.py:9   : Some information
#10-19 19:57 WARNING  test.py:10  : A shot across the bow
#(, 'C:/xxx/pyfunc/magic.py', 16, '', ['test()\n'], 0)
```
**uuid 模块:生成唯一的ID**
```python
在有些情况下你需要生成一个唯一的字符串。我看到很多人使用md5()函数来达到此目的，但它确实不是以此为目的。
其实有一个名为uuid()的Python函数是用于这个目的的。
import uuid
result = uuid.uuid1()
print result
# output => various attempts
# 9e177ec0-65b6-11e3-b2d0-e4d53dfcf61b
# be57b880-65b6-11e3-a04d-e4d53dfcf61b
# c3b2b90f-65b6-11e3-8c86-e4d53dfcf61b

你可能会注意到，即使字符串是唯一的，但它们后边的几个字符看起来很相似。这是因为生成的字符串与电脑的MAC地址是相联系的。
为了减少重复的情况，你可以使用这两个函数。
import hmac,hashlib
key='1'
data='a'
print hmac.new(key, data, hashlib.sha256).hexdigest()
  
m = hashlib.sha1()
m.update("The quick brown fox jumps over the lazy dog")
print m.hexdigest()
  
# c6e693d0b35805080632bc2469e1154a8d1072a86557778c27a01329630f8917
# 2fd4e1c67a2d28fced849ee1bb76e7391b93eb12
```
**JSON: **
```python
import json
  
variable = ['hello', 42, [1,'two'],'apple']
print "Original {0} - {1}".format(variable,type(variable))
  
# encoding
encode = json.dumps(variable)
print "Encoded {0} - {1}".format(encode,type(encode))
  
#deccoding
decoded = json.loads(encode)
print "Decoded {0} - {1}".format(decoded,type(decoded))
  
# output
  
# Original ['hello', 42, [1, 'two'], 'apple'] - <type 'list'="">
# Encoded ["hello", 42, [1, "two"], "apple"] - <type 'str'="">
# Decoded [u'hello', 42, [1, u'two'], u'apple'] - <type 'list'="">
```
**sys I/O、错误、程序终止、模块包含了跟python解析器和环境相关的变量和函数。**
```python
sys.argv        —— 对命令行参数的访问:sys.argv[1]
sys.platform()  —— 输出平台信息
sys.exit(n)     整数参数返回给调用它的程序
sys.path        —— 与程序有关的执行路径
sys.modules     —— python的所有模块
sys.stdin,stdout,stderr —— 标准输入输出，错误输出
        
以下两行在事实上等价：
    sys.stdout.write('hello'+'\n')
    print 'hello' 

    hi=raw_input('hello? ')
    print 'hello? ',                #comma to stay in the same line
    hi=sys.stdin.readline()[:-1]    # -1 to discard the '\n' in input stream

sys 还有 stdin， stdout 和 stderr 属性，即使在 stdout 被重定向时，后者也可以用于显示警告和错误信息:

>>> sys.stderr.write('Warning, log file not found starting a new one\n')
Warning, log file not found starting a new one

大多脚本的定向终止都使用 sys.exit() 。
```
**[re](re.md) 字符串正则匹配**
```python

re 模块为高级字符串处理提供了正则表达式工具。对于复杂的匹配和处理，正则表达式提供了简洁、优化的解决方案:

>>> import re
>>> re.findall(r'\bf[a-z]*', 'which foot or hand fell fastest')
['foot', 'fell', 'fastest']
>>> re.sub(r'(\b[a-z]+) \1', r'\1', 'cat in the the hat')
'cat in the hat'

只需简单的操作时，字符串方法最好用，因为它们易读，又容易调试:

>>> 'tea for too'.replace('too', 'two')
'tea for two'
```
**[math](math.md) 数学**
```python
math 模块为浮点运算提供了对底层 C 函数库的访问:

>>> import math
>>> math.cos(math.pi / 4.0)
0.70710678118654757
>>> math.log(1024, 2)
10.0

random 提供了生成随机数的工具:

>>> import random
>>> random.choice(['apple', 'pear', 'banana'])
'apple'
>>> random.sample(xrange(100), 10)   # sampling without replacement
[30, 83, 16, 4, 8, 81, 41, 50, 18, 33]
>>> random.random()    # random float
0.17970987693706186
>>> random.randrange(6)    # random integer chosen from range(6)
4
seed([X]) 设置生成随机数用的整数起始值。调用任何其他random模块函数之前调用这个函数。
random.seed( 10 )       #当然可以以时间为种子。但是容易产生相同的(因为种子同则随机的值也相同)。
```
**[互联网访问](web_spider.md)**
```python
    有几个模块用于访问互联网以及处理网络通信协议。
    其中最简单的两个是用于处理从 urls 接收的数据的 urllib2 以及用于发送电子邮件的 smtplib:

>>> from urllib2
>>> for line in urllib2.urlopen('http://tycho.usno.navy.mil/cgi-bin/timer.pl'):
...     line = line.decode('utf-8')  # Decoding the binary data to text.
...     if 'EST' in line or 'EDT' in line:  # look for Eastern Time
...         print line

<BR>Nov. 25, 09:43:32 PM EST

>>> import smtplib
>>> server = smtplib.SMTP('localhost')
>>> server.sendmail('soothsayer@example.org', 'jcaesar@example.org',
... """To: jcaesar@example.org
... From: soothsayer@example.org
...
... Beware the Ides of March.
... """)
>>> server.quit()

(注意第二个例子需要在 localhost 运行一个邮件服务器。)
```
**[time](time.md) 日期和时间**
```python
    datetime 模块为日期和时间处理同时提供了简单和复杂的方法。支持日期和时间算法的同时，
    实现的重点放在更有效的处理和格式化输出。该模块还支持时区处理:

>>> # dates are easily constructed and formatted
>>> from datetime import date
>>> now = date.today()
>>> now
datetime.date(2003, 12, 2)
>>> now.strftime("%m-%d-%y. %d %b %Y is a %A on the %d day of %B.")
'12-02-03. 02 Dec 2003 is a Tuesday on the 02 day of December.'

>>> # dates support calendar arithmetic
>>> birthday = date(1964, 7, 31)
>>> age = now - birthday
>>> age.days
14368
```
**数据压缩**
```python
以下模块直接支持通用的数据打包和压缩格式：zlib，gzip，bz2，zipfile 以及 tarfile:

>>> import zlib
>>> s = b'witch which has which witches wrist watch'
>>> len(s)
41
>>> t = zlib.compress(s)
>>> len(t)
37
>>> zlib.decompress(t)
b'witch which has which witches wrist watch'
>>> zlib.crc32(s)
226805979
```
**性能度量**
```python
有些用户对了解解决同一问题的不同方法之间的性能差异很感兴趣。Python 提供了一个度量工具，为这些问题提供了直接答案。

例如，使用元组封装和拆封来交换元素看起来要比使用传统的方法要诱人的多。timeit 证明了后者更快一些:

>>> from timeit import Timer
>>> Timer('t=a; a=b; b=t', 'a=1; b=2').timeit()
0.57535828626024577
>>> Timer('a,b = b,a', 'a=1; b=2').timeit()
0.54962537085770791

相对于 timeit 的细粒度，profile 和 pstats 模块提供了针对更大代码块的时间度量工具。
```
**质量控制**
```python
开发高质量软件的方法之一是为每一个函数开发测试代码，并且在开发过程中经常进行测试。
    doctest 模块提供了一个工具，扫描模块并根据程序中内嵌的文档字符串执行测试。测试构造如同简单的将它的输出结果
    剪切并粘贴到文档字符串中。通过用户提供的例子，它发展了文档，允许 doctest 模块确认代码的结果是否与文档一致:

def average(values):
    """Computes the arithmetic mean of a list of numbers.

    >>> print average([20, 30, 70])
    40.0
    """
    return sum(values, 0.0) / len(values)

import doctest
doctest.testmod()   # automatically validate the embedded tests

unittest 模块不像 doctest 模块那么容易使用，不过它可以在一个独立的文件里提供一个更全面的测试集:

import unittest

class TestStatisticalFunctions(unittest.TestCase):

    def test_average(self):
        self.assertEqual(average([20, 30, 70]), 40.0)
        self.assertEqual(round(average([1, 5, 7]), 1), 4.3)
        self.assertRaises(ZeroDivisionError, average, [])
        self.assertRaises(TypeError, average, 20, 30, 70)

unittest.main() # Calling from the command line invokes all tests
```
**“瑞士军刀”**
```python
Python 展现了“瑞士军刀”的哲学。这可以通过它更大的包的高级和健壮的功能来得到最好的展现。例如:

    xmlrpclib 和 SimpleXMLRPCServer 模块让远程过程调用变得轻而易举-----用户无需拥有XML的知识或处理 XML。

    email 包是一个管理邮件信息的库，包括MIME和其它基于 RFC2822 的信息文档。不同于实际发送和接收信息的
     smtplib 和 poplib 模块，email包包含一个构造或解析复杂消息结构(包括附件)及实现互联网编码和头协议的完整工具集

    xml.dom 和 xml.sax 包为流行的信息交换格式提供了强大的支持。同样，csv 模块支持在
        通用数据库格式中直接读写。综合起来，这些模块和包大大简化了 Python 应用程序和其它工具之间的数据交换。

    国际化由 gettext， locale 和 codecs 包支持。


```
**pickle**：
pickle模块被用来序列化python的对象到bytes流，从而适合存储到文件，网络传输，或数据库存储。（pickle的过程也被称serializing,marshalling或者flattening，pickle同时可以用来将bytes流反序列化为python的对象）。



[返回目录](README.md)