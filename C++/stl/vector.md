## stl_vector.h
```C++
vector是C++标准模板库中模板。它是一个多功能的，能够操作多种数据结构和算法的模板类和函数库。
vector之所以被认为是一个容器，是因为它能够像容器一样存放各种类型的对象，
简单地说，vector是一个能够存放任意类型的动态数组，能够增加和压缩数据。

　　#include <vector>
　　vector<Elem>c
　　vector<Elem> c1(c2)
　　vector<Elem> c(n)
　　vector<Elem> c(n, elem)
　　vector<Elem> c(beg,end)
　　c.~ vector<Elem>()
标准运算符: ==, !=, <=, >=, <, 和 >
    v[]         // 要访问vector中的某特定位置的元素可以使用 [] 操作符.
    v1 == v2    // 两个vectors被认为是相等的,如果: 1.它们具有相同的容量;2.所有相同位置的元素相等.
    v1 != v2
    v1 <= v2    // vectors之间大小的比较是按照词典规则.
    v1 >= v2 
    v1 < v2
    v1 > v2 
函数表述：
　  c.push_back()        添加到末尾
　  c.pop_back()        删最后一个
　　c.assign(beg,end)   将[beg; end)区间中的数据赋值给c（beg,end不可是自己的迭代器）=======所有迭代器失效
    c.assign(n,elem)    将n个elem的拷贝赋值给c
　　c.at(idx)   传回索引idx所指的数据，如果idx越界，抛出out_of_range。
　　c.back()　　传回最后一个数据的引用，不检查这个数据是否存在。
　　c.front()　　传回第一个数据引用。
　　c.begin()　　传回迭代器中的第一个数据地址。
　　c.end()　　指向迭代器中末端元素的下一个，指向一个不存在元素。
　　c.rbegin()　　指向迭代器中最后一个元素
　　c.rend()　　传回迭代器中的第一个数据的前一个，指向一个不存在元素。
　　c.capacity()　　返回容器中可容纳数据的个数。
　　c.reserve()     重置capacity大小
　  c.size()        大小
　  c.resize()      重设大小
　　c.empty()　　判断容器是否为空
　　c.clear()　　移除容器中所有数据。
　　c.erase(pos)    删除pos位置的数据，传回下一个数据的迭代器。:自动把后面的前移，最坏O(N)
　　c.erase(beg,end)    　删除(beg,end)区间的数据，传回下一个数据迭代器。
　　c.insert(pos,elem)      在迭代器指向的元素前插入。返回指向新添加的迭代器
　　c.insert(pos,n,elem)    在迭代器指向的元素前插入n个elem，返回void
　　c.insert(pos,beg,end)   在迭代器指向的元素前插入beg~end间的元素，返回void。
　　c1.swap(c2)　　swap(c1,c2)将c1和c2元素互换。同上操作。
```

[返回目录](README.md)