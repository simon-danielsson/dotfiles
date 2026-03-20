local o       = vim.o
local bo      = vim.bo
local autocmd = vim.api.nvim_create_autocmd

o.expandtab   = true
o.smartindent = true
o.autoindent  = true
o.tabstop     = 4
o.shiftwidth  = 4
o.softtabstop = 4

autocmd({ "FileType", "BufWritePre" }, {
    pattern = { "reamake" },
    callback = function()
        vim.opt_local.list = true
        bo.tabstop         = 4
        bo.shiftwidth      = 4
        bo.softtabstop     = 4
        bo.smartindent     = false
        bo.autoindent      = false
    end,
})

autocmd("FileType", {
    pattern = { "html", "css" },
    -- pattern = { "*" },
    callback = function()
        vim.opt_local.list = true
        bo.tabstop         = 4
        bo.shiftwidth      = 4
        bo.softtabstop     = 4
    end,
})
