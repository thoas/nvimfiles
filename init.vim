call plug#begin('~/.config/nvim/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'neovim/nvim-lspconfig'
Plug 'jiangmiao/auto-pairs'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle', 'tag': '5.0.0' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-unimpaired'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-commentary'
Plug 'L3MON4D3/LuaSnip'
call plug#end()

if has("nvim")
    lua require("vim-misc")
endif

source $HOME/.config/nvim/settings.vim
source $HOME/.config/nvim/map.vim
source $HOME/.config/nvim/autocmd.vim
source $HOME/.config/nvim/plugins.vim
