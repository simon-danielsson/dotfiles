local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local ui_group = augroup("UiCommands", { clear = true })

-- vim.api.nvim_create_autocmd("BufEnter", {
--     group = ui_group,
--     callback = function()
--         vim.opt.formatoptions:remove { "c", "r", "o" }
--     end,
--     desc = "Disable new line comment",
-- })

autocmd("VimResized", {
    group = ui_group,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
    desc = "Auto-resize splits when window is resized",
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    group = ui_group,
    pattern = { '*.txt' },
    callback = function()
        if vim.o.filetype == 'help' then vim.cmd.wincmd('L') end
    end,
    desc = "Open help window in a vertical split to the right",
})

vim.api.nvim_create_autocmd("InsertEnter", {
    group = ui_group,
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = false
    end,
    desc = "Disable relative line numbers in insert mode",
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = ui_group,
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = true
    end,
    desc = "Enable relative line numbers in normal mode",
})
