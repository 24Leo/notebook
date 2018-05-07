#List    　　　　[seq,]
```python
dir(list):显示所有list方法和属性。

tt=[1,4,78,[2,3,'43',5],9,'sd',true,23]
tt.append([]):   添加
tt.insert(i,j):  下标i处插入j
tt.pop(i):       删除下标i元素，默认最后一个
tt.remove(i):　　删除第一次出现的i
tt.index(i):　　　第一次出现i的下标
tt.count(i):　　　i出现的次数
del tt[i]:　　　　删除下标为i的元素
del tt[i:j]:　　　删[i,j)区域元素

print [1,2,3]+[5,6,9]
  >>>[1,2,3,5,6,9]
print [1,2,3]-[5,6,9]
  >>>error```

因为list内部实现了加法add，没有实现减法。我们重载一下：
```python
class superList(list):
    def __sub__(self, b):
        a = self[:]     # 这里，self是supeList的对象,superList继承于list，利用list[:]方法来表示整个对象。
        b = b[:]        
        while len(b) > 0:
            element_b = b.pop()
            if element_b in a:
                a.remove(element_b)
        return a

print superList([1,2,3]) - superList([3,4])
```


[返回目录](README.md)