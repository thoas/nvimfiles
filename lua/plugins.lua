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
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/stevearc/conform.nvim",
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

-- When closing a window (:q, Ctrl-w) leaves only the tree in the tab, close
-- the tab too, or quit if it was the last one
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    vim.schedule(function()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local is_float = vim.api.nvim_win_get_config(win).relative ~= ""
        if not is_float and vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "NvimTree" then return end
      end
      -- Fails harmlessly (and keeps the tree) if quitting would lose unsaved changes
      pcall(vim.cmd, vim.fn.tabpagenr("$") > 1 and "tabclose" or "quit")
    end)
  end,
})

-- Like jiangmiao/auto-pairs; set up before blink.cmp so its <CR> falls back to
-- autopairs (splitting {|} onto separate lines) when the menu is closed
require("nvim-autopairs").setup({})

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
    -- Accepting a function adds its parentheses
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = true, auto_show_delay_ms = 300 },
    list = { selection = { preselect = false, auto_insert = false } },
  },
  signature = { enabled = true },
  -- "snippets" reads snippets/<filetype>.json from this config
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Formatters (<leader>f, and on save for Go and Python). Prettier comes from the
-- project's node_modules when it has one, otherwise from Mason.
local prettier = { "prettier" }
local format_on_save = { go = true, python = true }
require("conform").setup({
  formatters_by_ft = {
    -- Sort imports (ruff's isort rules), then format
    python = { "ruff_organize_imports", "ruff_format" },
    -- gofmt formatting plus adding missing / removing unused imports
    go = { "goimports" },
    javascript = prettier,
    javascriptreact = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    json = prettier,
    jsonc = prettier,
    css = prettier,
    scss = prettier,
    html = prettier,
    markdown = prettier,
    yaml = prettier,
  },
  -- Other filetypes fall back to the language server's formatter
  default_format_opts = { lsp_format = "fallback" },
  format_on_save = function(buf)
    if format_on_save[vim.bo[buf].filetype] then return { timeout_ms = 2000 } end
  end,
})

require("telescope").setup({})
require("lualine").setup({ options = { theme = "molokai" } })
require("gitsigns").setup({})
