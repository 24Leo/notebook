## grep：查找并打印
```linux
grep [-acinorvw] [--color=auto] '搜寻字符串' filename/*.*
选项与参数：
-a ：将 binary 文件以 text 文件的方式搜寻数据
-c ：计算找到 '搜寻字符串' 的次数
-i ：忽略大小写的不同，所以大小写视为相同
-n ：顺便输出行号
-o ：只显示正则表达式匹配的部分
-r ：递归的读取目录下的所有文件，包括子目录。
-v ：反向选择，亦即显示出没有 '搜寻字符串' 内容的那一行！
-w ：精确匹配单词
--color=auto ：可以将找到的关键词部分加上颜色的显示！
```
##find：在目录结构中搜索文件，并执行指定的操作
**格式：find pathname [-para] [options]**
* pathname：路径。用.来表示当前目录，用/来表示系统根目录。
* para：
* -print：将结果输出到标准输出
* -exec:对匹配的文件执行该参数所给出的shell命令
    * 相应命令的形式为'command' { } \;，注意{ }和\;之间的空格。
* -ok：与exec同，但每次都会让用户确认
* options:

```C
-name 按照文件名查找文件。
-perm 按照文件权限来查找文件。
-prune 不在当前指定的目录中查找，如果同时使用-depth选项，那么-prune将被find命令忽略。
-user 按照文件属主来查找文件。
-group 按照文件所属的组来查找文件。
-mtime -n +n 按照文件的更改时间来查找文件，
- n表示文件更改时间距现在n天以内，+n表示文件更改时间距现在n天以前。
-nogroup 查找无有效所属组的文件，即该文件所属的组在/etc/groups中不存在。
-nouser 查找无有效属主的文件，即该文件的属主在/etc/passwd中不存在。
-newer file1 ! file2 查找更改时间比文件file1新但比文件file2旧的文件。
-type 查找某一类型的文件，诸如：
    b - 块设备文件。
    d - 目录。
    c - 字符设备文件。
    p - 管道文件。
    l - 符号链接文件。
    f - 普通文件。
-size n：[c] 查找文件长度为n块的文件，带有c时表示文件长度以字节计。
-depth：在查找文件时，首先查找当前目录中的文件，然后再在其子目录中查找。
-fstype：查找位于某一类型文件系统中的文件
-mount：在查找文件时不跨越文件系统mount点。
-follow：如果find命令遇到符号链接文件，就跟踪至链接所指向的文件。
-cpio：对匹配的文件使用cpio命令，将这些文件备份到磁带设备中。
另外,下面三个的区别:
-amin n 查找系统中最后N分钟访问的文件
-atime n 查找系统中最后n*24小时访问的文件
-cmin n 查找系统中最后N分钟被改变文件状态的文件
-ctime n 查找系统中最后n*24小时被改变文件状态的文件
-mmin n 查找系统中最后N分钟被改变文件数据的文件
-mtime n 查找系统中最后n*24小时被改变文件数据的文件
```
* 实例
    * find . -name "*.log" ：当前目录下以log为后缀的所有文件
    * find /opt/soft/test/ -perm 777 ：权限为777的文件
    * find . -type f -name "*.log" ：查找当目录，以.log结尾的普通文件
    * find . -name '*.html' -exec grep 'mailto:'{}：查找字符串
    * find . -size +1000000c -print 查找当前目录下大于1000000字节的文件
    * find . -size+7M -print 查找大于7M 的文件
    *  find . -type f -exec ls -a {} \


###lsof：显示系统打开的文件（linux一切都是文件）
```C
lsof语法格式是：
lsof ［options］ [filename]

lsof abc.txt 显示开启文件abc.txt的进程
lsof -c abc 显示abc进程现在打开的文件
lsof -c -p 1234 列出进程号为1234的进程所打开的文件
lsof -g gid 显示归属gid的进程情况
lsof +d /usr/local/ 显示目录下被进程开启的文件
lsof +D /usr/local/ 同上，但是会搜索目录下的目录，时间较长
lsof -d 4 显示使用fd为4的进程
lsof -i 用以显示符合条件的进程情况
lsof -i[46] [protocol][@hostname|hostaddr][:service|port]
46 --> IPv4 or IPv6
protocol --> TCP or UDP
hostname --> Internet host name
hostaddr --> IPv4地址
service --> /etc/service中的 service name (可以不止一个)
port --> 端口号 (可以不止一个)
```

###more、less、cat、head、tail
```C
cat：
1. 显示文件
2. 创建文件。不能修改，只能创建
3. 合并多个文件为一个.注意清空原文件。
    -A, --show-all 等价于 -vET
    -b, --number-nonblank 对非空输出行编号
    -e 等价于 -vE
    -E, --show-ends 在每行结束处显示 $
    -n, --number 对输出的所有行编号
    -s, --squeeze-blank 不输出多行空行
    -t 与 -vT 等价
    -T, --show-tabs 将跳格字符显示为 ^I
    -u (被忽略)
    -v, --show-nonprinting 使用 ^ 和 M- 引用，除了 LFD 和 TAB 之外
    --help 显示此帮助信息并离开
    >/>> [filename] 新建文件或向文件添加内容

more：根据窗口的大小进行分页显示，然后还能提示文件的百分比；类似cat：一个全显示，一个按页显示
    +num 从第num行开始显示；
    -num 定义屏幕显示num行；
    +/pattern 从pattern 前两行开始显示；
    -c 从顶部清屏然后显示；
    -d 提示Press space to continue, 'q' to quit.（按空格键继续，按q键退出），禁用响铃功能；
    -l 忽略Ctrl+l （换页）字符；
    -p 通过清除窗口而不是滚屏来对文件进行换页。和-c参数有点相似；
    -s 把连续的多个空行显示为一行；
    -u 把文件内容中的下划线去掉退出more的动作指令是q
    Enter 向下n行，需要定义，默认为1行；
    Ctrl+f 向下滚动一屏；
    空格键 向下滚动一屏；
    Ctrl+b 返回上一屏；
    = 输出当前行的行号；
    :f 输出文件名和当前行的行号；
    v 调用vi编辑器；

less：对文件或其它输出进行分页显示，加强版more：可以前后滚动、查找
    -M 显法读取文件的百分比、行号及总行数；
    -N 在每行前输出行号；
    -p pattern 搜索pattern；比如在/etc/profile搜索单词MAIL，就用 less -p MAIL /etc/profile
    -s 把连续多个空白行作为一个空白行显示；
    -Q 在终端下不响铃；
    回车键/j 向下移动一行；
    y/k 向上移动一行；
    f／空格键 向下滚动一屏；
    b 向上滚动一屏；
    d 向下滚动半屏；
    h less的帮助；
    u 向上洋动半屏；
    g 跳到第一行；
    G 跳到最后一行；
    p n% 跳到n%，比如 10%，也就是说比整个文件内容的10%处开始显示；
    /字符串：向下搜索“字符串”的功能
    ?字符串：向上搜索“字符串”的功能
    v 调用vi编辑器编辑该文件；
    q 退出less
    !command 调用SHELL，可以运行命令；比如!ls 显示当前列当前目录下的所有文件；


head：显示文件内容的前几行
head -n 行数值 文件名；
tail：显示文件内容的最后几行
tail -n 行数值 文件名；
    注意tail有个－f参数，可以实时看到新插入的内容，如日志文件。
```
##压缩tar
```C
tar [params] desc-name dir/files
选项与参数：
    -c ：创建打包文件，可搭配 -v 来察看过程中被打包的档名(filename)
    -t ：查看tarfile里的文件
    -x ：解打包或解压缩的功能，可以搭配 -C (大写) 在特定目录解开
特别留意的是， -c, -t, -x 不可同时出现在一串命令列中。
    -j ：通过 bzip2 的支持进行压缩/解压缩：此时文件名最好为 *.tar.bz2
    -z ：通过 gzip 的支持进行压缩/解压缩：此时文件名最好为 *.tar.gz
    -v ：在压缩/解压缩的过程中，将正在处理的文件名显示出来
    -f filename：-f 后面要立刻接要被处理的文件名！建议 -f 单独写一个选项
    -C 目录 ：这个选项用在解压缩，若要在特定目录解压缩，可以使用这个选项。
    -p ：保留备份数据的原本权限与属性，常用於备份(-c)重要的配置文件
    -P ：保留绝对路径，亦即允许备份数据中含有根目录存在之意；
    --exclude=FILE：在压缩的过程中，不要将 FILE 打包

实例一：将这个/etc目录下的文件全部打包成 /home/etc.tar
tar -cvf etc.tar /etc　　　　 -->> 这个命令只是用来打包，不进行压缩
tar -zcvf etc.tar /etc　　　 -->> 打包以后，使用gzip 对其进行压缩
tar -jcvf etc.tar /etc　　　　-->> 打包以后，使用bzip2 对其进行压缩
# 特别注意，在参数 f 之后的档案档名是自己取的，我们习惯上都用 .tar 来作为标识。
# 如果加 z 参数，则以 .tar.gz 或 .tgz 来代表 gzip 压缩过的 tar file
# 如果加 j 参数，则以 .tar.bz2 来作为扩展名

实例二：查看上述etc.tar 文件里有哪些内容
[root@xiaoluo ~]# tar -ztvf etc.tar
# 由于我们使用 gzip 压缩，所以要查阅该 tarfile 内的文件时，
# 就得要加上 z 这个参数

实例三：将etc.tar 文件解压缩到当前目录下
tar -zxvf etc.tar
# 此时我们可以发现当前目录下已经有了一个etc的文件夹，里面就是我们解压缩出来的文件

实例四：如果我只是希望将 etc.tar 中的 etc/passwd 解压出来
tar -zxvf etc.tar etc/passwd
# 我可以通过 tar -ztvf 来查阅 tarfile 内的文件名，如果单只要一个文件，
# 就可以通过这个方式来完成。注意到！ etc.tar.gz 内的根目录 / 不见了

实例五：备份/etc 内的所有文件，并且保存其权限
tar -zcvpf etc.tar.gz /etc/
# 这个 -p 的属性是很重要的，尤其是当您要保留原本文件的属性时

实例六：在/home 中，比2013/04/01 新的文件就进行备份
tar -N '2013/04/01' -zcvf home.tar /home

实例七：我要备份/home,/etc的所有文件，但是不要备份/home/xiaoluo 这个目录下的文件
tar --exclude /home/xiaoluo -zcvf myfile.tar.gz /home/* /etc
```
##sed
sed一次处理一行文件并把输出送往屏幕。sed把当前处理的行存储在临时缓冲区中，称为**模式空间(pattern space)**。一旦sed完成对模式空间中的行的处理，模式空间中的行就被送往屏幕。行被处理完成之后，就被移出模式空间，程序接着读入下一行，处理，显示，移出......文件输入的最后一行被处理完以后sed结束。通过存储每一行在临时缓冲区，然后在缓冲区中操作该行，**保证了原始文件不会被破坏**。
**两个原则：**
    * 大多以单字符命令开始
    * 多数字符命令前可加目标范围地址

| 参数 | 作用 | 解释 |
| - | - | - |
| i、a | 前插、后插 | 一行之前、之后 |
| s | 替换 | 第一个,加g本全替换指定字符串 ｜
| p | 打印 |  |
| d | 删除 | 	|
| c | 新文本替换 | 范围内整体换成某个字符串 |
| g | 全局标记 | |
| $ | 最后一行常量 |  |
| & | 前面匹配的内容（正则表达式） |  |
| ======== | = | = |
| n | 安静模式 | 原来输出所有，现在仅输出符合命令处理的行 |
|e | 可以后接多个命令 | |
| f | 执行该文件内sed命令| |
| i | 直接修改文件内容 | 慎用.mac系统强制备份。可以在i后面加一个‘fname’参数为空也可以|
| , | 约定范围。 | 不仅可以数值之间如1,3，也可以匹配行：3,／^test/。即3行到test开头的行 |
```shell
sed 's/^/HELL&' temp.txt
sed -n 's/hello/HELL' temp.txt
sed -n '1,$s/hello/HELL/g' temp.txt 这两个全局替换。一个默认，一个指定g（每一行默认还是第一个替换，但是加g后，每一行全部替换。效果就是全文替换）
上面 ‘／’只是分隔符号，换成其他也可以
sed -n '/ruby/p' ab    #查询包括关键字ruby所在所有行
ßsed -n '/\$/p' ab        #查询包括关键字$所在所有行，使用反斜线\屏蔽特殊含义。删除即变p为d
sed '/./{s/^/HEAD&/;s/$/&TAIL/}' test.file   每一行行首加HEAD，行尾加TAIL
sed '/test/,/west/s/$/aaa bbb/' file    对于模板test和west之间的行，每行的末尾用字符串aaa bbb替换
```
[sed参考](http://man.linuxde.net/sed)

##awk 按行处理
三段函数
awk [para] 'BEGIN{} {command-list} END{}' file

| 参数 | 作用 | 解释 |
| - | - | - |
| F | 指定原文件分隔符，默认空格 |  |
| v | 引入外部变量 |  ｜
| f | 脚本中读入命令 |  |
| =  | = | = |
| $0、$n | 整行字符串，第n个子段，默认空格分割，或F指定分隔符 |  |
| NF | 字段总数，$NF最后一个字符段 ||
| NR | 当前行数 ||
| OFS | 输出时字段间分隔符，默认空格 ||
| =  != | 等于、不等于 | |
| ~ !~ | 匹配 、 不匹配||
| &&   \|\| | 逻辑与、或 | |
| re | 支持正则 ||
例子

| 命令 | 作用 | 解释 |
| - | - | - |
| awk  -F: '{print $1,$3,$6}' OFS="\t" /etc/passwd | //输出字段1,3,6，分隔符，‘：’ 以及‘\t’ ||
| awk '!/mysql/{print $0}' /etc/passwd  | 输出不匹配mysql的行 ||
| awk -F":" '{if($1=="mysql") print $3}' /etc/passwd | 第一个子段mysql，则输出第三个 ||
-F[: ]表示指定分隔符可以是:或者 （空格） 这里指定多个分隔符,如果后缀+代表多个如awk -F '[: ]+'
[awk参考](http://man.linuxde.net/awk)

##sort
* sort [params] filename。将处理结果显示到标准输出。**原始文件不变**

| 参数 | 作用 | 解释 |
| - | - | - |
| u | 输出时去除重复行 |  |
| r | 逆序排序输出 |  |
| o | 写入原文件 | >符号不可以写入原文件。唯一优势 |
| n | 按数值排序 | 10比2小 |
| t | 设置间隔符 | 与k参数一起使用 |
| k | kn 比较第n个列 | 第几个列，t设置的间隔符分割列 |
|  综合使用：sort -t ‘ ‘ -k 3nr -k 2n facebook.txt | 空格分割；第三列按数值逆序排列，相同按第二列排 |
| sort -t ‘：‘ -k 1.2 facebook.txt | 第一列第二个字符排序 ||
其他高级应用参考：
[sort参考](http://www.cnblogs.com/xudong-bupt/p/3721984.html)



[return](README.md)