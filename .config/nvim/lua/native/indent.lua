local opt     = vim.opt
local g       = vim.g
local o       = vim.o
local bo      = vim.bo
local autocmd = vim.api.nvim_create_autocmd

o.expandtab   = true
o.smartindent = true
o.autoindent  = true
o.tabstop     = 8
o.shiftwidth  = 8
o.softtabstop = 8

-- Filetype-specific settings
autocmd("FileType", {
        pattern = { "gdscript", "rust", "lua" },
        callback = function()
                vim.opt_local.list      = true
                vim.opt_local.listchars = {
                        tab = "║ ",
                        trail = "•",
                        nbsp = " ",
                }
                bo.tabstop              = 8
                bo.shiftwidth           = 8
                bo.softtabstop          = 8
                bo.smartindent          = true
                bo.autoindent           = true
        end,
})

autocmd("FileType", {
        pattern = { "python", "markdown", "html", "css" },
        callback = function()
                vim.opt_local.list      = true
                vim.opt_local.listchars = {
                        tab = "║ ",
                        trail = "•",
                        nbsp = " ",
                }
                bo.tabstop              = 4
                bo.shiftwidth           = 4
                bo.softtabstop          = 4
        end,
})
