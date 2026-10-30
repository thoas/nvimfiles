local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader><Space>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<CR>", { desc = "Save" })
-- Close the window, like :q (the tab goes too if only the tree is left)
map({ "n", "v" }, "<C-q>", "<cmd>quit<CR>", { desc = "Close file" })
-- Reload the file from disk; refuses (E37) rather than drop unsaved changes
map("n", "<leader>r", "<cmd>edit<CR>", { desc = "Reload file" })
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
-- Pasting over a selection keeps what you copied (Vim's p would copy the replaced
-- text instead); built-in P does exactly that
map("x", "p", "P", { desc = "Paste without copying the replaced text" })
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

-- j/k move by screen line on wrapped text (gj/gk); with a count (5j) they still
-- move by real lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down (screen line)" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up (screen line)" })

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
-- Cmd-p like other editors (needs the terminal to pass Cmd through, as kitty does)
map({ "n", "i", "v" }, "<D-p>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map({ "n", "v" }, "<leader>*", "<cmd>Telescope grep_string<CR>", { desc = "Grep word / selection" })
map("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Symbols in file" })
map("n", "<leader>S", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Symbols in project" })
map("n", "<leader>D", "<cmd>Telescope diagnostics<CR>", { desc = "Project diagnostics" })
map("n", "<leader>l", "<cmd>Telescope resume<CR>", { desc = "Reopen last search" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
