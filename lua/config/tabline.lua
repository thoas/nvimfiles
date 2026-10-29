-- Tab line in the lualine molokai colors: " 1 main.go ● " per tab, named after
-- the tab's file window (never the tree), shown only when there are 2+ tabs.

local function set_highlights()
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#232526", bg = "#66d9ef", bold = true })
  vim.api.nvim_set_hl(0, "TabLine", { fg = "#808080", bg = "#232526" })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#1B1D1E" })
  vim.api.nvim_set_hl(0, "TabLineModSel", { fg = "#f92672", bg = "#66d9ef", bold = true })
  vim.api.nvim_set_hl(0, "TabLineMod", { fg = "#f92672", bg = "#232526" })
end
set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

-- The file shown in the tab: its current window, or the last window that isn't the tree
local function tab_buf(tab)
  local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
  if vim.bo[buf].filetype ~= "NvimTree" then return buf end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    local b = vim.api.nvim_win_get_buf(win)
    if vim.bo[b].filetype ~= "NvimTree" then buf = b end
  end
  return buf
end

function _G.molokai_tabline()
  local out = {}
  local current = vim.api.nvim_get_current_tabpage()
  for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local buf = tab_buf(tab)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    if name == "" then name = "[No Name]" end
    local sel = tab == current
    out[#out + 1] = "%" .. i .. "T" .. (sel and "%#TabLineSel#" or "%#TabLine#") .. " " .. i .. " " .. name .. " "
    if vim.bo[buf].modified then
      out[#out + 1] = (sel and "%#TabLineModSel#" or "%#TabLineMod#") .. "● "
    end
  end
  return table.concat(out) .. "%#TabLineFill#%T"
end

vim.o.tabline = "%!v:lua.molokai_tabline()"
