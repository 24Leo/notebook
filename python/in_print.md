
## 字符编码：
早期只有127个英文字符写入计算机中，即ASCII码每个1B，<br>
后来全世界范围内产生了unicode编码标准
unicode就是一个记录全世界所有字符到数字映射关系的标准。每个字符2B<br>
但是每个2B不好：对ASCII太浪费，而对汉字等又不够，所以utf-8应运而生（1~8B）<br>
gb,gb2312，GBK都是针对汉字的，其中GBK是汉字升级版，utf-8则是世界范围通用
###输出模板:


```python
python3之后，print成为函数
%s    字符串 (采用str()的显示)
%r    字符串 (采用repr()的显示)
%c    单个字符
%b    二进制整数
%d    十进制整数
%i    十进制整数
%o    八进制整数
%x    十六进制整数
%e    指数 (基底写为e)
%E    指数 (基底写为E)
%f    浮点数
%F    浮点数，与上相同
%g    指数(e)或浮点数 (根据显示长度)
%G    指数(E)或浮点数 (根据显示长度)
%%    字符"%"

print ("I'm %s. I'm %d year old" % ('Vamei', 99))
        I'm Vamei. I'm 99 year old
print ("I'm %(name)s. I'm %(age)d year old" % {'name':'Vamei', 'age':99})
        I'm Vamei. I'm 99 year old

对格式进行进一步的控制：
%[(name)][flags][width].[precision]typecode

    (name)为命名

    flags可以有+,-,' '或0。+表示右对齐。-表示左对齐。''为一个空格。0表示使用0填充。

    width表示显示整体宽度(包括小数点)
    
    precision表示小数点前个数
        
比如：

print("%+10x" % 10)
print("%04d" % 5)
print("%6.3f" % 2.3)
        上面的width, precision为两个整数。我们可以利用*，来动态代入这两个量。比如：

print("%.*f" % (4, 1.2))
```
###输入模板:
```python
python3之前：input([prompt])和raw_input([prompt])差不多。不过input内部由raw_input()实现
python3之后，用input(),无raw_input()
无论如何，输入来的永远是字符串！
```
##显示错误在哪一行:traceback
```python
try
    print("test error...")
except  Exception,e:
    traceback.print_exc()
```

[返回目录](README.md)