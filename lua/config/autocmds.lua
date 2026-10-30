local autocmd = vim.api.nvim_create_autocmd

-- Reopen files at the last cursor position (not for commit messages / rebase todos)
autocmd("BufReadPost", {
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name:match("COMMIT_EDITMSG$") or name:match("git%-rebase%-todo$") then return end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Notice files changed outside nvim (git checkout, another split...) without
-- waiting for a focus change: also check when the cursor rests (updatetime)
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then vim.cmd("checktime") end
  end,
})

-- Briefly highlight yanked text
autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank({ timeout = 200 }) end,
})
