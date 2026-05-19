-- plugins --------------------------------------------------------------------

vim.pack.add({
    {
        src = "https://github.com/simon-danielsson/dimma.nvim"
    },
    {
        src = "https://github.com/nvim-mini/mini.nvim"
    }
})
require('mini.pairs').setup()
require('mini.snippets').setup()
require('mini.git').setup()

require('dimma').setup({
    transparent = false,
    bold = true,
    italic = false,
})

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
