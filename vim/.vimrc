"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"    Cyberpelican
" Version:
"    0.3
"
" Common references
" github.com/amix/vimrc/blob/master/vimrcs/basic.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Common Global Options
set nocompatible
set encoding=utf-8
set mouse=a
set confirm
set fileformats=unix,dos,mac
set backspace=indent,eol,start

" Disable Annoying Sound On Error
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Indention Options
set autoindent
set smartindent
set smarttab
set tabstop=2
set expandtab
set shiftwidth=2
set shiftround

" Paste and Copy Options
set paste
set clipboard=unnamedplus

" Search Options
set hlsearch
set magic
set ignorecase
set incsearch
set smartcase
set showmatch
set matchtime=5

" Command Options
set cmdheight=1
set wildmenu

" Diff Options
" set diff
" set diffopt=filler,vertical

" Display Options
set title
set ruler
set number
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
set scrolloff=7
syntax on
" colorscheme torte

" Miscellaneous Options
set lazyredraw
set autoread
set noautowrite
set spell
set wrap
set nocursorline
set shell=sh
set regexpengine=0
filetype plugin on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" normal mode maps
map <F2> GoDate: <Esc>:read !date<CR>kJ
" map <space> /

" insert mode maps
imap <F2> <CR>Date: <Esc>:read !date<CR>kJa<CR>

" yank text from vim to system clipboard
autocmd TextYankPost * if (v:event.operator == 'y' || v:event.operator == 'd') | silent! execute 'call system("wl-copy", @")' | endif
" paste text from system clipboard to vim
nnoremap p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<CR>p

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocmds
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" delete trailing white space on save
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.java,*.py,*.go,*.yml,*.yaml,*.json,*.sh :call CleanExtraSpaces()
endif

" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" code autocompletion
" autocmd FileType css  set omnifunc=csscomplete#CompleteCSS
" autocmd FileType js   set omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
" autocmd FileType php  set omnifunc=phpcomplete#CompletePHP


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Code
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
call vundle#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
" vimawesome.com
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plugin 'scrooloose/nerdtree'
Plugin 'ryanoasis/vim-devicons'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'valloric/youcompleteme'
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'junegunn/fzf'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree
" vimawesome.com/plugin/nerdtree-red
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:NERDTreeDirArrowExpandable = '▸'
" let g:NERDTreeDirArrowCollapsible = '▾'

let g:NERDTreeShowHidden=1
let g:webDevIconsOS='Manjaro'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Airline
" vimawesome.com/plugin/vim-airline-superman
" vimawesome.com/plugin/vim-airline-themes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='violet'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic
" https://vimawesome.com/plugin/syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_sh_checkers = ['sh']
let g:syntasitc_c_checkers = ['gcc']
let g:syntasitc_cpp_checkers=['cpplint']
let g:syntasitc_python_checkers = ['pylint']
let g:syntasitc_go_checkers = ['golint']
let g:syntasitc_java_checkers = ['javac']
let g:syntasitc_html_checkers = ['eslint']
let g:syntastic_javascript_checkers = ['jslint']
let g:syntasic_json_checkers = ['jsonlint']
let g:syntastic_css_checkers = ['csslint']
let g:syntastic_ruby_checkers = ['rubylint']
let g:syntastic_sql_checkers = ['sqllint']
let g:syntastic_xml_checkers = ['xmllint']
let g:syntastic_yaml_checkers = ['yamllint']
let g:syntasitc_dockerfile_checkers = ['dockerfile_lint']
let g:syntastic_lua_checkers = ['']
let g:syntastic_perl_checkers = ['']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Solarized
" vimawesome.com/plugin/vim-colors-solarized-ours
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:solarized_termcolors = 256
set background=dark
colorscheme solarized
