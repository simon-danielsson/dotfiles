vim.pack.add({
    {
        src = "https://github.com/simon-danielsson/dimma.nvim"
    },
})

require('options').setup()
require('netrw').setup()
require('keymaps').setup()
require('theme').setup()
require('statusline').setup()
require('autocommands').setup()
require('terminal').setup()
require('lsp').setup()
require('modules').setup()
