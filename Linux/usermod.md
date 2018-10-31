部分管理需要root身份：
[参考](https://blog.csdn.net/zyqblog/article/details/79226826)
###用户
| 作用 | 命令 | 解释 |
| ---- | ----- |
| 添加用户 | useradd、adduser | sudo useradd Uname |
| 添加用户同时到组 | useradd、adduser | sudo useradd -m -g 组名 用户名（加上m自动创建目录，加上g自动添加到组） |
| 用户密码 | passwd | sudo passwd Uname（当前用户不需要Uname） |
| 更新密码 | 同上 | 同上 |
| 用户信息 | id、finger、whoami | id Uname 、finger |
| 用户文件修改 | usermod | 组、名、uid、家目录等，具体使用man |
| 删除用户 | userdel | userdel -r Uname（连同目录一并删除） |
| 用户切换 | su | su Uname |
| finger用户信息修改 | chfn | 名字、电话等(当前用户) |
提示： 如果添加用户时，没有加-m创建家目录，最简单的方法是删除该用户，重新创建。
###用户组
| 作用 | 命令 | 解释 |
| ---- | ----- |
| 添加组 | groupadd | sudo groupadd Gname |
| 删除组 | groupdel | groupdel Gname |
| 添加用户到组 | useradd －G | useradd -G group user |
| 用户所属组 | groups |  |
| 添加用户到组 | usermod -aG | usermod -aG group user没有a以前组删除 |
| 添加用户到组 | gpasswd | gpasswd -a user group（以前组保留） |
| 删除用户的组 | gpasswd | gpasswd -d user group**（group不是主组）** |
| 查看用户 | cat /etc/passwd ||
| 查看组 | cat /etc/group ||

#### 说明
* 添加的组会保存到/etc/group文件中，可以通过cat -n /etc/group | grep 组名 单独查看信息。
* 创建的用户保存在/etc/passwd文件中，可以通过cat -n /etc/passwd | grep 用户名 单独查看信息。

##更新权限
####1. chmod：操作权限
创建新文件默认权限由umask觉得
| 数字 | 说明 | 权限 |
| -- | -- | -- |
| 0 | 无权限 | --- |
| 1 | 执行权限 | --x |
| 2 | 写入权限 | -w- |
| 3 | 写＋执行 | -wx |
| 4 | 读取权限 | r-- |
| 5 | 读＋执行 | r-x |
| 6 | 读＋写 | rw- |
| 7 | 读＋写＋执行 | rwx |

例子：```-rw-r--r--  1 bu users  2254 2006-05-20 13:47 tt.htm```
    * 从第二个字符起rw-是说用户bu有读、写权，没有运行权，
    * 接着的r--表示用户组users只有读权限，没有运行权，
    * 最后的r--指其他人（others）只有读权限，没有写权和运行权。
    
**chmod [who] +/- [pre] file**
    * who
        * u stands for cuser.
        * g stands for group.
        * o stands for others.
        * a stands for all.
    * pre
        * x/r/w
    * chmod -R 777 ./
    
###2.chown：所属对象
**chown [-R] [user]:[group] file/dir**
chgrp 同上，但是仅用来修改所属组


[返回子目录](README.md)