##[升级使用](http://www.cnblogs.com/zhangs1986/p/4914125.html)
###查看默认配置
mysql --help | grep my.cnf。
查看所有配置文件路径

* mysql刚安装后，通过mysql可以直接登录（select user();可以获得当前帐号）。也可以通过mysql -uroot指定root帐号登录，登录后需改root密码
    * SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');
* 然后配置远程访问、本地访问，需要重启
    * 远程：
        * 创建用户：create user 'work'@'localhost' identified by 'work1234';
            * 刷新权限：FLUSH PRIVILEGES;要不然会报警：找不到用户。
        * 授权：grant all PRIVILEGES on Tdname.* to 'work';
        * 允许访问：update user set host='%' where host='localhost' and user='work';
            * 再次刷新：FLUSH PRIVILEGES; 
    * 本地：
        * 同理：只要对当前用户授权，然后刷新权限即可。
    * 重启：
        * 关闭（mysqladmin shutdown -uroot -p123456）、启动

```C++
    修改密码：
        1)终端：mysqladmin -u[user-name] -p[old-password] password [new-password]
        2)mysql环境：set password for [username]@[host]=password('new password')  修该某一用户
                    set password=password('new password')       修该当前用户
    添加用户：
        grant [select,insert,update,delete] on [DB].[T] to [username]@[host] identified by [p-word]
        即：
            新建用户：create user [username]@[host] identified by [password]
            授权：grant [privileges] on [DBname].[Tname] to [username]@[host]
            * grant all privileges on YQ.* to wise;
        注：
            username   用户名
            host       指定用户从那个主机登陆(本机：localhost)
            password   用户密码
            privileges  允许该用户的操作如select、update等（all 代表所有操作都允许）
            DBname/Tname  允许访问的数据库和表（*.*即所有都可以）
            可以用通配符  order
            允许用户给别人权限：在grant命令最后加上 with grant option／但是仅能给自己有的权限。
    显示当前所有用户：
        select user from mysql.user;
    显示授权：
        show grants for [username]@[host];
    撤销授权：
        revoke [privileges] on [DBname].[Tname] from [username]@[host];
    删除用户：
        drop user [username]@[host];
    读取已有sql文件：
        mysql -u-p-D < sqlfilepath;  
    主键
        添加主键： Alter table [Tname] add primary key(col) 
        删除主键： Alter table [Tname] drop primary key(col) 
    索引
        创建索引：create [unique] index [idxname] on [Tname](col….) 
            ALTER  TABLE  `table_name`  ADD  `INDEX index_name` (  `column`  )
        删除索引：drop index [idxname] 
        注：索引是不可更改的，想更改必须删除重新建。 
    视图
        创建视图：create view [viewname] as select statement 
        删除视图：drop view [viewname] 
    查找：
        select * from table1 where field1 like ’%value1%’       —like的语法很精妙，查资料! 
    排序： 
        select * from table1 order by field1 [desc/asc],field2 [desc/asc]
    总数：
        select count as totalcount from table1 
    求和：
        select sum(field1) as sumvalue from table1 
    平均：
        select avg(field1) as avgvalue from table1 
    最大：
        select max(field1) as maxvalue from table1 
    最小：
        select min(field1) as minvalue from table1 
    限制数量：
        select * from [Tname] limit 0,[num]      前0~num个
        select * from [Tname] order by [col] asc limit [num]  后num个
        select * from [Tname] order by [col] asc limit [pos],[num]  指定位置
    分组显示：
        单列：select id,name,sum(price) as title date from [Tname] group by id order by title desc
        多列：select id,name,sum(price*num) as title from [Tname] group by title order by id asc
        多表：select a.name,avg(a.price),b.name,avg(b.price) from [Tname1] as a,[Tname2] as b 
            where a.id=b.id group by t.type
```

###免密码登陆：
1. 在当前用户路径下配置my.cnf文件，将user、password写在client节点下即可。
1. 启用skip-grant-tables 配置文件中，所有用户均免密码.。一般用于修改忘记密码，别忘记禁用。


##执行过程揭秘
![](/assets/mysql执行过程.png)

在以上的10个处理步骤中, **每一步的处理都生成一个虚拟表来作为下一步的输入**. 虚拟表对于调用者或输出查询来说是不存在的, 仅在最后步骤生成的表才会返回给调用者或者输出查询. 如果某一子句没有出现在SQL语句中, 这一步就被简单跳过..
这10个具体步骤是:

    1. FROM: from子句中的两个表首先进行交叉连接(笛卡尔积), 生成虚拟表VT1。
        * from后面的表关联，是自右向左解析的 
        * 尽量把数据量小的表放在最右边来进行关联（用小表去匹配大表）
    2. ON: on条件作用在VT1上, 将条件为True的行生成VT2。
    3. OUTER: 如果outer join被指定, 则根据外连接条件, 将左表or右表or多表的未出现在VT2查询结果中的行加入到VT2后生成VT3。
    4. WHERE: VT3表中应用Where条件, 结果为真的行用来生成VT4。
        * 自左向右
        * 把能筛选出小量数据的条件放在where语句的最左边 （用小表去匹配大表）
    5. GROUP BY: 根据Group by指定的列, 将VT4的行组织到不同的组中, 生成VT5。
    6. CLUB|ROLLUP: 超级组(分组之后的分组)被添加到VT5中, 生成VT6。
    7. HAVING: Having用来筛选组, VT6上符合条件的组将用来生成VT7。
    8. SELECT: select子句用来选择指定的列, 并生成VT8。
    9. DISTINCT: 从VT8中删除重复的行后, VT9被生成。
    10. ORDER BY: 根据Order by子句, VT9中的行被排序, 生成游标10。
 
``` 
 按由高到低的顺序显示个人平均分在70分以上的学生姓名和平均分，为了尽可能地提高平均分，
 在计算平均分前不包括分数在60分以下的成绩，并且也不计算贱人（jr）的成绩。 分析： 
1．要求显示学生姓名和平均分 
  因此确定第1步select s_name,avg(score) from student 
2．计算平均分前不包括分数在60分以下的成绩，并且也不计算贱人（jr）的成绩
  因此确定第2步 where score>=60 and s_name!=’jr’ 3．显示个人平均分 
3 相同名字的学生（同一个学生）考了多门科目 
  因此按姓名分组,确定第3步 group by s_name 4．显示个人平均分在70分以上 
4 因此确定第4步 having avg(s_score)>=70 5．按由高到低的顺序 
5 因此确定第5步 order by avg(s_score) desc 
```

from  on  join（生成虚表）  where

####注意事项:
    * 第一步中FROM: 需要对两表同时存在的列添加前缀, 以免混淆.
    * 第二步中ON: 在SQL特有的三值逻辑(true,false,unknown)中, unkown的值也是确定的, 只是在不同情况下有时为true, 有时为false. 一个总的原则是: unknown的值非真即假, 非假即真. 也就是时说, unknown只能取true和false里面的一个值, 但是unknown的相反还是unknown.如:在ON、WHERE和HAVING中做过滤条件时, unknown看做false;在CHECK约束中, unknown被看做是true;在条件中, 两个NULL的比较结果还是Unknown.在UNIQUE和PRIMARY KEY约束、排序和分组中, NULL被看做是相等的. 例如Group by 将null分为一组, 而order by将所有null排在一起.之后join
    * 第三步中OUTER: 如果多余两张表, 则将VT3和FROM中的下一张表再次执行从第一步到第三步的过程.
    * 第四步中WHERE: 由于此刻没有分组, 也没有执行select所以, where子句中不能写分组函数, 也不能使用表的别名. 并且, 只有在外连接时, on和where的逻辑才是不同的, 因此建议连接条件放在on中.
    * 第五步中GROUP BY: 如果查询中包含Group by 子句, 那么所有的后续操作(having, select等)都是对每一组的结果进行操作.Group by子句中可以使用组函数, 在Sql 2000中一旦使用组函数, 其后面的步骤将都不能处理, 而在Sql2005中没有这个限制.
    * 第六步不常用, 略过.
    * 第七步中HAVING: having表达式是仅有的分组条件. 注意: count(*)不会忽略掉null, 而count(field)会; 此外分组函数中不支持子查询做输入.
    * 第八步中SELECT: 如果包含Group By子句, 那么在第5步后将只能使用Group By子句中出现的列, 如果要使用其他原始列则, 只能使用组函数.另外, select在第八步才执行, 因此别名只能第八步之后才能使用, 并且只能在order by中使用.
    * 第九步中DISTINCT: 当使用Group By子句时, 使用Distinct是多余的, 他不会删除任何记录.
    * 第十步中ORDER BY: 按Order by子句指定的列排序后, 返回游标VC10.别名只能在Order by子句中使用.如果定义了Distinct子句, 则只能排序上一步中返回的表VT9, 如果没有指定Distinct子句, 则可以排序不再最终结果集中的列. 例如: 如果不加Distinct则Order by可以访问VT7和VT8中的内容.这一步最不同的是它返回的是游标而不是表, Sql是基于集合论的, 集合中的元素师没有顺序的, 一个在表上引用Order by排序的查询返回一个按照特定特定物理顺序组织的对象—游标. 所以对于视图、子查询、派生表等均不能将order by结果作为其数据来源.
    * 建议: 使用表的表达式时, 不允许使用order by子句的查询, 因此除非你真的要对行排序, 否则不要使用order by 子句.


##mysql server四种启动方式:
* ####mysqld
启动mysql服务器:./mysqld --defaults-file=/etc/my.cnf --user=root
客户端连接:
mysql --defaults-file=/etc/my.cnf
or
mysql -S /tmp/mysql.sock
 
* ####mysqld_safe
启动mysql服务器:./mysqld_safe --defaults-file=/etc/my.cnf --user=root &
客户端连接:
mysql --defaults-file=/etc/my.cnf
or
mysql -S /tm/mysql.sock
 
* ####mysql.server
cp -v /usr/local/mysql/support-files/mysql.server /etc/init.d/
chkconfig --add mysql.server
启动mysql服务器:service mysql.server {start|stop|restart|reload|force-reload|status}
客户端连接:同1、2
 
* ####mysqld_multi
```c++
mkdir $MYSQL_BASE/data2
cat <<-EOF>> /etc/my.cnf
[mysqld_multi]
mysqld = /usr/local/mysql/bin/mysqld_safe
mysqladmin = /user/local/mysql/bin/mysqladmin
user = mysqladmin
password = mysqladmin
[mysqld3306]
port            = 3306
socket          = /tmp/mysql3306.sock
pid-file = /tmp/mysql3306.pid
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
basedir = /usr/local/mysql
datadir = /usr/local/mysql/data
[mysqld3307]
port            = 3307
socket          = /tmp/mysql3307.sock
pid-file = /tmp/mysql3307.pid
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
basedir = /usr/local/mysql
datadir = /usr/local/mysql/data2
EOF
#mysql -S /tmp/mysql3306.sock
mysql>GRANT SHUTDOWN ON *.* TO 'mysqladmin'@'localhost' identified by 'mysqladmin' with grant option;
#mysql -S /tmp/mysql3307.sock
mysql>GRANT SHUTDOWN ON *.* TO 'mysqladmin'@'localhost' identified by 'mysqladmin' with grant option;
启动mysql服务器:./mysqld_multi --defaults-file=/etc/my.cnf start 3306-3307
关闭mysql服务器:mysqladmin shutdown
```


一些好的实例：
```C++
    1、复制表(只复制结构,源表名：a 新表名：b) (Access可用) 
        法一：select * into b from a where 1<>1 
        法二：select top 0 * into b from a 
    2、拷贝表(拷贝数据,源表名：a 目标表名：b) (Access可用) 
        insert into b(a, b, c) select d,e,f from b; 
    3、跨数据库之间表的拷贝(具体数据使用绝对路径) (Access可用) 
        insert into b(a, b, c) select d,e,f from b in ‘具体数据库’ where 条件 
        例子：..from b in ‘"&Server.MapPath(".")&"\data.mdb" &"’ where.. 
    4、子查询(表名1：a 表名2：b) 
        1)select a,b,c from a where a IN (select d from b )
        2)select a,b,c from a where a IN (1,2,3) 
    5、显示文章、提交人和最后回复时间 
        select a.title,a.username,b.adddate from table a,(select max(adddate) adddate from table 
            where table.title=a.title) b 
    6、外连接查询(表名1：a 表名2：b) 
        select a.a, a.b, a.c, b.c, b.d, b.f from a LEFT OUT JOIN b ON a.a = b.c 
    7、在线视图查询(表名1：a ) 
        select * from (SELECT a,b,c FROM a) T where t.a > 1; 
    8、between的用法,between限制查询数据范围时包括了边界值,not between不包括 
        select * from table1 where time between time1 and time2 
        select a,b,c, from table1 where a not between 数值1 and 数值2 
    9、in 的使用方法 
        select * from table1 where a [not] in (‘值1’,’值2’,’值4’,’值6’) 
    10、两张关联表，删除主表中已经在副表中没有的信息 
        delete from table1 where not exists ( select * from table2 where 
                table1.field1=table2.field1 ) 
    11、四表联查问题： 
        select * from a left inner join b on a.a=b.b right inner join c on a.a=c.c inner join d 
            on a.a=d.d where ….. 
    12、日程安排提前五分钟提醒 
        select * from 日程安排 where datediff(’minute’,f开始时间,getdate())>5 
    13、一条sql 语句搞定数据库分页 
        select top 10 b.* from (select top 20 主键字段,排序字段 from 表名 order by 排序字段 desc)
        a,表名 b where b.主键字段 = a.主键字段 order by a.排序字段 
    14、前10条记录 
        select top 10 * form table1 where 范围 
    15、选择在每一组b值相同的数据中对应的a最大的记录的所有信息(类似这样的用法可以用于论坛每月排行榜,
    每月热销产品分析,按科目成绩排名,等等.) 
        select a,b,c from tablename ta where a=(select max(a) from tablename tb where tb.b=ta.b) 
    16、包括所有在 TableA 中但不在 TableB和TableC 中的行并消除所有重复行而派生出一个结果表 
        (select a from tableA ) except (select a from tableB) except (select a from tableC) 
    17、随机取出10条数据 
        select top 10 * from tablename order by newid() 
    18、随机选择记录 
        select newid() 
    19、删除重复记录 
        Delete from tablename where id not in (select max(id) from tablename group by col1,col2,…) 
    20、列出数据库里所有的表名 
        select name from sysobjects where type=’U’ 
    21、列出表里的所有的 
        select name from syscolumns where id=object_id(’TableName’) 
    22、列示type、vender、pcs字段，以type字段排列，case可以方便地实现多重选择，类似select 中的case。 
        select type,sum(case vender when ‘A’ then pcs else 0 end),sum(case vender when ‘C’ then 
        pcs else 0 end),sum(case vender when ‘B’ then pcs else 0 end) FROM tablename group by type 
            显示结果： 
            type vender pcs 
            电脑 A 1 
            电脑 A 1 
            光盘 B 2 
            光盘 A 2 
            手机 B 3 
            手机 C 3 
    23、初始化表table1 
        TRUNCATE TABLE table1 
    24、选择从10到15的记录 
        select top 5 * from (select top 15 * from table order by id asc) T_别名 order by id desc 
```
###类型转换
* 两个参数都是字符串，会按照字符串来比较，不做类型转换。
* 两个参数都是整数，按照整数来比较，不做类型转换。
* 十六进制的值和非数字做比较时，会被当做二进制串。
* 有一个参数是 TIMESTAMP 或 DATETIME，并且另外一个参数是常量，常量会被转换为 timestamp
* 有一个参数是 decimal 类型，如果另外一个参数是 decimal 或者整数，会将整数转换为 decimal 后进行比较，如果另外一个参数是浮点数，则会把 decimal 转换为浮点数进行比较
* 所有其他情况下，两个参数都会被转换为浮点数再进行比较



[返回目录](README.md)