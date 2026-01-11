local colors = require("ui.theme").colors

vim.pack.add({
	{
		src = "https://github.com/lukas-reineke/indent-blankline.nvim.git",
		name = "ibl",
		version = "v3.9.0",
		sync = true,
		silent = true
	},
})

vim.api.nvim_set_hl(0, "CursorColumn", { fg = colors.bg_mid, bg = "none" })
vim.api.nvim_set_hl(0, "Scope", { fg = colors.fg_mid, bg = "none" })

require("ibl").setup {
	indent = { highlight = "CursorColumn", char = "│" },

	whitespace = {
		remove_blankline_trail = false,
	},
	scope = {
		highlight = "Scope",
		enabled = true },
}
