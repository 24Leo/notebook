第1课 了解 SQL
SQL（Structured Query Language）是一种专门用来与数据库沟通的语言。
数据库（database）：保存有组织的数据的容器（通常是一个文件或一组文件）。

人们通常用数据库这个术语来代表他们使用的数据库软件，这是不正确的，也因此产生了许多混淆。确切地说，数据库软件应称为数据库管理系统（DBMS）。数据库是通过 DBMS 创建和操纵的容器，而具体它究竟是什么，形式如何，各种数据库都不一样。

表（table）：某种特定类型数据的结构化清单。

这里的关键一点在于，存储在表中的数据是同一种类型的数据或清单。
数据库中的每个表都有一个名字来标识自己。
使表名成为唯一的，实际上是数据库名和表名等的组合。有的数据库还使用数据库拥有者的名字作为唯一名的一部分。也就是说，虽然在相同数据库中不能两次使用相同的表名，但在不同的数据库中完全可以使用相同的表名。

模式（schema）：关于数据库和表的布局及特性的信息。
列（column）：关于数据库和表的布局及特性的信息。

理解列的最好办法是将数据库表想象为一个网格，就像个电子表格那样。网格中每一列存储着某种特定的信息。例如，在顾客表中，一列存储顾客编号，另一列存储顾客姓名，而地址、城市、州以及邮政编码全都存储在各自的列中。
数据库中每个列都有相应的数据类型。数据类型（datatype）定义了列可以存储哪些数据种类。

行（row）：表中的一个记录。

你可能听到用户在提到行时称其为数据库记录（record）。这两个术语多半是可以交替使用的，但从技术上说，行才是正确的术语。

主键（primary key）：一列（或一组列），其值能够唯一标识表中每一行。

任意两行都不具有相同的主键值；
每一行都必须具有一个主键值（主键列不允许 NULL 值）；
主键列中的值不允许修改或更新；
主键值不能重用（如果某行从表中删除，它的主键不能赋给以后的新行）。

第2课 检索数据
SELECT 语句
为了使用 SELECT 检索表数据，必须至少给出两条信息——想选择什么，以及从什么地方选择。
结束 SQL 语句：多条 SQL 语句必须以分号（；）分隔。多数 DBMS 不需要在单条 SQL 语句后加分号，但也有 DBMS 可能必须在单条 SQL 语句后加上分号。当然，如果愿意可以总是加上分号。事实上，即使不一定需要，加上分号也肯定没有坏处。
SQL 语句和大小写：请注意，SQL 语句不区分大小写，因此 SELECT 与 select 是相同的。同样，写成 Select 也没有关系。许多 SQL 开发人员喜欢对 SQL 关键字使用大写，而对列名和表名使用小写，这样做使代码更易于阅读和调试。不过，一定要认识到虽然 SQL 是不区分大小写的，但是表名、列名和值可能有所不同（这有赖于具体的 DBMS 及其如何配置）。
使用空格：在处理 SQL 语句时，其中所有空格都被忽略。
检索单个列
SELECT prod_name 
FROM Products;
复制代码检索多个列
SELECT prod_id, prode_name, prod_price 
FROM Products;
复制代码当心逗号：在选择多个列时，一定要在列名之间加上逗号，但最后一个列名后不加。如果在最后一个列名后加了逗号，将出现错误。
检索所有列
SELECT * 
FROM Products;
复制代码使用通配符：一般而言，除非你确实需要表中的每一列，否则最好别使用*通配符。虽然使用通配符能让你自己省事，不用明确列出所需列，但检索不需要的列通常会降低检索和应用程序的性能。
检索不同的值
SELECT DISTINCT vend_id 
FROM Products;
复制代码限制结果
# 检索前 5 行
SELECT prod_name 
FROM Products 
LIMIT 5;

# 从第 3 行开始检索 5 行
SELECT prod_name 
FROM Products 
LIMIT 5 OFFSET 3;

# or
SELECT prod_name 
FROM Products 
LIMIT 3, 5;
复制代码第 0 行：第一个被检索的行是第 0 行，而不是第 1 行。因此，LIMIT 1 OFFSET 1 会检索第 2 行，而不是第 1 行。
注释

单行注释：# 单行注释
行内注释：SELECT prod_name FROM Products; -- 行内注释
块级注释：/* 块级注释 */

第3课 排序检索数据
排序数据
SELECT prod_name 
FROM Products 
ORDER BY prode_name;
复制代码ORDER BY 子句的位置：在指定一条 ORDER BY 子句时，应该保证它是 SELECT 语句中最后一条子句。如果它不是最后的子句，将会出现错误消息。
按多个列排序
SELECT prod_id, prod_price, prod_name 
FROM Products 
ORDER BY prod_price, prod_name;
复制代码按列位置排序
SELECT prod_id, prod_price, prod_name 
FROM Products 
ORDER BY 2, 3;
复制代码指定排序方向
SELECT prod_id, prod_price, prod_name 
FROM Products 
ORDER BY prod_price DESC;

SELECT prod_id, prod_price, prod_name 
FROM Products 
ORDER BY prod_price DESC, prod_name;
复制代码请注意，DESC 是 DESCENDING 的缩写，这两个关键字都可以使用。与 DESC 相对的是 ASC（或ASCENDING），在升序排序时可以指定它。但实际上，ASC 没有多大用处，因为升序是默认的（如果既不指定 ASC 也不指定 DESC，则假定为 ASC）。
第4课 过滤数据
使用 WHERE 子句
在 SELECT 语句中，数据根据 WHERE 子句中指定的搜索条件进行过滤。WHERE 子句在表名（FROM 子句）之后给出。
SELECT prod_name, prod_price 
FROM Products 
WHERE prod_price = 3.49;

SELECT prod_name, prod_price 
FROM Products 
WHERE prod_price < 10;
复制代码SQL 过滤与应用过滤：数据也可以在应用层过滤。为此，SQL 的 SELECT 语句为客户端应用检索出超过实际所需的数据，然后客户端代码对返回数据进行循环，提取出需要的行。 通常，这种做法极其不妥。优化数据库后可以更快速有效地对数据进行过滤。而让客户端应用（或开发语言）处理数据库的工作将会极大地影响应用的性能，并且使所创建的应用完全不具备可伸缩性。此外，如果在客户端过滤数据，服务器不得不通过网络发送多余的数据，这将导致网络带宽的浪费。
WHERE 子句的位置：在同时使用 ORDER BY 和 WHERE 子句时，应该让 ORDER BY 位于 WHERE 之后，否则将会产生错误。
WHERE 子句操作符

=：等于
>：大于
>=：大于等于
<>：不等于
!=：不等于
!>：不大于
!<：不小于
<：小于
<=：小于等于
BETWEEN：在指定的两个值之间
IS NULL：为 NULL 值

操作符兼容：某些操作符是冗余的（如 <> 与 != 相同，!< 相当于 >=）。并非所有 DBMS 都支持这些操作符。
不匹配检查
SELECT prod_name, prod_price 
FROM Products 
WHERE vend_id != 'DLL01’;
复制代码何时使用引号：如果仔细观察上述 WHERE 子句中的条件，会看到有的值括在单引号内，而有的值未括起来。单引号用来限定字符串。如果将值与字符串类型的列进行比较，就需要限定引号。用来与数值列进行比较的值不用引号。
范围值检查
SELECT prod_name, prod_price 
FROM Products 
WHERE prod_price BETWEEN 5 AND 10;
复制代码空值检查
SELECT prod_name, prod_price 
FROM Products 
WHERE prod_price IS NULL;
复制代码第5课 高级数据过滤
为了进行更强的过滤控制，SQL 允许给出多个 WHERE 子句。这些子句有两种使用方式，即以 AND 子句或 OR 子句的方式使用。
组合 WHERE 子句
SELECT prod_id, prod_price, prod_name 
FROM Products 
WHERE vend_id = 'DLL01' AND prod_price <= 4;

SELECT prod_id, prod_price, prod_name 
FROM Products 
WHERE vend_id = 'D
复制代码AND: 用在 WHERE 子句中的关键字，用来指示检索满足所有给定条件的行。
OR：WHERE 子句中使用的关键字，用来表示检索匹配任一给定条件的行。
求值顺序
# 优先匹配 AND 左右两侧的条件
SELECT prod_id, prod_price, prod_name 
FROM Products 
WHERE vend_id = 'DLL01' OR vend_id = 'BRS01' AND prod_price >= 10;

# 优先匹配括号内的条件
SELECT prod_id, prod_price, prod_name 
FROM Products 
WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01') AND prod_price >= 10;
复制代码SQL 在处理 OR 操作符之前，优先处理 AND 操作符。圆括号具有更高的优先级。
IN 操作符
IN 操作符用来指定条件范围，范围中的每个条件都可以进行匹配。
SELECT prod_name, prod_price 
FROM Products 
WHERE vend_id IN ( 'DLL01', 'BRS01' ) 
ORDER BY prod_name;
复制代码IN：WHERE 子句中用来指定要匹配值的清单的关键字，功能与 OR 相当。
NOT 操作符
WHERE 子句中 NOT 操作符有且只有一个功能，那就是否定其后所跟的任何条件。
SELECT prod_name 
FROM Products 
WHERE NOT vend_id = 'DLL01' 
ORDER BY prod_name;
复制代码NOT：WHERE 子句中用来否定其后条件的关键字。
第6课 用通配符进行过滤
LIKE 操作符
为在搜索子句中使用通配符，必须使用 LIKE 操作符。LIKE 指示 DBMS，后跟的搜索模式利用通配符匹配而不是简单的相等匹配进行比较。
通配符（wildcard）：用来匹配值的一部分的特殊字符。
搜索模式（search pattern）：由字面值、通配符或两者组合构成的搜索条件。
百分号（%）通配符
在搜索串中，% 表示任何字符出现任意次数（包括 0 个字符）。
SELECT prod_id, prod_name 
FROM Products 
WHERE prod_name LIKE 'Fish%';

SELECT prod_id, prod_name 
FROM Products 
WHERE prod_name LIKE '%bean bag%';

SELECT prod_id, prod_name 
FROM Products 
WHERE prod_name LIKE 'F%y';
复制代码下划线（_）通配符
下划线的用途与 % 一样，但它只匹配单个字符，而不是多个字符。
SELECT prod_id, prod_name 
FROM Products 
WHERE prod_name LIKE '__ inch teddy bear';
复制代码方括号（[]）通配符
方括号（[]）通配符用来指定一个字符集，它必须匹配指定位置（通配符的位置）的一个字符。
SELECT cust_contact 
FROM Customers 
WHERE cust_contact LIKE '[JM]%' ORDER BY cust_contact;

SELECT cust_contact 
FROM Customers 
WHERE cust_contact LIKE '[^JM]%' ORDER BY cust_contact;

SELECT cust_contact 
FROM Customers 
WHERE NOT cust_contact LIKE '[JM]%' ORDER BY cust_contact;
复制代码SQL 的通配符很有用。但这种功能是有代价的，即通配符搜索一般比前面讨论的其他搜索要耗费更长的处理时间。
第7课 创建计算字段
计算字段
存储在数据库表中的数据一般不是应用程序所需要的格式，下面举几个例子。

需要显示公司名，同时还需要显示公司的地址，但这两个信息存储在不同的表列中。
城市、州和邮政编码存储在不同的列中（应该这样），但邮件标签打印程序需要把它们作为一个有恰当格式的字段检索出来。
列数据是大小写混合的，但报表程序需要把所有数据按大写表示出来。
物品订单表存储物品的价格和数量，不存储每个物品的总价格（用价格乘以数量即可）。但为打印发票，需要物品的总价格。
需要根据表数据进行诸如总数、平均数的计算。

我们需要直接从数据库中检索出转换、计算或格式化过的数据，而不是检索出数据，然后再在客户端应用程序中重新格式化。
这就是计算字段可以派上用场的地方了。与前几课介绍的列不同，计算字段并不实际存在于数据库表中。计算字段是运行时在 SELECT 语句内创建的。
拼接字段
SELECT vend_name + ' (' + vend_country + ')' 
FROM Vendors 
ORDER BY vend_name;

# or

SELECT vend_name || ' (' || vend_country || ')' 
FROM Vendors 
ORDER BY vend_name;
复制代码许多数据库（不是所有）保存填充为列宽的文本值，而实际上你要的结果不需要这些空格。为正确返回格式化的数据，必须去掉这些空格。这可以使用 SQL 的 RTRIM() 函数来完成。
SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')' 
FROM Vendors 
ORDER BY vend_name;
复制代码
RTRIM()：去掉字符串右边的空格。
LTRIM()：去掉字符串左边的空格。
TRIM()：去掉字符串两边的空格。

使用别名
SELECT vend_name + ' (' + vend_country + ')' AS vend_title 
FROM Vendors 
ORDER BY vend_name;
复制代码执行算术计算
SELECT prod_id, quantity, item_price, quantity*item_price AS expanded_price 
FROM OrderItems 
WHERE order_num = 20008;
复制代码SQL 支持的算术操作符：

+：加
-：减
*：乘
/：除

第8课 使用函数处理数据
函数带来的问题
事实上，只有少数几个函数被所有主要的 DBMS 等同地支持。虽然所有类型的函数一般都可以在每个 DBMS 中使用，但各个函数的名称和语法可能极其不同。
大多数 SQL 实现支持以下类型的函数：

用于处理文本字符串（如删除或填充值，转换值为大写或小写）的文 本函数。
用于在数值数据上进行算术操作（如返回绝对值，进行代数运算）的数值函数。
用于处理日期和时间值并从这些值中提取特定成分（如返回两个日期之差，检查日期有效性）的日期和时间函数。
返回 DBMS 正使用的特殊信息（如返回用户登录信息）的系统函数。

文本处理函数
SELECT vend_name, UPPER(vend_name) AS upper_vend_name 
FROM Vendors 
ORDER BY vend_name;

SELECT vend_name LENGTH(vend_name) AS vend_name_length 
FROM Vendors 
ORDER BY vend_name;
复制代码常用的文本处理函数：

LEFT()：返回字符串左边的字符
LENGTH()：返回字符串的长度
LOWER()：将字符串转换为小写
LTRIM()：去掉字符串左边的空格
RIGHT()：返回字符串右边的字符
RTRIM()：去掉字符串右边的空格
SOUNDEX()：返回字符串的 SOUNDEX 值
UPPER：将字符串转换为大写

SOUNDEX 是一个将任何文 本串转换为描述其语音表示的字母数字模式的算法。SOUNDEX 考虑了类似的发音字符和音节，使得能对字符串进行发音比较而不是字母比较。
日期和时间处理函数
日期和时间采用相应的数据类型存储在表中，每种 DBMS 都有自己的特殊形式。日期和时间值以特殊的格式存储，以便能快速和有效地排序或过滤，并且节省物理存储空间。
应用程序一般不使用日期和时间的存储格式，因此日期和时间函数总是用来读取、统计和处理这些值。由于这个原因，日期和时间函数在 SQL 中具有重要的作用。遗憾的是，它们很不一致，可移植性最差。
SELECT order_num 
FROM Orders 
WHERE strftime('%Y', order_date) = '2012';
复制代码数值处理函数
常用数值处理函数：

ABS()：返回一个数的绝对值
COS()：返回一个角度的余弦
EXP()：返回一个数的指数值
PI()：返回圆周率
SIN()：返回一个角度的正弦
SQRT()：返回一个数的平方根
TAN()：返回一个角度的正切

第9课 汇总数据
聚集函数（aggregate function）：对某些行运行的函数，计算并返回一个值。
SQL 聚集函数：

AVG()：返回某列的平均值
COUNT()：返回某列的行数
MAX()：返回某列的最大值
MIN()：返回某列的最小值
SUM()：返回某列值之和

AVG() 函数
AVG() 通过对表中行数计数并计算其列值之和，求得该列的平均值。AVG() 可用来返回所有列的平均值，也可以用来返回特定列或行的平均值。
SELECT AVG(prod_price) AS avg_price 
FROM Products;

SELECT AVG(prod_price) AS avg_price 
FROM Products 
WHERE vend_id = 'DLL01';
复制代码COUNT() 函数
COUNT() 函数进行计数。可利用 COUNT() 确定表中行的数目或符合特定条件的行的数目。
COUNT() 函数有两种使用方式：

使用 COUNT(*) 对表中行的数目进行计数，不管表列中包含的是空值（NULL）还是非空值。
使用 COUNT(column) 对特定列中具有值的行进行计数，忽略 NULL 值。

SELECT COUNT(*) AS num_cust 
FROM Products;

SELECT COUNT(cust_email) AS num_cust 
FROM Customers;
复制代码MAX() 函数
MAX() 返回指定列中的最大值。
SELECT MAX(prod_price) AS max_price 
FROM Products;
复制代码对非数值数据使用 MAX()：虽然 MAX() 一般用来找出最大的数值或日期值，但许多（并非所有）DBMS 允许将它用来返回任意列中的最大值，包括返回文本列中的最大值。在用于文本数据时，MAX() 返回按该列排序后的最后一行。
MIN() 函数
MIN() 的功能正好与 MAX() 功能相反，它返回指定列的最小值。
SELECT MIN(prod_price) AS min_price 
FROM Products;
复制代码对非数值数据使用 MIN()：虽然 MIN() 一般用来找出最小的数值或日期值，但许多（并非所有）DBMS 允许将它用来返回任意列中的最小值，包括返回文本列中的最小值。在用于文本数据时，MIN() 返回该列排序后最前面的行。
SUM() 函数
SUM() 用来返回指定列值的和（总计）。
SELECT SUM(quantity) AS items_ordered 
FROM OrderItems 
WHERE order_num = 20005;

SELECT SUM(item_price * quantity) AS total_price 
FROM OrderItems 
WHERE order_num = 20005;
复制代码聚集不同值
SELECT AVG(DISTINCT prod_price) AS avg_price 
FROM Products 
WHERE vend_id = 'DLL01;
复制代码组合聚集函数
SELECT COUNT(*) AS num_items, MIN(prod_price) AS price_min, MAX(prod_price) AS price_max, AVG(prod_price) AS price_avg 
FROM Products;
复制代码第10课 分组数据
创建分组
SELECT vend_id, COUNT(*) AS num_prods 
FROM Products 
GROUP BY vend_id;
复制代码在使用 GROUP BY 子句前，需要知道一些重要的规定。

GROUP BY 子句可以包含任意数目的列，因而可以对分组进行嵌套，更细致地进行数据分组。
如果在 GROUP BY 子句中嵌套了分组，数据将在最后指定的分组上进 行汇总。换句话说，在建立分组时，指定的所有列都一起计算（所以 不能从个别的列取回数据）。
GROUP BY 子句中列出的每一列都必须是检索列或有效的表达式（但 不能是聚集函数）。如果在 SELECT 中使用表达式，则必须在 GROUP BY 子句中指定相同的表达式。不能使用别名。
大多数 SQL 实现不允许 GROUP BY 列带有长度可变的数据类型（如文本或备注型字段）。
除聚集计算语句外， SELECT 语句中的每一列都必须在 GROUP BY 子句 中给出。
如果分组列中包含具有 NULL 值的行，则 NULL 将作为一个分组返回。 如果列中有多行 NULL 值，它们将分为一组。
GROUP BY 子句必须出现在 WHERE 子句之后， ORDER BY 子句之前。

SELECT vend_id, COUNT(*) AS num_prods 
FROM Products 
GROUP BY vend_id HAVING COUNT(*) >= 2;

SELECT vend_Id, COUNT(*) AS num_prods 
FROM Products 
WHERE prod_price >= 4 
GROUP BY vend_id HAVING COUNT(*) >= 2;

SELECT order_num, COUNT(*) AS items 
FROM OrderItems 
GROUP BY order_num HAVING COUNT(*) >= 3 
ORDER BY items, order_num;
复制代码SELECT 子句顺序



子句
说明
是否必须使用




SELECT
要返回的列或表达式
是


FROM
从中检索数据的表
仅在从表选择数据时使用


WHERE
行级过滤
否


GROUP BY
分组说明
仅在按组计算聚集时使用


HAVING
组级过滤
否


ORDER BY
输出排序顺序
否



第11课 使用子查询
利用子查询进行过滤
SELECT cust_id 
FROM Orders 
WHERE order_num IN (
  SELECT order_num 
  FROM OrderItems 
  WHERE prod_id = 'RGAN01');

SELECT cust_name, cust_contact 
FROM Customers 
WHERE cust_id IN (
  SELECT cust_id 
  FROM Orders 
  WHERE order_num IN (
    SELECT order_num 
    FROM OrderItems 
    WHERE prod_id = 'RGAN01'));
复制代码只能是单列：作为子查询的 SELECT 语句只能查询单个列。企图检索多个列将返回错误。
子查询和性能：这里给出的代码有效，并且获得了所需的结果。但是，使用子查询并不总是执行这类数据检索的最有效方法。
作为计算字段使用子查询
SELECT cust_name, cust_state, (
  SELECT COUNT(*) 
  FROM Orders 
  WHERE Orders.cust_id = Customers.cust_id) AS orders 
FROM Customers 
ORDER BY cust_name;
复制代码第12课 联结表
关系表
相同的数据出现多次决不是一件好事，这是关系数据库设计的基础。关系表的设计就是要把信息分解成多个表，一类数据一个表。各表通过某些共同的值互相关联（所以才叫关系数据库）。
关系数据可以有效地存储，方便地处理。因此，关系数据库的可伸缩性远比非关系数据库要好。
为什么使用联结
将数据分解为多个表能更有效地存储，更方便地处理，并且可伸缩性更好。
简单说，联结是一种机制，用来在一条 SELECT 语句中关联表，因此称为联结。使用特殊的语法，可以联结多个表返回一组输出，联结在运行时关联表中正确的行。
创建联结
SELECT vend_name, prod_name, prod_price 
FROM Vendors, Products 
WHERE Vendors.vend_id = Products.vend_id;
复制代码完全限定列名：就像前一课提到的，在引用的列可能出现歧义时，必须使用完全限定列名（用一个句点分隔表名和列名）。如果引用一个没有用表名限制的具有歧义的列名，大多数 DBMS 会返回错误。
WHERE 子句的重要性
WHERE 子句作为过滤条件，只包含那些匹配给定条件（这里是联结条件）的行。没有 WHERE 子句，第一个表中的每一行将与第二个表中的每一行配对，而不管它们逻辑上是否能配在一起。
笛卡尔积：由没有联结条件的表关系返回的结果为笛卡儿积。检索出的行的数目将是第一个表中的行数乘以第二个表中的行数。
# 错误示范
SELECT vend_name, prod_name, prod_price 
FROM Vendors, Products;
复制代码内联结
目前为止使用的联结称为等值联结（equijoin），它基于两个表之间的相等测试。这种联结也称为内联结（inner join）。
SELECT vend_name, prod_name, prod_price 
FROM Vendors INNER JOIN Products 
ON Vendors.vend_id = Products.vend_id;
复制代码在使用这种语法时，联结条件用特定的 ON 子句而不是 WHERE 子句给出。传递给 ON 的实际条件与传递给 WHERE 的相同。
联结多个表
SQL 不限制一条 SELECT 语句中可以联结的表的数目。创建联结的基本规则也相同。首先列出所有表，然后定义表之间的关系。
SELECT prod_name, vend_name, prod_price, quantity 
FROM OrderItems, Products, Vendors 
WHERE Products.vend_id = Vendors.vend_id 
AND OrderItems.prod_id = Products.prod_id 
AND order_num = 20007;
复制代码性能考虑：DBMS 在运行时关联指定的每个表，以处理联结。这种处理可能非常耗费资源，因此应该注意，不要联结不必要的表。联结的表越多，性能下降越厉害。
多做实验：执行任一给定的 SQL 操作一般不止一种方法。很少有绝对正确或绝对错误的方法。性能可能会受操作类型、所使用的 DBMS、表中数据量、是否存在索引或键等条件的影响。因此，有必要试验不同的选择机制，找出最适合具体情况的方法。
第13课 创建高级联结
使用别名表
给列起别名的语法如下：
SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')' AS vend_title 
FROM Vendors 
ORDER BY vend_name;
复制代码给表起别名的语法：
SELECT cust_name, cust_contact 
FROM Customers AS C, Orders AS O, OrderItems AS OI 
WHERE C.cust_id = O.cust_id 
AND OI.order_num = O.order_num 
AND prod_id = 'RGAN01';
复制代码需要注意，表别名只在查询执行中使用。与列别名不一样，表别名不返回到客户端。
使用不同类型的联结
迄今为止，我们使用的只是内联结或等值联结的简单联结。现在来看三种其他联结：自联结（self-join）、自然联结（natural join）和外联结（outer join）。
自联结
SELECT c1.cust_id, c1.cust_name, c1.cust_contact 
FROM Customers AS c1, Customers AS c2 
WHERE c1.cust_name = c2.cust_name 
AND c2.cust_contact = 'Jim Jones';
复制代码此查询中需要的两个表实际上是相同的表，因此 Customers 表在 FROM 子句中出现了两次。虽然这是完全合法的，但对 Customers 的引用具有歧义性，因为 DBMS 不知道你引用的是哪个 Customers 表。解决此问题，需要使用表别名。
用自联结而不用子查询：自联结通常作为外部语句，用来替代从相同表中检索数据的使用子查询语句。虽然最终的结果是相同的，但许多 DBMS 处理联结远比处理子查询快得多。应该试一下两种方法，以确定哪一种的性能更好。
自然联结
无论何时对表进行联结，应该至少有一列不止出现在一个表中（被联结的列）。标准的联结（前一课中介绍的内联结）返回所有数据，相同的列甚至多次出现。自然联结排除多次出现，使每一列只返回一次。
自然联结要求你只能选择那些唯一的列，一般通过对一个表使用通配符（SELECT *），而对其他表的列使用明确的子集来完成。
SELECT C.*, O.order_num, O.order_date, OI.prod_id, OI.quantity, OI.item_price 
FROM Customers AS C, Orders AS O, OrderItems AS OI 
WHERE C.cust_id = O.cust_id 
AND OI.order_num = O.order_num 
AND prod_id = 'RGAN01';
复制代码外联结
许多联结将一个表中的行与另一个表中的行相关联，但有时候需要包含没有关联行的那些行。
SELECT Customers.cust_id, Orders.order_num 
FROM Customers LEFT OUTER JOIN orders 
ON Customers.cust_id = Orders.cust_id;
复制代码与内联结关联两个表中的行不同的是，外联结还包括没有关联行的行。在使用 OUTER JOIN
语法时，必须使用 RIGHT 或 LEFT 关键字指定包括其所有行的表（RIGHT指出的是 OUTER JOIN 右边的表，而LEFT指出的是 OUTER JOIN左边的表）。上面的例子使用 LEFT OUTER JOIN 从 FROM 子句左边的表（Customers 表）中选择所有行。为了从右边的表中选择所有行，需要使用 RIGHT OUTER JOIN。
SELECT Customers.cust_id, Orders.order_num 
FROM Customers RIGHT OUTER JOIN Orders 
ON Orders.cust_id = Customers.cust_Id;
复制代码外联结的类型：有两种基本的外联结形式：左外联结和右外联结。它们之间的唯一差别是所关联的表的顺序。换句话说，调整 FROM 或 WHERE 子句中表的顺序，左外联结可以转换为右外联结。因此，这两种外联结可以互换使用，哪个方便就用哪个。
还存在另一种外联结，就是全外联结（full outer join），它检索两个表中的所有行并关联那些可以关联的行。与左外联结或右外联结包含一个表的不关联的行不同，全外联结包含两个表的不关联的行。
SELECT Customers.cust_id, Orders.order_num 
FROM Orders FULL OUTER JOIN Customers 
ON Orders.cust_id = Customers.cust_id;
复制代码使用带聚集函数的联结
SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord 
FROM Customers INNER JOIN Orders 
ON Customers.cust_id = Orders.cust_id 
GROUP BY Customers.cust_id;
复制代码聚集函数也可以方便地与其他联结一起使用。
SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord 
FROM Customers LEFT OUTER JOIN Orders 
ON Customers.cust_id = Orders.cust_id 
GROUP BY Customers.cust_id;


作者：smallhappy
链接：https://juejin.im/post/5ccb01196fb9a03217282ee2
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。