" Leader
let mapleader = " "
let maplocalleader = " "

" Basic
inoremap jk <Esc>
nnoremap <C-s> :w<CR>
nnoremap <C-q> :qa<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>

" Misc
vnoremap < <gv
vnoremap > >gv
nnoremap <Esc> :noh<CR><Esc>
tnoremap <Esc><Esc> <C-\><C-n>

" Buffer
nnoremap <leader>bd :bd<CR>
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>

" Move to the beginning/end of the line
nnoremap L $
nnoremap H ^
vnoremap L g_
vnoremap H ^

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing
nnoremap <C-left> <C-w><
nnoremap <C-down> <C-w>-
nnoremap <C-up> <C-w>+
nnoremap <C-right> <C-w>>

" UI
set relativenumber
set number
set signcolumn=auto
set termguicolors
set scrolloff=6
set lazyredraw
set showmatch
set wildmenu

" Text
set tabstop=4
set shiftwidth=4
set nowrap
set mouse=a
set autoindent
set smartindent

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch

set undofile

" Syntax highlighting
syntax enable
colo habamax
