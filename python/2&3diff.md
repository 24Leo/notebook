## 主要是python2.X和python3.X的不同
1. 
可能是最好的消息：```默认编码是utf-8,我们就不需要在行首加一行：#coding:utf-8```

1. 
输入：
```python
在python2.7中：input()和raw_input()都可以，而且input()由raw_input()实现
但在python3中，仅留下了input()方法```
1. 
输出：
```python
python2.7或之前，print只是语句而不是函数。  print "hello"
但python3之后，必须函数形式才行。    print("hello")。
同exec()，也是函数了
格式控制：
    以前都是  % 来控制，现在用format()
    "I love {0},{1},{2}".format("eagg","meat","ha")             #普通：以0开始
    "I love {a},{b},{c}".format(a="eagg",b="meat",c="ha")       #字典
    "I love {0},{1},{c}".format("eagg","meat",c="ha")           #普通和字典混用，普通要在字典前！！！
```
1. 
除法
```python
在python2.7前，‘/’和‘//’都代表floor除     3/2=1
python3后，‘/’代表除法(//则是地板除)  3/2=1.5       3//2=1
当然可在python2.X中：from __future__ import division来使用Python3的除法或者强制转换(float)3/2、3/2.0
```
1. range()/xrange()
```python
对于range()和xrange()，python2.X是不同的。但是python3没有xrange()了，统一用range()。
而且range()有了一个新的__contains__方法。__contains__方法可以有效的加快整数和布尔型的“查找”速度。
　
x = 10000000
def val_in_range(x, val):
        return val in range(x)
　 
def val_in_xrange(x, val):
        return val in xrange(x)
%timeit val_in_range(x, x/2)　　　　　  ＃除法
%timeit val_in_range(x, x//2)           #地板除
执行结果：   整数比查找浮点数要快大约6万倍
1 loops, best of 3: 742 ms per loop
1000000 loops, best of 3: 1.19 µs per loop
```
1. 
异常
```python
捕获异常的语法由 except Exception,var 改为 except Exception as var。
抛出常的语法由 raise Exception,args 改为 raise Exception(args)
在2.x时代，所有类型的对象都是可以被直接抛出的，在3.x时代，只有继承自BaseException的对象才可以被抛出。
首先是引起异常的方式：
        python2.X:  raise IOError, "file error"
                    raise IOError("file error")  #====>均可得到：IOError: file error
        python3.X： 仅支持括号
                    raise IOError, "file error"  #====>错误： SyntaxError: invalid syntax
                    raise IOError("file error")  #====>正确可得到：IOError: file error
    处理方式：
        python2.X:  在except语句块外面仍可以访问异常对象
                    try:
                        let_us_cause_a_NameError
                    except NameError, err:
                        print err, '--> our error message'
                    print err   #正确
        python3.X: 1）必须使用关键字as而且多个异常时必须用小括号(元组)，否则error；
                   2）在except代码块外面访问错误。
                    try:
                        let_us_cause_a_NameError
                    except (NameError,ValueError) as e:
                        print e.err, '--> our error message'
                    print e     #错误
```
1. 
比较操作  != ，而且对象检查更严格---异常
```python
Python 2.x中不等于有两种写法 != 和 <>
Python 3.x中去掉了<>, 只有!=一种写法
python2.X:  [1,2]>"helo" 返回False
python3.X:  [1,2]>"helo" 引起异常
```
1. 
bool与int:
```python
在2.X中bool是int的子集，所以才有while 1 比while True快，
但是3.X之后True、False、as、with都是关键字，所以速度没区别
```
1. 
nonlocal
```python
使用nonlocal可以声明上一层的变量，但不是global变量
def test():
    i = 19
    def uses():
        i = i+1         #这是错误的，对于赋值：首先会把他看成局部变量。。直接读值才按照LEGB顺序。。
                        #此处可以先用nonlocal声明：nonlocal i，然后对i操作
```


[返回目录](README.md)