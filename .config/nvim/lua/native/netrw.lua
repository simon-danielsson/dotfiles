vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_preview = 1
vim.api.nvim_create_autocmd("FileType", {
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
