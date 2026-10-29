-- Plugins are managed by vim.pack, built into Neovim 0.12.
-- Update with :lua vim.pack.update()
vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  -- Pinned to release tags so the prebuilt fuzzy matcher can be downloaded
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
}, { confirm = false })

-- molokai lives in colors/, copied from the old Vim config
vim.o.background = "dark"
vim.cmd.colorscheme("molokai")

require("nvim-tree").setup({
  view = { width = 35 },
  renderer = { group_empty = true },
  -- .venv is usually gitignored, which nvim-tree hides by default
  filters = { dotfiles = false, custom = { "^.git$" }, exclude = { ".venv" } },
  update_focused_file = { enable = true },
  -- Open/split in the last used window instead of asking which one (NERDTree-like);
  -- the picker's letters were hidden behind lualine anyway
  actions = { open_file = { window_picker = { enable = false } } },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    api.config.mappings.default_on_attach(bufnr)
    -- NERDTree-style splits; replaces the default `s` (open with system app)
    local opts = function(desc) return { buffer = bufnr, nowait = true, desc = "nvim-tree: " .. desc } end
    vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
    vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: Horizontal Split"))
    vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
  end,
})

require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    -- <Tab> stays free for indenting and the Python debugger shortcuts
    ["<Tab>"] = false,
    ["<S-Tab>"] = false,
    -- <C-Space> switches input source on macOS; <C-n> opens the menu like in Vim
    ["<C-space>"] = false,
    ["<C-n>"] = {
      function(cmp)
        if cmp.is_menu_visible() then return cmp.select_next() end
        return cmp.show()
      end,
    },
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 300 },
    list = { selection = { preselect = false, auto_insert = false } },
  },
  signature = { enabled = true },
  sources = { default = { "lsp", "path", "buffer" } },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

require("telescope").setup({})
require("lualine").setup({ options = { theme = "molokai" } })
require("gitsigns").setup({})
