-- Debugger shortcuts: type the trigger alone on a line, then press <Tab>
local snippets = {
  pdb = "import pdb; pdb.set_trace()",
  ipdb = "import ipdb; ipdb.set_trace()",
  bp = "breakpoint()",
}

vim.keymap.set("i", "<Tab>", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local before = vim.api.nvim_get_current_line():sub(1, col)
  local indent, word = before:match("^(%s*)([%w_]+)$")
  local text = word and snippets[word]
  if not text then return "<Plug>(indent)" end
  -- Buffer edits aren't allowed while evaluating an expr mapping
  vim.schedule(function()
    vim.api.nvim_buf_set_text(0, row - 1, #indent, row - 1, col, { text })
    vim.api.nvim_win_set_cursor(0, { row, #indent + #text })
  end)
  return ""
end, { buffer = true, expr = true, remap = true, desc = "Expand debugger snippet" })
