syntax enable
set background=dark
colorscheme molokai
let g:molokai_original=1

" Override buffer, no save requirement when switching from on to another {{{
set hidden
" }}}

set encoding=utf-8
set fileencoding=utf-8
set colorcolumn=120

set termguicolors

set nocompatible
set title
set visualbell
set noerrorbells
set shell=bash
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db
set cb=unnamed

" Always split window in right direction {{{
set splitright
" }}}

" To write swap file to disk after 50 keystrokes {{{
set nobackup
set noswapfile
set updatecount=50
" }}}


set iskeyword+=_,$,@,%,#
set guifont=Monaco:h11
set number
set laststatus=2

set backspace=indent,eol,start
set history=50
set ruler
set showcmd
set ts=4 sts=4 shiftwidth=4 expandtab
set wildmenu
set wildmode=full
set ignorecase

" Automatic and smart indentation {{{
set expandtab
" }}}


set pastetoggle=<F2>
set showtabline=2
set showmatch
set viewdir=~/.vim/saveview/
set fileformats=unix
set foldcolumn=2

set incsearch
set hlsearch

set colorcolumn=120

" Ignore certain types of files on completion {{{
set wildignore+=*.o,*.obj,*.pyc,.git,.svn
" }}}

set completeopt-=preview

" neocomplete like
set completeopt+=noinsert
" deoplete.nvim recommend
set completeopt+=noselect

