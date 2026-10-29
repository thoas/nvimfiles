-- koron/iferr (go install github.com/koron/iferr@latest) builds the
-- `if err != nil` block with zero values matching the enclosing function's returns
local function iferr_bin()
  local bin = vim.fn.exepath("iferr")
  if bin == "" then
    local gopath = vim.fn.system({ "go", "env", "GOPATH" }):gsub("%s+$", "")
    bin = gopath .. "/bin/iferr"
  end
  return vim.fn.executable(bin) == 1 and bin or nil
end

local function iferr()
  local bin = iferr_bin()
  if not bin then return nil end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local pos = vim.fn.line2byte(row) - 1 + col
  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") .. "\n"
  -- `err` becomes a field to type over (e.g. with fmt.Errorf)
  local res = vim.system({ bin, "-pos", tostring(pos), "-message", "${1:err}" }, { stdin = text }):wait(2000)
  if res.code ~= 0 or res.stdout == "" then return nil end
  return (res.stdout:gsub("\n$", ""))
end

-- iferr, func + <Tab> (see snippets/go.json); iferr falls back to the static
-- snippet if the tool is missing or the file doesn't parse
require("config.snippets").tab_expand("go", { iferr = iferr })
