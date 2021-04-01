"Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Valloric/YouCompleteMe'
Plugin 'majutsushi/tagbar'
Plugin 'ryanoasis/vim-devicons'
Plugin 'chriskempson/base16-vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'chrisbra/Colorizer'
filetype plugin indent on
" set termguicolors
set t_Co=256
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

set encoding=utf-8

let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'
" let g:gruvbox_italic=1
let g:colorizer_auto_color=1

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

"TABS
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

"NerdTREE
map <F2> :NERDTreeToggle<CR>
nmap <leader>n :NERDTreeFind<CR>

"Buffers movement
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

noremap <left> <C-w><
noremap <right> <C-w>>
noremap <up> <C-w>+
noremap <down> <C-w>-

"Close stuff
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" YCM"
nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>

let NERDTreeIgnore = ['\.pyc$', '__pycache__$']

if has("autocmd")
  filetype plugin indent on
endif
"
" sessions
set ssop-=options    " do not store global and local values in a session

nmap <F8> :TagbarToggle<CR>

" automatically copy all yanks that land in " into +
augroup clipboard
  autocmd!
  autocmd TextYankPost *
    \  if v:event.regname==''&&v:event.operator=='y'
    \|   let @+=join(v:event.regcontents, "\n")
    \| endif
augroup END
