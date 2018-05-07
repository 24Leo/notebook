### C++内部异常
| 异常名 | 说明 |
| -- | -- |
| exception | 最常见的问题 |
| runtime_error | 运行时错误：仅在运行时才能检测到的问题 |
| range_error | 运行时错误：结果超出范围 |
| overflow_error | 运行时错误：计算上溢 |
| underflow_error | 运行时错误：计算下溢 |
| logic_error | 逻辑错误：运行前检测到的问题 |
| domain_error | 逻辑错误：参数结果值不存在 |
| invalid_argument | 逻辑错误：不适合的参数 |
| length_error | 逻辑错误：试图超出类型最大长度的对象 |
| out_of_range | 逻辑错误：使用的值超出范围 |


### 自定义异常：一般继承自exception

1. 
要求：
一个相对完善的异常处理类（以及附加的一些东西）应该能够处理下面的一些功能：
    * 
能够方便的定义异常类的继承树
    * 
 能够方便的throw、catch，也就是在代码中捕获、处理代码的部分应该更短
    * 
能够获取异常出现的源文件的名字、方法的名字、行号
    * 
能够获取异常出现的调用栈并且打印出来

1. 
基础：
    * 
对于没有捕获的异常（no handler），则会终止程序，调用terminate()
    * 
在定义函数的时候，我们可以在定义的后面加上throw (exception1, exception2…):
        * 
如果没有写这一段、则可能抛出任意的异常
        * 
如果写throw()，则表示函数不能抛出任意的异常
        * 
如果写throw(A, B), 表示函数抛出A、B的异常
    * 
如果抛出的异常不在列表范围内，则异常不能被catch，也就会调用unexpected()/terminate()

1. 
实现自定义异常：
    * 
继承基类
    * 
重写重写基类的```const char* what()```函数，返回错误信息；
    * 
代码：
```C++
#include<exception>    
#include<iostream>    
using namespace std;    
　
//customized exception class 'myException'  
//普通：指定输出
class myException:public exception          //继承
{    
    public:    
           const char* what()const throw()      //重写
           {    
                return "ERROR! Don't divide a number by integer zero.\n";    
           }        
};    
　
//传参：用户自定义
class myException:public exception          //继承
{    
    public:  
           myException()=default;
           myException(const string &s):ret(s){}
           const string what()const throw()      //重写
           {    
                return ret;   
           }
    private:
    string ret;
};    
　
//用户自定义高级
class myException:public exception          //继承
{    
    public:  
           myException(const string &s):exception(s){}
};    
　
void check(int y) //any type of exception is permitted    
{    
            if(y==0) throw myException();    
}    
void myUnexpected()    
{    
            cout<<"Unexpected exception caught!\n";    
            system("pause");    
            exit(-1);    
}    
void myTerminate() //##1 set it be the terminate handler    
{    
            cout<<"Unhandler exception!\n";    
            system("pause");    
            exit(-1);    
}    
//entry of the application    
int main()    
{    
            unexpected_handler oldHandler=set_unexpected(myUnexpected);    
            terminate_handler preHandler=set_terminate(myTerminate);    
            int x=100,y=0;    
            try    
            {    
                    check(y);    
                    cout<<x/y;    
            }    
            catch(myException &me)
            {
                    cout<<me.what();
            }
            catch(int &e) //no catch sentence matches the throw type    
            {    
                    cout<<e<<endl;    
            }    
            system("pause");    
            return 0;    
}```

[返回目录](README.md)