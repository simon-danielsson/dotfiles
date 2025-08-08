vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_preview = 1
vim.api.nvim_create_autocmd("FileType", {
        pattern = "netrw",
        callback = function()
                local opts = { buffer = true, noremap = true, silent = true }
                vim.keymap.set("n", "n", "h", opts)
                vim.keymap.set("n", "e", "j", opts)
                vim.keymap.set("n", "o", "k", opts)
                vim.keymap.set("n", "i", "l", opts)
                vim.wo.relativenumber = true
                vim.wo.number = true
        end,
})
