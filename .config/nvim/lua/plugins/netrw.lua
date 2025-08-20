vim.pack.add({
        { src = "https://github.com/prichrd/netrw.nvim", name = "netrw-nvim" },
})

require("netrw").setup({
        use_devicons = true, -- tells netrw.nvim to use nvim-web-devicons
        icons = {
                file = "", -- fallback icon for files
                directory = "", -- fallback icon for directories
        },
})
