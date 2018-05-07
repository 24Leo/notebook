
### 安装

```c
linux下安装：(window是图形界面)
sudo add-apt-repository ppa:webupd8team/sublime-text-3: 建立信任数据库
sudo apt-get update
sudo apt-get install sublime-text-installer
```
    增加Sublime Text的安装目录到系统环境变量path中
安装Package Contrl(sublime text 3):
        
```C
import urllib.request,os,hashlib; h = '7183a2d3e96f11eeadd761d777e62404' +
        'e330c659d4bb41d3bdf022e94cab3cd0'; pf = 'Package Control.sublime-package'; ipp =
        sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener(
        urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://sublime.wbond.net/' +
        pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating
        download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else
        open(os.path.join( ipp, pf), 'wb' ).write(by)
将subl添加到命令行：sudo ln -s /Applications/Sublime\Text.app/Contents/SharedSupport/bin/subl /usr/bin/subl
Mac 系统可能需要变为：／usr／local／bin/subl。因为苹果引入SIP，即使root权限也无法修改系统级目录
```
## 快捷键：

```c
    所有的默认快捷键都在preferendes->key binds default 中，可以设置key binds user 中重新设置 
ctrl + `            打开控制台
ctrl + shift+p      打开package control
Tab                 向后缩进
Shift + Tab         向前缩进
Ctrl + Enter        在当前行下面新增一行然后跳至该行；
Ctrl + Shift + Enter 在当前行上面增加一行并跳至该行
Ctrl + ←/→          进行逐词移动鼠标
Ctrl + Shift + ←/→  进行逐词选择。
Ctrl + ↑/↓          移动当前显示区域
Ctrl + Shift + ↑/↓  移动当前行
Ctrl + D            选择当前光标所在的词并高亮(使用 Ctrl+K 跳过，使用 Ctrl+U 进行回退，使用Esc退出多重编辑)
Ctrl+cmd+G          全选
Alt + F3            当前词的所有位置
Ctrl + Shift + L    同时编辑(先选择要同时编辑的区域)
Ctrl + J            把当前选中区域合并为一行

Ctrl + F            搜索
Ctrl + H            替换
         Enter跳至关键字当前光标的下一个位置，Shift + Enter跳至上一个位置，Alt + Enter出现的所有位置
         Alt + C切换大小写敏感   Alt + W切换整字匹配
        
Ctrl + P            列出当前打开的文件
    在Ctrl + P匹配到文件后，我们可以进行后续输入以跳转到更精确的位置：
        @ 符号跳转：    输入@symbol 跳转到symbol符号所在的位置
        # 关键字跳转：  输入#keyword 跳转到keyword所在的位置
        : 行号跳转：    输入:12 跳转到文件的第12行。
    
Ctrl + R            列出当前文件中的符号
Ctrl + G            然后输入行号以跳转到指定行
Ctrl + Shift + N    创建一个新sublime窗口
Ctrl + N            创建一个新标签
Ctrl + Tab          标签切换
Ctrl + W            关闭当前标签
Ctrl + Shift + T    恢复刚刚关闭的标签
Ctrl+Shift+W        关闭所有打开文件
Ctrl+X              删除当前行
Ctrl + Shift + [    折叠
Ctrl + Shift + ]    打开折叠
Alt + Shift + 1     单屏显示
Alt + Shift + 2     进行左右分屏    
Alt + Shift + 8     进行上下分屏
Alt + Shift + 5     进行上下左右分屏（即分为四屏）
Ctrl + 数字键        跳转到指定屏
Ctrl + K / B        显示或隐藏侧栏
Ctrl + M            可以快速的在起始括号和结尾括号间切换
Ctrl + Shift + M    则可以快速选择括号间的内容
　　
tab键的自动补全：
	div.classname   自动展开：<div class="classname">
	div#idname      自动展开：<div id="idname">
	
Sublime Text 常用快捷键（MAC 下）符号说明
⌘：command ⌃：control ⌥：option ⇧：shift ↩：enter ⌫：delete（打开/关闭/前往）快捷键 功能 ⌘⇧N 打开一个新的sublime窗口 ⌘N 新建文件 ⌘⇧W 关闭sublime，关闭所有文件 ⌘W 关闭当前文件 ⌘P 跳转、前往文件、前往项目、命令提示、前往method等等（Goto anything） ⌘⇧T 重新打开最近关闭的文件 ⌘T 前往文件 ⌘⌃P 前往项目 ⌘R 前往method ⌘⇧P 命令提示 ⌃G 前往行 ⌘KB 开关侧栏 ⌃` 打开控制台 ⌃- 光标跳回上一个位置 ⌃⇧- 光标恢复位置（编辑）快捷键 功能 ⌘A 全选 ⌘L 选择行（重复按下将下一行加入选择） ⌘D 选择词（重复按下时多重选择相同的词进行多重编辑） ⌃⇧M 选择括号的内容 ⌘⇧↩ 在当前行前插入新行 ⌘↩ 在当前行后插入新行 ⌃⇧K 删除行 ⌘KK 从光标处删除至行尾 ⌘K⌫ 从光标处删除至行首 ⌘⇧D 复制（多）行 ⌘J 合并（多）行 ⌘KU 改为大写 ⌘KL 改为小写 ⌘C 复制 ⌘X 剪切 ⌘V 粘贴 ⌘/ 注释 ⌘⌥/ 块注释 ⌘Z 撤销 ⌘Y 恢复撤销 ⌘⇧V 粘贴并自动缩进 ⌘⌥V 从历史中选择粘贴 ⌃M 跳转至对应的括号 ⌘U 软撤销（可撤销光标移动） ⌘⇧U 软重做（可重做光标移动） ⌘⇧S 保存所有文件 ⌘] 向右缩进 ⌘[ 向左缩进 ⌘⌥T 特殊符号集 ⌘⇧L 将选区转换成多个单行选区（查找/替换）快捷键 功能 ⌘f 查找 ⌘⌥f 查找并替换 ⌘⌥g 查找下一个符合当前所选的内容 ⌘⌃g 查找所有符合当前选择的内容进行多重编辑 ⌘⇧F 在所有打开的文件中进行查找（拆分窗口/标签页）快捷键 功能 ⌘⌥[1,2,3,4] 单列、双列、三列、四列 ⌘⌥5 网格（4组） ⌃[1,2,3,4] 焦点移动到相应的组（分屏编号） ⌃⇧[1,2,3,4] 将当前文件移动到相应的组（分屏编号） ⌘[1,2,3,4] 选择相应的标签页（快捷操作）快捷键 功能 ⌘⌃上下键 两行交换位置 ⌘KB 显示/隐藏侧边
```


## 个性化：

preferences->settings-User 中设置
```c
{
	"color_scheme": "Packages/Color Scheme - Default/Solarized (Light).tmTheme", (提前P-C安装)
	"font_size": 15,
	"highlight_line": true,
	
	// 设置tab的大小为2
    "tab_size": 4,
    // 使用空格代替tab
    "translate_tabs_to_spaces": true,
    // 添加行宽标尺
    "rulers": [80, 100],
    // 显示空白字符
    "draw_white_space": "all",
    // 保存时自动去除行末空白
    "trim_trailing_white_space_on_save": true,
    // 保存时自动增加文件末尾换行(项目有这样的要求?)
    "ensure_newline_at_eof_on_save": true,
    
	"ignored_packages":
	[
		"Vintage"
	]
}

```

## 一键运行python ：

在preferences->key binding 中
```c
[
       { "keys": ["ctrl+q"], "command": "repl_open",
                 "caption": "Python",
                 "mnemonic": "p",
                 "args": {
                 "type": "subprocess",
                 "encoding": "utf8",
                 "cmd": ["python", "-i", "-u", "$file"],
                 "cwd": "$file_path",
                 "syntax": "Packages/Python/Python.tmLanguage",
                 "external_id": "python"
                 }
    }
]
```


## 一键运行c++：

在tools->build system->new 新建一个即可,(一般已带)
```c
{
     "cmd": ["g++", "${file}", "-o", "${file_path}/${file_base_name}"],
     "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
     "working_dir": "${file_path}",
     "selector": "source.c, source.c++",
     "encoding": "cp936",
     "shell": true,

     "variants":
     [
          {
               "name": "Run",
               "cmd": [ "start", "${file_path}/${file_base_name}.exe"]
          }
     ]
}
```
##HTML
```shell
[
//windows
   { "keys": ["ctrl+1"], "command": "side_bar_files_open_with",
      "args": {"application": "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"} 
    },
//mac  
{ "keys": ["ctrl+q"], "command": "reindent" },
	{ "keys": ["command+2"], "command": "side_bar_files_open_with",
	     "args": {
	        "paths": [],
	        "application": "/Applications/Safari.app",
	        //"application": "/Applications/Google Chrome.app",
	        // "application": "/Applications/Firefox.app",
	        "extensions":".*"
	    }
	},
]	
```

## 常用插件：
```c
sublimetmpl:      常用模板(http://www.fantxi.com/blog/archives/sublime-template-engine-sublimetmpl/)
    ctrl+alt+h html
    ctrl+alt+j javascript
    ctrl+alt+c css
    ctrl+alt+p php
    ctrl+alt+r ruby
    ctrl+alt+shift+p python
    新增模板：
        /home/[user]/.config/sublime-text-3/Packages/SublimeTmpl/templates中新建对应的模板:[name].tmpl
    自定义快捷键：preferences->key bindings-user
    {
        "keys": ["ctrl+alt+j"], "command": "sublime_tmpl",
        "args": {"type": "[js/python...]"}, "context": [{"key": "sublime_tmpl.js"}]
    }
GitGutter:          记录改动
brackethighlight：  高亮匹配
AutoPEP8：          格式化Python代码。
Alignment：         进行智能对齐。
HTML/JS/CSS prettify  格式化HTML/JS/CSS
ColorHighlighter    css颜色高亮
jQuery              支持jquery的智能语法提示
SideBarEnhencement  增强文件操作
CSS3                CSS3的自动补全
SublimeLinter       可以验证各种语法错误。
SublimeCodeIntel    类似于ctag，跳转
ConvertToUTF8       自动转换乱码
DocBlockr           对代码建立文档。会解析函数，变量，和参数，自动生成文档范式，你的工作就是去填充对应的说明。
AllAutocomplete     自动完成插件(全部打开的文件中，自动完成)
ColorPicker         颜色选择器(Ctrl / Cmd + Shift + C)
CTags&cscope        source insight 效果                  
git 
```
##source insight 环境
####1、 安装ctags
1. sublime 安装
1. 电脑环境安装ctags(brew install ctags)，比如Mac放到了/usr/local/bin/ctags.
1. 在sublime中将ctags的默认设置放到用户设置中，然后修改command选项：
```C
"command":"/usr/local/bin/ctags",
```
1. 在目标项目文件夹下运行：ctags －R －f .tags。当然可以和下面一条命令一起运行

###2、 安装cscope
1. sublime 安装cscope
1. 电脑安装cscope( brew install cscope)，目录/usr/local/bin/cscope（Mac环境）
1. sublime中对cscope默认配置覆盖用户配置，然后修改executable：
```C
"executable":"/usr/local/bin/cscope",
```
1. 在项目路径运行：
```C
find . -name "*.php" -o "*.cpp" > cscope.files
cscope -bkq -i cscope.files
```


[返回目录](SUMMARY.md)