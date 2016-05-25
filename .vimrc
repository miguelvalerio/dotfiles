"Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
Bundle 'scrooloose/syntastic'
Bundle 'vim-airline/vim-airline'
Bundle 'othree/javascript-libraries-syntax.vim'
Bundle 'mxw/vim-jsx'
Bundle 'othree/html5.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'scrooloose/nerdtree'
Bundle 'rstacruz/sparkup'
Bundle 'kien/ctrlp.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'chriskempson/base16-vim'
Bundle 'Raimondi/delimitMate'
Bundle 'klen/python-mode'
Bundle 'gmarik/Vundle.vim'
Bundle 'tpope/vim-surround'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'majutsushi/tagbar'
Bundle 'morhetz/gruvbox'
Bundle 'wellle/targets.vim'
filetype plugin indent on

set t_Co=256
color gruvbox
set background=dark

set relativenumber
syntax enable
set clipboard=unnamed
let mapleader=","
set hidden

nnoremap H ^
nnoremap L g_
nnoremap Y y$
nnoremap gp `[v`]

"Highlights on/off
map  <F12> :set hls!<CR>
imap <F12> <ESC>:set hls!<CR>a
vmap <F12> <ESC>:set hls!<CR>gv

"CTRLP
let g:ctrlp_show_hidden = 1
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_working_path_mode = 'a'
nnoremap <leader>. :CtrlPTag<CR>

"No swap files
set noswapfile

"Powerline
let g:powerline_loaded = 1
" let $PYTHONPATH='/usr/lib/python3.4/site-packages'
set laststatus=2
set formatoptions-=cro

" Airline
let g:airline_powerline_fonts = 1

" tags
nmap <F8> :TagbarToggle<CR>
let g:tagbar_ctags_bin = '/usr/bin/ctags'

"TABS
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

"NerdTREE
map <F2> :NERDTreeToggle<CR>

" YCM
let g:ycm_python_binary_path = '/usr/bin/python3.5'
let g:ycm_server_python_interpreter = '/usr/bin/python3.5'
nnoremap <leader>jd :YcmCompleter GoTo<CR>

"Buffers movement
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope_lookup_project = 0
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion_bind = '<C-z>'

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pylint,pep8,pyflakes"
let g:pymode_lint_ignore = "W0404"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" JS vim-javascript
let g:javascript_enable_domhtmlcss = 1

" JS-libraries
let g:used_javascript_libs = 'jquery, react, flux, requirejs'
" vim-jsx
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

let g:syntastic_javascript_checkers = ['eslint']

autocmd Filetype javascript setlocal ts=2 sw=2 softtabstop=2 expandtab

" PyMode documentation hide after selection
" autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
" autocmd InsertLeave * if pumvisible() == 0|pclose|endif

let NERDTreeIgnore = ['\.pyc$', '__pycache__$']

if has("autocmd")
  filetype plugin indent on
endif

set grepprg=grep\ -nH\ $*
let g:tex_flavor = 'latex'
let g:tex_fast = "cmMprs"
let g:tex_conceal = ""
" let g:tex_fold_enabled = 0
let g:tex_comment_nospell = 1
set runtimepath+=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" sessions
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
