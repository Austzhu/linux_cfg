set helplang=cn
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
set enc=utf-8
set langmenu=zh_CN.UTF-8              " 语言设置
set ruler                             " 显示标尺
set autoread                          " 设置当文件被改动时自动载入
set completeopt=preview,menu          " 代码补全
set clipboard+=unnamed                " 共享剪贴板
set nobackup                          " 从不备份
set autowrite                         " 自动保存
set cursorline                        " 突出显示当前行
set foldcolumn=0                      " 设置在状态行显示的信息
set foldmethod=indent
set foldlevel=3
set nocompatible                      " 不要使用vi的键盘模式，而是vim自己的
set noeb                              " 去掉输入错误的提示声音
set confirm                           " 在处理未保存或只读文件的时候，弹出确认
set autoindent                        " 自动缩进
set cindent
set tabstop=4                         " Tab键的宽度
set softtabstop=4
set shiftwidth=4
set noexpandtab                       " 不要用空格代替制表符
set smarttab                          " 在行和段开始处使用制表符
set number                            " 显示行号
set history=100                       " 历史记录数
set noswapfile
set ignorecase                        " 搜索忽略大小写
set hlsearch                          " 搜索逐字符高亮
set incsearch
set gdefault                          " 行内替换
set cmdheight=2                       " 命令行（在状态行下）的高度，默认为1，这里是2
set viminfo+=!                        " 保存全局变量
set iskeyword+=_,$,@,%,#,-            " 带有如下符号的单词不要被换行分割
set linespace=0                       " 字符间插入的像素行数目
set wildmenu                          " 增强模式中的命令行自动完成操作
set backspace=2                       " 使回格键（backspace）正常处理indent, eol, start等
set report=0                          " 通过使用: commands命令，告诉我们文件的哪一行被改变过
set fillchars=vert:\ ,stl:\ ,stlnc:\  " 在被分割的窗口间显示空白，便于阅读
set showmatch                         " 高亮显示匹配的括号
set matchtime=1                       " 匹配括号高亮的时间（单位是十分之一秒）
set scrolloff=3                       " 光标移动到buffer的顶部和底部时保持3行距离
set smartindent                       " 为C程序提供自动缩进
set tags=tags;                        " 设置 tags
set autochdir
set t_Co=256
set background=dark

let Tlist_Sort_Type = "name"          " 按照名称排序
let Tlist_Use_Right_Window = 0        " 在右侧显示窗口
let Tlist_Compart_Format = 1          " 压缩方式
let Tlist_Exist_OnlyWindow = 1        " 如果只有一个buffer，kill窗口也kill掉buffer
let Tlist_File_Fold_Auto_Close = 0    " 不要关闭其他文件的tags
let Tlist_Enable_Fold_Column = 0      " 不要显示折叠树
let Tlist_Show_One_File = 1           " 不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1         " 如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Auto_Open=0
let Tlist_Ctags_Cmd = '/usr/bin/ctags'

autocmd QuitPre      * :%s/\s\+$//g   " 保存退出时删除尾部空格
"autocmd BufWritePre *  :%s/\s\+$//g  " 保存时删除尾部空格
filetype     on                       " 侦测文件类型
filetype     indent on                " 为特定文件类型载入相关缩进文件
filetype     plugin on                " 允许插件
syntax       on                       " 语法高亮
syntax       enable
colorscheme  solarized

map          <F3>       :tabnew .<CR>      " 列出当前目录文件
map          <C-F3>     \be                " 打开树状文件目录
map!         <F1> <ESC> :po      <cr>i
map          <F1>       :po      <cr>
map          <F2>       :tag     <C-r>=expand("<cword>") <cr> <cr>
map!         <F2> <ESC> :tag     <C-r>=expand("<cword>") <cr> <cr>i
inoremap     ( ()<ESC>i
inoremap     { {}<ESC>i
inoremap     [ []<ESC>i
inoremap     " ""<ESC>i
inoremap     ' ''<ESC>i
nnoremap     <leader>f  :%s/\s\+$//<cr>     " 删除行尾空格

"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()"
func SetTitle()                                    "定义函数SetTitle，自动插入文件头
	"如果文件类型为.sh文件
	if &filetype == 'sh'
		call setline(1, "\#!/bin/bash")
	else
		call setline(1, "/********************************************************************")
		call append(line("."), "	> File Name:	".expand("%"))
		call append(line(".")+1, "	> Author:		Austzhu")
		call append(line(".")+2, "	> Mail:			153462902@qq.com.com ")
		call append(line(".")+3, "	> Created Time:	".strftime("%c"))
		call append(line(".")+4, " *******************************************************************/")
		call append(line(".")+5, "")
	endif
	if &filetype == 'cpp'
		call append(line(".")+6, "#include <iostream>")
		call append(line(".")+7, "using namespace std;")
		call append(line(".")+8, "")
	endif
	if &filetype == 'c'
		call append(line(".")+6, "#include <stdio.h>")
		call append(line(".")+7, "")
	endif
	"新建文件后，自动定位到文件末尾
	autocmd BufNewFile * normal G
endfunc


set mouse=v
"set selection=exclusive
"set selectmode=mouse,key
":nnoremap a i
":nnoremap i k
":nnoremap k j
":nnoremap j h

