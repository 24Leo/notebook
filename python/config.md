##配置文件的读取和修改
```python
需要的包:   import ConfigParser```

### 函数：
```python
实例化：    cf = ConfigParser.ConfigParser()
打开文件：  cf.read([file_path])
读取：     
        1)读field：     cf.sections()
        2)读选项(key)： cf.options([field])
        3)读数据项：    cf.items([field])
        4)读具体项：    cf.get([field],[key])
写入：
        cf.set([field],[key],[value])
        cf.write(open([file_path],[mode]))
```

### 配置文件：

```
[field]
key1=value1
key2=value2
key3=value3

实例：
    [basetest]          #field
    name = leo          #key-value
    age = 25
    strs = zhang
    [exten]             #field
    tt = hello
```

## 例子：

```python

#/usr/bin/env python
#_*_coding:utf-8_*_
#author:LEO
#time:12.18.2015

import os
import ConfigParser

def testread(file_path):
    cf = ConfigParser.ConfigParser()
    cf.read(file_path)
    
    field = cf.sections()
    print("field are:%s"%field)
    
    key = cf.options("basetest")
    print("key in basetest are:%s"%key)
    
    item = cf.items("basetest")
    print("item in basetest are:%s"%item)
    
    name = cf.get("basetest","name")
    age = cf.get("basetest","age")
    strs = cf.get("basetest","strs")
    tt = cf.get("exten","tt")
    print("all values in fields are:%s"%(name,age,strs,tt))
    
    cf.set("basetest","b_set1","nihao")
    cf.set("exten","e_set1","shide")
    cd.write(open(fiel_path,"w+cd"))
    ```
    
    
[返回目录](README.md)