
# OS moduler

```python
import os
          os模块包含普遍的操作系统功能。如果你希望你的程序能够与平台无关的话，这个模块是尤为重要的。```

## Built_in  function

```python
os.name
        输出字符串指示正在使用的平台。如果是window 则用'nt'表示，对于Linux/Unix用户，它是'posix'。
os.uname()
        详细信息
os.environ
        系统环境变量
os.environ.get('key')
        返回某个系统变量
os.getcwd()
        函数得到当前工作目录，即当前Python脚本工作的目录路径。
os.mkdir()
        创建目录
os.makedirs('dirname1/dirname2') 
        可生成多层递归目录
os.rmdir()
        删除目录
os.listdir()
        返回指定目录下的所有文件和目录名,包括隐藏文件，并以列表方式打印。
        Linux 正常
        window  os.listdir('C:\\Users\\leo')。注意转义字符
os.remove()
        删除一个文件。
os.rename(old,new)
        重命名
os.remove()
        删除文件
os.chdir(dirname)
        把当前工作目录切换到dirname下
os.tmpfile() 
        创建并打开‘w+b'一个新的临时文件
os.access('pathfile',os.W_OK) 
        检验文件权限模式，输出True，False
os.chmod('pathfile',os.W_OK) 
        改变文件权限模式
os.chown(path,uid,gid)
        改变文件的属主
os.system()
        运行shell命令。
os.sep 
        操作系统特定的路径分割符。
os.linesep
        字符串给出当前平台使用的行终止符
os.symlink(src,dst)
        创建符号链接
os.readlink(path)
        返回path这个符号链接所指向的路径
os.path.split()
        函数返回一个路径的目录和文件名
os.path.splitext():
        分离文件名与扩展名
os.path.isfile()
os.path.isdir()
        函数分别检验给出的路径是一个文件还是目录。
os.path.isabs(path) 
        如果path是绝对路径，返回True
os.path.normpath(path) 
        规范化路径
os.path.getatime(path) 
        返回path所指向的文件或者目录的最后存取时间
os.path.getmtime(path) 
        返回path所指向的文件或者目录的最后修改时间
os.path.exists()
        函数用来检验给出的路径是否真地存在
os.path.abspath(name):
        获得绝对路径
os.path.normpath(path):
        规范path字符串形式
os.path.getsize(name):
        获得文件大小，如果name是目录返回0L
os.path.join(path,name):
        连接目录与文件名或目录
os.path.basename(path):
        返回文件名
os.path.getsize()
        文件大小
os.path.dirname(path):
        返回文件路径
os.stat(file,struct stat)
        获取文件属性
os.walk(dir)
        遍历：返回的是一个三元tupple(dirpath, dirnames, filenames),
```

#路径和文件相关
##OS
```python
mkdir(path)         创建新目录，path为一个字符串，表示新目录的路径。相当于$mkdir命令
rmdir(path)         删除空的目录，path为一个字符串，表示想要删除的目录的路径。相当于$rmdir命令
listdir(path)       返回目录中所有文件。相当于$ls命令。
remove(path)        删除 path指向的文件。
rename(src, dst)    重命名文件，src和dst为两个路径，分别表示重命名之前和之后的路径。
chmod(path, mode)   改变path指向的文件的权限。相当于$chmod命令。
chown(path, uid, gid) 改变path所指向文件的拥有者和拥有组。相当于$chown命令。
stat(path)          查看path所指向文件的附加信息，相当于$ls -l命令。
symlink(src, dst)   为文件dst创建软链接，src为软链接文件的路径。相当于$ln -s命令。
getcwd()            查询当前工作路径 (cwd, current working directory)，相当于$pwd命令。
rename(old,new)
remove(file)
```
```python

文件处理
    mkfifo()/mknod() —— 创建命名管道/创建文件系统节点
    remove()/unlink() —— 删除文件
    rename()/renames() —— 重命名文件
    stat() —— 返回文件信息
    symlink() —— 创建符号链接
    utime() —— 更新时间戳
    tmpfile() —— 创建并打开('w'+'b')一个新的临时文件
    walk() —— 生成一个目录树下的所有文件名

目录/文件夹
    chdir() —— 改变当前工作目录
    chroot() —— 改变当前进程的根目录
    listdir() —— 列出指定目录的文件
    getcwd() —— 返回当前工作目录
    mkdir()/makedirs() —— 创建目录/创建多层目录
    rmdir()/removedirs() —— 删除目录/删除多层目录

 访问/权限
    access() —— 检验权限模式
    chmod() —— 改变权限模式
    chown() —— 改变owner和GID，但不会跟踪链接
    umask() —— 设置默认权限模式

文件描述符操作
    open() —— 打开文件
    read() / write() —— 读取/写入文件

os.path 模块的文件/目录访问函数

分隔
    basename() —— 去掉目录路径，返回文件名
    dirname() —— 去掉文件名，返回目录路径
    join() —— 将分离的各部分组合成一个路径名
    split() —— 返回（dirname(),basename()）元组
    splitdrive() —— 返回（drivename，pathname）元组
    splitext —— 返回（filename，extension）元组

信息
    getatime() —— 返回最近访问时间
    getctime() —— 返回文件创建时间
    getmtime() —— 返回最近文件修改时间
    getsize() —— 返回文件大小（以字节为单位）

查询
    exists() —— 指定路径（文件或目录）是否存在
    isabs() —— 指定路径是否为绝对路径
    isdir() —— 指定路径是否存在且为一个目录
    isfile() —— 指定路径是否存在且为一个文件
    islink() —— 指定路径是否存在且为一个符号链接
    ismount —— 指定路径是否存在且为一个挂载点
    samefile —— 两个路径名是否指向同一个文件
```

##os.path
```python
import os.path
path = '/home/vamei/doc/file.txt'
print(os.path.basename(path))    # 查询路径中包含的文件名
print(os.path.dirname(path))     # 查询路径中包含的目录
info = os.path.split(path)       # 将路径分割成文件名和目录两个部分，放在一个表中返回
path2 = os.path.join('/', 'home', 'vamei', 'doc', 'file1.txt')  # 使用目录名和文件名构成一个路径字符串
p_list = [path, path2]
os.path.isfile()/isdir()
os.path.basename()
os.path.getsize()
print(os.path.commonprefix(p_list))    # 查询多个路径的共同部分
此外，还有下面的方法：
os.path.normpath(path)   # 去除路径path中的冗余。比如'/home/vamei/../.'被转化为'/home'

import os.path 
path = '/home/vamei/doc/file.txt'
print(os.path.exists(path))    # 查询文件是否存在
print(os.path.getsize(path))   # 查询文件大小
print(os.path.getatime(path))  # 查询文件上一次读取的时间
print(os.path.getmtime(path))  # 查询文件上一次修改的时间
print(os.path.isfile(path))    # 路径是否指向常规文件
print(os.path.isdir(path))     # 路径是否指向目录文件```


##shutil
```python
copy(src, dst) 复制文件，从src到dst。相当于$cp命令。
move(src, dst) 移动文件，从src到dst。相当于$mv命令。
shutil.copytree(src,dst[,symlinks])  复制目录
shutil.rmtree(path[,ignore_errors[,onerror]])   删除文件夹

copy.copy 浅拷贝 只拷贝父对象，不会拷贝对象的内部的子对象。
copy.deepcopy 深拷贝 拷贝对象及其子对象
        copy.copy(a)          #浅拷贝。相当于c与a现在是两个单独的内存区域
        copy.deepcopy(a)      #深拷贝。相当于是完全独立的内存区域```
**例子：**
```python
sys.argv是一个列表，保存了python程序的命令行参数。其中 sys.argv[0]是程序本身的名字
1、把一个指定目录下的所有文件拷贝到另一个目录中
    import sys,os,shutil
    for file in os.listdir(sys.argv[1]):
        shutil.copy(os.path.join(sys.argv[1],file),sys.argv[2])
        
2、把一个文件夹下的所有文件重命名成 10001～10999
    import sys,os
    dirname = sys.argv[1]
    i = 10001
    for file in os.listdir(dirname):
        src = os.path.join(dirname,file)
        if os.path.isdir(src):
            coutinue
        os.rename(src,str(i))
        i+=1
```


[返回目录](README.md)