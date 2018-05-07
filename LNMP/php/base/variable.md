* PHP同时还支持复合变量，也就是类似$$a的变量，它会进行两次的解释。
* 变量的作用域是使用不同的符号表来实现的
    * 局部、全局。global关键字就是把局部换成读全局的

##第一章 面向对象
* 编程语言3范式：
    * 面向过程如C语言
    * 面向对象如C++、java、C#等
        * 对象、封装、可重用性、可扩展性
            * 复用两个：类级别如多态，函数级别如重载
        * 仅仅是一个设计理念或者一个原则，**和语言无关**
    * 函数式编程
    * 严格来说PHP不是一个纯面向对象语言
* 序列化 及 反序列化
    * 需要包含类定义
    * 字节流保存，方便传输
* 对象
    * 对象包含“属性数组” + “函数数组”，对象和数组可互相转化，不同是对象有一个指针指向它所属的类。
* 魔术方法
    * php的重载：动态的“创建”类的属性和方法。（____set__ __）
        * c++、java重载是把函数和参数一起生成函数表，从而实现重载
    * ____call____：动态创建延迟绑定。通过函数名、**参数数组**调用函数：call_user_func
        * call_user_func：调用指定回掉函数
        * get_called_class：**静态函数**里面返回所属类
* 继承
    * parent、self
    * 继承最好别超过3层，  
    * final、abstract     
* 多态
    * php自身就是多态
    * C++的多态是指：动态执行过程中具体化对象 ==== 同一类型、不同结果
        * 父指针可以指向子对象，而且是虚函数重写
    * PHP通过interface和implements实现    P22
    ```c
    interface emploee{
        const value = 10000;
        public function working();
    }
    class teacher implements emploee {
        public function working() {
            echo "teacher";
        }
    }
    class coder implements emploee {
        public function working() {
            echo "coding is best";
        }
    }
    // 接口是抽象类的变体
    function myPrint(emploee $e) {
        $e->working();
    }
    ```
    * 同一类型、不同结果
        * 其实不管任何一个语言，无非就是查表和判断～
        * 类型转换不是多态！
* 接口
    * 接口里面可以有方法、常量，是一个契约，规定所有实现它的都应该和自己一样
        * 接口什么都不做，仅声明方法、常量
    * 接口就是抽象类的变体，所以接口方法必须全部实现，另外实现类可以额外添加新方法。
        * 额外添加新方法其实是PHP的一个折中，java中若有新的就会报错。
        * 接口就是抽象类的变体，推荐使用抽象类，traits是接口的加强
* 反射
    * 在PHP运行态中，扩展分析PHP程序，获得类、方法、属性等信息。
    ```c
new ReflectionObject(class-obj);
obj->getProperties、obj->getMethods,返回数组
get_object_vars(class-obj)：属性关联数组
get_class_vars(class-obj)：属性
get_class_methods(class-obj)：方法数组
get_class(class-obj)：获得所属类
    ```
* 异常
    * PHP一般主动抛出才会有并普获异常。
    * 用户可以自定义错误处理机制 P40

##第三章 正则
* 


[return](README.md)