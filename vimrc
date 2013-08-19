"=================================================
" Auto Session Save/Restore
function GetProjectName()
    " Get the current editing file list, Unix only
    let edit_files = split(system("ps -o command= -p " . getpid()))
    if len(edit_files) >= 2
        let project_path = edit_files[1]
        if project_path[0] != '/'
            let project_path = getcwd() . project_path
        endif
    else
        let project_path = getcwd()
    endif

    return substitute(project_path, '[/]', '', 'g')
endfunction

function SaveSession()
    "NERDTree doesn't support session, so close before saving
    execute ':NERDTreeClose' 
    let project_name = GetProjectName()
    execute 'mksession! ~/.vim/sessions/' . project_name
	execute 'wviminfo ~/.vim/sessions/' . project_name . '.viminfo'
endfunction

function RestoreSession()
    let session_path = expand('~/.vim/sessions/' . GetProjectName())
	if filereadable(session_path)
		execute 'source ' . session_path
		execute 'rviminfo ' . session_path . '.viminfo'
	endif
	syntax enable
	set background=dark
	colorscheme solarized
	hi Normal ctermbg=None
endfunction

nmap ssa :call SaveSession()
nmap sso :call RestoreSession()
autocmd VimLeave * call SaveSession()
"autocmd VimEnter * call RestoreSession()
"=================================================

"=================================================
" Persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload



"=================================================
map <F12> :tabnew ~/.vimrc<CR>
imap <F12> <ESC>:tabnew ~/.vimrc<CR>

syntax enable
set background=dark
colorscheme solarized
hi Normal ctermbg=None
set mouse=a

set nocompatible "be Improved
filetype plugin indent on "开启文件类型检测

set number  "显示行号
set cursorline "高亮当前行
set textwidth=79 "宽79
"tw+1列高亮(对python)
autocmd FileType python set colorcolumn=+1 
"高亮列颜色设置
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey 

set hls "高亮显示被找到的文本,使用:nohl取消高亮 
set is "搜索时即时显示结果

au BufNewFile,BufRead *.html setf htmldjango

set autoindent "自动缩进
set shiftwidth=4 "自动缩进为4个空格
set tabstop=4 "TAB宽度4个空格
set smarttab "按一下退格删除一个TAB位
autocmd FileType python setlocal expandtab "对python将tab转换为tab
autocmd BufRead *.html,*.htm,*.css,*.js setlocal noexpandtab tabstop=2 shiftwidth=2 "对这些格式特殊处理

autocmd FileType python setlocal foldmethod=indent "对python缩进折叠
set foldlevel=100 "默认打开所有折叠

map <C-h> :tabp<CR>
imap <C-h> <ESC>:tabp<CR>
map <C-l> :tabn<CR>
imap <C-l> <ESC>:tabn<CR>

"=================================================
" omnicomplete自动补全
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"=================================================

"=================================================
" <F5>运行代码
" 
" python  
map <F5> :w<CR>:!python % <CR>
"=================================================

"=================================================
"NewBundle 插件管理
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
" My Bundles here:
"
" Note: You don't set neobundle setting in .gvimrc!
"*Original repos on github
NeoBundle 'scrooloose/nerdtree' "目录树
NeoBundle 'mattn/calendar-vim' "日历插件
NeoBundle 'nvie/vim-flake8' "python代码检查，PEP8标准
NeoBundle 'hynek/vim-python-pep8-indent' "python代码缩进PEP8标准
"NeoBundle 'Lokaltog/powerline' "状态栏增强
NeoBundle 'altercation/vim-colors-solarized' "Solarized配色
"NeoBundle 'tpope/vim-fugitive'
"NeoBundle 'Lokaltog/vim-easymotion'
"NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}
"*vim-scripts repos
NeoBundle 'taglist.vim' "显示tag
NeoBundle 'vimwiki' "wiki插件
NeoBundle 'django.vim' "django语法高亮
"NeoBundle 'L9'
"NeoBundle 'FuzzyFinder'
"NeoBundle 'rails.vim'
"*Non github repos
"NeoBundle 'http://conque.googlecode.com/svn/trunk/', {
"	'name': 'conque'} "vim中的shell，不是很好用
"NeoBundle 'git://git.wincent.com/command-t.git'
"*gist repos
"NeoBundle 'gist:Shougo/656148', {
"      \ 'name': 'everything.vim',
"      \ 'script_type': 'plugin'}
" Non git repos
"NeoBundle 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'

" ...

filetype plugin indent on     " Required!
"
" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

" Installation check.
NeoBundleCheck
"=================================================

"=================================================
"vim-flake8
"let g:flake8_max_line_length=99 "每行代码长度增加为99
"autocmd BufWritePost *.py call Flake8()
"=================================================

"=================================================
"ctags
map <C-F12> :!ctags -R <CR>  
"=================================================

"=================================================
"taglist
let Tlist_Exit_OnlyWindow=1 "只有taglist窗口存在时关闭vim
"let Tlist_Auto_Open=1 "打开vim时自动打开taglist窗口 
let Tlist_Show_One_File=1 "只显示一个文件的tag 
let Tlist_Use_Right_Window=1 "在右侧显示窗口
"=================================================

"=================================================
"Pydiction
let g:pydiction_location='~/.vim/bundle/Pydiction/complete-dict' "字典文件路径
"=================================================

"=================================================
"NERD_tree
"autocmd VimEnter * NERDTree
" F2打开/关闭NERDtree
map <F2> :silent! NERDTreeToggle<CR>
" 当通过NERD Tree打开文件自动退出NERDTree界面
let NERDTreeQuitOnOpen = 1 
"let NERDTreeShowBookmarks=1

