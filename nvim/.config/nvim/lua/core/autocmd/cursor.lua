local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local cursor_group = augroup("CursorCommands", { clear = true })

autocmd("BufReadPost", {
    group = cursor_group,
    callback = function()
        if vim.bo.filetype == "commit" then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
    desc = "Restore cursor location when opening a buffer",
})

autocmd("TextYankPost", {
    group = cursor_group,
    callback = function()
        vim.highlight.on_yank()
    end,
    desc = "Highlight yanked text",
})
