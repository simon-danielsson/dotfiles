-- plugins --------------------------------------------------------------------

vim.pack.add({
    "https://github.com/nvim-mini/mini.snippets",
})

require('mini.snippets').setup()

-- native ---------------------------------------------------------------------

require('options').setup()
require('netrw').setup()
require('keymaps').setup()
require('theme').setup()
require('statusline').setup()
require('autocommands').setup()
require('terminal').setup()
require('lsp').setup()
require('modules').setup()
