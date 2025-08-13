vim.pack.add({
        {
                src = "https://github.com/lukas-reineke/indent-blankline.nvim",
                version = "master",
                sync = true,
                silent = true
        },
})

require("ibl").setup({
        indent = {
                char = "║",
        },
        scope = {
                enabled = true,
        },
        enabled = true,
})
