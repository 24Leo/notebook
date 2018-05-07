##PSR总览
* php类名大写驼峰，方法小写驼峰，常量字母大写分隔符分割。
    * 方法名大小写不区分，类名、常量敏感
    * 类名可能包含目录，分隔符就会转化
* 类、函数、结构体语句等关键字和左括号有空格，左右括号内没有空格，右括号右边和中括号有空格。

     
PSR是由PHP Framework Interoperablity Group（FIG，PHP通用性框架小组）发布的一系列标准／规范。目前共包括5个规范
    * PSR0：自动加载规范，现在已被PSR4“取代”；
    * PSR1：基本代码书写规范
    * PSR2：代码样式
    * PSR3：日志接口
    * PSR4：PSR0补充和更新

##PSR0－已标记“deprecated
####强制规范（mandatory requirements）：
     * 每个规范的命名空间和类名满足：```\<Vendor Name>\(<Namespace>\)*<Class Name>```
     * 每个命名空间必须有顶层命名空间（“vendor name“）
     * 每个命名空间可以有多个子命名空间
     * 从文件系统加载文件时：命名空间中反斜线‘\’会转化为目录文件分隔符DIRECTORY_SEPARATOR
     * 加载时：类名中下划线‘_’会转化为目录分隔符
     * 加载时整个名字以'.php'结尾
     * 顶层空间名、命名空间、类名等可以任何大小写字母组合

####代码实现
官方提供[简单例子](http://gist.github.com/221634)
```php
//例子
\namespace\package_name\Class_Name=>/path/to/project/lib/vendor/namespace/package_name/Class/Name.php
<?php
function autoload($className)
{
    $className = ltrim($className, '\\');
    $fileName  = '';
    $namespace = '';
    if ($lastNsPos = strrpos($className, '\\')) {
        $namespace = substr($className, 0, $lastNsPos);
        $className = substr($className, $lastNsPos + 1);
        $fileName  = str_replace('\\', DIRECTORY_SEPARATOR, $namespace) . DIRECTORY_SEPARATOR;
    }
    $fileName .= str_replace('_', DIRECTORY_SEPARATOR, $className) . '.php';

    require $fileName;
    
    //由于autoloader stack逻辑，所以添加返回如下：
    $filePath  = stream_resolve_include_path($fileName);
    if ($filePath) {
        require $filePath;
    }
    return $filePath !== false;
}
spl_autoload_register('autoload');
```
##[PSR1](https://segmentfault.com/a/1190000002521577)
####强制规范（mandatory requirements）：
     * PHP代码必须以标签```<?php、<?= ```开始；其他均不可以！
     * PHP代码必须以 不带BOM的UTF－8编码；
          * Byte Order Marker：用来标记多字节文件编码和排序。在文件头部，不可见，编辑器自动处理。
          * Linux不用，window推荐。所以注意跨平台问题；
     * 一个PHP文件要么用来声明类、函数、常量，要么产生从属效应操作；二者选一
          * 从属效应操作：产生输出、直接require／include原文件、链接外部服务、修改ini文件、抛出异常、修改全局或静态变量、读写文件；
     * 命名空间和类必须符合PSR0、PSR4规范
     * 类命名规范：大写驼峰，即每个单词首字母大写
     * 方法命名规范：小写驼峰，即首个单词字母小写，其他单词首字母大写
     * 常量命名规范：所有字母大写，下划线分隔；
     
     * 变量命名规范：团队自定 ，可以大、小驼峰、下划线分割   
     * **变量区分大小写，函数不区分大小写**
     
####代码实现
```php
<?php
// 从属效应：修改 ini 配置
ini_set('error_reporting', E_ALL);

// 从属效应：引入文件
include "file.php";

// 从属效应：生成输出
echo "<html>\n";

// 声明函数
function foo()
{
    // 函数主体部分
}

// PHP 5.3及以后版本的写法
namespace Vendor\Model;
class Foo
{
}
// 5.2.x及之前版本的写法
class Vendor_Model_Foo
{
}
```

##[PSR2](https://segmentfault.com/a/1190000002521620)
####强制规范（mandatory requirements）：
     * 符合PSR1标准
     * 必须使用4个空格键而不是tab键
     * 每个namespace、use块后必须插入一个空格行
     * 类、函数开始花括号｛ 后自成一行，结束花括号｛ 也自成一行。和百度不同
     * 类的属性、函数必须添加访问修饰符，abstract、final必须在修饰符前，而static必须在之后
     * 控制结构关键字后必须有空格，但是左小括号后、右小括号前一定不能有空格
     * 控制结构开始花括号在同一行，结束花括号自成一行。且开始花括号与右小括号必须有空格
     * 
 
####代码实现
```php
namespace Vendor\Package;

use FooInterface;
use BarClass as Bar;
use OtherVendor\OtherPackage\BazClass;  //以use代码块为单位

class Foo extends Bar implements FooInterface
{
    public function sampleFunction($a, $b = null)    // 百度规范：｛ 同行
    {
        if ($a === $b) {
            bar();
        } elseif ($a > $b) {
            $foo->bar($arg1);
        } else {
            BazClass::bar($arg2, $arg3);
        }
    }

    final public static function bar()
    {
        // method body
    }
}
```
####其他不同
    * 文件必须以Unix LF作为行结束符；
    * 所有PHP文件必须以一个空行结束。纯PHP代码一定不能添加?>结束标记
    * 每行长度一定不能有规定，但是大概80～120个字符较好。
    * PHP关键字必须小写：true、false、null
    * 函数参数可以写多行、默认参数写在最后。右小括号一定与开始花括号一行
    * 实现多个接口时：也可以多行，但也是第一个就要新启一行。

```php
     public function aVeryLongMethodName(
        ClassTypeHint $arg1,
        &$arg2,
        array $arg3 = []
    ) {
        // method body
    }
    class ClassName extends ParentClass implements \ArrayAccess, \Countable
    {
        // constants, properties, methods
    }
    class ClassName extends ParentClass implements
        \ArrayAccess,
        \Countable,
        \Serializable
    {
        // constants, properties, methods
    }

```
    
##PSR3
####强制规范（mandatory requirements）：
为了让日志类库以简单通用的方式，通过接收一个 Psr\Log\LoggerInterface 对象，来记录日志信息。
     * 接口对外定义9个方法：前8个对应日志等级（debug、info、notice、warning、error、critical、alert、emergency），第九个是log方法，第一个参数是记录等级常量，必须达到和钱八个之一的效果。
     * 以上方法以字符串类型或者有__toString方法的对象为参数。
     * 记录信息参数可以使用占位符，实现者可以根据上下文参数解析成对应值。
     * 上下文参数用了装载字符串类型无法表示的信息。但一定不能抛出异常、报错等
     * 如果传入Exception对象，上下文参数键为‘exception‘，
     * 助手类：
         * PSR\Log\AbstractLogger类使得继承类只需要实现log方法即可容易地实现LoggerInterface接口，而另外八个方法就能把记录信息和上下文信息传给他。
         * Psr\Log\LogLevel 类装载了八个记录等级常量
         
####代码实现
```php
 namespace Psr\Log;
/**
 * 日志等级常量定义
 */
class LogLevel
{
    const EMERGENCY = 'emergency';
    const ALERT     = 'alert';
    const CRITICAL  = 'critical';
    const ERROR     = 'error';
    const WARNING   = 'warning';
    const NOTICE    = 'notice';
    const INFO      = 'info';
    const DEBUG     = 'debug';
}

interface LoggerInterface
{
    /**
     * 系统不可用
     *
     * @param string $message
     * @param array $context
     * @return null
     */
    public function emergency($message, array $context = array());

    /**
     * **必须**立刻采取行动
     *
     * 例如：在整个网站都垮掉了、数据库不可用了或者其他的情况下，**应该**发送一条警报短信把你叫醒。
     *
     * @param string $message
     * @param array $context
     * @return null
     */
    public function alert($message, array $context = array());

    /**
     * 紧急情况
     *
     * 例如：程序组件不可用或者出现非预期的异常。
     *
     * @param string $message
     * @param array $context
     * @return null
     */
    public function critical($message, array $context = array());

    /**
     * 运行时出现的错误，不需要立刻采取行动，但必须记录下来以备检测。
     *
     * @param string $message
     * @param array $context
     * @return null
     */
    public function error($message, array $context = array());

    /**
     * 出现非错误性的异常。
     *
     * 例如：使用了被弃用的API、错误地使用了API或者非预想的不必要错误。
     *
     * @param string $message
     * @param array $context
     * @return null
     */
    public function warning($message, array $context = array());

    /**
     * 一般性重要的事件。
     *
     * @param string $message
     * @param array $context
     * @return null
     */
    public function notice($message, array $context = array());

    /**
     * 重要事件
     *
     * 例如：用户登录和SQL记录。
     *
     * @param string $message
     * @param array $context
     * @return null
     */
    public function info($message, array $context = array());

    /**
     * debug 详情
     *
     * @param string $message
     * @param array $context
     * @return null
     */
    public function debug($message, array $context = array());

    /**
     * 任意等级的日志记录
     *
     * @param mixed $level
     * @param string $message
     * @param array $context
     * @return null
     */
    public function log($level, $message, array $context = array());
}
```

##PSR4
####强制规范（mandatory requirements）：
     * 类名大小写敏感
     * 完整类名中，去掉最前面的分隔符。多个连续命名空间作为前缀，而且必须与至少一个“文件基目录”对应
     * 对应后，命名空间分隔符变成目录分隔符。前缀替换 
     * 末尾的类名加上.php必须与文件名一样。所以大小写敏感 
     * 自动加载一定不能抛出异常、产生错误以及不应该有返回值。
 
####转化
|完整类名|命名空间前缀|文件基目录|文件路径|
|-|-|-|-|
|\Acme\Log\Writer\File_Writer|Acme\Log\Writer|	./acme-log-writer/lib/|./acme-log-writer/lib/File_Writer.php|
|\Aura\Web\Response\Status|Aura\Web|/path/to/aura-web/src/|/path/to/aura-web/src/Response/Status.php|
|\Zend\Acl|Zend|/usr/includes/Zend/|/usr/includes/Zend/Acl.php|
####代码实现
```php

namespace Example;

class Psr4AutoloaderClass
{
    /**
     * An associative array where the key is a namespace prefix and the value
     * is an array of base directories for classes in that namespace.
     *
     * @var array
     */
    protected $prefixes = array();

    /**
     * Register loader with SPL autoloader stack.
     * 
     * @return void
     */
    public function register()
    {
        spl_autoload_register(array($this, 'loadClass'));
    }

    /**
     * Adds a base directory for a namespace prefix.
     *
     * @param string $prefix The namespace prefix.
     * @param string $base_dir A base directory for class files in the
     * namespace.
     * @param bool $prepend If true, prepend the base directory to the stack
     * instead of appending it; this causes it to be searched first rather
     * than last.
     * @return void
     */
    public function addNamespace($prefix, $base_dir, $prepend = false)
    {
        // normalize namespace prefix
        $prefix = trim($prefix, '\\') . '\\';

        // normalize the base directory with a trailing separator
        $base_dir = rtrim($base_dir, '/') . DIRECTORY_SEPARATOR;
        $base_dir = rtrim($base_dir, DIRECTORY_SEPARATOR) . '/';

        // initialize the namespace prefix array
        if (isset($this->prefixes[$prefix]) === false) {
            $this->prefixes[$prefix] = array();
        }

        // retain the base directory for the namespace prefix
        if ($prepend) {
            array_unshift($this->prefixes[$prefix], $base_dir);
        } else {
            array_push($this->prefixes[$prefix], $base_dir);
        }
    }

    /**
     * Loads the class file for a given class name.
     *
     * @param string $class The fully-qualified class name.
     * @return mixed The mapped file name on success, or boolean false on
     * failure.
     */
    public function loadClass($class)
    {
        // the current namespace prefix
        $prefix = $class;

        // work backwards through the namespace names of the fully-qualified
        // class name to find a mapped file name
        while (false !== $pos = strrpos($prefix, '\\')) {

            // retain the trailing namespace separator in the prefix
            $prefix = substr($class, 0, $pos + 1);

            // the rest is the relative class name
            $relative_class = substr($class, $pos + 1);

            // try to load a mapped file for the prefix and relative class
            $mapped_file = $this->loadMappedFile($prefix, $relative_class);
            if ($mapped_file) {
                return $mapped_file;
            }

            // remove the trailing namespace separator for the next iteration
            // of strrpos()
            $prefix = rtrim($prefix, '\\');   
        }

        // never found a mapped file
        return false;
    }

    /**
     * Load the mapped file for a namespace prefix and relative class.
     * 
     * @param string $prefix The namespace prefix.
     * @param string $relative_class The relative class name.
     * @return mixed Boolean false if no mapped file can be loaded, or the
     * name of the mapped file that was loaded.
     */
    protected function loadMappedFile($prefix, $relative_class)
    {
        // are there any base directories for this namespace prefix?
        if (isset($this->prefixes[$prefix]) === false) {
            return false;
        }

        // look through base directories for this namespace prefix
        foreach ($this->prefixes[$prefix] as $base_dir) {

            // replace the namespace prefix with the base directory,
            // replace namespace separators with directory separators
            // in the relative class name, append with .php
            $file = $base_dir
                  . str_replace('\\', DIRECTORY_SEPARATOR, $relative_class)
                  . '.php';
            $file = $base_dir
                  . str_replace('\\', '/', $relative_class)
                  . '.php';

            // if the mapped file exists, require it
            if ($this->requireFile($file)) {
                // yes, we're done
                return $file;
            }
        }

        // never found it
        return false;
    }

    /**
     * If a file exists, require it from the file system.
     * 
     * @param string $file The file to require.
     * @return bool True if the file exists, false if not.
     */
    protected function requireFile($file)
    {
        if (file_exists($file)) {
            require $file;
            return true;
        }
        return false;
    }
}



<?php
namespace Example\Tests;

class MockPsr4AutoloaderClass extends Psr4AutoloaderClass
{
    protected $files = array();

    public function setFiles(array $files)
    {
        $this->files = $files;
    }

    protected function requireFile($file)
    {
        return in_array($file, $this->files);
    }
}
class Psr4AutoloaderClassTest extends \PHPUnit_Framework_TestCase
{
    protected $loader;

    protected function setUp()
    {
        $this->loader = new MockPsr4AutoloaderClass;

        $this->loader->setFiles(array(
            '/vendor/foo.bar/src/ClassName.php',
            '/vendor/foo.bar/src/DoomClassName.php',
            '/vendor/foo.bar/tests/ClassNameTest.php',
            '/vendor/foo.bardoom/src/ClassName.php',
            '/vendor/foo.bar.baz.dib/src/ClassName.php',
            '/vendor/foo.bar.baz.dib.zim.gir/src/ClassName.php',
        ));

        $this->loader->addNamespace(
            'Foo\Bar',
            '/vendor/foo.bar/src'
        );

        $this->loader->addNamespace(
            'Foo\Bar',
            '/vendor/foo.bar/tests'
        );

        $this->loader->addNamespace(
            'Foo\BarDoom',
            '/vendor/foo.bardoom/src'
        );

        $this->loader->addNamespace(
            'Foo\Bar\Baz\Dib',
            '/vendor/foo.bar.baz.dib/src'
        );

        $this->loader->addNamespace(
            'Foo\Bar\Baz\Dib\Zim\Gir',
            '/vendor/foo.bar.baz.dib.zim.gir/src'
        );
    }

    public function testExistingFile()
    {
        $actual = $this->loader->loadClass('Foo\Bar\ClassName');
        $expect = '/vendor/foo.bar/src/ClassName.php';
        $this->assertSame($expect, $actual);

        $actual = $this->loader->loadClass('Foo\Bar\ClassNameTest');
        $expect = '/vendor/foo.bar/tests/ClassNameTest.php';
        $this->assertSame($expect, $actual);
    }

    public function testMissingFile()
    {
        $actual = $this->loader->loadClass('No_Vendor\No_Package\NoClass');
        $this->assertFalse($actual);
    }

    public function testDeepFile()
    {
        $actual = $this->loader->loadClass('Foo\Bar\Baz\Dib\Zim\Gir\ClassName');
        $expect = '/vendor/foo.bar.baz.dib.zim.gir/src/ClassName.php';
        $this->assertSame($expect, $actual);
    }

    public function testConfusion()
    {
        $actual = $this->loader->loadClass('Foo\Bar\DoomClassName');
        $expect = '/vendor/foo.bar/src/DoomClassName.php';
        $this->assertSame($expect, $actual);

        $actual = $this->loader->loadClass('Foo\BarDoom\ClassName');
        $expect = '/vendor/foo.bardoom/src/ClassName.php';
        $this->assertSame($expect, $actual);
    }
}
```




[return](README.md)