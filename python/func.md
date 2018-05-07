#类中有三种函数：
    普通(实例函数)、staticmethod、classmethod
```python
class test(object):
    a = 'jkf'
    def __init__(self,name):
        self.name=name
    def show(self,name):
        return self.name
        
    @staticmethod
    def stmethod():
        print("staticmethod is called")
    
    @classmethod
    def clmethod(cls,name):
        return cls.name
```

### 总结：

```python
1、一般来说，类中的函数都是实例函数：
    1)即对某一实例的操作：该实例通过self传入----->默认第一个参数都是self，操作实例
    2)使用类名来调用该方法会出现错误！！！
2、但是有两种特殊的函数：
    1、staticmethod：
        1)也是一种普通的函数，存在于类的命名空间中，
        2)但是不需要self参数，也不对实例有任何影响
        3)你可以把它想像成静态语言的static方法
    2、classmethod：
        1)参数是类本身，而不是实例------>对类本身操作
        2)可以用类或实例调用
3、在python中，所有的方法放在一起管理，而不像静态语言分开管理！
```

[返回目录](README.md)