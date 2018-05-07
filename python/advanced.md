变量的查找过程：LEGB规则----->本地变量[L]、上一层def/lamba[E]、全局[G]、内置[B]<br>
　　　　1)变量在哪里赋值就决定它的作用域<br>
　　　　2)python3中nonlocal可以访问上一层的变量，但不是全局

**1. 闭包：**

返回引用了自由变量的函数。这个被引用的自由变量将和这个函数一同存在，即使已经离开了创造它的环境也不例外。所以，有另一种说法认为闭包是由函数和与其相关的引用环境组合而成的实体。返回的函数也可以有参数的
```python
def make_adder(addend):
    def adder(augend):
        return augend + addend
    return adder
p = make_adder(23)
q = make_adder(44)
print p(100)
print q(100)

运行结果:
123
144
分析一下:
    make_adder是包括一个参数addend的函数：比较特殊的地方是这个函数里面又定义了一个新函数,这个新函数里面的一个
变量正好是外部make_adder的参数.也就是说,外部传递过来的addend参数已经和adder函数绑定到一起了,形成了一个新函数,我们
可以把addend看做新函数的一个配置信息,配置信息不同,函数的功能就不一样了,也就是能得到定制之后的函数.
根据运行结果，虽然p和q都是make_adder生成的,但是因为配置参数不同,后面再执行相同参数的函数后得到了不同的结果.
这就是闭包.
```
闭包简单点理解就是一个内部函数对外部变量但不是全局变量进行引用：该函数+变量=闭包。所以该变量是绑定的(static)。

所以一个常见的问题：
```python
def foo(): 
    a = 1
    def bar(): 
        a = a + 1   #错误
        return a 
    return bar
 是错误的
 因为在python中，所有在赋值语句左边的变量都是局部变量。故a=a+1由于a已经被认定为局部了，出错。解决：nonlocal
 ```
** 作用：**
* 
保存当前环境：函数每次执行都是基于上次的结果
* 
根据外部作用域的局部变量来得到不同的结果
```python
def make_filter(keep): 
    def the_filter(file_name): 
        file = open(file_name) 
        lines = file.readlines() 
        file.close() 
        filter_doc = [i for i in lines if keep in i] 
        return filter_doc 
    return the_filter
如果我们需要取得文件["result.txt"]中含有["pass"]关键字的行，则可以这样使用例子程序
filter = make_filter("pass")
filter_result = filter("result.txt")
```

[返回目录](README.md)