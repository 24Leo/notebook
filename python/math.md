##math
```python
常数：
math.e   # 自然常数e
math.pi  # 圆周率pi```
```python
方法：
math.ceil(x)       对x向上取整，比如x=1.2，返回2
math.floor(x)      对x向下取整，比如x=1.2，返回1
math.pow(x,y)      指数运算，得到x的y次方
math.log(x)        对数，默认基底为e。可以使用base参数，来改变对数的基地。比如math.log(100,base=10)
math.sqrt(x)       平方根
math.abs(x)        返回一个数的绝对值。
math.complex(1,2)   返回一个复数 1+2j

三角函数: math.sin(x), math.cos(x), math.tan(x), math.asin(x), math.acos(x), math.atan(x)
            这些函数都接收一个弧度(radian)为单位的x作为参数。
角度和弧度互换: math.degrees(x), math.radians(x)
双曲函数: math.sinh(x), math.cosh(x), math.tanh(x), math.asinh(x), math.acosh(x), math.atanh(x)
特殊函数： math.erf(x), math.gamma(x)```


##random()
```python
import random

随机实数：
random.random()          # 随机生成下一个实数，它在[0,1)范围内。
random.uniform(a,b)      # 随机生成下一个实数，它在[a,b]范围内。
下面生成的实数符合其它的分布 (你可以参考一些统计方面的书籍来了解这些分布):
random.gauss(mu,sigma)    # 随机生成符合高斯分布的随机数，mu,sigma为高斯分布的两个参数。 
random.expovariate(lambd) # 随机生成符合指数分布的随机数，lambd为指数分布的参数。

设置种子：random.seed(x)
seed([X]) 设置生成随机数用的整数起始值。调用任何其他random模块函数之前调用这个函数。
random.seed( 10 )       #当然可以以时间为种子。但是容易产生相同的(因为种子同则随机的值也相同)。

随机整数：
>>> import random
>>> random.randint(0,99)
21

随机选取0到100间的偶数：
>>> import random
>>> random.randrange(0, 101, 2)
42

随机浮点数：
>>> import random
>>> random.random()
0.85415370477785668
>>> random.uniform(1, 10)
5.4221167969800881

随机字符：
>>> import random
>>> random.choice('abcdefg&#%^*f')
'd'

多个字符中选取特定数量的字符：
>>> import random
random.sample('abcdefghij',3)
['a', 'd', 'b']

多个字符中选取特定数量的字符组成新字符串：
>>> import random
>>> import string
>>> string.join(random.sample(['a','b','c','d','e','f','g','h','i','j'], 3)).replace(" ","")
'fih'

随机选取字符串：
>>> import random
>>> random.choice ( ['apple', 'pear', 'peach', 'orange', 'lemon'] )
'lemon'

洗牌：
>>> import random
>>> items = [1, 2, 3, 4, 5, 6]
>>> random.shuffle(items)
>>> items
[3, 2, 5, 6, 4, 1] ```


[返回目录](README.md)