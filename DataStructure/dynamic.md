#[动态规划](http://www.zhihu.com/question/23995189)
动态规划算法通常基于一个递推公式及一个或多个初始状态。 当前子问题的解将由上一次子问题的解推出。

分治算法是将问题划分成相对独立的子问题，递归的解决所有子问题，

动态规划是对于 某一类问题 的解决方法！！重点在于如何鉴定“某一类问题”是动态规划可解的而不是纠结解决方法是递归还是递推！

1.动态规划通常情况下应用于最优化问题，这类问题一般有很多个可行的解，每个解有一个值，而我们希望从中找到最优的答案。

2.该问题必须符合无后效性。即当前状态是历史的完全总结，过程的演变不再受此前各种状态及决策的影响。

一个问题是该用递推、贪心、搜索还是动态规划，完全是由这个问题本身阶段间状态的转移方式决定的！
但是贪心、动态规划是算法，而递推、分治是解决方式或者技巧
* 
每个阶段只有一个状态->递推；
* 
每个阶段的最优状态都是由上一个阶段的最优状态得到的->[贪心](http://blog.csdn.net/yelbosh/article/details/7649717)；
* 
把原问题拆分为多个子问题，然后递归地解决子问题-->分治
* 
每个阶段的最优状态是由之前所有阶段的状态的组合得到的->搜索；
* 
每个阶段的最优状态可以从之前某个阶段的某个或某些状态直接得到而不管之前这个状态是如何得到的->动态规划
    * 
一步一个脚印！

=====》动态规划是通过拆分问题，定义问题状态和状态之间的关系，使得问题能够以递推（或者说分治）的方式去解决。



自己理解：

贪心：每次选择能让当前状态距离问题最近的解，然后在次基础上继续！所以每次选择的不一定是最优解，但一定是跨步最大的（贪心嘛）。

动态规划：把问题分为子问题，找到状态转移方程。每一步都是为了最终最优解前进。每解决一步，就以当前为起点继续。不断把状态转移给下一个，直至最终达到最优。

###拿糖果问题
```C++
***
     * 用动态规划方法计算：
     * 用一个数组result[i][j]保存每一个点i,j的最大收益
     *              num[i][j],                                    i=j=0
     * result[i][j]=result[i][j-1]+num[i][j],                     i=0,j!=0
     *              result[i-1][j]+num[i][j],                     j=0,i!=0
     *              Max(result[i-1][j],result[i][j-1])+num[i][j], i!=0,j!=0
     * 
     * @param num 非空数组num
     * @return 
     */
    public static int[][] getMax(int[][] num){
        int m=num.length;
        if(m==0){//说明数组num为空
            return new int[0][0];
        }
        int n=num[0].length;
        int[][] result=new int[m][n];
        for(int jj=0;jj<n;jj++){
            for(int ii=0;ii<m;ii++){
            
//================================================================
    //初始化信息
                if(ii==0 && jj==0){
                    result[ii][jj]=num[ii][jj];
                    continue;
                }
                if(jj==0){
                    result[ii][jj]=result[ii-1][jj]+num[ii][jj];
                    continue;
                }
                if(ii==0){
                    result[ii][jj]=result[ii][jj-1]+num[ii][jj];
                    continue;
                }
//================================================================
    //左侧和上侧求自己的。
                int maxIJ=Math.max(result[ii][jj-1],result[ii-1][jj]);
                result[ii][jj]=maxIJ+num[ii][jj];
            }
        }
        return result;
    }
*****************************************************************
    int getMost(vector<vector<int> > board) {
    // write code here
    int i,j,sum;
    i = j = sum = 0;
    vector<vector<int> > res(board);
    res[0][0] = board[0][0];
    
    int ind = 0;
    while(++ind < 6)
        res[0][ind] = res[0][ind - 1] + board[0][ind];
    
    ind = 0;
    while(++ind < 6)
        res[ind][0] = res[ind - 1][0] + board[ind][0];
    
    for(int i = 1;i < 6; ++i)
        for(int j = 1; j < 6;++j)
        {
            if(res[i-1][j] > res[i][j-1])
                res[i][j] = res[i-1][j] + board[i][j];
            else
                res[i][j] = res[i][j - 1] + board[i][j];
        }

    return res[5][5];
}
```

[返回目录](README.md)