### **[智能指针](http://blog.csdn.net/lollipop_jin/article/details/8499530)概念**

C++中指针申请和释放堆内存通常采用的方式是new和delete。智能指针是基于**RAII(Resource acquisition is initialization)机制实现的类(模板)**，具有指针的行为(重载了operator*与operator->操作符)，可以“智能”地销毁其所指对象。C++11中有unique_ptr、auto_ptr、shared_ptr与weak_ptr等智能指针，可以对动态资源进行管理

** 0、RAII概念**

C++中的RAII全称是“Resource acquisition is initialization”，直译为“资源获取就是初始化”。但是这翻译并没有显示出这个惯用法的真正内涵。RAII的好处在于它提供了一种**资源自动管理**的方式，当产生异常、回滚等现象时，RAII可以正确地释放掉资源。
RAII的**实现原理**很简单，利用stack上的临时对象生命期是程序自动管理的这一特点，将我们的资源释放操作封装在一个临时对象中。比如文件操作还没有到达close就因异常退出。

** 1、unique_ptr概念**

unique_ptr**“唯一”拥有其所指对象**，同一时刻只能有一个unique_ptr指向给定对象（通过禁止拷贝语义、只有移动语义来实现）。

unique_ptr指针本身的**生命周期**：从unique_ptr指针创建时开始，直到离开作用域。离开作用域时，若其指向对象，则将其所指对象销毁(默认使用delete操作符，用户可指定其他操作)。

unique_ptr指针与其所指对象的关系：在智能指针生命周期内，可以改变智能指针所指对象，如创建智能指针时通过构造函数指定、通过reset方法重新指定、通过release方法释放所有权、通过移动语义转移所有权。
**unique_ptr的基本操作：**
```C
//智能指针的创建  
unique_ptr<int> u_i; //创建空智能指针
u_i.reset(new int(3)); //"绑定”动态对象  
unique_ptr<int> u_i2(new int(4));//创建时指定动态对象  
//所有权的变化  
int *p_i = u_i2.release(); //释放所有权  
unique_ptr<string> u_s(new string("abc"));  
unique_ptr<string> u_s2 = std::move(u_s); //所有权转移(通过移动语义)，u_s所有权转移后，变成“空指针”  
u_s2=nullptr;//显式销毁所指对象，同时智能指针变为空指针。与u_s2.reset()等价  ```
** 1.1、unique_ptr的使用场景**
```C
(1) 动态资源的异常安全保证(利用其RAII特性)：
        void foo()  
        {//不安全的代码  
            X *px = new X;  
            // do something, exception may occurs  
            delete px; // may not go here  
        }  
        void foo()  
        {//异常安全的代码。无论是否异常发生，只要px指针成功创建，其析构函数都会被调用，确保动态资源被释放  
            unique_ptr<X> px(new X);  
            // do something,  
        }  
(2) 返回函数内创建的动态资源
        unique_ptr<X> foo()  
        {  
            unique_ptr<X> px(new X);  
            // do something  
            return px; //移动语义  
        }  
(3) 可放在容器中(弥补了auto_ptr不能作为容器元素的缺点)
        方式一：
        vector<unique_ptr<string>> vs { new string{“Doug”}, new string{“Adams”} };  
        方式二：
        vector<unique_ptr<string>>v;  
        unique_ptr<string> p1(new string("abc"));  
        v.push_back(std::move(p1));     //这里需要显式的移动语义，因为unique_ptr并无copy语义  
(4) 管理动态数组，因为unique_ptr有unique_ptr<X[]>重载版本，销毁动态对象时调用delete[]
        unique_ptr<int[]> p (new int[3]{1,2,3});  
        p[0] = 0;   // 重载了operator[]
```
** 1.2、自定义资源删除操作(Deleter):**
```C
unique_ptr默认的资源删除操作是delete/delete[]，若需要，可以进行自定义：
void end_connection(connection *p) { disconnect(*p); } //资源清理函数  
unique_ptr<connection, decltype(end_connection)*> //资源清理器的“类型”  
        p(&c, end_connection);// 传入函数名，会自动转换为函数指针  ```
### ** 2 auto_ptr**

auto_ptr是C++标准库中(```<utility>```)为了解决资源泄漏的问题提供的一个智能指针类模板（注意：这只是一种简单的智能指针）

auto_ptr的实现原理其实就是RAII，在构造的时候获取资源，在析构的时候释放资源，并进行相关指针操作的重载，使用起来就像普通的指针:```std::auto_ptr<Class A> pa(new ClassA);```

** 2.1 事项**

1. 
auto_ptr没有考虑引用计数，因此一个对象只能由一个auto_ptr所拥有，在给其他auto_ptr赋值(不管是直接还是间接赋值)的时候，会转移这种拥有关系。自己为空。
1. 
不能指向数组，也不能作为容器的元素  
1. 
利用auto_ptr取代普通指针作为成员变量，这样首先调用成功的成员变量的构造函数肯定会调用其析构函数，那么就可以避免资源泄漏问题。

**auto_ptr与unique_ptr**

在C++11环境下，auto_ptr被看做“遗留的”，他们有如下区别：
1. 
auto_ptr有拷贝语义，拷贝后源对象变得无效；unique_ptr则无拷贝语义，但提供了移动语义
1. 
auto_ptr不可作为容器元素，unique_ptr可以作为容器元素
1. 
auto_ptr不可指向动态数组(尽管不会报错：但销毁时delete而不是delete []错****)，unique_ptr可以指向动态数组

### **3. [shared_ptr](http://my.oschina.net/costaxu/blog/103119)**

shared_ptr与scoped_ptr一样包装了new操作符在堆上分配的动态对象，但它实现的是引用计数型的智能指针 ，**可以被自由地拷贝和赋值，在任意的地方共享它**，当没有代码使用（引用计数为0）它时才删除被包装的动态分配的对象。shared_ptr也可以安全地放到标准容器中，并弥补了auto_ptr因为转移语义而不能把指针作为STL容器元素的缺陷。shared_ptr就是为了解决auto_ptr在对象所有权上的局限性（auto_ptr是独占的），在使用引用计数的机制上提供了可以共享所有权的智能指针，当然这不会没有任何额外的代价。
####多线程安全性：
首先要分为两个方面：智能指针自身、管理的对象
* 
shared_ptr 的线程安全级别和内建类型、标准库容器、std::string 一样
* 
一个 shared_ptr 实体可被多个线程同时读取；
* 
两个的 shared_ptr 实体可以被两个线程同时写入，“析构”算写操作；
* 
若[多个线程](http://www.cppblog.com/Solstice/archive/2013/01/28/197597.html)读写同一个 shared_ptr 对象，那么需要加锁：因为 **shared_ptr 有两个数据成员，读写操作不能原子化**
* 
 shared_ptr 对象本身的线程安全级别，不是它管理的对象的线程安全级别。
* 
引用计数本身是安全且无锁的，但对象的读写则不是

```C
__shared_count&
      operator=(const __shared_count& __r) // nothrow
      {    
    _Sp_counted_base<_Lp>* __tmp = __r._M_pi;
    if (__tmp != _M_pi)                 //先判断是否为自赋值
      {    
        if (__tmp != 0)                 //右边计数加1
          __tmp->_M_add_ref_copy();
        if (_M_pi != 0)                 //左边计数减1
          _M_pi->_M_release();
        _M_pi = __tmp;                  //左边等于右边               
      }
      COSTA_DEBUG_REFCOUNT;
    return *this;
      }
      ```

### 多用make_shared和make_unique

```C++
auto upw1(std::make_unique<Widget>()); // with make func
std::unique_ptr<Widget> upw2(new Widget); // without make func
auto spw1(std::make_shared<Widget>()); // with make func
std::shared_ptr<Widget> spw2(new Widget); // without make func
1、为了节省一次内存分配：原来 shared_ptr<Foo> x(new Foo); 需要为 Foo 和 ref_count 各分配一次内存，
    现在用 make_shared() 的话，可以一次分配一块足够大的内存，供 Foo 和 ref_count 对象容身
2、new调用构造函数时可能会出错。
```
####自定义shared_ptr
```C++ 
// 定义仅由HasPtr类使用的U_Ptr类，用于封装使用计数和相关指针  
// 这个类的所有成员都是private，我们不希望普通用户使用U_Ptr类，所以它没有任何public成员  
// 将HasPtr类设置为友元，使其成员可以访问U_Ptr的成员  
class U_Ptr  
{  
    friend class HasPtr;  
    int *ip;  
    size_t use;  
    U_Ptr(int *p) : ip(p) 
    {  
        if(!ip)
            ++use;
        cout << "U_ptr constructor called !" << endl;  
    }  
    ~U_Ptr()  
    {  
        delete ip;  
        cout << "U_ptr distructor called !" << endl;  
    }  
};  
  
class HasPtr  
{  
public:  
    // 构造函数：p是指向已经动态创建的int对象指针  
    HasPtr(int *p, int i) : ptr(new U_Ptr(p)) , val(i)  
    {  
        cout << "HasPtr constructor called ! " << "use = " << ptr->use << endl;  
    }  
  
    // 复制构造函数：复制成员并将使用计数加1  
    HasPtr(const HasPtr& orig) : ptr(orig.ptr) , val(orig.val)  
    {  
        ++ptr->use;  
        cout << "HasPtr copy constructor called ! " << "use = " << ptr->use << endl;  
    }  
  
    // 赋值操作符  
    HasPtr& operator=(const HasPtr&);  
  
    // 析构函数：如果计数为0，则删除U_Ptr对象  
    ~HasPtr()  
    {  
        cout << "HasPtr distructor called ! " << "use = " << ptr->use << endl;  
        if (--ptr->use == 0)  
            delete ptr;  
    }  
  
    // 获取数据成员  
    int *get_ptr() const  
    {  
        return ptr->ip;  
    }  
    int get_int() const  
    {  
        return val;  
    }  
  
    // 修改数据成员  
    void set_ptr(int *p) const  
    {  
        ptr->ip = p;  
    }  
    void set_int(int i)  
    {  
        val = i;  
    }  
  
    // 返回或修改基础int对象  
    int get_ptr_val() const  
    {  
        return *ptr->ip;  
    }  
    void set_ptr_val(int i)  
    {  
        *ptr->ip = i;  
    }  
private:  
    U_Ptr *ptr;   //指向使用计数类U_Ptr  
    int val;  
};  
HasPtr& HasPtr::operator = (const HasPtr &rhs)  //赋值操作符在减少做操作数的使用计数之前使rhs的使用加1，防止自我赋值
{  
    // 增加右操作数中的使用计数  
    ++rhs.ptr->use;  
    // 将左操作数对象的使用计数减1，若该对象的使用计数减至0，则删除该对象  
    if (--ptr->use == 0)  
        delete ptr;  
    ptr = rhs.ptr;   // 复制U_Ptr指针  
    val = rhs.val;   // 复制int成员  
    return *this;  
}  

//升级========================================================================模板
template <typename T>
class SmartPtr;

template <typename T>
class U_Ptr     //辅助类
{
private:
    //该类成员访问权限全部为private，因为不想让用户直接使用该类
    friend class SmartPtr<T>;      //定义智能指针类为友元，因为智能指针类需要直接操纵辅助类

    //构造函数的参数为基础对象的指针
    U_Ptr(T *ptr) :p(ptr),count(1) {}
    //析构函数
    ~U_Ptr() { delete p; }
    
    void add_referece()
    {
        ++count;
    }
    void release()
    {
        --count;
    }

    //引用计数
    int count;   
    //基础对象指针
    T *p;                                                      
};

template <typename T>
class SmartPtr   //智能指针类
{
public:
    SmartPtr(T *ptr) :rp(new U_Ptr<T>(ptr)) { }      //构造函数
    SmartPtr(const SmartPtr<T> &sp) 
    { 
        rp = sp.rp;             //注意sp不是指针，所以用的.而不是->
        rp->count += 1;
    }  //复制构造函数
    SmartPtr& operator=(const SmartPtr<T>& rhs) 
    {    //重载赋值操作符
        if(rhs.rp->p != rp->p)
        {
            ++rhs.rp->count;     //首先将右操作数引用计数加1，
            if (--rp->count == 0)     //然后将引用计数减1，可以应对自赋值
                delete rp;
            rp = rhs.rp;
        }
        return *this;
    }

    int getnumber()
    {
        return rp->count;
    }
    
    T getvalue()
    {
        return *(rp->p);
    }

    ~SmartPtr() {        //析构函数
        if (--rp->count == 0)    //当引用计数减为0时，删除辅助类对象指针，从而删除基础对象
            delete rp;
        else 
            std::cout << "还有" << rp->count << "个指针指向基础对象" << std::endl;
    }
private:
    U_Ptr<T> *rp;  //辅助类对象指针
};

```
###shared_ptr源码：
 shared_ptr的实现
 shared_ptr模板类有一个__shared_count类型的成员_M_refcount来处理引用计数的问题。__shared_count也是一个模板类，它的内部有一个指向Sp_counted_base_impl类型的指针_M_pi。所有引用同一个对象的shared_ptr都共用一个_M_pi指针。

当一个shared_ptr拷贝复制时， _M_pi指针调用_M_add_ref_copy（）函数将引用计数+1。 当shared_ptr析构时，_M_pi指针调用_M_release()函数将引用计数-1。 _M_release()函数中会判断引用计数是否为0. 如果引用计数为0， 则将shared_ptr引用的对象内存释放掉。

```C++
    //首先将参数__r的_M_pi指针赋值给自己， 然后判断指针是否为NULL， 如果不为null 则增加引用计数。
    __shared_count(const __shared_count& __r) 
    : _M_pi(__r._M_pi) // nothrow
    {    
        if (_M_pi != 0)
            _M_pi->_M_add_ref_copy();
            COSTA_DEBUG_REFCOUNT;
    }
    /*
    首先，判断等号左右两边的__share_count是否引用同一个对象。如果引用同一个对象(__tmp==_M_pi)，
    那么引用计数不变，什么都不用做。如果不是的话，就把等号左边的share_ptr的引用计数-1，
    将等号右边的引用计数+1 。例如： 有两个shared_ptr p1和p2, 运行p1= p2 。
    假如p1和p2是引用同一个对象的，那么引用计数不变。 如果p1和p2是指向不同对象的，
    那么p1所指向对象的引用计数-1， p2指向对象的引用计数+1。 
    */
    __shared_count& operator=(const __shared_count& __r) // nothrow
    {    
        _Sp_counted_base<_Lp>* __tmp = __r._M_pi;
        if (__tmp != _M_pi)
        {    
            if (__tmp != 0)
                __tmp->_M_add_ref_copy();
            if (_M_pi != 0)
                _M_pi->_M_release();
            _M_pi = __tmp;
        }
        COSTA_DEBUG_REFCOUNT;
        return *this;
    }
    /*析构函数只是调用了_M_pi的_M_release这个成员函数。_M_release这个函数，除了会将引用计数-1之外，
    还会判断是否引用计数为0， 如果为0就调用_M_dispose()函数。
    _M_dispose函数会将share_ptr引用的对象释放内存。 
    */
    ~__shared_count() // nothrow
    {
        if (_M_pi != 0)
            _M_pi->_M_release();

        COSTA_DEBUG_REFCOUNT;
    }
```
### **4 weak_ptr**

weak_ptr是为配合shared_ptr而引入的一种智能指针来协助shared_ptr工作，它可以从一个shared_ptr或另一个weak_ptr对象构造，它的构造和析构不会引起引用记数的增加或减少。没有重载*和->但可以使用lock获得一个可用的shared_ptr对象

[返回目录](README.md)