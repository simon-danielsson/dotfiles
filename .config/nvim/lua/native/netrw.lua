-- ======================================================
-- General Settings
-- ======================================================

local g = vim.g
g.netrw_liststyle = 1
g.netrw_banner = 0
g.netrw_preview = 1
g.netrw_list_hide = [[\v(^|/)\.DS_Store$]]
vim.api.nvim_create_autocmd({"FileType", "BufWinEnter" }, {
        pattern = "netrw",
        callback = function()
                local opts = { buffer = true, noremap = true, silent = true }
                local keymap = vim.keymap.set
                keymap("n", "n", "h", opts)
                keymap("n", "e", "j", opts)
                keymap("n", "o", "k", opts)
                keymap("n", "i", "l", opts)
                vim.wo.relativenumber = true
                vim.wo.number = true
        end,
})

-- ======================================================
-- Preview
-- ======================================================

local grp = vim.api.nvim_create_augroup("netrw_layout", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
        group = grp,
        pattern = "netrw",
        callback = function()
                vim.cmd("wincmd H")
                vim.cmd("vertical resize 30")
        end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
        group = grp,
        callback = function()
                if vim.wo.previewwindow then
                        vim.cmd("wincmd L")
                        vim.cmd("vertical resize 80")
                end
        end,
})

vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
                vim.cmd("pclose")
        end,
})
