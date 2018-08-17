##文件（当前目录：一段PHP代码的学习.pdf）

首先我们要打破一个思维: PHP不像C语言那样, 只有你显示的调用内存分配相关API才会有内存的分配. 也就是说, 在PHP中, 有很多我们看不到的内存分配过程：
    * 保存数据-实际内存（类似C语言）
    * 保存符号-符号表
    * PHP语言是一种解释型的脚本语言，这种运行机制使得每个PHP页面被解释执行后，所有的相关资源都会被回收。也就是说，PHP在语言级别上没有办法让某个对象常驻内存
    
##普通变量
* 1.在5.2版本或之前版本，PHP会根据refcount值来判断是不是[垃圾](http://onwise.xyz/2017/04/20/%E6%B5%85%E8%B0%88php5%E4%B8%AD%E5%9E%83%E5%9C%BE%E5%9B%9E%E6%94%B6%E7%AE%97%E6%B3%95garbage-collection%E7%9A%84%E6%BC%94%E5%8C%96/)
    * 每个对象分配一个计数器，初始化1，新变量引用时加1，减少一个引用时计数器减1.这个计数器就是refcount
    * 如果refcount值为0，PHP会当做垃圾释放掉。
    * 但是这种回收机制有缺陷，对于循环引用的变量无法回收
* 2.在5.3之后版本改进了垃圾回收机制
    * 如果发现一个zval容器中的refcount在增加，说明不是垃圾
    * 如果发现一个zval容器中的refcount在减少，如果减到了0，直接当做垃圾回收
    * 如果发现一个zval容器中的refcount在减少，并没有减到0，PHP会把该值放到缓冲区，当做有可能是垃圾的怀疑对象
        * 可能是，不一定是
        * 这些会放到缓冲区中
    * 当缓冲区达到临界值，PHP会自动调用一个方法取遍历每一个值，如果发现是垃圾就清理
        * 深度优先遍历，所有减1并记住自己是否已减以防重复。
        * 再次深度遍历，如果为0则垃圾，否则加1（非垃圾还原操作）
    
PHP的[内存管理](http://www.laruence.com/2011/11/09/2277.html), 分为俩大部分:
    * 第一部分是PHP自身的内存管理, 这部分主要的内容就是引用计数, 写时复制, 等等面向应用的层面的管理. 
    * 而第二部分是 zend_alloc中描写的关于PHP自身的内存管理, 包括它是如何管理可用内存, 如何分配内存等.
        * Zend Memory Manager, 以下简称Zend MM, 是PHP中内存管理的逻辑. 其中有一个关键数据结构: zend_mm_heapZend MM把内存分为小块内存和大块内存俩种, 区别对待, 对于小块内存, 这部分是最最常用的, 所以追求高性能. 而对于大块内存, 则追求的是稳妥, 尽量避免内存浪费.

## 数组内存管理
注意：Hashtable只能扩容不会减少, 当删除所有元素后内存释放。但是符号表不会释放缩小。

* 首先明确一点：
![](/assets/未命dsa.png)
开始时不申请内存，当第一次使用才初始化申请内存，大小不指定就是8
* 源码
```c
// 大小
#define HT_SIZE_EX(nTableSize, nTableMask) (HT_DATA_SIZE((nTableSize)) + HT_HASH_SIZE((nTableMask)))
((size_t)(nTableSize) * sizeof(Bucket)) + (((size_t)(uint32_t)-(int32_t)(nTableMask)) * sizeof(uint32_t))
// 即 4 * 8 + 32 * 8， 4 * 8代表arHash，32 * 8 代表arData
ptr = pemalloc(4 * 8 + 32 * 8); // 总的地址空间
// bucket数组地址设置
(ht)->arData = (Bucket*)(((char*)(ptr)) + HT_HASH_SIZE((ht)->nTableMask));
// 因此ptr是所有空间地址，arData指向bucket数组地址
// 以后访问arHash都是通过((uint32_t*)(arData))[(int32_t)(idx)]。一般idx都是负数，而且arData转化为uint32_t，就往arHas取值了。
```
* arHash里面的值保存arData的下标，判断arData[idx]的key是否和指定同，不同则冲突下一个：arData[idx]的val.u2.next中保存冲突链中下一个元素在arData下标。
* 对key，经过hash计算后64B，太长不适合作下标，我们和mask作位运算得到基于数组大小的一个值，就是arHash的下标，那么arHash保存的就是arData下标。
    * 插入时：发现已经有元素怎么办？即冲突了----**头插法**
    * 当前元素放到arData中记住下标，然后当前arHash值保存在arData->val.u2.next中，arHash保存新插入arData的下标。这样新插入的元素就放到了冲突链的头部。
    * 删除时，简单保证不断链即可，自身标记is_undef
    * 如果就自己一个，直接标记；
    * 如果冲突连上，肯定从第一个开始遍历，那么就知道上一个了
* 空间不够时：
    * 先使用is_undef（删除一个元素时：其实并不删除而是作一个UNDEF的标记）
    * 如果没有UNDEF空间，那么翻倍；
    * 扩展后会rehash


 [return](README.md) 