##模板
* 
使用模板的目的就是能够让程序员编写与类型无关的代码。
1. 
模板的声明或定义只能在全局，命名空间或类范围内进行。即不能在局部范围，函数内进行，比如不能在main函数中声明或定义一个模板。
* 
不能“分离编译”

###函数模板
* 形式：
    ```C++
    template <typename T1,...,typename Tn>
    ret-type func(T1 &a,T2 &b,...)
    {}
    ```
* 调用：只能是参数推演，不能传递类型
    ```C++
    func(1,3);
    func(int,int);  //错误
    ```

###类模板
* 
形式：
    ```C++ 
    //.H文件
    template<class data_obj>
    class other;    //前置声明：不带类型，只有类名
    template<typename T1,...typename Tn>
    class cname
    {
        ret-type func(T1 &a,T2 &b,...);
    }  //类中的类型用T1,...,Tn
    
    template <typename T1,...typename Tn>
    ret-type cname<T1,...,Tn>::func(T1 &a,T2 &b,...)
    {}
    template <typename T1,...typename Tn>
    int cname<T1,...,Tn>::i = 9;
    ```
    注：切记不可分离编译，声明和定义一起！！！
1. 
调用：类模板形参不存在实参推演的问题。
    ```C++ 
    cname(int,int);  
    cname(1,3);     //错误
    ```

###参数：
* 
类型参数：普通的
* 
非类型参数：
    ```template<class T, int a> class B{};其中int a就是非类型的模板形参。```
    1. 
非类型模板的形参只能是整型，指针和引用，像double，String, String \*这样的类型是不允许的。但是double &，double *，对象的引用或指针是正确的。
    1. 
调用非类型模板形参的实参必须是一个常量表达式，即他必须能在编译时计算出结果。
* 
模板参数：
    1. 
可以为类模板的类型形参提供默认值，但不能为函数模板的类型形参提供默认值。
    1. 形式：
```template<class T1, class T2=int> class A{}```

[返回目录](README.md)