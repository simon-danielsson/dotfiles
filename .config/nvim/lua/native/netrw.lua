-- ==== General Settings ====

local g = vim.g
g.netrw_liststyle = 1
g.netrw_banner = 0
g.netrw_preview = 1
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
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

-- ==== Preview ====

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.cmd("pclose")
    end,
})
