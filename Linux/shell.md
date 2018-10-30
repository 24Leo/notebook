### shell 参数
    •$n        $1 the first parameter,$2 the second... 
    •$#        The number of command-line parameters. 
    •$0        The name of current program. 
    •$?        Last command or function's return value. 
    •$$        The program's PID. 
    •$!        Last program's PID. 
    •$@        Save all the parameters.

##SHELL if 命令参数说明

    •–b 当file存在并且是块文件时返回真 
    •-c 当file存在并且是字符文件时返回真 
    •-d 当pathname存在并且是一个目录时返回真 
    •-e 当pathname指定的文件或目录存在时返回真 
    •-f 当file存在并且是正规文件时返回真 
    •-g 当由pathname指定的文件或目录存在并且设置了SGID位时返回为真 
    •-h 当file存在并且是符号链接文件时返回真，该选项在一些老系统上无效 
    •-k 当由pathname指定的文件或目录存在并且设置了“粘滞”位时返回真     
    •-p 当file存在并且是命令管道时返回为真 
    •-r 当由pathname指定的文件或目录存在并且可读时返回为真 
    •-s 当file存在文件大小大于0时返回真 
    •-u 当由pathname指定的文件或目录存在并且设置了SUID位时返回真 
    •-w 当由pathname指定的文件或目录存在并且可执行时返回真。一个目录为了它的内容被访问必然是可执行的。 
    •-o 当由pathname指定的文件或目录存在并且被子当前进程的有效用户ID所指定的用户拥有时返回真。 
## Shell 里面比较字符写法：

•-eq   等于 
•-ne    不等于 
•-gt    大于 
•-lt    小于 
•-le    小于等于 
•-ge   大于等于 
•-z    空串 
•=     两个字符相等 
•!=    两个字符不等 
•-n    非空串

[return](README.md)