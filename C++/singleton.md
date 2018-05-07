单例模式也称为单件模式、单子模式，意图是保证**一个类仅有一个实例，并提供一个访问它的全局访问点，该实例被所有程序模块共享**。有很多地方需要这样的功能模块，如系统的日志输出。====》但是不能多态

面对单例模式适用的情况，可能会优先考虑使用全局或者静态变量的方式，这样比较简单，也是没学过设计模式的人所能想到的最简单的方式了。


### [基本思路:](http://blog.jobbole.com/96963/)

定义一个单例类，使用类的私有静态指针变量指向类的唯一实例，并用一个公有的静态方法获取该实例。<br>
**构造函数、析构函数（一般不写）、拷贝构造函数和赋值构造函数都要是私有化：以防被用户代码随意创建**
#### **两种模式**
1. 
“恶汉”：实例化类时就创建静态实例
```C++
class testsingle{
    private:
        static testsingle * instance = new testsingle();    //全局：线程安全，因初始化时是单线程
        testsingle();
        testsingle(const testsingle &);
        testsingle & operator =(const testsingle &);
    public:
        static testsingle * getinstance(){
            return instance;
        }
}
```
1. 
“懒汉”：第一次使用时才创建实例(存在多线程安全的问题)－－－－延迟初始化：函数被调用时其才会被创建
```C++
class singleton{
    private:
        singleton();
        singleton(const singleton &);
        singleton & operator =(const singleton &);
    public:
        static singleton *getinstance(){
            static singelton * instance;
            return instance;
        }     //不好，多线程会导致在判断NULL时创建多个实例
   /*     //改进:双重检查
        static singleton *getinstance(){
            if(instance==NULL){
                lock();
                if(instance==NULL){
                    instance=new singelton();           //函数被调用时其才会被创建，一直到程序结束
                }
                unlock();
                return instance;
            }
        }*/
}
```
综合：<br>
        １、构造函数、拷贝构造函数、赋值构造函数都要是私有的：private,以防用户随意创建,保护构造函数
        2、全局静态变量(恶汉模式)的好处：没有多线程安全问题，因为初始化时是单线程模式
                        坏处：就是不管使不使用均在开始时初始化，影响性能
           局部静态变量(懒汉模式)的好处：第一次使用时才初始化，不影响性能，加快启动速度
                        坏处：多线程时存在安全问题，因为可能存在多个线程同时判断是否已经建立，就会产生多个实例（2号）
        3、析构函数：不能delete，因为delete不仅释放内存还会调用对象的析构函数，故会陷入死循环（内部一个静态类实例 4号)
## 解决思路：


1. 
内部类:存在什么时候释放的问题  　　   良：看第四个方案：atexit(func)注册释放函数　　     
```C++
class testsingle{
    private:
        class testhold{
            static testsingle *instance = new testsingle();
            ～testhold(){
                delete instance;
            }
        }
    public:
        static testsingle *getinstance(){
            return this.testhold.instance;
        }
}
```
1. 
局部静态变量：多线程安全问题      
```C++
class singleton{
    private:
        singleton();
        singleton(const singleton &);
        singleton & operator =(const singleton &);
    public:
        static singleton & getinstance(){
            static singleton instance;          //延迟初始化：函数被调用时其才会被创建，一直到程序结束
            return instance;
        }
}
```
**问题**：
这是由局部静态变量的实际实现所决定的。为了能满足局部静态变量只被初始化一次的需求，很多编译器会<br>通过一个全局的标志位记录该静态变量是否已经被初始化的信息。那么，对静态变量进行初始化的伪码就变成下面<br>这个样子：
```C++
bool flag = false;
if (!flag)
{
    flag = true;
    staticVar = initStatic();
}```
“那么在第一个线程执行完对flag的检查并进入if分支后，第二个线程将可能被启动，从而也进入if分支。这样，两个线程都将执行对静态变量的初始化。<br>
**解决**：用一个指针记录创建的实例，局部静态变量不是线程安全的。在对指针进行赋值之前使用锁保证在同一时间内只能有一个线程对指针进行初始化。**同时**基于性能的考虑，我们需要在每次访问实例之前检查指针是否已经经过初始化，以避免每次对Singleton的访问都需要请求对锁的控制权
1. 
线程安全、异常安全，可以做以下扩展                      好
```C++
class Lock
{
    private:       
    	CCriticalSection m_cs;
    public:
    	Lock(CCriticalSection  cs) : m_cs(cs)
    	{
    		m_cs.Lock();
    	}
    	~Lock()
    	{
    		m_cs.Unlock();
    	}
};
class Singleton
{
    private:
    	Singleton();
    	Singleton(const Singleton &);
    	Singleton& operator = (const Singleton &);
    public:
    	static Singleton *Instantialize();
    	static Singleton *pInstance;
    	static CCriticalSection cs;
};
Singleton* Singleton::pInstance = 0;
Singleton* Singleton::Instantialize()
{
    /*因此在这里，使用了指针，并在对指针进行赋值之前使用锁保证在同一时间内只能有一个线程对指针进行初始化。
    同时基于性能的考虑，我们需要在每次访问实例之前检查指针是否已经经过初始化，
以避免每次对Singleton的访问都需要请求对锁的控制权。*/
	if(pInstance == NULL)
	{   //double check
		Lock lock(cs);           //用lock实现线程安全，用资源管理类，实现异常安全
		//使用资源管理类，在抛出异常的时候，资源管理类对象会被析构，析构总是发生的无论是因为异常抛出还是语句块结束。
		if(pInstance == NULL)
		{
			pInstance = new Singleton();
		}
	}
	return pInstance;
}
　
使用：
    Singleton& tt=Singleton::Instantialize();       //对
    Singleton tt=Singleton::Instantialize();       //错：赋值构造禁止了
必须是引用，如果无出错：别忘了赋值构造已经是私有化的。
```
1. 
升级：有几个类型都需要实现为Singleton，复用上述代码　　　想通下面标注的问题就通了。
```C++
template <typename T>
class Singleton
{
public:
    static T& get_Instance()     //为什么用的指针，非要返回引用？:返回实例的生存期由Singleton定，不是用户代码
    {
        if (m_pInstance == NULL)
        {
            Lock lock;
            if (m_pInstance == NULL)                    //double-check
            {
                m_pInstance = new T();                  //延迟初始化
                atexit(Destroy);                        //解决释放问题
            }
            return *m_pInstance;
        }
        return *m_pInstance;
    }
protected:
    Singleton(void) {}
    ~Singleton(void) {}
private:
    Singleton(const Singleton& rhs) {}                  //各种构造函数的私有化
    Singleton& operator = (const Singleton& rhs) {}
    void Destroy()
    {
        if (m_pInstance != NULL)
            delete m_pInstance;
        m_pInstance = NULL;
    }
    static T* volatile m_pInstance;     //使用指针而不是局部静态变量的原因？：多线程下问题，方案2
};
//.cpp文件
template <typename T>
T* Singleton<T>::m_pInstance = NULL;                //类中静态变量初始化问题
　
使用：
class SingletonInstance : public Singleton<SingletonInstance>…
“在需要重用该Singleton实现时，我们仅仅需要从Singleton派生并将Singleton的泛型参数设置为该类型即可。”
　
在通过new关键字创建类型实例的时候，我们同时通过atexit()函数注册了释放该实例的函数，从而保证了这些实例能够
在程序退出前正确地析构。该函数的特性也能保证后被创建的实例首先被析构。
atexit（）不能使用时，内部类处理释放问题:
        析构所有的全局变量,事实上，系统也会析构所有的类的静态成员变量，就像这些静态成员也是全局变量一样。
template <typename T>
class Singleton
{
public:
    static T& get_Instance()                            //为什么用的指针，非要返回引用？
    {
        if (m_pInstance == NULL)
        {
            Lock lock;
            if (m_pInstance == NULL)                    //double-check
            {
                m_pInstance = new T();                  //延迟初始化
            }
            return *m_pInstance;
        }
        return *m_pInstance;
    }
protected:
    Singleton(void) {}
    ~Singleton(void) {}
private:
    Singleton(const Singleton& rhs) {}                  //各种构造函数的私有化
    Singleton& operator = (const Singleton& rhs) {}
    　
    static Dele;
    class Dele{
        ~Dele(){
            if(Singleton::m_pInstance)
                delete Singleton::m_pInstance
        }
    }
    　
    static T* volatile m_pInstance;                 //使用指针而不是局部静态变量的原因？
};
```
在实现中使用指针，但是返回引用？生存期不能交给用户：因为Singlet
on返回的实例的生存期是由Singleton本身所决定的，而不是用户代码

Singleton的最主要目的并不是作为一个全局变量使用，而是保证类型实例有且仅有一个。它所具有的全局访问特性仅仅是它的一个普通作用。但正是这个副作用使它更类似于包装好的全局变量，从而允许各部分代码对其直接进行操作。

“从语法上来讲，首先Singleton模式实际上将类型功能与类型实例个数限制的代码混合在了一起，违反了SRP（single responsibility protocol单一职责原则，一个类应该有且仅有一个职责）。其次Singleton模式在Instance()函数中将创建一个确定的类型，从而禁止了通过多态提供另一种实现的可能。”

“但是从系统的角度来讲，对Singleton的使用则是无法避免的：假设一个系统拥有成百上千个服务，那么对它们的传递将会成为系统的一个灾难。从微软所提供的众多类库上来看，其常常提供一种方式获得服务的函数，如GetService()等。另外一个可以减轻Singleton模式所带来不良影响的方法则是为Singleton模式提供无状态或状态关联很小的实现。”

“也就是说，Singleton本身并不是一个非常差的模式，对其使用的关键在于何时使用它并正确的使用它。”

##思考题：为什么可以编译？
```C
class Sin {
private:
	Sin() {}
	Sin(const Sin&){}

	static Sin *inst;
};

Sin *Sin::inst = new Sin();
```

[返回目录](README.md)