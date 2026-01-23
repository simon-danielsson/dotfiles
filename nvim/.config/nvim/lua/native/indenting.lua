local opt     = vim.opt
local g       = vim.g
local o       = vim.o
local bo      = vim.bo
local autocmd = vim.api.nvim_create_autocmd

o.expandtab   = true
o.smartindent = true
o.autoindent  = true
-- o.tabstop     = 4
-- o.shiftwidth  = 4
-- o.softtabstop = 4

-- -- Filetype-specific settings
-- autocmd({ "FileType", "BufWritePre" }, {
-- 	pattern = { "c", "gdscript", "rust", "lua" },
-- 	callback = function()
-- 		vim.opt_local.list      = true
-- 		bo.tabstop              = 4
-- 		bo.shiftwidth           = 4
-- 		bo.softtabstop          = 4
-- 		bo.smartindent          = true
-- 		bo.autoindent           = true
-- 	end,
-- })

autocmd("FileType", {
	pattern = { "html", "css" },
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
