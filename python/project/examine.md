
#  经典的小测试

* 
打印1到1亿之间的偶数：

```python
for i in xrange(1,100000001):
    if(x%2==0):
        print x
或者：
    ge = (i for i in xrange())
    不断调用：ge.next()即可
================================================================================================    
学习：
    1）列表生成式在数据量大的时候不如生成器，因为生成式需要分配足够的空间，而生成器则不需要(生成器只记住当前的：无以前)
    2）range()与xrange()用法差不多，但是range()返回一个列表，xrange()返回生成器。除非要返回list，否则用xrange()
    3)python3中range()已经取代xrange()
```
* 
正则表达式的匹配，清除子串[]及其内容

```python
import re
s = "weji[lltws],一个列[930jk]/1p;am[;p]'a[成式需要分]djsla39802成式需要分"
pat = re.compile(r'\[.*?\]')
res = re.sub(pat,"",s)
print s,res
================================================================================================  
学习：
    1）.*?  是不贪婪匹配所有字符
    2）re.sub(pattern,desc,src)   在src中所有符合pattern的字串替换为desc
```
* 
函数运行时间：

```python
def testpy():
    print(datetime.datetime.now())
def cal():
    start = datetime.datetime.now()
    testpy()
    end = datetime.datetime.now()
    print("time in use :%s"%(end-start))
if __name__=="__main__":
    cal()
================================================================================================  
学习：
    1）时间：datetime.datetime.now()
    2）时间的输出：%s代表秒
    3）常用格式：print '(%Y-%m-%d %H:%M:%S %p): ', dt.strftime('%y-%m-%d %I:%M:%S %p') 
```


[返回目录](README.md)