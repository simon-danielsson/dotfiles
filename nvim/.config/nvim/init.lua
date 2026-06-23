-- native ---------------------------------------------------------------------

require('options').setup()
require('keymaps').setup()
require('netrw').setup()
require('theme').setup()
require('statusline').setup()
require('autocommands').setup()
require('terminal').setup()
require('lsp').setup()
require('modules').setup()

-- plugins --------------------------------------------------------------------

require('render-markdown').setup({
    completions = { lsp = { enabled = true } },
})
