
## CURL

用于连接URI，也可以下载目标文件

#### 用法
```C++
curl --head  "[url]"        列出目标信息
curl -o [file_path&name] "[url]"    下载文件
```

##python版本
```python
import pycurl

实例化：
    pc = pycurl.Curl()
函数：主要就是setopt([arg])参数的设定
    1)地址：pc.setopt(pycurl.URL,[url])
    2)包头：pc.setopt(pycurl.HTTPHEADER,[dict])
    3)方法：pc.setopt(pycurl.CUSTOMREQUEST,[method_type])
    4)post数据：pc.setopt(pycurl.POSTFIELDS,[dict])
    5)回调：pc.setopt(pycurl.WRITEFUNCTION,[funcB])   pycurl.FOLLOWLOCATION
    6)重定向：pc.setopt(pycurl.MAXDEDIRS,[int])
    7)超时：pc.setopt(pycurl.CONNECTTIMEOUT,[int])/(pycurl.TIMEOUT,[int])  #链接和下载的超时
    8)代理：pc.setopt(pycurl.USERAGENT,[str])
    9)输出：pc.setopt(pycurl.HEADER,1)/(pycurl.HEADERFUNCTION,[func])
    10执行：pc.perform()
    11)打印：print funcB.getvalue()
    12)返回值：print pc.getinfo(pc.HTTP_CODE/pc.CONTENT_TYPE/pc.EFFECTIVE_URL)
```
**例子：**
```python
import pycurl
import os,sys
import StringIO

def testcurl():
    url = "http://www.baidu.com"
    pc = pycurl.Curl()
    sb = StingIO.StringIO()
    headers = {}
    headers['Accept'] = ""
    headers['User_Agent'] = ""
    data = {}
    data['name'] = "he"
    data['ops'] = '123456'
    
    pc.setopt(pycurl.URL,url)
    pc.setopt(pycurl.HTTPHEADER,headers)
    pc.setopt(pycurl.WRITEFUNCTION,sb.write)
    pc.setopt(pycurl.CUSTOMREQUEST,"PUT")
    pc.setopt(pycurl.POSTFIELDS,data)
    pc.perform()
    
    print sb.getvalue()
    print pc.getinfo(pc.HTTP_CODE)
    print pc.getinfo(pc.CONTENT_TYPE)
    print pc.getinfo(pc.EFFECTIVE_URL)
```

[返回目录](README.md)