##图：
### 基本概念：
```C
完全图：n*(n-1)/2条边   n*(n-1)条弧
连通图：无向图中任意两个顶点都有路径
强连通图：有向图中任意两个顶点都存在路径
连通分量：无向图中的极大连通子图（可能有多个）
强连通分量：有向图中的极大连通子图（可能有多个）
生成树：极小连通子图，含有图中全部顶点，但只有足以构成一棵树的n-1条边，加一个边就有环（某个连通分量的）
    生成树分广度优先生成树和深度优先生成树两种(遍历顺序不同)
```
###1.实现：数组、邻接表、十字链表、邻接多重表
####1.1 数组实现
数组记录顶点，然后用邻接矩阵记录边的信息
####1.2 邻接表实现
```C
图的链式存储形式，对每个顶点都建立一个单链表。
表头节点：
    firstarc：指向第一个与该节点邻接的弧
    data: 必要的信息
内部节点：
    adjvex：连接的顶点
    nextarc：下一个与该头节点邻接的弧
    info：信息
然后这些单链表的表头节点按顺序存放，以便随即访问。
逆邻接表：即对每个对点建立一个以该顶点为头的弧的表
```
####1.3 十字链表实现
有向图的另一种链式存储方式
####1.4 邻接多重表实现
无向图的另一种链式存储方式

###2.遍历：对所有顶点扫描一次，故有一个辅助数组记录是否已访问
####2.1 BFS：广度优先搜索
类似于树的层次遍历

**思想：**
```
初始时，所有顶点未访问。
BFS选择一个顶点开始，然后以该顶点起始进行层次遍历；
然后从这些邻接点出发继续层次访问他们的邻接点；
直至所以节点都被访问到。
```
**实现：**
```C
层次遍历需要queue
bool visited[num_of_vex]
void BFS_Traverse(Graph g,int v)
{
    for(v=0;v<num_of_vex;++v)   visited[v] = false;
    initqueue(q);
    for(v=0;v<num_of_vex;++v)   
    {
        if(visited[v] == false)
        {
            visited[v] = true;
            enqueue(q,v);
            while(!empty(q))
            {
                dequeue(q,u);
                for(w = firstadjvex(g,u);w>=0; w = nextadjvex(g,u,w))
                {
                    if(visited[w] == false)
                    {
                        visited[w] = true;
                        enqueue(w);
                    }
                }
            }
        }
    }   //以防还有未访问到的节点
}       

```
**总结：**
```C
数组实现：  O（n*n）    n代表顶点数
邻接表实现：O（n+e）    n代表顶点数，e代表边/弧数
```
####2.2 DFS：深度优先搜索
类似于树的先根遍历

**思想：**
```
初始时，所有顶点未访问。
DFS选择一个顶点开始访问，然后从该顶点进行深度遍历直至访问所有的顶点或者遇到已访问的节点；
若此时还有未访问的节点，则以该节点开始继续；
直至所以节点都被访问到。
```
**实现：**
```C
bool visited[num_of_vex]
void DFS_Traverse(Graph g,int v)
{
    for(v=0;v<num_of_vex;++v)   visited[v] = false;
    for(v=0;v<num_of_vex;++v)   
    {
        if(visited[v] == false)
            DFS(g,v);
    }   //以防还有未访问到的节点
}       
void DFS(Graph g,int v)
{
    visited[v] = true;
    for(w = firstadjvex(g,v);w>=0;w = nextadjvex(g,v,w))
        if(visited[v] == false) 
            DFS(g,w);
}   //深度遍历以该顶点为起始的路径
```
**总结：**
```C
数组实现：  O（n*n）    n代表顶点数
邻接表实现：O（n+e）    n代表顶点数，e代表边/弧数
```
###2.3 搜索树
即根据上述算法的遍历过程生成的树，
##3.图的经典算法：
###3.1 连通性问题
连通图仅需从一个节点出发通过DFS或者BFS就可以访问所有的节点；而非连通图则需要从多个节点出发进行搜索
###3.2 最小生成树
MST性质：假设N={V,{E}}是一个连通网，U是顶点集V的非空子集。若u∈U，v∈V-U,且（u,v）是一条具有最小权值的边那么最小生成树一定包含该边。<br>
两个算法：普里姆(prim)和克鲁斯卡尔(kruskal)，均利用上述性质
####3.2.1 普里姆prim
####3.2.1.1 prim思想
假设N={V,{E}}是一个连通网：TE是最小生成树中边的集合，U是V的一个子集。<br>
初始状态：TE = {},U={u0},u0∈V,
<br>
重复下述操作：<br>
**对于所有的u∈U，v∈V-U,且（u,v）∈E，找到(u,v)是权值最小的边，边加入到TE 中，顶点v加入到U中。**
直至U=V为止。<br>
此时，T = {U,{TE}}即最小生成树
####3.2.1.2 prim实现
```C
void prim_code(MGraph G,VertexType u)
{
    vertex U,V;
    arc TE;
    U.insert(u);
    while(U!=V)
    {
        v = find_closest(G,U,V);
        U.insert(v);
        TE.insert(u,v)
    }
}
vertex find_closest(MGraph,vertex []U,vertex []V)   //返回最小边的另一个顶点
```
####3.2.1.3 prim分析
时间复杂度为：O（N*N），与边数无关。
<br>
所以适合求稠密图的最小生成树
####3.2.2 克鲁斯卡尔kruskal
####3.2.1.1 kruskal思想
假设N={V,{E}}是一个连通网<br>
最小生成树的初始状态：T = {V，{}},U=V,边集为空，图中每个顶点自成一个连通分量；
<br>
重复下述操作：**在所有边中，选择权值最小而且两个顶点在不同连通分量中的边，加入到T中，否则选择下一个权值最小的边**<br>
直至所有顶点都在一个连通分量中为止。<br>
此时，T = {U,{TE}}即最小生成树
####3.2.1.2 kruskal实现

####3.2.1.3 kruskal分析
时间复杂度：O（e*loge）， 与顶点数无关<br>
适合稀疏图
###3.3 拓扑排序与环：事件之间的先后关系
DGA：有向无环图
<br>
**环是否存在：**<br>
####3.3.1 无向图：
**法一**：深度遍历时只要不遇到回边即可，需要额外记录边的信息。边数<=顶点数-1；<br>
**法二**：首先把图中所有度小于等于1的顶点删除，同时删除所有相连的边并修改连接顶点的度，把所有度变成1的顶点加入队列中；对队列中每个顶点重复上一操作，如果最后还有未删除顶点则有环，否则没有<br>
####3.3.2 有向图：拓扑排序
####3.3.2.1 拓扑排序思想
在有向图中选一个没有前驱的顶点输出；<br>
从图中删除该顶点和所有以他为尾的弧；<br>
重复上述两步，如果无节点说明结束；否则说明有环；
####3.3.2.1 拓扑排序实现
保存顶点的入度
```C
求入度；
while(无顶点||无入度为0的顶点)
{
    找入度为0的顶点；
    删除该顶点和所有与其相关的弧；
}
判断是无顶点还是无入度为0的顶点，前者说明排序完成，后者说明有环；
bool topologicalSort(ALGraph G)
{
    int indegree[G.vertexnum];
    int count=0;
    initdegree(G,indegree); //求各个节点的入度
    initstack(s);
    for(int i = 0;i <G.vertexnum;++i)
        if(indegree[i]==0)
            s.push(i);      //入度为0的入栈
    while(!empty(s))
    {
        i = pop(s);
        ++count;    //节点数
        for(w = G.ver[i].firstarc;w;w=G.ver[i].nextarc) //每一个相连的弧
        {
            j = w->adj; //该弧连接顶点
            if(!(--indegree[i]))    
                s.push(j);
        }
    }
    if(count!=vertexnum)
        return false;
    return true;
}
```
####3.3.2.1 拓扑排序分析
时间复杂度：O（n+e）<br>
**顶点可以代表活动，弧代表先后关系========》作选择时先后关系**
###3.4 关键路径：
带权值的有向无环图：顶点代表事件，弧代表活动，权值代表花费；
####3.4.1 思想：开始到结束的路径
关键路径代表路径长度最长的路径，其上的活动都是关键活动<br>
活动最早开始时间E(i)和可以最晚开始时间L(i)，如果L(i)==E(i)，则活动i是关键活动，L(i)-E(i)代表活动i的可等待时间。<br>
重点：求得活动的最早开始时间E(i)和可以最晚开始时间L(i)，也就需要求得事件的最早开始时间VE(i)和可以最晚开始时间VL(i)，
####3.4.2 关键路径算法
* 
从原点出发，ve[0] = 0,按拓扑顺序求除了汇点外其他顶点的最早发生时间ve[i];如果有环则终止；
* 
从汇点出发，求除了汇点和原点之外所有顶点最晚开始时间VL[i]
* 
根据各节点的VE和VL值，求所有弧的E和L值，若相等则弧代表的活动为关键活动；

对拓扑排序算法进行扩增即可
####3.4.2.1 关键路径实现
```C
bool topologicalSort(ALGraph G,stack &T)
{
    int indegree[G.vertexnum]，ve[G.vertexnum]=0;
    int count=0;
    initdegree(G,indegree); //求各个节点的入度
    initstack(s);
    initstack(T);       //保存拓扑序列
    for(int i = 0;i <G.vertexnum;++i)
        if(indegree[i]==0)
            s.push(i);  //入度为0的入栈
    while(!empty(s))
    {
        i = pop(s);
        T.push(i);
        ++count;    //节点数
        for(w = G.ver[i].firstarc;w;w=G.ver[i].nextarc) //每一个相连的弧
        {
            j = w->adj; //连接顶点
            if(!(--indegree[i]))    
                s.push(j);      
            if(ve[i]+*(w->info)>ve[i])
                ve[k] = ve[i]+*(w->info);   //如果从当前活动结束开始较晚则更新
        }
    }
    if(count!=vertexnum)
        return false;
    return true;
}
bool criticalPath(ALGraph G)
{
    stack T;
    if(!topolocialSort(G,T)
        return false;
    vl[G.vertexnum] = ve;   //出度默认等于入度
    while(T.empty())
    {
        i = T.pop();        //从汇点开始求最晚时间
        for(p = G.ver[i].firstarc;p;p=G.ver[i].nextarc)
        {
            k = p->adj;
            dur = *(p->info);
            if(vl[k]-dur<vl[j])
                vl[j]=vl[k]-dur;    //最晚时间更新
        }
        for(j=0;j<G.vertexnum;++j)
        {
            for(p = G.ver[i].firstarc;p;p=G.ver[i].nextarc)
            {
                k = p->adj;
                dur = *(p->info);
                ee = ve[j];
                el = vl[k]-dur;
                tag = (ee==el)?'*':' ';
                printf(j,k,dur,ee,el,tag);
            }
        }
    }
}
```
####3.4.2.2 关键路径分析
时间复杂度：O（n+e）<br>
**顶点可以代表某件事，弧代表完成事件的具体活动，权值代表时间或者其他花费====》得到工程总时间和关键活动，可能多条**
###3.5 最短路径：
####3.5.1 从某个原点到其他顶点的最短路径：单源最短路,径Dijkstra迪杰斯特拉
* 
对该顶点建立一个辅助数组D，记录从该顶点s到其余各顶点的距离：初始值为两顶点间有弧则为权值，否则∞；<br>新建S代表已经得到的最短距离的顶点集合，初始为空；
* 
对V-S的顶点集合：从数组D中找到最小值的一个顶点u，即当前求得的一条从该顶点出发的最短路径的终点，加入S中
* 
更新V-S中其余的值：对于V-S中的其他顶点，如果**D[u] + arcs[s][u]<D[k],则更新D[k]=D[u] + arcs[s][u]**；即从开始顶点经过S中所有的顶点，上一步得到的u是最后一个，然后到达顶点V-S中顶点
* 
重复上述两步n-1次，即可求得到所有顶点的最短路径。

####3.5.2 单源最短路径实现
```C
void shortest_DIJ(MGraph G, int s,shortpathtable &d)
{
    for(v = 0;v<G.vexnum;+=v)
    {
        final[i] = false;   //代表未求得到该顶点的最短路径
        d[i] = G.arcs[s][i];    //初始化到各个顶点的距离
    }
    d[s] = 0; final[s] = true;  
    for(i = 1;i<G.vexnum;++i)   //重复n-1次
    {
        min = infinity;
        for(w = 0;w<G.vexnum;+=w)   //V-S中最小的顶点
            if(!final(w))       //顶点在V-S中=====================核心1
                if(d[w]<min)
                {
                    v= w;
                    min = d[w];
                }
        final[v] = true;
        for(w=0;w<G.vexnum;++w) //由上步最小的顶点，更新其余
        {
            if(!final[w]&&(min+G.arcs[v][w]<d[w]))  //===============核心2
                d[w] = min+G.arcs[v][w];
        }
    }
}
```
####3.5.3 单源最短路径分析
时间复杂度：O（N*N）

####3.5.4 最短路径:
* 
**法一：** 对每一个顶点进行一边迪杰斯特拉算法。O（N\*N\*N）
* 
**法二：** Floyd弗洛伊德算法。O(N\*N\*N)

两点最短路径：图的遍历算法即可

[返回目录](README.md)