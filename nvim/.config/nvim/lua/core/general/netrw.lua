-- ==== General Settings ====

local autocmd = vim.api.nvim_create_autocmd
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1
vim.g.netrw_keepdir = 0

autocmd({ "FileType", "BufWinEnter" }, {
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

autocmd("BufEnter", {
    callback = function()
        vim.cmd("pclose")
    end,
})
