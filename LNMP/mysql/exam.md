[](https://www.jianshu.com/p/ef274efa5770?from=groupmessage)[参考](https://blog.csdn.net/zuosixiaonengshou/article/details/53011452)
### N：N
**最简单的例子就是文章和标签～～**特性：
* 一个文章有个多个标签
* 一个标签有多个文章

#### 简单方案
##### 方案1
1. 文章表    ： aid => content
    * 记录文章ID和文章信息
2. 标签表    ： tid => tagname
    * 记录标签ID和标签信息
3. 文章和标签映射表   : mid => aid,tid
    * 记录标签ID和文章ID
    * 5个文章，3个标签，共15条记录。。。
    * 如果文章特别多，标签也特别多--------冗余 N * M 
    * 另外多个标签一起查询怎么办？
        * 包含条t1、t2的文章列表？如果用EXISTS那么嵌套层次太深。
    
#####方案2
两张表：
1. 文章表
2. tag表：一个tag对应的文章列表。
    * ```select * from articles where article_id in (select distinct(article_id) from tags where tags in ('tag1','tag2','tag3')) limit n; ```

#### 进阶方案
听说过es吗？[ES](https://www.elastic.co/guide/cn/elasticsearch/guide/current/foreword_id.html)


####参考
[标签设计](https://www.jianshu.com/p/ef274efa5770?from=groupmessage)

###树形入表
![](/assets/20160811112635235.png)
####增删查改
* 查找节点4的所有子节点
    * 思路:我们只要查找出 节点左值在 '节点4' 左值和右值之间的节点
* 找出6节点的额所有父节点：
    * 思路: 找出 左值小于 '节点6' 并且 右值大于 '节点6' 的节点。

[return](README.md)