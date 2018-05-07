#JS 中this用法
   不管何时：代表函数运行时，自动生成的一个内部对象，只能在函数内部使用。指向的是调用函数的那个对象。
   
1. 
第一种用法：纯粹的函数调用----this代表全局对象Global
    
    ```
    var x=3;
    function test(){ 
　　　　this.x = 1; 
　　　　alert(this.x); 
　　} ```


此时test()，输出 1，屏蔽3

2 作为函数方法调用时，指向调用者
```
    var point = { 
    x : 0, 
    y : 0, 
    moveTo : function(x, y) { 
        this.x = this.x + x; 
        this.y = this.y + y; 
        } 
    }; 
    point.moveTo(1, 1)              //this 绑定到当前对象，即 point 对象```
　　
 
作为函数调用时，this 绑定到全局对象；作为方法调用时，this 绑定到该方法所属的对象


[返回目录](README.md)