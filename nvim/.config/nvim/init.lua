require('options').setup()
require('keymaps').setup()
require('theme').setup()

-- vim.o.statusline = "%#StatusLineHidden# "
-- vim.o.laststatus = 0

require('autocommands').setup()
require('lsp').setup()
require('terminal').setup()
require('modules').setup()
require('plugins')
