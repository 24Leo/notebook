##注释
支持C、C++、shell的注释风格
1. //      这是单行注释
1. #       这也是单行注释
1. /**/    多行注释

按《PHP与MySql Web开发》一书来作学习总结；
##1、PHP基础
a）php支持shell、C/C++风格注释：#、//、/**/
b）php标识符和C/C++相似，不允许数字开头。变量区分大小写，函数不区分大小写。
c）php数据类型：整形、浮点、字符串、布尔、数组、类（对象）等；
e）任何一个未初始化的变量、值为 0 或 false 或 空字符串"" 或 null的变量、空数组、没有任何属性的对象，都是empty；
f）‘＝＝＝’不仅仅要求两边值相同，类型也要相同
g）
###1.1 作用域
a）超全局变量，在脚本任意地方均可以访问。
b）常量，在当前脚本任意地方均可以访问。两种：
```PHP
   define ('TEM',100);       
   define('PHPLIB_PATH', 'D:\\code\\odp\\phplib-pay');  常量和字符串值（数值时不用引号）用单引号。
   const PHPLIB_PATH ＝  'D:\\code\\odp\\phplib-pay'；```
c）变量
             函数内变量作用域：函数内可见；
             脚本内变量作用域：全脚本除函数内部范围可见
d）函数内部静态变量，虽然函数外不可见，但是函数调用过程中一直存在。
e）函数内访问脚本定义变量：函数内声明时加global关键字，名字保持一致。
###1.2超全局变量
| 函数 | 作用 | 解释 |
| - | - | - |
| $_GLOBALS | 全局变量 | |
| $_SERVER | 服务器环境变量数组 | |
| $_REQUEST | 用户输入的请求数组，相当于下面三个集合 | 	php4.3之前还包括$_FILES|
| $_GET | GET方法参数 | |
| $_POST | POST方法参数 | |
| $_COOKIE | COOKIE数组 | |
| $_SESSION | 会话数组 | |
| $_FILES | 文件上传 | |
| $_ENV | 环境变量 | |
###1.3数组
PHP支持关联数组和数值索引数组、多维数组。

| 功能 | 实现 | 解释 |
| - | - | - |
| 排序 | sort(arr)、rsort(arr) | |
| | ksort(arr)、krsort(arr) | |
| | asort(arr)、arsort(arr) | |
| | usort( arr, self_func) | 自定义排序函数。该函数有两个参数代表比较的两个元素 | 
| | shullfe(arr) | 随机打乱 |
| 数组逆序 | array_reverse(arr)| 	原数组的逆序，产生新数组。 |
| 数组头 | reset(arr)|  |
| 数组尾 | end(arr)|  |
| 前进、后进 | each()、next()、prev() | 前两个都是从头向后，prev是从后向前 each、prev是先返回当前元素在移动，next是先移动在返回当前元素。＋＋前置、后置区别  |
| 当前 | current(arr) | | 
| 遍历 | each() | |
| 重新命名 | list(key,value) | 和each匹配可以处理关联数组 |
| 元素处理 | arrar_walk(arr，func) | 对每个元素应用函数，函数一个参数代表当前处理的元素 |
| 计数 | count() 、sizeof()、array_count_values() | 前两个一样（别名），后一个按特定值统计出现次数。|
| 提取为变量 | array_extract(arr) | 仅非数字索引数组，键值对变为变量和值 |
| 合并 | array_combine(arr1,arr2) | arr1为键，arr2为值。产生关联数组 |
| | array_merge(arr1,arr2.....) | 合并多个数组为一个 |
| 差集 | array_diff(arr1，arr2) | 仅值不同。在arr1中存在的或者说独有的，如果arr1比arr2少，可能返回空。 |
| | array_diff_key(arr1，arr2) | 仅键不同。|
| 唯一性处理 | array_unique() | 重复的删除 |
| 插入尾部 | array_push()、array_pop() | 尾部插入、弹出 |
| 随机0～1数组 | rand(min,max) | 普通0～1数组 |
| | mt_rand(min,max) | 使用 Mersenne Twister 算法返回随机整数。 比上面快四倍 | 
| 变量是否在数组中 | in_array(var,arr) | |
| 头元素删除 | array_shift() | 删除头元素，并返回 | 
| | 更多使用可以查php－manual | |

###1.4 字符串
PHP中字符和字符串没有特殊区分。PHP中空格：space、换行、制表、结束符等

| 功能 | 实现 | 解释 |
| - | - | - |
| 格式化－空格 | trim(str)、ltrim(str)、rtrim(str) |  清除空格：两侧、左侧、右侧。 |
| | | **注意无法清除全角符**，用str_replace | 
| | chop(str,str1) | 删除末尾str1串 |
| 格式化－转义	 | addslashes(str)、stripslashes(str) | 保存特殊字符 |
| 输出 | sprintf(str,y1,y2...)、printf() | 输出、赋值,格式：
| | | ％[pos\$][ 'pad][－][width][.pre]type |
| | | 必须以％开始；|
| | | pos第几个参数 |
| | | pad填充字符，默认空格 |
| | | －左对齐 |
| | | width宽度，填充 |
| | | pre仅用于小数。小数点后几位 |
| | | type见下： |
| | | s 字符串 | 
| | | f 浮点数 | 
| | | d 整数 |
| | | 等 |
| | sprintf("The total number is %2\$'-8.4f(Interset is %1\$4.2f), tips is %3$s",num1,num2,str). | | 
| | 使用第二个参数，左对齐，用－填充，8位，小数点后4位 | |
| 大小写 | strtoupper(str) | 大写 | 
| | strtolower(str) | 小写 |
| | ucfirst(str) | 第一个字符是字母时大写 |
| | ucword(str) | 每个单词第一个字符大写 |
| 连接、分割 | +、. 、implode/join(char c, arr)用于连接，explode(char c, str1) | explode使用字符c分割字符串。implode和join则是合并。 | 
| 获得子串 | substr(str,pos[,length]) | | 
| 查找 | strstr(str1,str)、strchr()、strrchr()、stristr() | 前两个一样，第三个反向查找，第四个不区分大小写 |
| | strpos(str1,str)、strrpos() | 作用相同，但是返回位置 |
| 比较 | strcmp(str1，str2)、strcasecmp()、strnatcmp()、strnatcasecmp() | 按字符比较（大小写）；按自然序列数值比较 |
| 长度 | strlen(str) | | 
| 替换 | str_replace(mixed1，mixed2，str) | 把mixed1中的换成mixed2中 |
| | substr_replace(str，str1，pos[，length]) | 指定位置指定长度替换为子字符串 |


###1.5、面向对象
```PHP
class Test extends Base implements Interface{
	public cData = array();
	protected dData = 'temp';
	private eData = 'eeee';
	function __construct(){
		//code
	}
	function __destruct(){
		//code
	}
	function __get($name){
		return $this->$name;
	}
	function __set($name,$value){
		$this->$name = $value;
	}
	final function finalFunction(){
		//code
	}
	function __call($method,$p){
		if($method == 'func1'){
			$this->func1($p[0]);
		}elseif($method == 'func2'){
			$this->func2($p[0]);
		}
		//code
	}
	function __toString(){
		return var_export($this,true);
	}
 
	function self_func(params){
		//code
	}
}
```
| 函数 | 作用 | 解释 |
| - ||
| __construct() | 构造函数	参数看是否需要 |
| __destruct() | 析构函数	一般无参数 |
| __get($name) | 获得属性值 | 
| __set($name,$value) | 设置属性值 | 
| __call($method,$p) | 重载实现。 | method代表要调用的函数名，p代表参数数组 |
| | | **注意：这个method方法不能实现**。 |
| __toString() | 输出类信息函数 |
| __autoload($name) | 自动加载初始化所需的文件 | **千万注意不是类内部函数** | 

| 关键字 | 作用 | 解释 |
| - |||
| public | 类内外部均可访问 |	默认，和C++不同点 | 
| protected | 类内可以，继承类可以，类外部不可以 | | 
| private | 类内可以，继承类不行，外部也不行 | 其实继承类有，但是不可访问，看上去像未继承一样。此处和C++一样 |
| | 上述三个是控制访问可见的，而不是控制是否继承的。 | |
| extends | 继承 | |
| implements | 实现接口 | 	接口声明函数，由实现类具体实现 | 
| abstract | 抽象类 | 	不可实例化，和C++一样 | 
| final | 禁止继承的方法 | 	放在方法function前面，和C++放函数名后面不一样 |
| parent | 父类 | |
| | 注意变量的问题。 | |
| | 比如父类子类均有函数： |
| | function myEcho(){ |
| | echo "Father name is " . $this->name . " he." //父类实现 |
| | echo "Child name is " . $this->name . " he." //子类实现 |
| | } |
| | 此时调用父类的myEcho，会输出：Father name is ［子类名］ he。 |
| static | 静态变量 | | 
| this | 当前实例 | **不可引用静态属性或者方法** |
| self | 类本身 | 通常访问静态成员 |
| instanceof | 查看一个实例是否是一个类的对象 if($b instanceof B ) | |

###1.6、异常
```PHP
try {} catch(){}
try{
	throw new Exception("description", 333);
}catch(Exception $e)
{
	echo "exception";
}
```
* 可以接多个catch块，处理不同的异常以及自定义异常
* 所有异常均继承自Exception基类

#####Exception基类

| 函数 | 说明 | 解释 |
| -  ||
| getcode()| 	构造时错误码 | | 
| getMessage()| 	构造时错误信息 | | 
| getFile()| 	异常代码所在文件 | | 
| getLine()| 	异常代码行数 | | 
| getTrace()| 	异常代码回退路径信息 | | 
| getTraceAsString()| 	也是回退路径信息，但是转化为字符串 | | 
|  需要注意的是，上述方法都是final，也就是说不可以继承重载。| 
| _toString() | 同打印类信息 | | 
| self_func |	自定义方法 | |
原则
	* try处代码尽量少
	* 不要忘记catch，否则会引起致命错误




[return](README.md)