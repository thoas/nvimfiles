-- Expand snippets from snippets/<filetype>.json (VS Code format, also read by
-- blink.cmp) by typing a prefix and pressing <Tab>.
local M = {}

local cache = {}

local function load(ft)
  if cache[ft] == nil then
    local path = vim.fn.stdpath("config") .. "/snippets/" .. ft .. ".json"
    local by_prefix = {}
    local ok, lines = pcall(vim.fn.readfile, path)
    if ok then
      for _, snip in pairs(vim.json.decode(table.concat(lines, "\n"))) do
        local body = type(snip.body) == "table" and table.concat(snip.body, "\n") or snip.body
        for _, prefix in ipairs(type(snip.prefix) == "table" and snip.prefix or { snip.prefix }) do
          by_prefix[prefix] = body
        end
      end
    end
    cache[ft] = by_prefix
  end
  return cache[ft]
end

-- Buffer-local <Tab>: expand the prefix before the cursor, else fall back to <Plug>(indent).
-- `dynamic` maps a prefix to a function returning the body for the current cursor
-- position (after the prefix is removed), or nil to use the JSON snippet.
function M.tab_expand(ft, dynamic)
  dynamic = dynamic or {}
  vim.keymap.set("i", "<Tab>", function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local before = vim.api.nvim_get_current_line():sub(1, col)
    local word = before:match("[%w_]+$")
    local body = word and load(ft)[word]
    if not body then return "<Plug>(indent)" end
    vim.schedule(function()
      vim.api.nvim_buf_set_text(0, row - 1, col - #word, row - 1, col, { "" })
      vim.api.nvim_win_set_cursor(0, { row, col - #word })
      vim.snippet.expand(dynamic[word] and dynamic[word]() or body)
    end)
    return ""
  end, { buffer = true, expr = true, remap = true, desc = "Expand snippet" })
end

return M
