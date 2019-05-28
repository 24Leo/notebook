mysql技术内幕：sql编程／InnoDb引擎，高性能Mysql，数据库索引设计和优化（DBA进阶）

[安装](../LNMP/PHP/settings.md)
##[基础](https://juejin.im/post/5ccb01196fb9a03217282ee2#heading-35)：
数据库通常分为层次式数据库、网络式数据库和关系式数据库三种。
* 
层次式：IMS(Information Management System)是其典型代表
* 
网络式
* 
关系型数据库管理系统：SQL Server、ORACLE、MySql、PostgreSQL、SYBASE、INFORMIX和 DB2。
* NoSQL非关系型的数据库：
MongoDB（文档型）、Redis（key-value）、HBase（列数据库）

[入门](http://www.cnblogs.com/mr-wid/archive/2013/05/09/3068229.html#c1)
```C++

例如有索引key(a,b,c)
where a=xx and b=xx and c=xxx 此语句可以用到索引
where b=xx and a=xx and c=xxx 同上，顺序没有关系，同样能用到索引
where a=xx and b=xx 可以用到索引
where a=xx and c=xx 可以用到索引
where b=xx and c=xx 用不到索引
where b=xx 用不到索引
where c=xx 用不到索引


MySQL 为关系型数据库(Relational Database Management System), 这种所谓的"关系型"可以理解为"表格"的概念, 
        一个关系型数据库由一个或数个表格组成
Structed Query Language
SQL语句分为三种：DML（Data Manipulation Language）与DDL(Data Definition Language)及DCL(Data Control)
    1、DML
        select、update、delete、insert into
    2、DDL
        create database、alter database、create table、alter table、alter table、drop table
    3、DCL
        GRANT，REVOKE，COMMIT，ROLLBACK
```
####语法特点：
* 
没有“ ”，只有‘ ’
* 
没有逻辑相等，只有=，赋值和逻辑相等都是=
* 
任何数据都可以包含在‘ ’以内
* 
不区分大小写

####操作符
```C++
算术操作符：
    +  -  /  *  %  |  ^  &  <<  >>
比较操作符：
    =  >  <   <=  >=  ！= 
逻辑操作符：
    not、！     or、||      XOR         and、&&
通配符 
    * % 匹配0～n个
    * _ 匹配1个
    * [] 匹配字符集
    ```
###数据类型：
```C++
    1)算术、数值：
        tinyint、smallint、mediumint、int、bigint、float(M,D)、double(M,D)、decimal(M,D)
            MySQL数据类型	    含义（有符号）
            tinyint(m)	     1个字节  范围(-128~127)
            smallint(m)	    2个字节  范围(-32768~32767)
            mediumint(m)	   3个字节  范围(-8388608~8388607)
            int(m)	         4个字节  范围(-2147483648~2147483647)
            bigint(m)	      8个字节  范围(+-9.22*10的18次方)
                上述5个可以定义unsigned。
                如果定义int(2)，并不是说2位存储，而是显示给用户几位，数据库保存来所有
            float(m,d)	    单精度浮点型    8位精度(4字节)     m总个数，d小数位
            double(m,d)	   双精度浮点型    16位精度(8字节)    m总个数，d小数位    
                对于float（5，3）：
                1.插入123.45678，最后查询得到的结果为99.999；
                2.插入123.456，最后查询结果为99.999；
                3.插入12.34567，最后查询结果为12.346；
            decimal(m,d)      参数m<65 是总个数，d<30且 d<m 是小数位。存储为字符串。
                可以放大然后存成bigint类型，计算更快
    2)文本、字符串：
        char、varchar、tinyblob、blob、mediumblob、longblob、enum、set
            MySQL数据类型	    含义
            char(n)	    固定长度，最多255个字符
            varchar(n)	 可变长度，最多65535个字符
            tinytext	   可变长度，最多255个字符
            text       	可变长度，最多65535个字符
            mediumtext 	可变长度，最多2的24次方-1个字符
            longtext   	可变长度，最多2的32次方-1个字符
            set        1B／2B／4B／8B最多64个元素，值尽可以为其中几个或者NULL。多选
            enum        1B／2B最多65535个元素，值仅可以为其中一个或NULL。单选
                上述两个均是字符串类型
            1._BLOB和_text存储方式不同，_TEXT以文本方式存储，区分大小写，而_Blob是以二进制方式存储，不分大小写
            2._BLOB存储的数据只能整体读出。 
            3._TEXT可以指定字符集，_BLOB不用指定字符集。
            char和varchar：
                1.char(n) 若存入字符数小于n，则以空格补于其后，查询之时再将空格去掉。但是若是中文，则n＊3。
                    所以char类型存储的字符串末尾不能有空格，varchar不限于此。 
                2.char(n) 固定长度，char(4)不管是存入几个字符，都将占用4个字节，varchar是存入的实际字符数+1、2个
                    字节（n<=255）或2个字节(n>255)，所以varchar(4),存入3个字符将占用4个字节，记录长度。 不经常变的varchar，因为varchar会计算长度。
                3.char类型的字符串检索速度要比varchar类型的快。
                4. 如果字符串的最大长度比平均长度大很多，且列的更新很少时则适合用VARCHAR
            varchar和text： 
                1.varchar可指定n，text不能指定，内部存储varchar是存入的实际字符数+1个字节（n<=255）或2个字节(n>255)，
                 text是实际字符数+2个字节。 
                2.text类型不能有默认值。 
                3.varchar可直接创建索引，text创建索引要指定前多少个字符。varchar查询速度快于text,
                    在都创建索引的情况下，text的索引似乎不起作用。
    3)时间：
        date、datetime、time、timestamp、year
            MySQL数据类型	    含义
            year             年，1B
            date	        日期 '2008-12-2'，3B
            time	        时间 '12:25:36'，3B
            datetime	    日期时间 '2008-12-2 22:06:44'，8B
            timestamp       保存1970年1月1日后秒数，自动存储记录修改时间，4B
            若定义一个字段为timestamp，这个字段里的时间数据会随其他字段修改的时候自动刷新，
            所以这个数据类型的字段可以存放这条记录最后被修改的时间。
    4)数据类型属性：
        bit、string、boolean、Null、hexadecimal、decimal
            MySQL关键字	        含义
            NULL	            数据列可包含NULL值
            NOT NULL	        数据列不允许包含NULL值
            DEFAULT	         默认值，指定一个默认值，如果未赋值
            PRIMARY KEY 	    主键
            AUTO_INCREMENT      自动递增，适用于整数类型，一般用于主键
            UNSIGNED	        无符号
            CHARACTER SET [name]	指定一个字符集
    5）原则：
        a）最小往往最好，省内存和磁盘空间、CPU处理时间
        b）简单最好：数值比字符操作代价更小；
        c）尽量不使用NULL
        d）数字字符、IP等可以考虑转化为bigint
        e）char：短、定长、经常变动
        f）varchar：最大长度比平均长度大很多，列更新较少。
```


###基本操作：
```C    
    不区分大小写,每条命令以';'结束。
    登录：
        mysql [-h[host_addr]] -u[user-name] -p[password]   没有空格
        -D [Dname]. 指明登陆后用的数据库
    修改密码：
        mysqladmin -u[user-name] -p[old-password] password [new-password]
    数据库：
        show databases character set gbk;
        create database [DBname] character set [character-name] COLLATE [collation-name];
        use [DBname];
        drop database [DBname];
        rename database [olddbname] to [newdbname]
    表：
        show tables;
        create table [Tname] (col_name col_type,...) ENGINE=InnoDB DEFAULT CHARSET=utf-8;
        drop table [Tname];
        describe/desc  [Tname];
        select */col1,col2,... from [Tname] where coli=[str1] and colj=[str2] and col3 like "%1_";
        insert into [Tname](col1,col2,...) values('v1','v2',...);
        update [Tname] set coli=[str1] where colj=[str2];
        delete from [Tname] where coli=[str2];
        alter table [old-Tname] rename [new_Tname];
        alter table [Tname] add column [col_name] [col_type] after [col_name];
        alter table [Tname] change [old_col] [new_col] [col_type];
        alter table [Tname] modify [col] [col_type];
        alter table [Tname] drop column [col_ame];
        ALTER  TABLE  `table_name`  ADD  INDEX `index_name` (  `column`  )
        delete from [Tname]         清空表内容，相当于一行一行删
        truncate table [Tname]      同上，但是无记录
    导入导出：
        selcect col1... from [Tname] [condition] into outfile 'path/filename';
        load data infile 'path/filename' into table [Tname];
    备份：  
        终端中：mysqldump -r[username] -p[password] [DBname] [Tname] > 'backup_name'
    select:
        columns from ...
        func
        math
```
### 编码：
修改编码后需要重启生效[参考](http://blog.csdn.net/ultrani/article/details/17486637)
    1. 查看支持编码集：
        * show character set；
        * show varaiables like “%char%” ;
        * status也可以

<br>
    2. 涉及系统、服务器、数据库、表、列等编码，以及端、客户端等编码。列定义缺失用表默认，表默认缺失用库默认，库默认缺失用服务器默认配置，而且支持混合设置。
    3. 库：
```C
show create database [Dname];
alter database [Dname] default character set  [character-name] collate [collate-name];
```
<br>
4. 表：
```C
show create table [Tname]; show table status from [Dname];
alter table [Tname] default character set[character-name] collate [collate-name]; 
```
<br>
5. 列：show full columns from [Tname];
    * alter table [Tname] convert to character set [character-name] collate [collate-name]; 表和列一起
    
<br>
6. 终端查看／查找时：set names [character-name],端上用某个显示。session级别。相当于设置client、connection、results变量值

<br>
7. unicode是编码协议，并不是实现。具体实现有utf8、utf16等
中文字符集：GB2312（我国组织制定） － GBK（微软） － GB18030（我国政府发布）.向下兼容。
其他字符集：
utf8、utf16、latin等

![](/assets/luanma.jpg)

1. 服务器变量[client]下
    * 系统变量character_set_client：用来指定解析客户端传递数据的编码
    * 系统变量character_set_connection：用来指定数据库内部处理时使用的编码
    * 系统变量character_set_results：用来指定数据返回给客户端的编码方式
    * 上述三个相当于：**default-character-set=utf8即可**
    * 如果没客户端没有提供编码集，默认使用character_set_server作为客户端编码
    * 当客户端指定编码集时，相当于设置了前3个变量。
2. 客户端
    * 需要在连接器上设置characterEncoding=UTF-8&characterSetResults=UTF-8

###实例:
```C
    创建详细功能表：
        create table students
    	（
    		id int unsigned not null auto_increment primary key,
    		name char(8) not null,
    		sex char(4) not null,
    		age tinyint unsigned default '0' not null,
    		tel char(13) null default "-"
    	)ENGINE=InnoDB DEFAULT CHARSET=gbk;
    //插入时自增主键冲突：我们可以设为0或NULL，也可以不设置，让数据库自己处理
    between：
        between ... and ...
        not between ... and ...
    in/not in    desc/asc
    where：
        select t.name from students as t where t.sex='男' and t.age>18 and t.tel like "%687*";
    like用法：
        模式            注释
          *             多个字符匹配    
          %             同上，匹配多个字符
          [*/...]       即匹配*/...
          ?             单字符匹配
          #             单个数字匹配
          -[a-z]        范围内任意一个
          [!0-9]        不匹配范围内任一个
    联结：
        0)内联结：
            select ... from [Tname1] [INNER|CROSS] join [Tname2] on [eq_relation] where [contion]
        1)外左联结
            SELECT ... FROM [Tname1] LEFT JOIN [Tname2] ON [eq_relation] where [contion];
        2)外右联结
            SELECT ... FROM [Tname1] RIGHT JOIN [Tname2] ON [eq_relation] where [contion];
        联结的运算顺序:不想犯错就用括号
        SELECT t1.id,t2.id,t3.id FROM t1,t2 LEFT JOIN t3 ON (t3.id=t1.id) WHERE t1.id=t2.id;
        --实际上这么执行
        SELECT t1.id,t2.id,t3.id FROM t1,(  t2 LEFT JOIN t3 ON (t3.id=t1.id)  ) WHERE t1.id=t2.id;
        --应该这么写
        SELECT t1.id,t2.id,t3.id FROM (t1,t2) LEFT JOIN t3 ON (t3.id=t1.id) WHERE t1.id=t2.id;
```
###关键字
* 
select：从表（可能是其他关键字形成的虚表）中选择指定的列，并形成虚表。
* 
from：将指定的表首先进行交叉连接（笛卡尔积），形成虚表
* 
on：left join时条件作用于**表2**(可能是虚表），将条件满足的列与表1形成虚表，左表都在=======》用于形成虚表，将结果放到左表。
* 
where：条件作用于**当前from后表**(可能是虚表），结果为真的形成新的虚表=========》作用于虚表，形成最终的虚表。没有左连接含义，已形成表了。过滤使用！
* 
group by：根据条件指定列，将行组织到不同的组上
    * select * from employee group by sex; 单独使用，每个组仅显示第一个记录
    * select sex,group_concat(name) from employee group by sex;
        * 两列：sex，group_concat(name)。第二列name的集合 
    * select sex,avg(age) from employee group by sex;
        * 两列sex,avg(age).第二列为所有的平均年龄。
    * select sex,count(sex) from employee group by sex;
* 
having：用于**筛选组**，符合条件的生成新的虚表=============》用于筛选组group
    * select sex,count(sex) from employee group by sex having count(sex)>2;
* 
distinct：用于从原有的表中删除重复的行，生成新的虚表
* 
order by desc/asc：对表进行排序
* constraint
约束条件也叫完整性约束条件,当对表中的数据做DML操作时会验证数据是否违反约束条件.如果违反了DML操作会失败.约束条件可以应用于表中的一列或几列,应用于整个表或几个表之间.
    * 非空约束  
    * 唯一性约束  
    * 主键、外键 
    * 检查check   check(nom>10)
* unique 唯一性约束。unique(col)。不可以重复，NULL可以。
* explain 。查看语句最优执行方式、计划

### 常用函数：

```C++
version()               mysql版本
current_date()          当前时期
user()                  当前用户
database()              当前的数据库
now()                   当前时间
concat()                连接成一个字符串
lower()/upper()         小写/大写
left/right(str,n)       取str的左/右n个字符
substring(str,x,y)      从str的x处取y个字符
abs()                   绝对值
ceil()/floor()          大于的最小整数／小于的最大整数
mod(x,y)                x除以y
rand()                  0~1随即数
round(x,y)              对x四舍五入，留y位小数
truncate(x,y)           x保留y位小数后的值

count()                 计数
max/min()               最大最小
avg
sum
```



[返回目录](README.md)