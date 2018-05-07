## [经验1](http://blog.csdn.net/chenhuajie123/article/details/7405080)
###[经验2](http://www.ezlippi.com/blog/2014/12/c-open-project.html)
## 混淆点

**0.字面值常量：**<br>
字面值因为只能用值称呼，常量说明不可以改变<br>
long double > double > float > unsigned long int > long int > unsigned int > int 

**1. 
暂停：**
```C
system("pause")             #include <unistd.h>
sleep()
getchar()```
暂停固定时间：
```C++
windows中：
    #include<windows.h>
    Sleep(unsigned int &);
linux下：
    #include<unistd.h>
    sleep(int seconds);
    自定义：
    通过初始化两个tm结构体，然后不断相减，直至等于要暂停的数。
    void sleep(const inst &num){
        time_t tt1,tt2;
        time(&tt1);
        do{
            time(&tt2);
        }while(tt2-tt1<num);
    }   
```

**2. 函数名/函数地址/函数指针**
```C
每一个函数都有一个入口地址，该入口地址就是函数指针所指向的地址。
函数名相当于一个指向其函数入口指针常量。
#include
　　int max(int x,int y){ return(x>y?x:y); }
　　void main()
　　{
    　　int (*ptr)(int, int);       /* 声明一个函数指针 */
    　　int a,b,c;
    　　ptr=max;                    /* 将max函数的首地址赋给指针ptr,max不带括号和参数，max代表函数的首地址 */
    　　scanf("%d,%d",&a,&b);
    　　c=(*ptr)(a,b);
    　　printf("a=%d,b=%d,max=%d",a,b,c);
　　}
　  实际上ptr和max都指向同一个入口地址，不同就是ptr是一个指针变量，不像函数名称那样是死的，它可以指向任何函数
注意，指向函数的指针变量没有++和--运算```


#### **3. [static](static.md)**

<br>static被引入以告知编译器，将变量存储在程序的**全局静态存储区而非栈上空间，且只实例化一次(故编译器用一个bool对象每次判断是否已经实例化)**。

static变量于全局数据区。第一次实例化或使用后就一直存在。
   1. 对局部static变量的每一次访问，都是访问全局数据区。即获有“全局变量”性质，每一次改变都是全局数据区的改变。
   1. 全局static变量和类中的static局部变量都是针对当前文件或者类来说的。引用当前文件或者实例化类时，可以有同名而不冲突。**因为针对当前文件、类，对其他文件或者类不可见**
   2. 类中的static函数只能访问static成员，不能访问其他的成员。因为类中的static成员是类有的，而不是实例特有。
   3. **const成员要在构造函数初始化，而static成员在需要在在类体外初始化，**那么static const和 const static 的成员应该在哪里进行初始化呢？这两个写法又会有什么不一样吗？其实他俩都一样。


### **4.auto、extern**
auto关键字可以从表达式中推导出变量的类型，这样就大大简化了编程人员的工作。而且auto是在编译时对变量进行了类型推导，所以不会对程序的效率造成影响，另外auto也不会对编译速度造成太大影响，因为编译时本身也要右侧推导后判断是否与左侧匹配。
```C++
vector<int> tt(a,a+4);
for(auto it=tt.begin();it!=tt.end();++tt)
    ...
```
extern关键字告诉编译器这个变量在其他文件中定义，编译的时候“放行“即可。因为全局变量在链接的时候才会可见，编译时看不到。------但**是声明而不是定义（除非赋值）**！！！！！！！

### **5.implicit/explicit**
首先explicit这个关键字只能用在类内部的**单参数构造函数声明**上，而不能用在类外部的函数定义上，它的作用是不能进行隐式转换。即显示的指明用那个构造函数。implicit是默认的，可以自动使用最“接近的”构造函数，但是当构造函数参数超过两个后自动关闭implicit.
### **7.mutable/const**
const 推出的初始目的，正是为了取代预编译指令，消除它的缺点，同时继承它的优点。
* 
首先，以const 修饰的常量值，具有不可变性，这是它能取代预定义语句的基础。
* 
第二 可以很方便地进行参数的调整和修改。
* 
第三，C++的编译器通常不为普通const常量分配存储空间，而是将它们保存在符号表中，这使得它成为一个编译期间的常量，没有了存储与读内存的操作，使得它的效率也很高，同时，这也是它取代预定义语句的重要基础。
* 
同样，必须初始化（特别是类中，必须在初始化列表解决）
* 
修饰函数时，则不可以修改调用的对象

mutable修饰的变量，将永远处于可变的状态，即使在一个const函数中。

### **8. volatile**

该关键字的实际意义是由其修饰的变量可能会被意想不到地改变，因此每次对其所修饰的变量进行操作都需要**从内存中取得它的实际值**。它可以用来阻止编译器对指令顺序的调整。只是由于该关键字所提供的禁止重排代码是假定在单线程环境下的，因此并不能禁止多线程环境下的指令重排。

### **9.左值/右值**

左值：可以取地址、有名字-----》即可以在内存中读写

右值：不可以取地址

左值引用：正常的C++98中的引用 &

右值引用：T && 因右值没有名字，这就相当于引用其值

### **10.指针和引用**
1. **指针要分配内存，而引用不用，因为它只是别名。有区别的根本原因！**
2. 语法级别：首先指针不必初始化也可以为NULL，引用必须初始化。
2. 语法级别：指针可以用关键字delete删除
3. 内部实现：指针赋值是修改绑定的对象，引用赋值是修改绑定对象的值。
4. 从语法上来说，引用和指针的最大区别在于是否可以被delete关键字删除以及是否可以为NULL。

### **11.NULL 0  nullptr**
```C
#ifndef NULL
#ifdef _cplusplus
#define NULL 0
#else
#define NULL ((void *)0)
#endif
#endif
```
在C中NULL就是void *的指针，可以隐式转换成相应的类型<br>
在C++中，空NULL就是0. nullptr是专门空指针类型的
但是两个函数：
```C
void bar(sometype1 a, sometype2 *b);
void bar(sometype1 a, int i);
```
使用bar(t,0)时就会出现问题。原本想传空指针过去，但是0是空指针更是整形。所以bar(t,nullptr)

C++中，空指针多用nullptr
### **12.类型扩展**
**size_t**是unsigned int类型，用于指明数组**长度或下标，它必须是一个正数**，std::size_t.设计size_t就是为了适应多个平台，其引入增强了程序在不同平台上的可移植性。

**ptrdiff_t**是signed类型，用于存放同一数组中**两个指针之间的差距(以数组元素的长度为单位，而非字节)，它可以使负数**，std::ptrdiff_t.同上，使用ptrdiff_t来得到独立于平台的地址差值.

**size_type**是unsigned类型,表示容器中元素长度或者下标，```vector<int>::size_type i = 0;```

**difference_type**是signed类型,表示迭代器差距，```vector<int>:: difference_type = iter1-iter2.```

 ### **前二者位于标准类库std内，后二者专为STL对象所拥有。**
 
 ### **13. 智能指针：auto_ptr与unique_ptr、shared_ptr与weak_ptr等**
** auto_ptr:**已被抛弃

** unique_ptr:**
    从创建开始直到离开作用域，“唯一”拥有该对象，只能通过reset(重定)、move(转移)、release(释放)但无拷贝
** shared_ptr:**
```C
__shared_count& operator=(const __shared_count& __r) // nothrow
    {    
        _Sp_counted_base<_Lp>* __tmp = __r._M_pi;   //_M_pi对象的计数指针
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
    }```
** weak_ptr:**
### **14.BOOL , float, 指针变量 与“零值”比较的 if 语句**
```C
标准答案：
    if ( flag )
    if ( !flag )
如下写法均属不良风格，不得分。
    if (flag == TRUE)  
    if (flag == 1 )    
    if (flag == FALSE)  
        if (flag == 0)     

标准答案示例：因为float的精度是6位，即精确到小数点后第五位，所以应该使用其精确位0.00001；
同理双精度小数其精度为15位，精确到小数点后第14位。
const float EPSINON = 0.00001;
if ((x >= - EPSINON) && (x <= EPSINON)
不可将浮点变量用“==”或“！=”与数字比较，应该设法转化成“>=”或“<=”此类形式。
如下是错误的写法，不得分。
    if (x == 0.0)  
    if (x != 0.0)  

标准答案：
    if (p == NULL)
    if (p != NULL)
如下写法均属不良风格，不得分。
    if (p == 0)
    if (p != 0)    
    if (p)  
        if (!)  
```
###**15.int_ptr、uint_ptr**
intptr_t 和uintptr_t 类型用来存放指针地址。它们提供了一种可移植且安全的方法声明指针，而且和系统中使用的指针长度相同，对于把指针转化成整数形式来说很有用。uintptr_t 是intptr_t 的无符号版本。
```C
typedef long int intptr_t; / typedef int intptr_t;  
typedef unsigned long int intptr_t; / typedef unsigned int uintptr_t;  
int num;
intptr_t *pi = &num;
uintptr_t *pu = (uintptr_t*)&num;
```
概念上, 尽管地址是指针, 内存管理常常使用一个无符号的整数类型更好地完成; 内核对待物理内存如同一个大数组, 并且内存地址只是一个数组索引. 进一步地, 一个指针容易解引用; 当直接处理内存存取时, 你几乎从不想以这种方式解引用. 使用一个整数类型避免了这种解引用, 因此避免了 bug. 因此, 内核中通常的内存地址常常是 unsigned long, 利用了指针和长整型一直是相同大小的这个事实, 至少在 Linux 目前支持的所有平台上.
###16.malloc、free/new、delete
* 
new调用malloc
* 
malloc是函数调用，new是操作符
* 
malloc未初始化，new是初始化的，自动调用构造函数/析构函数。
* 
malloc返回（void*），new返回对象指针

###16.移位操作符
```C++
#include <stdio.h>
void main()
{
   unsigned int i,j;
   i=35;
 
   //为什么下面两个左移操作结果不一样？
   j=1<<i;  // j为8
   j=1<<35; // j为0
}```
* 
对于1<<i，i是变量所以编译时i会和31取&，得到3；
* 
对应1<<35，编译时由于35'\>'31，最终结果直接换为0；
* 
《C陷阱与缺陷》 7.5移位运算符，p110: n<<32 或 n<<-1是非法的

[返回目录](README.md)