"Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
Bundle 'scrooloose/syntastic'
Bundle 'bling/vim-airline'
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
Bundle 'chrisbra/csv.vim'
Bundle 'klen/python-mode'
Bundle 'gmarik/Vundle.vim'
Bundle 'tpope/vim-surround'
Bundle 'suan/vim-instant-markdown'
Bundle 'nanotech/jellybeans.vim'
filetype plugin indent on

let base16colorspace=256
set t_Co=256
colorscheme base16-flat
set background=dark

set relativenumber
syntax enable
set clipboard=unnamed
let mapleader=","
set hidden

"Highlights on/off
map  <F12> :set hls!<CR>
imap <F12> <ESC>:set hls!<CR>a
vmap <F12> <ESC>:set hls!<CR>gv

"CTRLP
let g:ctrlp_show_hidden = 1
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_working_path_mode = 'a'

"No swap files
set noswapfile

"Powerline
let g:powerline_loaded = 1
" let $PYTHONPATH='/usr/lib/python3.4/site-packages'
set laststatus=2
set formatoptions-=cro

" Airline
let g:airline_powerline_fonts = 1

"TABS
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

"NerdTREE
map <F2> :NERDTreeToggle<CR>

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
let g:pymode_rope_lookup_project = 1
let g:pymode_rope = 1
let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_completion_bind = '<C-Space>'

" Documentation
let g:pymode_doc = 0
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

" JS
let g:javascript_enable_domhtmlcss = 1

" JS-libraries
let g:used_javascript_libs = 'jquery, react, flux, requirejs'
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

let g:syntastic_javascript_checkers = ['eslint']

autocmd Filetype javascript setlocal ts=2 sw=2 softtabstop=2 expandtab

" PyMode documentation hide after selection
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

let NERDTreeIgnore = ['\.pyc$', '__pycache__$']

if has("autocmd")
  filetype plugin indent on
endif

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set runtimepath+=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
