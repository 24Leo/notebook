[参考](http://www.bijishequ.com/detail/519052)
* 安装iterm2: http://iterm2.com/downloads.html
* 查看当前正在使用什么shell  : echo $SHELL
* 查看有哪些shell : cat /etc/shells
* 更改shell：  chsh -s /bin/zsh
* 安装oh-my-zsh：直接在iTerm2终端执行以下代码：
```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
* 修改主题：vim ~/.zshrc
    * ZSH_THEME 修改即可（agnoster较炫）
    * 可能乱码：
        * sudo easy_install pip  然后 pip install powerline-status
            * 如果出错：	pip install ipython --user -U
        * 字体库：
        git clone https://github.com/powerline/fonts ~/Downloads/fonts 然后执行./install.sh
        * 然后偏好设置（Preference）--profile--text：font & non-ascii均换成有Powerline的字体的即可
        * 色彩库：
        git clone https://github.com/mbadolato/iTerm2-Color-Schemes 然后Preference - Profiles - Colors右下角导入（import...）
    * 名字长：vim ~/.oh-my-zsh/themes/agnoster.zsh-theme找到prompt_context()中 $USER@%m ，%m替换成任意即可
* 插件
    * autojump
        * brew install autojump
        * /usr/local/etc/profile.d/autojump.sh
    * zsh-syntax-highlighting
    * zsh-autosuggestion
        * 这两个先cd ~/.oh-my-zsh/plugins，然后运行：
        ```
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./plugins/zsh-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-autosuggestions.git ./plugins/zsh-autosuggestions/```
    * 配置：**vim ~/.zshrc**
         * 找到“plugins=( )”在的这一行：
         ```
         git zsh-syntax-highlighting zsh-autosuggestions Z autojump
  source $ZSH/oh-my-zsh.sh
  $(brew --prefix)/usr/local/etc/profile.d/autojump.sh  
  ```
         
* 编写expect脚本快速登陆

```shell
#!/usr/bin/expect -i
 
set dest [lindex $argv 0]   #代表第几个参数
 
set RELAYSERVER email@..com   #堡垒机
set PASSWORD [lindex $argv 1]      
set PASSWORD *****$PASSWORD     #堡垒机拼接密码
set USER root             #目标机器用户名
set DPASSWD *******     #目标机器密码
 
spawn ssh $RELAYSERVER  #发起请求。spawn+命令：执行命令
expect {              #expect命令。注意空格
	"yes/no" { send "yes\r";exp_continue;}   #如果yes、no。发送yes并继续
	"*password:*" { send "$PASSWORD\r"}   #如果返回结果有password，发送密码
}
 #继续登陆目标机器
expect {
	"*succeeded*" { send "ssh -l $USER $dest\r"} #有-l 不需要@
	"*Last*" { sed "ssh -l $USER $dest\r"}
}
expect {
	"yes/no" { send "yes\r"; exp_continue;}
	"*password*" { send "$DPASSWD\r"}
}
interact #将控制权交给控制台
```
    * 执行```/usr/bin/expect file_expect ip/hostname passwd```即可登陆
    * 如果觉得命令较长，可以将```/usr/bin/expect file_expect IP```重命名alias
    * Mac中.bash_profile文件是用户登陆终端的时候会自动执行的文件，一般此文件中会调用.bashrc ： 里面添加source ~/.bashrc
    
    *
 
     
[return](README.md)    