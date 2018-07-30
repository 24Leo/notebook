##快速搜索
command+space
##多点触控
1. 单指手势 
<br>单指手势只有一个，就是轻拍来点按，手指轻轻一点，相当于鼠标左键的功能，完全不需要把手挪到触控板下方来按下去。
1. 双指手势
     * 右击
          <br>这个手势充当鼠标右键的功能，手势是双指在触控板上轻拍。
     * 滚动
          <br>双指轻贴触控板上下移动（不需要并在一起），相当于鼠标滚轮的效果，多用于写文档和看网页以及调节视频音量。
     * 放大缩小
          <br>双指张开或者并拢，可以放大缩小图像等内容。
     * 智能缩放
          <br>双指轻拍触控板两下，可以由电脑智能缩放，通常是充满整个屏幕。
     * 旋转
          <br>双指张开并顺时针或者逆时针旋转可以调节图像的角度。
     * 网页之间切换
          <br>双指并住左右滑动，可以当成前进后退来切换网页。
     * 打开通知中心
          <br>两指从右边滑入
1. 三指手势
     * 查找含义
          <br>三个手指轻拍，查找并显示当前光标位置文字的含义
          <br>备注：查看misson control和app expose 可以是三指，可以是四指，这个需要根据自己的喜好去系统偏好里面设置。这里将查看Mission Control分为四指手势。
     * mission control
          <br>显示当前所有打开应用程序：焦点是当前打开的程序
1. 四指手势
     * Launchpad和显示桌面
          <br>四个手指滑动并拢，可以在当前界面显示launchpad。相反，四个手指滑动分开，隐藏launchpad以显示当前界面。
     * Mission Control显示当前打开的程序
          <br>四个手指向上平移，显示Misson Control。**三指也可以，区别是当前焦点是当前程序还是下一个**
     ＊ clear desktop
          <br>四个手指向四个方向离开。四指滑动分开

####扩展显示器
将鼠标放在任意屏幕低端2秒，自动出现
      
###Samba权限
chmod和samba在近端和远端共同控制着一个文件夹的访问权限，相当于一条路的两道关卡，要想通过，缺一不可。chmod是本地控制，对各级用户使用权限具有本地决定权；samba是网端控制，在开放chmod权限的前提下（通常是至少770），才能使用samba进一步设置特定用户权限，具有网端决定权。
```php
//安装samba
yum -y install samba
cp  /etc/samba/smb.conf  /etc/samba/smb.conf.bak
编辑文件/etc/samba/smb.conf
[zhaorui07]
      comment = zhaorui07-file
      path = /home/zhaorui07dir
      writable = yes
      #zhaorui07名字随便去，最好是好记的。
//添加用户
smbpasswd  -a   zhaorui07
service smb restart
//端上访问
window：文件夹目录直接输入file://${host_ip}
mac：文件夹－前往－链接服务器；服务器地址  smb://10.99.200.196。然后输入用户名和密码即可
```
####更换端口
* /etc/samba/smb.conf里面的global字段添加配置smb ports = ****
* 后/sbin/service smb restart
* 然后连接的时候通过IP:PORT即可。

###Dash激活
[证书下载](https://kapeli.com/licenses/Dash/2015/181/A9xyvwUTgNKIjFMPNX3Uh4byRMmZgk/license.dash-license)，然后双击即可！过期会让你重新下载，这时候就是去官网下载了。

[return](SUMMARY.md)