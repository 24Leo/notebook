#JS上传文件 
JS 直接操作文件是严格禁止的，HTML5以前都是靠上传按钮来获得许可，然后得到相应的文件信息比如文件名、大小、格式（MIME）等。在点击浏览添加完文件之后，就可以使用如下的javascript代码来获取相应的文件属性了。此处使用了添加事件（change）的方式，当然一旦选择了文件之后，这些属性随时都可以获得

```JS
<form action="do_file_upload.php" method="post" enctype="multipart/form-data"> <!--enctype必须有-->
<input type="file" id="your-files" name="file" multiple>             <!--name比id更重要-->
</form>
<script>
var control = document.getElementById("your-files");
control.addEventListener("change", function(event) {
    // 当 control 改变的时候
    var i = 0,
        files = control.files,                               //所有的文件都在files中
        len = files.length;
    for (; i < len; i++) {
        console.log("Filename: " + files[i].name);
        console.log("Type: " + files[i].type);
        console.log("Size: " + files[i].size + " bytes");
    }
}, false);
</script>
```

注：enctype="multipart/form-data"，是必需的，它告诉FORM这个是一文件上传类型,一旦这次请求成功后，文件就被上传到了服务器的临时文件夹中，至于到达目的地后，文件将会被怎么样处理那就是PHP,JSP,ASP的事了。（WEB早已把文件上传到服务器了，我们只是运用上传处理函数来处理上传的文件。）
用上传文件建立了一个输入流，再建立一个输出流就好了.


文件的上传需要获得文件的访问许可，比如IE需要通过ActiveX控件来获取对本地文件的访问能力，不同的浏览器实现方式不同，所以我们程序就会很复杂，但是FILEAPI彻底改变了这些。  <br>                   **[HTML5-FileAPI](http://blog.csdn.net/testcs_dn/article/details/8695532)**    
**[本地记录](FileAPI.md)**

---


#jQuery插件之ajaxFileUpload
一、ajaxFileUpload是一个异步上传文件的jQuery插件。利用iframe实现无刷新异步提交
    
```JS 
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>  
<script src="../js/ajaxfileupload.js"></script>              <!--注意引用顺序--> ```  

　　语法：```$.ajaxFileUpload([options])```

　　options参数说明：

* 1、url　　　　　　　　　　  上传处理程序地址。　　
* 2，fileElementId　　　　　  需要上传的文件域的ID，即<input type="file">的ID。
* 3，secureuri　　　　　　　 是否启用安全提交，默认为false。 
* 4，dataType　　　　　　　 服务器返回的数据类型。可以为xml,script,json,html。如果不填写，jQuery自动判断。
* 5，success　　　　　　　　提交成功后自动执行的处理函数，参数data就是服务器返回的数据。
* 6，error　　　　　　　　　 提交失败自动执行的处理函数。
* 7，data	　　　　　　　　   自定义参数，当有数据是与上文件相关的时候，这个东西就要用到了
* 8，type	　　　　　　　　　  当要提交自定义参数时，这个参数要设置成post

   ``` JS 
   success: function (data, status){}
   error: function (data, status, e){}<!--data:服务器返回数据，status:服务器状态-->```
    错误提示:

* 1，SyntaxError: missing ; before statement错误　　如果出现这个错误就需要检查url路径是否可以访问
* 2，SyntaxError: syntax error错误
　　如果出现这个错误就需要检查处理提交操作的服务器后台处理程序是否存在语法错误
* 3，SyntaxError: invalid property id错误
　　如果出现这个错误就需要检查文本域属性ID是否存在
* 4，SyntaxError: missing } in XML expression错误
　　如果出现这个错误就需要检查文件name是否一致或不存在
* 5，其它自定义错误
　　大家可使用变量$error直接打印的方法检查各参数是否正确，比起上面这些无效的错误提示还是方便很多

  #####然后后台处理文件即可：Request.Files
#插件：jQuery File Upload 
  这是一个Jquery图片上传组件，支持多文件上传、取消、删除，上传前缩略图预览、列表显示图片大小，支持上传进度条显示；支持各种动态语言开发的服务器端。
  用法：
  ```JS
  $(function () {  
            //文件上传地址  
            //var url = 'http://localhost/index.php/upload/do_upload';  
            var url = 'http://localhost/index.php/uploadwe';  
            //初始化，主要是设置上传参数，以及事件处理方法(回调函数)  
            $('#fileupload').fileupload({  
                autoUpload: true,//是否自动上传  
                //url: url,//上传地址  
                dataType: 'json',  
                done: function (e, data) {//设置文件上传完毕事件的回调函数  
                    //$.each(data.result.files, function (index, file) {  
                    $("#myimg").attr({src:data.result.imgurl});  
                    $("#myimg").css({width:"290px",height:"218px"});  
                    //alert(data.result);  
                },  
                progressall: function (e, data) {//设置上传进度事件的回调函数  
                    var progress = parseInt(data.loaded / data.total * 5, 10);  
                    $('#progress .bar').css(  
                        'width',  
                        progress + '%'  
                    );  
                }  
            });  
        }); ```
 当然你也可以绑定函数来监视上传的过程：
```JS
$('#fileupload')
    .bind('fileuploaddrop', function (e, data) {/* ... */})
    .bind('fileuploadchange', function (e, data) {/* ... */});```
    
    
    

---
本文参考链接：[CSDN](http://blog.csdn.net/jianyi7659/article/details/8708857)

[返回目录](README.md)