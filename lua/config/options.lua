local opt = vim.opt

opt.number = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.updatetime = 250
opt.undofile = true
opt.swapfile = false

opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }

-- Jinja2 templates. An .html file under a templates/ folder is Jinja, unless that
-- folder belongs to a Django app (has apps.py or models.py next to it).
vim.filetype.add({
  extension = { j2 = "jinja", jinja = "jinja", jinja2 = "jinja" },
  pattern = {
    [".*/templates/.*%.html"] = function(path)
      local app = path:match("^(.*)/templates/")
      if vim.uv.fs_stat(app .. "/apps.py") or vim.uv.fs_stat(app .. "/models.py") then
        return "htmldjango"
      end
      return "jinja"
    end,
  },
})

-- Go uses tabs, JS/TS conventionally 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function() vim.opt_local.expandtab = false end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "lua", "jinja", "htmldjango", "html" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})
