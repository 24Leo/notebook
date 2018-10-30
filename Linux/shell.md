##$
1. $$
 * Shell本身的PID（ProcessID）
1. $! 
 * Shell最后运行的后台Process的PID
1. $?
 * 最后运行的命令、函数的结束代码（返回值）
1. $-
 * 使用Set命令设定的Flag一览
1. $*
 * 所有参数列表。如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。
1. $@
 * 所有参数列表。如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。
1. $#
 * 添加到Shell的参数个数
1. $0
 * Shell本身的文件名
1. $1～$n
 * 添加到Shell的各参数值。$1是第1参数、$2是第2参数…


### shell 参数
•$n        $1 the first parameter,$2 the second... 
•$#        The number of command-line parameters. 
•$0        The name of current program. 
•$?        Last command or function's return value. 
•$$        The program's PID. 
•$!        Last program's PID. 
•$@        Save all the parameters.

almost any shell book will talk about them,from which you can get their detail usages.

2    Linux SHELL if 命令参数说明

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
UNIX Shell 里面比较字符写法：

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