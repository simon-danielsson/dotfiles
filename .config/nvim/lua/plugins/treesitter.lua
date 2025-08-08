return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua",
				"python",
				"javascript",
				"html",
				"json",
				"rust",
				"markdown",
				"markdown_inline",
				"css",
				"c",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			fold = {
				enable = true,
				disable = { "python" },
			},
		})
		vim.o.foldmethod = 'expr'
		vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
		vim.o.foldlevel = 99
		vim.o.foldenable = true
		vim.keymap.set('n', 'zo', 'zR', { desc = 'Open all folds' })
		vim.keymap.set('n', 'zc', 'zM', { desc = 'Close all folds' })
		vim.keymap.set('n', 'zt', 'za', { desc = 'Toggle fold under cursor' })
	end,
}
