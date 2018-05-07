#线性结构
1、特点：（非空有限集合）
* 
存在唯一一个被称作“第一个”的元素
* 
存在唯一一个被称作“最后一个”的元素* 
* 
除第一个元素外，其他没一个元素都有唯一一个前驱
* 
除最后一个元素外，其他每一个元素都有唯一一个后继

2、线性表：　n个数据元素的有限序列，其长度为n。
* 
顺序表示和实现：逻辑上相连的两个元素物理位置也是相连
```C
优点：随机存取
缺点：插入和删除要移动大量元素
　
#define LIST_INIT_SIZE 100       //初始空间分配个数
#define LISTINCREMENT 10         //分配增量
typedef struct{
    ElemType *elem;              //存储空间基址
    int      length;             //当前长度
    int      listsize;           //当前分配的容量。sizeof(ElemType)
}SqList;
```
* 
链式表示和实现：逻辑上相连物理位置不一定相连
```C
一般情况下，我们在第一节点前加一个称作头节点的节点。但是不管有无头节点，头指针永远指向第一个节点。
　
优点：插入和删除时不需要大量移动元素
缺点：无随机存取
　
分类：
1、单链表：   “向后”链接
typedef struct LNode{
    ElemType        data;
    struct LNode    *next;
}LNode,*LinkList
　　　　
2、循环链表：   “向后”链接,但是是一个环，没有第一个或最后一个节点，用头指针定位。
　　　　
3、双向链表：   ”向前向后“链表，即每一个节点都有各自的前驱和后继
typedef struct DuLNode{
    ElemType            data;
    struct DuLNode      *prior;
    struct DuLNode      *next;
}DuLNode, *DLinkList;
　　　　
4、双向循环链表
　　　　
5、静态链表：
#define MAXSIZE 100     //最大长度
typedef struct{
    ElemType     data;
    int          cur;
}SLinkList[MAXSIZE];
```
1. 
两个特殊：  栈、队列
```C
    栈：只能在尾部添加和删除操作的线性表。表尾称作栈顶，表头称作栈底。----->先入后出(LIFO)
        头指针不变，插入时尾指针加1,删除时尾指针减1。(插入时先分配后写值，删除先除值后回收)
　　typedef struct{
　　    SElemType       *base;          //栈底指针
　　    SElemType       *top;           //栈顶指针
　　    int             stacksize;      //最大可用容量
　　}SqStack;
　　base：始终指向栈底的位置，为NULL表示栈不存在
　　top:  始终指向栈顶元素的下一个位置上，top==base 栈为空。插入加1,删除减1.
　      以上均是顺序栈的特性，链式栈也可以有。
　  　　　　
　队列：一端插入，一端删除的线性表。队头用来删除，对尾用来插入。------>先入先出(FIFO)
　      插入时尾指针加1,删除时头指针减1。头尾相遇时可能空亦可能满！
　  顺序队列：
　      #define MAXSIZE 100         //最大长度
　      typedef struct {
　          QElemType    *base;     //初始化时的起址
　          int          front;     //头指针
　          int          rear;      //尾指针
　      }SqQueue;
　  链式队列：
　      typedef struct QNode{
　          QElemType       data;
　          struct QNode    *next;
　      }QNode,*QueueOtr;
　      typedef struct {
　          QueuePtr front;
　          QueuePtr rear;
　      }LinkQueue;
　      ```
　   
　
3、串：由零个或者多个字符组成的有限序列。
```C
顺序表示：typedef unsigned char SString[size]    //一般s[0]记录串长度
模式匹配算法：子串T在主串S中，pos位置后的下标
    int index(SString S,SString T,int pos){
        int i = pos, j = 1;
        while(i<=S[0]&&j<=T[0]){
            if(S[i]==T[j]){
                ++i;
                ++j;
            }else{
                j = 1;
                i = i-j+2;
            }
            if(j>T[0])
                return i-T[0];
            else
                return 0;
        }
    }
从上可以看出，每一次匹配不成功，主串都会重新回溯加2(i=i-j+2)再次匹配 O(n*m)
改进KMP：
    每次出现不匹配时，指示主串的指针不回溯，而是将已得到的“部分匹配”结果向右滑动尽可能远的距离。
对比：虽然普通匹配O(n*m)，但实际趋向O(n+m)。KMP算法只有子串在主串中存在多个相似匹配才会快得多。
```
4、数组
```C
typedef struct Array{
    ElemType *base;     //数组基址
    int dim;            //数组维数
    int *bounds;        //数组维界基址
    int *constants;     //数组常量基址,malloc()分配的地址
}```
5、广义表：lists

6、单链表环：<br>
两个指针，一个每次加1,一个加2,如果相遇，则有环，否则会到终点即无环！<br>
**性质：**
* 
相遇点向前走到交叉点的距离等于起点到交叉点的距离！
* 
两个指针继续走，下一次遇到时快的正好一共比慢的多走一圈，即多一个环长。

[返回目录](README.md)