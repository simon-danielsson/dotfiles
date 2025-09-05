vim.pack.add({
        {
                src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
                sync = true,
                silent = true
        },
})

require('render-markdown').setup()
