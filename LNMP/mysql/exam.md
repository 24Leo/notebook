### N：N
**最简单的例子就是文章和标签～～**特性：
* 一个文章有个多个标签
* 一个标签有多个文章

#### 简单方案
1. 文章表    ： aid => content
    * 记录文章ID和文章信息
2. 标签表    ： tid => tagname
    * 记录标签ID和标签信息
3. 文章和标签映射表   : id => aid,tid
    * 记录标签ID和文章ID
    * 5个文章，3个标签，共15条记录

#### 进阶方案
听说过es吗？[ES](https://www.elastic.co/guide/cn/elasticsearch/guide/current/foreword_id.html)