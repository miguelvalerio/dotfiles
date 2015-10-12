"Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
Bundle 'gmarik/Vundle.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'chriskempson/base16-vim'
Bundle 'Raimondi/delimitMate'
Bundle 'chrisbra/csv.vim'
filetype plugin indent on

let base16colorspace=256
set t_Co=256
colorscheme base16-flat
set background=dark

set relativenumber
syntax enable
set clipboard=unnamed
let mapleader=","

"Highlights on/off
map  <F12> :set hls!<CR>
imap <F12> <ESC>:set hls!<CR>a
vmap <F12> <ESC>:set hls!<CR>gv

"CTRLP
let g:ctrlp_show_hidden = 1
let g:ctrlp_follow_symlinks = 1

"No swap files
set noswapfile

"Powerline
let $PYTHONPATH='/usr/lib/python3.4/site-packages'
set laststatus=2
set formatoptions-=cro

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
