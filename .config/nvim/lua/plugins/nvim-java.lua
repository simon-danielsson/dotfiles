vim.pack.add({
        {
                src = 'https://github.com/nvim-java/nvim-java',
                version = 'main',
        },
})

require('java').setup()
vim.lsp.enable('jdtls')
