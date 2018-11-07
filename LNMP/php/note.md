* array_merge 一个非数组时会报php-warning，不会终止程序执行。但是结果不是我们想象的：null。。。
    * 如果要结果就需要```array_merge($srcArr, array($var)),或者$result=array_merge((array)$a,(array)$b);```;
    * 总结：无论**变量为null，还是未定义，还是参数是非数组字符串**都不会发生致命错误，程序不会崩溃，但是结果和你使用array_merge这个函数的初衷向背，合并之后竟然成了**null**，数组$arr1中的信息都没有了，这肯定是不对的！
    * 如果key相同后面覆盖前面，如果是数字索引，则从排序而不是覆盖！
        * 如果不想被覆盖：使用‘+’，后面的会被抛弃


[return](README.md)