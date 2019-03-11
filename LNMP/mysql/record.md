1、表锁：共享s、排他x、意向排他ix、意向共享is、表自增锁
    * 共享：可读，不可写，允许其他加s，不允许加x
    * 排他：可读可写，不允许其他加s、x
    * 意向锁：为了满足多粒度锁需求。（比如A对一行加读锁，B相对全表加写锁，那么B肯定不应该加因为A在读，那B怎么知道A读哪一行呢？A在对某一行加锁时先获得表的意向锁is，这样B来的时候就知道了）
        * 意向排他：我想接下来对表中某一行修改，你们谁都不能加任何锁
        * 意向共享：我想读取某一行记录，你们不可以加x，其他都可以
    * 自增锁：主键自增
        * 自增锁的解锁是在插入语句结束时发生的，而不是在事务结束
    * 表锁：仅在set autocommit=0是有效

2、行锁：
    * 共享：读，s-record lock
    * 排他：写，x-record lock
    * gap：    
        * record lock：仅锁住一行（insert 插入时，仅锁住插入的这一行）
            * 锁住的是索引，而不是记录！！！
            * 如果没有索引，innodb会默认聚集主键索引，锁这个：所以说当一条sql没有走任何索引时，那么将会在每一条聚集索引后面加X锁，这个类似于表锁，但原理上和表锁应该是完全不同的。
        * gap lock：开区间的范围（记录之间的范围加锁，或记录之前、之后的范围加锁，但是不包括**记录本身**）
        * next key lock：左开右闭区间，即锁记录，也锁区间。
            * s nk
            * x nk
            * 默认情况下，innodb使用next-key locks来锁定记录。（也就是说替换record lock，但是如果索引有唯一属性则和record没区别）
        * insert intension gap lock：是gap特例，而不是意向锁。作用是**insert时**说明自己在某个区间插入，只要大家不插入相同记录就不会互相锁住。
        
3、插入insert：插入时会对插入的记录加上record锁，仅锁住该行。但是插入之前会获得insert intension gap lock也就是某个范围，所以如果大家不插入相同记录不会有问题，如果相同那么都会去获得这个记录的record锁而发生死锁。
    * 如果一个在插入了，另外的就会变成获取共享锁

4、innodb默认rr模式下：
    * select ... from ... where ... 一致性读，默认不加锁
        * 隔离级别为最高serializable会加s-nk
    * select ... lock in share mode：扫描到的任何索引记录上加 s|nk，同时主键索引上加排他锁
    * select ... for update：扫描到的所有索引记录上加 x|nk锁，同时主键上加排他锁
    * update、delete ... where：加nk，同时主键加排他
    * insert：先加gap意向锁，然后加record锁（注意死锁）
    * insert ... on duplicate key update：如果有冲突直接加排他锁
    * replace ：无冲突和insert一样否则也是直接排他锁
    * insert into T ... select ... from S ： T上和insert同，S上加共享nk锁
    * 自增列锁：全表排他锁
    * 外键：索引记录上加共享record lock


[return](README.md)