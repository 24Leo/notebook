* array_merge 一个非数组时会报php-warning，不会终止程序执行。但是结果不是我们想象的：null。。。
    * 如果要结果就需要```array_merge($srcArr, array($var))```;
    * 总结：无论**变量为null，还是未定义，还是参数是非数组字符串**都不会发生致命错误，程序不会崩溃，但是结果和你使用array_merge这个函数的初衷向背，合并之后竟然成了**null**，数组$arr1中的信息都没有了，这肯定是不对的！


[return](README.md)