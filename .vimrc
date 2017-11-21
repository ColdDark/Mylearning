if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"


"pathogen settings
execute pathogen#infect()
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  "不显示工具/菜单栏
  set guioptions-=T
  set hlsearch
  set guifont=Monospace\ 12
  set lines=32 columns=100
  colors desert
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

filetype plugin indent on

" Display line number
set number
set tabstop=4
set shiftwidth=4
set expandtab  "Replace tab with space
" set ci
" set si
set shortmess=atl
set autowrite


" This is my vim plugin list
" auto-pairs  nerdcommenter  nerdtree-git-plugin  syntastic  vim-sensible
" jedi-vim    nerdtree       supertab             tagbar     DoxygenToolkit
" and I use pathogen manage them.
" Syntastic recommended settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_flake8_args = '--ignore=E501, F841'

" Syntastic supports checkers for my filetype
let g:syntastic_python_checkers = ['flake8']
" let g:syntastic_python_python_exec = '/server/python3.6/bin/python3'
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_sh_checkers = ['sh', 'shellcheck']


" Several setting to change the default behavior of nerdcommenter
" Add spaces after comment delimiters by default
" NerdCommenter settings
let mapleader = ","
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_python = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1


" Tagbar setting
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width = 20


" NERDTree setting
nmap <F9> :NERDTreeToggle<CR>
" let NERDTreeShowHidden=1    "是否显示隐藏文件
let NERDTreeWinSize=20      "设置宽度
let NERDTreeIgnore=['\.pyc', '\~$', '\.swp']    "忽略以下文件的显示
let NERDTreeShowBookmarks=1    "显示书签列表
let g:nerdtree_tabs_open_on_console_startup=1    "终端启用vim时，共享NERDTree

" nerdtree-git-plugin
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }


" When create a new file like .sh, .py, insert into file header.
" Define function SetTitle
func SetTitle()
    call setline(1, '#!/bin/bash')
    call append(1, '###################################')
    call append(2, "\# File Name: ".expand("%"))
    call append(3, "\# Author: ColdDark")
    call append(4, "\# Mail: 3038786382@qq.com")
    call append(5, "\# Created Time: ".strftime("%Y-%m-%d"))
    call append(6, '###################################')
    "After create file, auto move to end of the file.
    normal G
    normal o
    normal o
endfunc
autocmd BufNewFile *.sh call SetTitle()

" Define function HeaderPython
func HeaderPython()
    call setline(1, '#!/usr/bin/env python3')
    call append(1, '# -*- coding: UTF-8 -*-')
    call append(2, '###################################')
    call append(3, '# File Name: '.expand("%"))
    call append(4, '# Author: ColdDark')
    call append(5, '# Mail: 3038786382@qq.com')
    call append(6, '# Created Time: '.strftime("%Y-%m-%d"))
    call append(7, '###################################')
    "After create file, auto move to end of the file.
    normal G
    normal o
    normal o
endfunc
autocmd BufNewFile *.py call HeaderPython()


" Jedi-vm settings
" let g:jedi#goto_command = "<leader>d"
"let g:jedi#goto_assignments_command = "<leader>g"
"let g:jedi#goto_definitions_command = ""
"let g:jedi#documentation_command = "K"
"let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<F7>"
"let g:jedi#rename_command = "<leader>r"


" DoxygenToolkit settings
let g:DoxygenToolkit_startCommentTag="# "
let g:DoxygenToolkit_startCommentBlock="#"
let g:DoxygenToolkit_endCommentTag="# "
let g:DoxygenToolkit_endCommentBlock="#"
let g:DoxygenToolkit_interCommentTag="# "
let g:DoxygenToolkit_interCommentBlock="#"
let g:DoxygenToolkit_briefTag_pre="@Synopsis: "
let g:DoxygenToolkit_paramTag_pre="@Param: "
let g:DoxygenToolkit_returnTag="@Returns: "
let g:DoxygenToolkit_blockHeader="##############################################"
let g:DoxygenToolkit_blockFooter="##############################################"
let g:DoxygenToolkit_authorTag="@Author: "
let g:DoxygenToolkit_authorName="寒露凝冰"
let g:DoxygenToolkit_fileTag="@Filename: "
let g:DoxygenToolkit_versionTag="@Version: "
let g:DoxygenToolkit_versionString="1.0"
let g:DoxygenToolkit_dateTag="@Date: "
"let g:DoxygenToolkit_licenseTag="My own license""
