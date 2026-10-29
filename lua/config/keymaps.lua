local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader><Space>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<CR>", { desc = "Save" })
-- Whole buffer in normal mode, the selected lines in visual mode
map({ "n", "v" }, "<leader>f", function() require("conform").format({ async = true }) end, { desc = "Format" })

-- Insert mode: <Tab>/<S-Tab> indent/dedent the line, unless a snippet
-- (e.g. completed function arguments) is active, in which case they jump.
-- <Plug>(indent) lets buffer-local <Tab> maps (Python debugger shortcuts) fall back to it.
map("i", "<Plug>(indent)", function()
  if vim.snippet.active({ direction = 1 }) then return "<cmd>lua vim.snippet.jump(1)<CR>" end
  return "<C-t>"
end, { expr = true })
map("i", "<Tab>", "<Plug>(indent)", { remap = true, desc = "Indent line" })
map("i", "<S-Tab>", function()
  if vim.snippet.active({ direction = -1 }) then return "<cmd>lua vim.snippet.jump(-1)<CR>" end
  return "<C-d>"
end, { expr = true, desc = "Dedent line" })

-- Visual mode: indent/dedent the selection and keep it selected
map("x", "<Tab>", ">gv", { desc = "Indent selection" })
map("x", "<S-Tab>", "<gv", { desc = "Dedent selection" })
-- Overrides the <C-w> window prefix; window moves use <C-h/j/k/l> below
map("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Arrows: left/right switch tabs, up/down switch buffers
map("n", "<Left>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<Right>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<Up>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<Down>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Cmd + j/k/4/6/0 move by screen (wrapped) lines, from the old MacVim config.
-- Needs a terminal that sends Cmd to Neovim (kitty does, unless a kitty shortcut takes the key).
map({ "n", "v" }, "<D-j>", "gj", { desc = "Down one screen line" })
map({ "n", "v" }, "<D-k>", "gk", { desc = "Up one screen line" })
map({ "n", "v" }, "<D-4>", "g$", { desc = "End of screen line" })
map({ "n", "v" }, "<D-6>", "g^", { desc = "Start of screen line" })
map({ "n", "v" }, "<D-0>", "g^", { desc = "Start of screen line" })

-- Tabs
map({ "n", "v", "o" }, "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map({ "n", "v", "o" }, "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- File tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
map({ "n", "i" }, "<F9>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal file in tree" })

-- Fuzzy finding (kept off <leader>f so formatting doesn't wait for a second key)
map("n", "<leader>p", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>g", "<cmd>Telescope live_grep<CR>", { desc = "Grep" })
map("n", "<leader>b", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
