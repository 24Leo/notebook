#JQuery-Ajax
1. load()
```JS
$(selector).load(url,data,callback)    //selector加载制定资源并显示 
```
    必需的 URL 参数规定您希望加载的 URL.

    可选的 data 参数规定与请求一同发送的查询字符串键/值对集合.

    可选的 callback 参数是 load() 方法完成后所执行的函数名称。
        callback(responseTxt,statusTxt,xhr) - responseTxt: 包含调用成功时的结果内容; statusTXT:包含调用的状态; xhr:包含 XMLHttpRequest 对象
    
2. get()
    ```JS
$.get(url,[data],[callback])
```
    说明：url为请求地址，data为请求数据的列表，callback为请求成功后的回调函数，该函数接受两个参数，第一个为    服务器返回的数据，第二个参数为服务器的状态，是可选参数。

3.post()
```JS
    $.post(url,[data],[callback],[type])```
   这个函数跟$.get()参数差不多，多了一个type参数，type为返回的数据类型，可以是html,xml,json等类型

4  ajxa()   [参数](http://www.runoob.com/jquery/ajax-ajax.html)
```JS
$.ajax({  
 url: 目标地址, 
 data:{Full:"fu"}, 
 type: "POST", 
 dataType:'json', 
 success:CallBack, 
 error:function(er){ 
 BackErr(er);} 
 });
 
```

5 getJson():    构建数据通讯的桥梁
    
```JS
$.getJSON(url,[data],[callback])
```


);


[返回目录](README.md)