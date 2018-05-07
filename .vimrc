"开启语法高亮
syntax enable
syntax on
 
"设置高亮搜索
set hlsearch
set incsearch

"编码
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese
set langmenu=zh_CN,UTF-8
set ambiwidth=double
set helplang=cn 

"显示行号
set number 

"突出当前行
set cursorline

"自动保存
set autowrite

"当文件被外部修改时自动读取
set autoread

"自动缩进
set tabstop=4
set cin     "C++缩进风格

"换行无自动缩进
set nowrap

"不要空格代替指标符
set noexpandtab

"现实历史记录数
set history=100

"禁止生成临时文件
set noswapfile
set nobackup

"在编辑过程中，在右下角显示光标位置的状态行
set ruler

"显示匹配括号
set showmatch

"允许鼠标定位
set mouse=a

"去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
set nocompatible

"打开的文件类型检测，用于智能补全
set completeopt=longest,menu
filetype plugin indent on

"自动补全时采用菜单式匹配列表
set wildmenu
autocmd FileType ruby,eruby set omnifunc=rubycomplete
autocmd FileType python set omnifunc=pythoncomplete  
autocmd FileType javascript set omnifunc=javascriptcomplete  
autocmd FileType html set omnifunc=htmlcomplete  
autocmd FileType css set omnifunc=csscomplete  
autocmd FileType xml set omnifunc=xmlcomplete  
autocmd FileType java set omnifunc=javacomplete  

"全选+复制 ctrl+a
map <C-A> ggVGY
map! <C-A> <Esc> ggVGY
map <F12> gg=G

"选中状态下，ctrl+c复制
vmap <C-c> "+y

"共享剪切板
set clipboard+=unnamed

"python 支持
set filetype=python
au BufNewFile,BufRead *.py,*.pyw setf python 
set shiftwidth=4
set textwidth=90
set expandtab
let python_highlight_all=1

"--ctags setting--
"按下F5重新生成tag文件，并更新taglist
map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
set tags=tags
set tags+=./tags        "add current directory's generated tags file

"-- omnicppcomplete setting --
" 按下F3自动补全代码，注意该映射语句后不能有其他字符，包括tab；否则按下F3会自动补全一些乱码
imap <F3> <C-X><C-O>
" 按下F2根据头文件内关键字补全
imap <F2> <C-X><C-I>
set completeopt=menu,menuone        " 关掉智能补全时的预览窗口
let OmniCpp_MayCompleteDot = 1      " autocomplete with .
let OmniCpp_MayCompleteArrow = 1    " autocomplete with ->
let OmniCpp_MayCompleteScope = 1    " autocomplete with ::
let OmniCpp_SelectFirstItem = 2     " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2     " search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype in popup window
let OmniCpp_GlobalScopeSearch=1     " enable the global scope search
let OmniCpp_DisplayMode=1           " Class scope completion mode: always show all members
"let OmniCpp_DefaultNamespaces=["std"]
let OmniCpp_ShowScopeInAbbr=1       " show scope in abbreviation and remove the last column
let OmniCpp_ShowAccess=1

"-- Taglist setting --
let Tlist_Auto_Open=1  "默认打开
let Tlist_Ctags_Cmd='ctags' "因为我们放在环境变量里，所以可以直接执行
let Tlist_Use_Right_Window=1 "让窗口显示在右边，0的话就是显示在左边
let Tlist_Show_One_File=0 "让taglist可以同时展示多个文件的函数列表
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "当taglist是最后一个分割窗口时，自动推出vim
"是否一直处理tags.1:处理;0:不处理
let Tlist_Process_File_Always=1 "实时更新tags
let Tlist_Inc_Winwidth=0

"-- WinManager setting --
let g:winManagerWindowLayout='FileExplorer|TagList' " 设置我们要管理的插件
"let g:persistentBehaviour=0 " 如果所有编辑文件都关闭了，退出vim
nmap wm :WMToggle<cr>

" -- MiniBufferExplorer --
let g:miniBufExplMapWindowNavVim = 1 " 按下Ctrl+h/j/k/l，可以切换到当前窗口的上下左右窗口
let g:miniBufExplMapWindowNavArrows = 1 " 按下Ctrl+箭头，可以切换到当前窗口的上下左右窗口
let g:miniBufExplMapCTabSwitchBufs = 1 
"在当前窗口打开；ubuntu好像不支持
let g:miniBufExplModSelTarget = 1 " 不要在不可编辑内容的窗口（如TagList窗口）中打开选中的buffer

"-- QuickFix setting --
" 按下F6，执行make clean
map <F6> :make clean<CR><CR><CR>
" 按下F7，执行make编译程序，并打开quickfix窗口，显示编译信息
map <F7> :make<CR><CR><CR> :copen<CR><CR>
" 按下F8，光标移到上一个错误所在的行
map <F8> :cp<CR>
" 按下F9，光标移到下一个错误所在的行
map <F9> :cn<CR>
" 以上的映射是使上面的快捷键在插入模式下也能用
imap <F6> <ESC>:make clean<CR><CR><CR>
imap <F7> <ESC>:make<CR><CR><CR> :copen<CR><CR>
imap <F8> <ESC>:cp<CR>
imap <F9> <ESC>:cn<CR>

"-- Cscope setting --
if has("cscope")
set csprg=/usr/bin/cscope " 指定用来执行cscope的命令
set csto=0 " 设置cstag命令查找次序：0先找cscope数据库再找标签文件；1先找标签文件再找cscope数据库
set cst " 同时搜索cscope数据库和标签文件
set cscopequickfix=s-,c-,d-,i-,t-,e- " 使用QuickFix窗口来显示cscope查找结果
set nocsverb
if filereadable("cscope.out") " 若当前目录下存在cscope数据库，添加该数据库到vim
cs add cscope.out
elseif $CSCOPE_DB != "" " 否则只要环境变量CSCOPE_DB不为空，则添加其指定的数据库到vim
cs add $CSCOPE_DB
endif
set csverb
endif
map <F4> :cs add ./cscope.out .<CR><CR><CR> :cs reset<CR>
imap <F4> <ESC>:cs add ./cscope.out .<CR><CR><CR> :cs reset<CR>
" 将:cs find c等Cscope查找命令映射为<C-_>c等快捷键（按法是先按Ctrl+Shift+-, 然后很快再按下c）
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR><CR> :copen<CR><CR>

"------------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
"------------------------------------------------------------------------------
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:iswindows = 0
endif	 
"------------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
"------------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif		 
"------------------------------------------------------------------------------
"  < 编译、连接、运行配置 >
"------------------------------------------------------------------------------
" F12 一键保存、编译、连接存并运行
map <F12> :call Run()<CR>
imap <F12> <ESC>:call Run()<CR>	 
" Ctrl + F12 一键保存并编译
map <c-F12> :call Compile()<CR>
imap <c-F12> <ESC>:call Compile()<CR>
" Ctrl + F11 一键保存并连接
map <c-F11> :call Link()<CR>
imap <c-F11> <ESC>:call Link()<CR>
let s:LastShellReturn_C = 0
let s:LastShellReturn_L = 0
let s:ShowWarning = 1
let s:Obj_Extension = '.o'
let s:Exe_Extension = '.exe'
let s:Sou_Error = 0
let s:windows_CFlags = 'gcc\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CFlags = 'gcc\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:windows_CPPFlags = 'g++\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CPPFlags = 'g++\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
				 
func! Compile()
    exe ":ccl"
    exe ":update"
    if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
        let s:Sou_Error = 0
		let s:LastShellReturn_C = 0
		let Sou = expand("%:p")
		let Obj = expand("%:p:r").s:Obj_Extension
		let Obj_Name = expand("%:p:t:r").s:Obj_Extension
		let v:statusmsg = ''
		if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
            redraw!
			if expand("%:e") == "c"
			    if g:iswindows
				    exe ":setlocal makeprg=".s:windows_CFlags
			    else
					exe ":setlocal makeprg=".s:linux_CFlags
				endif
				echohl WarningMsg | echo " compiling..."
				silent make
			elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
				if g:iswindows
				    exe ":setlocal makeprg=".s:windows_CPPFlags
				else
					exe ":setlocal makeprg=".s:linux_CPPFlags
				endif
				echohl WarningMsg | echo " compiling..."
				silent make
			endif
			redraw!
			if v:shell_error != 0
			    let s:LastShellReturn_C = v:shell_error
            endif
			if g:iswindows
			    if s:LastShellReturn_C != 0
				    exe ":bo cope"
					echohl WarningMsg | echo " compilation failed"
				else
				    if s:ShowWarning
				        exe ":bo cw"
                    endif
					echohl WarningMsg | echo " compilation successful"
				endif
			else
			    if empty(v:statusmsg)
	                echohl WarningMsg | echo " compilation successful"
				else
				    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Obj_Name"is up to date"
        endif
    else
	    let s:Sou_Error = 1
	    echohl WarningMsg | echo " please choose the correct source file"
	endif
	exe ":setlocal makeprg=make"
endfunc
func! Link()
    call Compile()
	if s:Sou_Error || s:LastShellReturn_C != 0
	       return
	endif
	let s:LastShellReturn_L = 0
	let Sou = expand("%:p")
	let Obj = expand("%:p:r").s:Obj_Extension
	if g:iswindows
	    let Exe = expand("%:p:r").s:Exe_Extension
		let Exe_Name = expand("%:p:t:r").s:Exe_Extension
	else
	    let Exe = expand("%:p:r")
	    let Exe_Name = expand("%:p:t:r")
	endif
	let v:statusmsg = ''
	if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
	    redraw!
		if !executable(Exe) || (executable(Exe) && getftime(Exe) < getftime(Obj))
	        if expand("%:e") == "c"
			    setlocal makeprg=gcc\ -o\ %<\ %<.o
				echohl WarningMsg | echo " linking..."
				silent make
			elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
			    setlocal makeprg=g++\ -o\ %<\ %<.o
			    echohl WarningMsg | echo " linking..."
			    silent make
			endif
			redraw!
			if v:shell_error != 0
			    let s:LastShellReturn_L = v:shell_error
			endif
			if g:iswindows
			    if s:LastShellReturn_L != 0
			        exe ":bo cope"
                    echohl WarningMsg | echo " linking failed"
				else
				    if s:ShowWarning
				        exe ":bo cw"
					endif
					echohl WarningMsg | echo " linking successful"
				endif
			else
			    if empty(v:statusmsg)
	                echohl WarningMsg | echo " linking successful"
			    else
			        exe ":bo cope"
				endif
			endif
	    else
			echohl WarningMsg | echo ""Exe_Name"is up to date"
		endif
	endif
    setlocal makeprg=make
endfunc
func! Run()
    let s:ShowWarning = 0
	call Link()
	let s:ShowWarning = 1
	if s:Sou_Error || s:LastShellReturn_C != 0 || s:LastShellReturn_L != 0
	    return
	endif
	let Sou = expand("%:p")
	let Obj = expand("%:p:r").s:Obj_Extension
	if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
	else
	    let Exe = expand("%:p:r")
	endif
	if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
	    redraw!
	    echohl WarningMsg | echo " running..."
	    if g:iswindows
	        exe ":!%<.exe"
		else
		    if g:isGUI
		        exe ":!gnome-terminal -e ./%<"
			else
			    exe ":!./%<"
			endif
		endif
		redraw!
		echohl WarningMsg | echo " running finish"
	endif
endfunc
"""""新文件标题""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java,.py文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1,"\#########################################################################") 
        call append(line("."), "\# Copyright(c) Leo Zhang,XXX")
        call append(line(".")+1, "\#           All Rights Reserved.")
        call append(line(".")+2, "\# File Name: ".expand("%"))
        call append(line(".")+3, "\# Description: $$$$")
        call append(line(".")+4, "\# Author:Leo Zhang")
        call append(line(".")+5, "\# E-mail:zhangzhuang24@163.com") 
        call append(line(".")+6, "\# Created Time: ".strftime("%d")) 
        call append(line(".")+7, "\#########################################################################") 
        call append(line(".")+8, "\#!/bin/bash") 
        call append(line(".")+9, "") 
    endif
    if &filetype == 'cpp'
        call setline(1,"/*#########################################################################")
        call append(line("."), "* Copyright(c) Leo Zhang,XXX")
        call append(line(".")+1, "*          All Rights Reserved.")
        call append(line(".")+2, "* File Name: ".expand("%"))
        call append(line(".")+3, "* Description: $$$$")
        call append(line(".")+4, "* Author:Leo Zhang")
        call append(line(".")+5, "* E-mail:zhangzhuang24@163.com")
        call append(line(".")+6, "* Created Time: ".strftime("%d"))
        call append(line(".")+7, "*###########################################################*/")
        call append(line(".")+8, " ")
        call append(line(".")+9,"#include<iostream>")
        call append(line(".")+10,"using namespace std;")                              
        call append(line(".")+11,"")
        call append(line(".")+12,"int main(){")
        call append(line(".")+13," ")
        call append(line(".")+14,"    return 0;")
        call append(line(".")+15,"}")
    endif
    if &filetype == 'c'
        call setline(1,"/*#########################################################################")
        call append(line("."), "* Copyright(c) Leo Zhang,XXX")
        call append(line(".")+1, "*          All Rights Reserved.")
        call append(line(".")+2, "* File Name: ".expand("%"))
        call append(line(".")+3, "* Description: $$$$")
        call append(line(".")+4, "* Author:Leo Zhang")
        call append(line(".")+5, "* E-mail:zhangzhuang24@163.com")
        call append(line(".")+6, "* Created Time: ".strftime("%d"))
        call append(line(".")+7, "*###########################################################*/")
        call append(line(".")+8, " ")
        call append(line(".")+9,"#include<stdio.h>")
        call append(line(".")+10,"")
        call append(line(".")+11,"int main(){")
        call append(line(".")+12," ")
        call append(line(".")+13,"    return 0;")
        call append(line(".")+14,"}")
   endif
   if &filetype == 'py'
        call setline(0,"\#*************************************************************************")                                                                                                    
        call append(line("."), "\# Copyright(c) Leo Zhang,XXX")                                                                                                           
        call append(line(".")+1, "\#         All Rights Reserved.")                                                                                                               
        call append(line(".")+2, "\# File Name: ".expand("%"))                                                                                                            
        call append(line(".")+3, "\# Description: $$$$")                                                                                                                  
        call append(line(".")+4, "\# Author:Leo Zhang")                                                                                                                   
        call append(line(".")+5, "\# E-mail:zhangzhuang24@163.com")                                                                                                       
        call append(line(".")+6, "\# Created Time: ".strftime("%d"))                                                                                                      
        call append(line(".")+7, "\#************************************************************************")                                                            
        call append(line(".")+8, "#_*_coding=utf-8_*_")                                                                                                                   
        call append(line(".")+9, "")  
    endif
"新建文件后，自动定位到文件末尾
    autocmd * normal G
endfunc 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""