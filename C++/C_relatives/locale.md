
### locale.h：国家、文化和语言规则集称为区域设置
 头文件中定义了区域设置相关的函数。setlocale函数用于设置或返回当前的区域特性，localeconv用于返回当前区域中的数字和货币信息（保存在struct lconv结构实例中）。setlocale的第一个实参指定要改变的区域行为类别，预定义的setlocale类别有：
```C
LC_ALL
全部本地化信息
LC_COLLATE
影响strcoll和strxfrm
LC_CTYPE
影响字符处理函数和多行字符处理函数
LC_MONETARY
影响localeconv返回的货币格式化信息
LC_NUMERIC
影响格式化输入输出字符中的小数点符号
LC_TIME
影响strftime函数```
locale.h 头文件中提供了2个函数 
```C
setlocale() 设置或恢复本地化信息 
localeconv() 返回当前地域设置的信息
```
**setlocale(constant,location) 用法 **
```C
如果这个函数成功执行，将返回当前的场景属性；如果执行失败，将返回False。
constant 参数 (必要参数。指定设置的场景信息)
    LC_ALL – 所有下属的常量
    LC_COLLATE – 排列顺序
    LC_CTYPE – 字符分类和转换（例如：将所有的字符转换成小写或大写形式）
    LC_MESSAGES – 系统信息格式
    LC_MONETARY – 货币 / 通货格式
    LC_NUMERIC – 数值格式
    LC_TIME – 日期和时间格式
location (必要参数)
    必要参数。指定需要进行场景信息设置的国家或区域。它可以由一个字符串或一个数组组成。如果本地区域是一个数组，
    那么setlocale()函数将尝试每个数组元素直到它从中获取有效的语言和区域代码信息为止。如果一个区域处于
    不同操作系统中的不同名称下，那么这个参数将非常有用。
```
**struct lconv *localeconv(void); 用法**
```C
localeconv 返回lconv结构指针 lconv结构介绍: 保存格式化的数值信息，保存数值包括货币和非货币的格式化信息，
localeconv返回指向该对象的指针，以下为结构中的成员及信息：

char *decimal_point; 数字的小数点号
char *thousands_sep; 数字的千分组分隔符
    每个元素为相应组中的数字位数，索引越高的元素越靠左边。一个值为CHAR_MAX的元素表示没有更多的分组了。
    一个值为0的元素表示前面的元素能用在靠左边的所有分组中
char *grouping; 数字分组分隔符
char *int_curr_symbol; 前面的三个字符ISO 4217中规定的货币符号，第四个字符是分隔符，第五个字符是'\0' */
char *currency_symbol; 本地货币符号
char *mon_decimal_point; 货币的小数点号
char *mon_thousands_sep; 千分组分隔符
char *mon_grouping; 类似于grouping元素
char *positive_sign; 正币值的符号
char *negative_sign; 负币值的符号
char int_frac_digits; 国际币值的小数部分
char frac_digits; 本地币值的小数部分
char p_cs_precedes; 如果currency_symbol放在正币值之前则为1，否则为0
char p_sep_by_space; 当且仅当currency_symbol与正币值之间用空格分开时为1
char n_cs_precedes; < 如果currency_symbol放在负币值之前则为1，否则为0/dt>
char n_sep_by_space; 当且仅当currency_symbol与负币值之间用空格分开时为1
char p_sign_posn; 格式化选项
    0 - 在数量和货币符号周围的圆括号 
    1 - 数量和货币符号之前的 + 号 
    2 - 数量和货币符号之后的 + 号 
    3 - 货币符号之前的 + 号 
    4 - 货币符号之后的 + 号
char n_sign_posn 格式化选项
    0 - 在数量和货币符号周围的圆括号 
    1 - 数量和货币符号之前的 - 号 
    2 - 数量和货币符号之后的 - 号 
    3 - 货币符号之前的 - 号 
    4 - 货币符号之后的 - 号
最后提示：可以使用setlocale(LC_ALL,NULL)函数将场景信息设置为系统默认值```

[返回目录](README.md)