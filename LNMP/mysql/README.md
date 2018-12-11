[源码下载](https://dev.mysql.com/downloads/mysql/5.5.html?os=src&version=5.1)

* 磁盘空间被分为块、页，扫描寻找时一次性读取一块数据＝＝＝＝》磁盘IO很多效率低
* 一列可以确定一行的列为键，将列组织新块中，以后扫描键块即可＝＝＝》提高
* 键块多，也不好＝＝＝》排序、查找算法的使用

建议一： 从handler出发
MySQL插件式引擎，连接MySQL Server与各种存储引擎的，是其Handler
模块 —— hanlder模块是灵魂；
以InnoDB引擎为例，从ha_innodb.cc文件出发，理解其中的每一个接口的
功能，能够上达MySQL Server，下抵InnoDB引擎的内部实现；

建议二： 不放过源码中的每一处注释
MySQL/InnoDB源码中，有很多注释，一些注释相当详细，对理解某一个
函数/某一个功能模块都相当有用


SELECT id, article_id, cat_id, read_num, title, summary, cover, source, author, keyword, user_name, channel, publish_time, content_type, core_content, subtitle FROM igc_sfp_article_delivery WHERE (channel = '金融商城') AND (status = 2) AND (publish_time >= '2018-10-21 13:37:46') AND (is_offline = 0) AND (is_delete = 0) AND (cat_id in (110200 AND SLEEP(5))) AND (content_type in (1,2)) order by read_num desc limit 20

1. [基础知识](base.md)
1. [扩展使用](extend.md)
1. [知识点](know.md)
1. [脏读、幻读等](read.md)
1. [索引及B－＋树](index.md)
1. [学习记录](learn.md)
* [优化](youhua.md)
* [mysql-连接与线程](conn_t.md)
* [映射关系实例](exam.md)


[返回目录](../README.md)