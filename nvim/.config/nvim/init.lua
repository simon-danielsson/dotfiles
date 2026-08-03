-- native ---------------------------------------------------------------------

require('options').setup()
require('keymaps').setup()
require('oil-conf').setup()
require('theme').setup()
require('statusline').setup()
require('autocommands').setup()
require('terminal').setup()
require('lsp').setup()
require('modules').setup()

-- plugins --------------------------------------------------------------------

vim.pack.add({
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require('render-markdown').setup({
    completions = { lsp = { enabled = true } },
})
