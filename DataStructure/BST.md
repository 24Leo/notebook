### 二叉排序树(BST)/二叉查找树：
```C
左孩子节点值比父节点小，而右孩子值比父大；每一个子节点都是一颗树。
查找算法：比当前小就进入左字树查找，大就进入右字树查找。
插入算法：比当前小就进入左字树插入，大就进入右字树插入。
typedef struct TreeNode
{
    int val;
    TreeNode *left,*right;
    TreeNode(){};
    TreeNode(int x):val(x),left(NULL),right(NULL){}
}TNode;
void insert(TNode *head,TNode *node)
{
    if(node->val>head->val)
    {
        if(head->right==NULL)
            head->right=node;
        else
            insert(head->right,node);
    }
    else
    {
        if(head->left==NULL)
            head->left=node;
        else
            insert(head->left,node);
    }
}
TreeNode *search(TNode *root, int v)
{
    if(root->val>v)
        return search(root->left,v)
    else if(root->val<v)
    {
        return search(root->child,v)
    }
    else if(root==v)
        return p;
    else
        return false;
}
TreeNode *create(int n)
{
    TNode *HT = new TreeNode(50);
    for(int i=0;i<n;++i)
    {
        TNode *NewNode = new TreeNode();
        NewNode->val = rand()%100;
        insert(HT,NewNode);
    }
    return HT;
}
```
删除时操作：
```
    删除节点类型：
    1)叶节点：直接删除，无影响
    2)只有一个子树：直接填上来
    3)有两个子树：
        I.在右子树中选最小的拿上来填，然后调整
        II.或在左子树中取最大的那个填，然后调整

```
![](IMG_20160116_105530.jpg)

### 平衡二叉树(AVL)：
保证每一个节点左右子树高度相差不超过1
```C
    int height(TreeNode *root)
    {
        if(!root)
            return 0;
        return height(root->left)>height(root->right)?height(root->left)+1:height(root->right)+1;
    }
    bool isBalanced(TreeNode* root) {
        if(!root)
            return true;
        int l = height(root->left);
        int r = height(root->right);
        return abs(l-r)<=1&&isBalanced(root->left)&&isBalanced(root->right);
    }
```
什么是A，就是那个**最先打破1**的节点（从下向上最先）<br>
* 
A的左子树B的左子树上添加一个(LL)：把B向左上方提成为根节点，A为其右子树，B的右子树成为A的左子树
* 
A的右子树B的右子树上添加一个(RR)：把B向右上方提成为根节点，A为其左子树，B的左子树成为A的右子树
    * 
上述两种都是**A的儿子B作为根节点**
* 
A的左子树B的右子树C上添加一个节点(LR)：把C向左上方提放到B处，然后再向右上方提放到A处。
* 
A的右子树B的左子树C上添加一个节点(RL)：把C向右上方提放到B处，然后再向左上方提放到A处。
    * 
上述两种都是**A的孙子C作为根节点**<br>

==========》什么是A，就是那个**最先打破1**的节点（从下网上最先）<br>
**要么B(提一次)要么C(提两次)成为根节点！！！**
```
```
![](IMG_20160116_105600.jpg)
![](IMG_20160116_105618.jpg)

[返回目录](README.md)