```C
vector无的操作：
    push_front()
string无：
    front()
    back()
    pop_back()
    push_front()
    pop_front()
list无：
    除了  ++   --  ！=   == 之外，所有的算术运算和关系运算都不支持
```
```C
string 特有：
    substr
    append
    replace
    find
    compare
vector特有：
    capacity
    reserve
```

C++中的容器种类：

1. 
序列容器（7个）
    * 
vector：提供了自动内存管理功能（采用了STL普遍的内存管理器allocator），可以动态改变对象长度，提供随机访问。在尾部添加和删除元素的时间是常数的，但在头部或中间就是线性时间。
    * 
deque：双端队列（double-ended queue），**支持随机访问**，与vector类似，主要区别在于，从deque对象的开始位置插入和删除元素的时间也是常数的，所以若多数操作发生在序列的起始和结尾处，则应考虑使用deque数据结构。为实现在deque两端执行插入和删除操作的时间为常数时间这一目的，deque对象的设计比vector更为复杂，因此，尽管二者都提供对元素的随机访问和在序列中部执行线性时间的插入和删除操作，但vector容器执行这些操作时速度更快些。
    * 
list：双向链表（是循环的）。目的是实现快速插入和删除。
    * 
forward_list(C++11)：实现了单链表，不可反转。相比于list，forward_list更简单，更紧凑，但功能也更少。
    * 
queue：是一个适配器类。queue模板让底层类（默认是deque）展示典型的队列接口。queue模板的限制比deque更多，它不仅不允许随机访问队列元素，甚至不允许遍历队列。与队列相同，只能将元素添加到队尾、从队首删除元素、查看队首和队尾的值、检查元素数目和测试队列是否为空。
    * 
priority_queue：是另一个适配器类，支持的操作与queue相同。
        priority_queue模板类是另一个适配器类，它支持的操作与queue相同。两者之间的主要区别在于，在priority_queue中，最大的元素被移到对首。内部区别在于，默认的底层类是vector。可以修改用于确定哪个元素放到队首的比较方式，方法是提供一个可选的构造函数参数：
```C++
        priority_queue<int> pq1;                     // default version
        priority_queue<int> pg2(greater<int>);       // use greater<int> to order
        greater<>函数是一个预定义的函数对象。```

    * 
stack：与queue相似，stack也是一个适配器类，它给底层类（默认情况下为vector）提供了典型的栈接口。
    * 
queue、stack默认用deque,也可以用vector、list实现
1. 
关联容器
    * 
4种有序关联容器：set、multiset、map和multimap，底层基于树结构
    * 
C++11又增加了4种无序关联容器：unordered_set、unordered_multiset、unordered_map和unordered_multimap，底层基于hash。

###STL的容器可以分为以下几个大类:
* 
序列容器，　有vector, list, deque, string.
* 
关联容器,     有set, multiset, map, mulmap
               hash_set,hash_map, hash_multiset, hash_multimap
* 
其他的杂项： stack, queue, valarray, bitset
 
####STL各个容器的实现:
* 
vector
    1. 
内部数据结构：数组。
    1. 
随机访问每个元素，所需要的时间为常量。
    1. 
在末尾增加或删除元素所需时间与元素数目无关，在中间或开头增加或删除元素所需时间随元素数目呈线性变化。
    1. 
可动态增加或减少元素，内存管理自动完成，但程序员可以使用reserve()成员函数来管理内存。
    1. 
vector的迭代器在内存重新分配时将失效（它所指向的元素在该操作的前后不再相同）。当把超过capacity()-size()个元素插入 vector中时，内存会重新分配，所有的迭代器都将失效；否则，指向当前元素以后的任何元素的迭代器都将失效。
    * 
当删除元素时，指向被删除元素以后的任何 元素的迭代器都将失效。   
    * 
resize(n)：调整元素的个数，如果n > size()则扩容，否则删除n~size()之间的元素
    * 
reverse(n)：调整空间的大小以容得下n个元素，n>size()时扩容，否则不变即忽略
 
* 
deque
    1. 
内部数据结构：数组。
    1. 
随机访问每个元素，所需要的时间为常量。
    1. 
在开头和末尾增加元素所需时间与元素数目无关，在中间增加或删除元素所需时间随元素数目呈线性变化。
    1. 
可动态增加或减少元素，内存管理自动完成，不提供用于内存管理的成员函数。
    1. 
增加任何元素都将使deque的迭代器失效。在deque的中间删除元素将使迭代器失效。
    1. 
在deque的头或尾删除元素时，只有指向该元素的迭代器失效。
* 
list
    1. 
内部数据结构：双向环状链表。
    1. 
不能随机访问一个元素。
    * 
可双向遍历。
    1. 
在开头、末尾和中间任何地方增加或删除元素所需时间都为常量。
    1. 
可动态增加或减少元素，内存管理自动完成。
    1. 
增加任何元素都不会使迭代器失效。删除元素时，除了指向当前被删除元素的迭代器外，其它迭代器都不会失效。
* 
forward-list
    1. 
内部数据结构：单向链表。
    1. 
不可双向遍历，只能从前到后地遍历。
    1. 
其它的特性同list相似。
* 
stack
    1. 
适配器，它可以将任意类型的序列容器转换为一个堆栈，一般使用**deque**作为支持的序列容器。
    1. 
元素只能后进先出（LIFO）。
    1. 
不能遍历整个stack。
* 
queue
    1. 
适配器，它可以将任意类型的序列容器转换为一个队列，一般使用**deque**作为支持的序列容器。
    1. 
元素只能先进先出（FIFO）。
    1. 
不能遍历整个queue。
* 
priority_queue
    1. 
适配器，它可以将任意类型的序列容器转换为一个优先级队列，一般使用**vector**作为底层存储方式。
    1. 
只能访问第一个元素，不能遍历整个priority_queue。
    1. 
第一个元素始终是优先级最高的一个元素。
* 
set
    1. 
按照键进行排序存储， 值必须可以进行比较， 可以理解为set就是键和值相等的map
    1. 
键唯一。
    1. 
元素默认按升序排列。
    1. 
如果迭代器所指向的元素被删除，则该迭代器失效。其它任何增加、删除元素的操作都不会使迭代器失效。
* 
multiset
    1. 
键可以不唯一。
    1. 
其它特点与set相同。
* 
hash_set
    1. 
与set相比较，它里面的元素不一定是经过排序的，而是按照所用的hash函数分派的，它能提供更快的搜索速度（当然跟hash函数有关）。
    1. 
hash_set将key进行hash， 然后将key放在hash值对应的桶中， 原理可以这样理解， hash_set就是key， value相等的hash_map
    1. 
其它特点与set相同。
* 
hash_multiset
    1. 
键可以不唯一。
    1. 
其它特点与hash_set相同。
* 
map
    1. 
键唯一。
    1. 
元素默认按键的升序排列。
    1. 
如果迭代器所指向的元素被删除，则该迭代器失效。其它任何增加、删除元素的操作都不会使迭代器失效。
* 
multimap
    1. 
键可以不唯一。
    1. 
其它特点与map相同。
* 
hash_map
    1. 
与map相比较，它里面的元素不一定是按键值排序的，而是按照所用的hash函数分派的，它能提供更快的搜索速度（当然也跟hash函数有关）。
    1. 
其它特点与map相同。
* 
hash_multimap
    * 
键可以不唯一。
    1. 
其它特点与hash_map相同。


[返回目录](README.md)