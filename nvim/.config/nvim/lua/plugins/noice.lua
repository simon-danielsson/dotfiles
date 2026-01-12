local icon = require("ui.icons").noice

local plugins = {
	"https://github.com/MunifTanjim/nui.nvim.git",
	"https://github.com/rcarriga/nvim-notify.git",
	"https://github.com/folke/noice.nvim",
}

for _, plugin in ipairs(plugins) do
	vim.pack.add({ { src = plugin, sync = true, silent = true } })
end

vim.notify = require("notify")

require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},

	cmdline = {
		enabled = true, -- enables the Noice cmdline UI
		view = "cmdline_input",
		format = {
			cmdline = { title = "", view = "cmdline_input", pattern = "^:", icon = icon.cmd, lang = "vim" },
			search_down = { title = " " .. icon.search .. " ", kind = "search", pattern = "^/", icon = "", lang = "regex" },
			search_up = { title = " " .. icon.search .. " ", kind = "search", pattern = "^%?", icon = "", lang = "regex" },
			filter = { pattern = "^:%s*!", icon = icon.filter, lang = "bash" },
			lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = icon.lua, lang = "lua" },
			help = { pattern = "^:%s*he?l?p?%s+", icon = icon.help },
			input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
		},
	},

	messages = {
		-- NOTE: If you enable messages, then the cmdline is enabled automatically.
		-- This is a current Neovim limitation.
		enabled = true, -- enables the Noice messages UI
		view = "notify", -- default view for messages
		view_error = "notify", -- view for errors
		view_warn = "notify", -- view for warnings
		view_history = "messages", -- view for :messages
		view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
	},
})
