###基础
```python
 到python官网下载http://pypi.python.org/pypi/xlrd模块安装，前提是已经安装了python 环境。
1、导入模块
      import xlrd
2、打开Excel文件读取数据
       data = xlrd.open_workbook('excelFile.xls')
3、使用技巧
  获取一个工作表
    table = data.sheets()[0]          #通过索引顺序获取
    table = data.sheet_by_index(0) #通过索引顺序获取
    table = data.sheet_by_name(u'Sheet1')#通过名称获取
  获取整行和整列的值（数组）
    table.row_values(i)
    table.col_values(i)
  获取行数和列数
   nrows = table.nrows
   ncols = table.ncols
  循环行列表数据
   for i in range(nrows ):
      print table.row_values(i)
  单元格
   cell_A1 = table.cell(0,0).value
   cell_C4 = table.cell(2,3).value
  使用行列索引
   cell_A1 = table.row(0)[0].value
   cell_A2 = table.col(1)[0].value
  简单的写入
   row = 0
   col = 0
  # 类型 0 empty,1 string, 2 number, 3 date, 4 boolean, 5 error
   ctype = 1 
   value = '单元格的值'
   xf = 0 # 扩展的格式化
   table.put_cell(row, col, ctype, value, xf)
   table.cell(0,0)  #单元格的值'
   table.cell(0,0).value #单元格的值'
 ```
1.读取Excel(需要安装xlrd)：
```python
#-*- coding: utf8 -*-
import xlrd

fname = "reflect.xls"
# fname = 'C:\\Users\\leo\\Download'
bk = xlrd.open_workbook(fname)
shxrange = range(bk.nsheets)
try:
    sh = bk.sheet_by_name("Sheet1")
except:
    print "no sheet in %s named Sheet1" % fname
#获取行数
nrows = sh.nrows
#获取列数
ncols = sh.ncols
print "nrows %d, ncols %d" % (nrows,ncols)
#获取第一行第一列数据 
cell_value = sh.cell_value(1,1)
#print cell_value

row_list = []
#获取各行数据
for i in range(1,nrows):
    row_data = sh.row_values(i)
    row_list.append(row_data)
```
2.写入Excel（需安装pyExcelerator）
```python
from pyExcelerator import *
w = Workbook()     #创建一个工作簿
ws = w.add_sheet('Hey, Hades')     #创建一个工作表
ws.write(0,0,'bit')    #在1行1列写入bit
ws.write(0,1,'huang')  #在1行2列写入huang
ws.write(1,0,'xuan')   #在2行1列写入xuan
w.save('mini.xls')     #保存
```
3.读写Excel的例子:读取reflect.xls中的某些信息进行处理后写入mini.xls文件中。　
```python
#-*- coding: utf8 -*-
import xlrd
from pyExcelerator import *  

w = Workbook()  
ws = w.add_sheet('Sheet1') 
fname = "reflect.xls"
bk = xlrd.open_workbook(fname)
shxrange = range(bk.nsheets)
try:
    sh = bk.sheet_by_name("Sheet1")
except:
    print "no sheet in %s named Sheet1" % fname
nrows = sh.nrows
ncols = sh.ncols
print "nrows %d, ncols %d" % (nrows,ncols)

cell_value = sh.cell_value(1,1)
#print cell_value

row_list = []
mydata = []
for i in range(1,nrows):
    row_data = sh.row_values(i)
    pkgdatas = row_data[3].split(',')
    #pkgdatas.split(',')
    #获取每个包的前两个字段
    for pkgdata in pkgdatas:
        pkgdata = '.'.join((pkgdata.split('.'))[:2])
        mydata.append(pkgdata)
    #将列表排序
    mydata = list(set(mydata))
    print mydata
    #将列表转化为字符串
    mydata = ','.join(mydata)
    #写入数据到每行的第一列
    ws.write(i,0,mydata)
    mydata = []
    row_list.append(row_data[3])
#print row_list
w.save('mini.xls')
```
4.根据Excel文件中满足特定要求的apk的md5值来从服务器获取相应的apk样本，就需要这样做：　
```python
#-*-coding:utf8-*-
import xlrd
import os
import shutil

fname = "./excelname.xls"
bk = xlrd.open_workbook(fname)
shxrange = range(bk.nsheets)
try:
    #打开Sheet1工作表
    sh = bk.sheet_by_name("Sheet1")
except:
    print "no sheet in %s named Sheet1" % fname
#获取行数
nrows = sh.nrows
#获取列数
ncols = sh.ncols
#print "nrows %d, ncols %d" % (nrows,ncols)
#获取第一行第一列数据
cell_value = sh.cell_value(1,1)
#print cell_value

row_list = []
#range(起始行,结束行)
for i in range(1,nrows):
    row_data = sh.row_values(i)
    if row_data[6] == "HXB":
        filename = row_data[3]+".apk"
        #print "%s  %s  %s" %(i,row_data[3],filename)
        filepath = r"./1/"+filename
        print "%s  %s  %s" %(i,row_data[3],filepath)
        if os.path.exists(filepath):
            shutil.copy(filepath, r"./myapk/")
```

[返回目录](README.md)