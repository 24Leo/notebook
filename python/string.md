# 字符串操作：

与[正则表达式](re.md)的一起应用更好

**去空格及特殊符号**

```python
s.strip().lstrip().rstrip(',')```

**字符串长度**

```python
#C:strlen(sStr1)
sStr1 = 'strlen'
print len(sStr1)```

**将字符串中的大小写转换**

```python
S.lower()       #小写
S.upper()       #大写
S.swapcase()    #大小写互换
S.capitalize()  #首字母大写
String.capwords(S)
    #这是模块中的方法。它把S用split()函数分开，然后用capitalize()把首字母变成大写，最后用join()合并到一起
S.title()   #只有首字母大写，其余为小写，模块中没有这个方法 
```

**字符串指定长度比较**

```python
指定长度：
#C:strncmp(sStr1,sStr2,n)
sStr1 = '12345'
sStr2 = '123bc'
n = 3
print cmp(sStr1[0:n],sStr2[0:n])

#C:strcmp(sStr1,sStr2)
sStr1 = 'strchr'
sStr2 = 'strch'
print cmp(sStr1,sStr2)```

**复制指定长度的字符**

```python
#C：strncpy(sStr1,sStr2,n)
sStr1 = ''
sStr2 = '12345'
n = 3
sStr1 = sStr2[0:n]
print sStr1

#C：strcpy(sStr1,sStr2)
sStr1 = 'strcpy'
sStr2 = sStr1
sStr1 = 'strcpy2'
print sStr2```

**将字符串前n个字符替换为指定的字符**

```python
#C:strnset(sStr1,ch,n)
sStr1 = '12345'
ch = 'r'
n = 3
sStr1 = n * ch + sStr1[3:]
print sStr1
```


**翻转字符串**

```python
#C:strrev(sStr1)
sStr1 = 'abcdefg'
sStr1 = sStr1[::-1]
print sStr1```

**查找字符串**

```python
S.find(substr, [start, [end]])
    #返回S中出现substr的第一个字母的标号，如果S中没有substr则返回-1。start和end为范围
S.index(substr, [start, [end]])
    #与find()相同，只是在S中没有substr时，会返回一个运行时错误
S.rfind(substr, [start, [end]])
    #返回S中最后出现的substr的第一个字母的标号，如果S中没有substr则返回-1
S.rindex(substr, [start, [end]])
S.count(substr, [start, [end]]) #计算substr在S中出现的次数 
#C:strstr(sStr1,sStr2)
sStr1 = 'abcdefg'
sStr2 = 'cde'
print sStr1.find(sStr2)

#C:strchr(sStr1,sStr2) 
 < 0 为未找到
sStr1 = 'strchr'
sStr2 = 's'
nPos = sStr1.index(sStr2)
print nPos

#C:strspn(sStr1,sStr2)
sStr1 = '12345678'
sStr2 = '456'
sStr1 and chars both in sStr1 and sStr2
print len(sStr1 and sStr2)
#扫描字符串
#C:strpbrk(sStr1,sStr2)
sStr1 = 'cekjgdklab'
sStr2 = 'gka'
nPos = -1
for c in sStr1:
    if c in sStr2:
        nPos = sStr1.index(c)
        break
print nPos```

**分割字符串**

```python
S.split([sep, [maxsplit]])
    #以sep为分隔符，把S分成一个list。maxsplit表示分割的次数。默认的分割符为空白字符
S.rsplit([sep, [maxsplit]])
S.splitlines([keepends])
    #把S按照行分割符分为一个list，keepends是一个bool值，如果为真每行后而会保留行分割符。
S.join(seq) #把seq代表的序列──字符串序列，用S连接起来 
#C:strtok(sStr1,sStr2)
sStr1 = 'ab,cde,fgh,ijk'
sStr2 = ','
sStr1 = sStr1[sStr1.find(sStr2) + 1:]
print sStr1
或者
s = 'ab,cde,fgh,ijk'
print(s.split(','))```

**连接字符串**

```python
delimiter = ','
mylist = ['Brazil', 'Russia', 'India', 'China']
print delimiter.join(mylist)    #join：把序列、元组、字典等用del连接起来

#C：strcat(sStr1,sStr2)
sStr1 = 'strcat'
sStr2 = 'append'
sStr1 += sStr2
print sStr1

#C：strncat(sStr1,sStr2,n)
sStr1 = '12345'
sStr2 = 'abcdef'
n = 3
sStr1 += sStr2[0:n]
print sStr1```

**PHP 中 addslashes 的实现**
```python
def addslashes(s):
    d = {'"':'\\"', "'":"\\'", "\0":"\\\0", "\\":"\\\\"}
    return ''.join(d.get(c, c) for c in s)
 
s = "John 'Johny' Doe (a.k.a. \"Super Joe\")\\\0"
print s
print addslashes(s)```

**只显示字母与数字**

```python
def OnlyCharNum(s,oth=''):
    s2 = s.lower();
    fomart = 'abcdefghijklmnopqrstuvwxyz0123456789'
    for c in s2:
        if not c in fomart:
            s = s.replace(c,'');
    return s;
    
print(OnlyStr("a000 aa-b"))```

**替换**
```python
S.replace(oldstr, newstr, [count])
    #把S中的oldstar替换为newstr，count为替换次数。这是替换的通用形式，还有一些函数进行特殊字符的替换 ```
**Encode**
```python
S.encode([encoding,[errors]])
# 其中encoding可以有多种值，比如gb2312 gbk gb18030 bz2 zlib big5 bzse64等都支持。errors默认值为"strict"，
#意思是UnicodeError。可能的值还有'ignore', 'replace', 'xmlcharrefreplace', 'backslashreplace' 和所有
#通过codecs.register_error注册的值。

S.decode([encoding,[errors]])
#字符串的测试函数，这一类函数在string模块中没有，这些函数返回的都是bool值： 

st=str.encode("ascii/utf-8")
result=st.decode("ascii/utf-8")    #str==result
```
**截取字符串**

```python
str = ’0123456789′ 
print str[0:3] 截取第一位到第三位的字符
print str[:] 截取字符串的全部字符
print str[6:] 截取第七个字符到结尾
print str[:-3] 截取从头开始到倒数第三个字符之前
print str[2] 截取第三个字符
print str[-1] 截取倒数第一个字符
print str[::-1] 创造一个与原字符串顺序相反的字符串
print str[-3:-1] 截取倒数第三位与倒数第一位之前的字符
print str[-3:] 截取倒数第三位到结尾
print str[:-5:-3] 逆序截取，具体啥意思没搞明白？```

[返回目录](README.md)