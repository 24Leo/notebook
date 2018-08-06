#变量
变量划分为两类：标量类型和复杂类型。
	* 标量类型包括布尔型、整型、浮点型和字符串；
	* 复杂类型包括数组、对象和资源；
	* 还有一个NULL比较特殊，它不划分为任何类型，而是单独成为一类。

在PHP内部
	* 布尔型、整型及资源（只要存储资源的标识符即可）都是通过lval字段存储的；
	* dval用于存储浮点型；
	* str存储字符串；
	* ht存储数组（注意PHP中的数组其实是哈希表）；
	* 而obj存储对象类型；
	* 如果所有字段全部置为0或NULL则表示PHP中的NULL；
	* 这样就达到了用5个字段存储8种类型的值。

####例子0、null、false、‘’
	* 复制代码
```php
<?php
    $str1 = null;
    $str2 = false;
    echo $str1==$str2 ? ‘相等’ : ‘不相等’;
    $str3 = "";
    $str4 = 0;
    echo $str3==$str4 ? ‘相等’ : ‘不相等’;
    $str5 = 0;
    $str6 = '0';
    echo $str5===$str6 ? ‘相等’ : ‘不相等’;
    $str7=0;
    $str=false;
    echo $str7==$str8 ? ‘相等’ : ‘不相等’;
?>
运行结果：
//相等，相等，不相等,相等。
```
	* 原因是在PHP中变量是以C语言的结构体来存储的，空字符串和NULL,false都是以值为0存储的，其中这个结构体有个zend_uchar type;这样的成员变量，他是用来保存变量的类型的，而空字符串的类型是string，NULL的类型是NULL,false是boolean。
	* 这一点可以用echo gettype('');和echo gettype(NULL);来打印看看！而===运算符是不单比较值，还有比较类型的，所以第三个为false！

###PHP5 变量
```c
//数据类型
#define IS_NULL     0      /* Doesn't use value */
#define IS_LONG     1      /* Uses lval */
#define IS_DOUBLE   2      /* Uses dval */
#define IS_BOOL     3      /* Uses lval with values 0 and 1 */
#define IS_ARRAY    4      /* Uses ht */
#define IS_OBJECT   5      /* Uses obj */
#define IS_STRING   6      /* Uses str */
#define IS_RESOURCE 7      /* Uses lval, which is the resource ID */
/* Special types used for late-binding of constants */
#define IS_CONSTANT 8
#define IS_CONSTANT_AST 9
typedef union _zvalue_value {
    long lval;                 // For booleans, integers and resources
    double dval;               // For floating point numbers
    struct {                   // For strings
        char *val;
        int len;
    } str;
    HashTable *ht;             // For arrays
    zend_object_value obj;     // For objects
    zend_ast *ast;             // For constant expressions
} zvalue_value;
typedef struct _zval_struct {
    zvalue_value value;
    zend_uint refcount__gc;
    zend_uchar type;
    zend_uchar is_ref__gc;
} zval;
// 大小：value16B，按照8B对齐。zval大小24Btype
// 为了解决循环引用引入垃圾回收，zval嵌入到gc结构体里面
typedef struct _zval_gc_info {
    zval z;
    union {
        gc_root_buffer       *buffered;
        struct _zval_gc_info *next;
    } u;
} zval_gc_info;
// 大小32B，另外PHP5需要从堆上申请内存，所以需要头结构HEAD 16B，因此整个zval应该大小48B。
```
###php5 引用
一旦发生变化，才会强制分离。同时引用和非引用不可能共享一个变量。
* 普通赋值
	```c
$a = 42;   // $a         -> zval_1(type=IS_LONG, value=42, refcount=1)
$b = $a;   // $a, $b     -> zval_1(type=IS_LONG, value=42, refcount=2)
$c = $b;   // $a, $b, $c -> zval_1(type=IS_LONG, value=42, refcount=3)
// The following line causes a zval separation
$a += 1;   // $b, $c -> zval_1(type=IS_LONG, value=42, refcount=2)
           // $a     -> zval_2(type=IS_LONG, value=43, refcount=1)
           // 因为a变了，所以新分配一个zval2给a
unset($b); // $c -> zval_1(type=IS_LONG, value=42, refcount=1)
           // $a -> zval_2(type=IS_LONG, value=43, refcount=1)
unset($c); // zval_1 is destroyed, because refcount=0
           // $a -> zval_2(type=IS_LONG, value=43, refcount=1)
	```
* 引用
	```c
$a = [];  // $a         -> zval_1(type=IS_ARRAY, refcount=1, is_ref=0) -> HashTable_1(value=[])
$b = $a;  // $a, $b     -> zval_1(type=IS_ARRAY, refcount=2, is_ref=0) -> HashTable_1(value=[])
$c = $b   // $a, $b, $c -> zval_1(type=IS_ARRAY, refcount=3, is_ref=0) -> HashTable_1(value=[])
$d =& $c; // $a, $b -> zval_1(type=IS_ARRAY, refcount=2, is_ref=0) -> HashTable_1(value=[])
          // $c, $d -> zval_2(type=IS_ARRAY, refcount=2, is_ref=1) -> HashTable_2(value=[])
          // $d is a reference of $c, but *not* of $a and $b, so the zval needs to be copied
          // here. Now we have the same zval once with is_ref=0 and once with is_ref=1.
$d[] = 1; // $a, $b -> zval_1(type=IS_ARRAY, refcount=2, is_ref=0) -> HashTable_1(value=[])
          // $c, $d -> zval_2(type=IS_ARRAY, refcount=2, is_ref=1) -> HashTable_2(value=[1])
          // Because there are two separate zvals $d[] = 1 does not modify $a and $b.
// =========扩展======
$arr = range(1,100000);
$ttt = &$arr;
var_dump(count($arr));
// $arr由于是引用，发生强制分离，count又是一个一个的，所以很慢
	```
* 强制分离：
	* 非引用和引用
	* 非引用间某个、某些变化
	* 

###php5 数组
```c
typedef struct bucket {
    ulong h;
    uint nKeyLength;
    void *pData;
    void *pDataPtr;
    struct bucket *pListNext;
    struct bucket *pListLast;
    struct bucket *pNext;
    struct bucket *pLast;
    const char *arKey;
} Bucket;
// 72B
typedef struct _hashtable {
    uint nTableSize;
    uint nTableMask; //哈希表的容量减一。这个mask用来根据当前的表大小调整生成的哈希值
    uint nNumOfElements;
    ulong nNextFreeElement;
    Bucket *pInternalPointer;   //数组当前位置
    Bucket *pListHead;
    Bucket *pListTail;
    Bucket **arBuckets;
    dtor_func_t pDestructor;
    zend_bool persistent;
    unsigned char nApplyCount;
    zend_bool bApplyProtection;
     #if ZEND_DEBUG
        int inconsistent;
     #endif
} HashTable;
// 
```
###问题
    * zval每次都需要从堆上申请、释放，堆HEAD，申请和释放也需要时间，空间时间不好～
    * Bucket同上
    * 额外双向链表，每个bucket里面都有一个指针指向zval，另外额外4个指针保存插入顺序、索引顺序
    * 过多的间接访问（indirect），需要指针访问
    * 不管需不需要引用，都有引用计数，而且保存在zval中，故而字符串无法和数组key共享
    * 而且zval没有预留字段，都要hack劫持新建，比如gc信息
    
###PHP7 
* zval不在单独分配，也不维护引用计数，也不用指针指向该值（直接保存在数组、字符串等中）。
	* In PHP 7, zvals are not heap allocated and no longer store a refcount.
* 数组、字符串等自身保存引用计数，都有一个头：zend_refcounted_h
* 更少的间接访问：减少通过指针访问。（PHP7大多保存zval而不是指向zval的指针）
* 引用保存在数据结构，引用是一种“类型”

```c
/* regular data types */
#define IS_UNDEF					0
#define IS_NULL						1
#define IS_FALSE					2
#define IS_TRUE						3
#define IS_LONG						4
#define IS_DOUBLE					5
#define IS_STRING					6
#define IS_ARRAY					7
#define IS_OBJECT					8
#define IS_RESOURCE					9
#define IS_REFERENCE				       10
// bool 修改为了 false true
/* constant expressions */
#define IS_CONSTANT_AST				       11
/* internal types */
#define IS_INDIRECT             	               13
#define IS_PTR						14
#define _IS_ERROR					15
/* fake types used only for type hinting (Z_TYPE(zv) can not use them) */
#define _IS_BOOL					16
#define IS_CALLABLE					17
#define IS_ITERABLE					18
#define IS_VOID						19
#define _IS_NUMBER					20
// ==================================
typedef union _zend_value {
		zend_long         lval;				/* long value */
		double            dval;				/* double value */
		zend_refcounted  *counted;
		zend_string      *str;
		zend_array       *arr;
		zend_object      *obj;
		zend_resource    *res;
		zend_reference   *ref;
		zend_ast_ref     *ast;
		zval             *zv;
		void             *ptr;
		zend_class_entry *ce;
		zend_function    *func;
		struct {
			uint32_t w1;
			uint32_t w2;
		} ww;
} zend_value;
struct _zval_struct {
		zend_value value;
		union {
			struct {
				ZEND_ENDIAN_LOHI_4(
					zend_uchar type,
					zend_uchar type_flags,
					zend_uchar const_flags,
					zend_uchar reserved)
			} v;
			uint32_t type_info;
		} u1;
		union {
			uint32_t var_flags;
			uint32_t next;       /* hash collision chain */
			uint32_t cache_slot; /* literal cache slot */
			uint32_t lineno;     /* line number (for ast nodes) */
		} u2;
};
typedef struct _Bucket {
		zend_ulong        h;
		zend_string      *key;   // key可以和别的引用共享
		zval              val;
} Bucket;
typedef struct _HashTable {
		uint32_t          nTableSize;
		uint32_t          nTableMask;
		uint32_t          nNumUsed;
		uint32_t          nNumOfElements;
		zend_long         nNextFreeElement;
		Bucket           *arData;   // 保存插入顺序
		//uint32_t         *arHash;
		dtor_func_t       pDestructor;
		uint32_t          nInternalPointer;
		union {
			struct {
				ZEND_ENDIAN_LOHI_3(
					zend_uchar    flags,
					zend_uchar    nApplyCount,
					uint16_t      reserve)
			} v;
			uint32_t flags;
		} u;
} HashTable;
// 56B
// 介绍
typedef struct _zend_refcounted_h {
		uint32_t         refcount;			/* reference counter 32-bit */
		union {
			uint32_t type_info;
		} u;
} zend_refcounted_h;
struct _zend_refcounted {
		zend_refcounted_h gc;
};
struct _zend_string {
		zend_refcounted_h gc;
		zend_ulong        h;                /* hash value */
		size_t            len;
		char              val[1];			// 字符串起始地址
};
struct _zend_reference {
		zend_refcounted_h gc;
		zval              val;
};
```
* 如果就是普通整形索引数组，那么arrHash是null。不需要碰撞链。
* 而且链表结构并没像传统链表一样在在内存中分散存储。我们直接读取 arData整个数组，而不是通过堆（heap）获取内存地址分散的指针。这是 PHP7 性能提升的一个重要点。数据局部性让 CPU 不必经常访问缓慢的主存储，而是直接从 CPU 的 L1 缓存中读取到所有的数据。

###php7 [引用](https://github.com/laruence/php7-internal/blob/master/reference.md)
```c
$a = [];  // $a         -> zend_array_1(refcount=1, value=[])
$b = $a;  // $a, $b,    -> zend_array_1(refcount=2, value=[])
$c = $b   // $a, $b, $c -> zend_array_1(refcount=3, value=[])
$d =& $c; // $a, $b                                 -> zend_array_1(refcount=3, value=[])
          // $c, $d -> zend_reference_1(refcount=2) ---^
          // Note that all variables share the same zend_array, even though some are PHP references and some aren't.
          // array refcount still 3，because three zend_zval structure point to it
$d[] = 1; // $a, $b                                 -> zend_array_1(refcount=2, value=[])
          // $c, $d -> zend_reference_1(refcount=2) -> zend_array_2(refcount=1, value=[1])
          // Only at this point, once an assignment occurs, the zend_array is duplicated.
```
* 从PHP7开始, 对于在zval的value字段中能保存下的值, 就不再对他们进行引用计数了, 而是在拷贝的时候直接赋值, 这样就省掉了大量的引用计数相关的操作：LONG、DOUBLE
* 另外对于仅有标志而没有值的也不需要引用：null、true、false
* 所有的复杂类型的定义, 开始的部分都是**zend_refcounted_h**结构, 这个结构里除了引用计数以外, 还有GC相关的结构. 从而在做GC回收的时候, GC不需要关心具体类型是什么, 所有的它都可以当做zend_refcounted*结构来处理.

###对比
* [foreach不同](https://codeday.me/bug/20170304/416.html)

```c
$arr = array('a','b','c');
print_r(current($arr));
foreach ($arr as $k => $v) {
	$arr[$k] = $v;
}
print_r(current($arr));
return ;
/* 
* php5 输出：a b
* php7 输出：a a
*/
```
* 常量或者不需要引用计数的地方：常量、常量数组、
	* php5：预先分配一段内存，然后保存；最后用指针地址来比较判断
		* 满足就不需要引用计数
	* php7：flags有标识位，标志是否是常量、是否可以引用等

#####思考
* php5 
	* foreach遍历时操作的不是arr数组，而是会对其拷贝一个副本，如果有值变化会发生会发生**强制分离**，然后arr和副本指向不同的结构体，最后再将副本值拷贝至arr中；
	* 整个过程伪代码：
```c
$arr = array('a','b','c');
print_r(current($arr)); 	// 直接输出current指向的值，内部是数组的pInternalPointer
foreach ($arr as $k => $v) {
		$arr[$k] = $v;
}		
// 循环需要详细介绍：
// 0、php5中foreach开始时，pInternalPointer自动指向第一个元素reset，$arrCopy = $arr;
// 1、foreach第一次循环时两个指向同一个内部结构，其引用计数值refcount=2
// 2、此时读值，读的是该共用结构体值 保存$k,$v，然后next，即pInternalPointer指向下一个了,实际上两个数组指向的还是同一个结构体，所以next也相同，
// 3、然后对arrCopy数组赋值，那么发生强制分离，接下来就是操作arrCopy数组了，同时arr数组不变了，直到最后整体赋值拷贝回来
print_r(current($arr));
return ;
```
	* foreach开始第一次循环之前拷贝数组重置pInternalPointer到第一个，接下来对副本操作，两个数组指向同一个结构体，然后读值进行next操作，指向下一个，读出来的值保存在k、v里面；
	* 此时开始赋值，那么会发生强制分离，产生一个新的结构体，赋值以及后面的操作都是在新结构体上，所以arr数组的pInternalPointer不变了；
	* 最后把副本整体拷贝回来即可然后副本销毁
	* 迭代器会向后走一个，当然如果不改变值，还共享的话，迭代器会一直走到最后，别忘记reset。
* php7
	* foreach不使用原数组指针pInternalPointer，也就不会该变
	* 值遍历时：foreach 总是在对数组副本进行操作(不共享，**开始即分离**)，在迭代中任何对数组的操作都不会影响到迭代行为
	* 引用遍历：对数组的修改将继续会影响到迭代



[返回目录](README.md)