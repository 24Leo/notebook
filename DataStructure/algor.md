##1、递归算法
[递归总结](https://juejin.im/post/5cd241e9f265da03a436e735)
递归递归就是“递”和“归”的结合：
* 
递：不断传递，即划分子问题
* 
归：每个子问题找到结束的条件；或者继续处理

####1.1 模型
```C++
ret-type func(para)
{
    //做一些处理
    if(end_contion)
        return something;
    else
    {
        归纳处理普通条件即不结束的条件
            如果结束了，直接return
        子问题
        调用自身/此处也可能直接返回调用结果
    }
    return something;
}
```
####1.2 例子
```C++
例如：返回一个二叉树的深度：
int depth(Tree t){ 
    if(!t) 
        return 0; 
    else { 
             int a=depth(t.right); 
             int b=depth(t.left); 
             return (a>b)?(a+1):(b+1); 
        } 
}

判断一个二叉树是否平衡：
int isB(Tree t){ 
    if(!t) return 0; 
    int left=isB(t.left); 
    int right=isB(t.right); 
    if( left >=0 && right >=0 && left - right <= 1 || left -right >=-1) 
         return (left<right)? (right +1) : (left + 1); 
    else return -1; 
}
```
##2、动态规划
将待求解的问题分解成若干个相互联系的子问题，先求解子问题，然后从这些子问题的解得到原问题的解；对于重复出现的子问题，只在第一次遇到的时候对它进行求解，并把答案保存起来，让以后再次遇到时直接引用答案，不必重新求解。
####2.1 设计动态规划法的步骤：
* 
找出最优解的性质，并刻画其结构特征；
* 
递归地定义最优值（写出动态规划方程）；
* 
以自底向上的方式计算出最优值；
* 
根据计算最优值时得到的信息，构造一个最优解。
* 
步骤1-3是动态规划算法的基本步骤。在只需要求出最优值的情形，步骤4可以省略，步骤3中记录的信息也较少；若需要求出问题的一个最优解，则必须执行步骤4，步骤3中记录的信息必须足够多以便构造最优解。
* 
动态规划的难点在于写出**递推式**即**状态转移方程**。

###3.蓄水池抽样
如何从未知或者很大样本空间随机地取k个数？
* 
如果知道总数，那么直接rand()即可
* 
但是不知道总数：========》蓄水池抽样
    * 
先把前K个放入蓄水池中
    * 
对于K+1到N个：每个求对应的概率rand(1,k+i);
    * 
如果对应的概率小于K（说明该数应该被选中），那么替换
    * 
代码：
```C++ 
initiative size：k
for i = k+1 to N:
            p = rand(1,i)
            if(p < k):  
                swap(pth,i)
            endif
            continue
endfor
```

[返回目录](README.md)