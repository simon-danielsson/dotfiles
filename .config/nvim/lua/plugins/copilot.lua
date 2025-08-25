vim.pack.add({
	{
		src = "https://github.com/github/copilot.vim.git",
		version = "release",
		sync = true,
		silent = true
	},
})
vim.api.nvim_set_keymap("i", "ä", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "Ä", 'copilot#Next()', { silent = true, expr = true })
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = {
	["*"] = true,
	["markdown"] = false,
	["text"] = false,
	["TelescopePrompt"] = false,
}
