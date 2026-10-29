-- Leader must be set before plugins load their keymaps
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- nvim-tree recommends disabling netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("config.keymaps")
require("plugins")
require("config.lsp")
