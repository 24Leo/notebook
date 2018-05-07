## Huffman树
**构造：**<br>
　　　1)在所有节点中选两个最小权值的节点来构建一个新的节点。这两个节点为新节点的左右子树。<br>
　　　2)然后删除这两个节点并把新节点加入到节点集中；<br>
　　　3)重复1)和2)过程，直至节点集没有节点了<br>
===============================<br>
　　　首先权值小的一定深度大。<br>
　　　整个过程共新建N-1个节点。该树2N-1个节点<br>
　　　整个Huffman树不存在度为1的节点（0/2）<br>
**代码实现：**
```C++
struct HTNode
{
    char c;
    unsigned int weight;
    HTNode *parent,*lchild,*rchild;
    HTNode():c(' '),weight(0),parent(NULL),lchild(NULL),rchild(NULL){};
};
HTNode *minum(HTNode **head)
{
    HTNode *pre = *head,*temp=*head,*child=*head,*node = *head;
    while(pre)
    {
        if(node->weight>pre->weight)
        {
            node = pre;
            child = temp;
        }
        temp = pre;
        pre = pre->parent;
    }
    if(node==*head)
        *head = (*head)->parent;
    else
        child->parent = node->parent;
    return node;    
}
HTNode *HTCreate(const int *w, const char *s)
{
    int index=0;
    HTNode *head = new HTNode();
    head->c=s[index];
    head->weight=w[index];
    head->lchild=NULL;
    head->rchild=NULL;
    while(w[++index])
    {
        HTNode *pres = new HTNode();
        pres->c=s[index];
        pres->weight=w[index];
        pres->lchild=NULL;
        pres->rchild=NULL;
        pres->parent = head;
        head = pres;
    }                                       //构造节点
    HTNode *m1 = new HTNode();
    HTNode *m2 = new HTNode();
    while(head->parent)
    {
        HTNode *newnode = new HTNode();
        m1=minum(&head);
        m2=minum(&head);
        newnode->weight=m1->weight+m2->weight;
        newnode->c='-';
        newnode->lchild=m1;
        newnode->rchild=m2;
        newnode->parent = head;
        head=newnode;
        m1->parent = newnode;
        m2->parent = newnode;
    }                                   //选两个最小的拿出来，建一个新的插入进去
    return head;
}
注：
    1、当把指针当成参数传过去后，可以通过解引用修改指向对象的值，但是你给指针直接赋值是无用的。
        因为直接赋值，此时指针相当于普通参数了。你给普通参数赋值，等函数返回时还有作用吗？
    2、一些特殊情况：
        第一个就是最小的，怎么办？
        什么时候不再循环？
```

[返回目录](README.md)