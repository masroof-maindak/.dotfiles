" Set space as leader key
let mapleader = " "
let maplocalleader = " "

" Exit insert mode w/ 'jk'
inoremap jk <Esc>

" Save with 'Ctrl-s'
nnoremap <C-s> :w<CR>

" Quit/Quit All
nnoremap <C-q> :qa<CR>
nnoremap <leader>q :q<CR>

" Write easily
nnoremap <leader>w :w<CR>

" Delete current buffer
nnoremap <leader>bd :bd<CR>

" Move to the beginning/end of the line
nnoremap L $
nnoremap H ^
vnoremap L g_
vnoremap H ^

" Window navigation with 'Ctrl-hjkl'
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resize with 'Ctrl-arrow'
nnoremap <C-left> <C-w><
nnoremap <C-down> <C-w>-
nnoremap <C-up> <C-w>+
nnoremap <C-right> <C-w>>

" Cycle to the next buffer with 'Tab'
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>

" Clear search highlights with 'Esc'
nnoremap <Esc> :noh<CR><Esc>

" Remain in visual selection after shifting text
vnoremap < <gv
vnoremap > >gv

" Exit terminal with double Esc
tnoremap <Esc><Esc> <C-\><C-n>

" Relative line numbers in gutter
set relativenumber
set number

" Number of spaces per tab
set tabstop=4

" Number of spaces to use for indents with >>, << and ==
set shiftwidth=4

" 24 bit colours
set termguicolors

" Enable mouse support for all modes
set mouse=a

" Highlight current line
set cursorline

" Always show sign column
set signcolumn=auto

" Undo files
set undofile

" Case insensitive searching UNLESS /C or capital in search
set ignorecase
set smartcase

" Line wrap
set nowrap

" Syntax highlighting
syntax enable

colo habamax

" Auto indentation
set autoindent
set smartindent

" Show matching parentheses
set showmatch

" Search highlighting
set hlsearch

" Persistent undo
set undofile

" Faster scrolling
set lazyredraw

" Incremental search
set incsearch

" Command-line completion
set wildmenu
