vim.pack.add({
        {
                src = "https://github.com/arnamak/stay-centered.nvim",
                name = "stay-centered",
                sync = true,
                silent = true
        },
})

require('stay-centered').setup({
        skip_filetypes = {},
        enabled = true,
        allow_scroll_move = true,
        disable_on_mouse = false,
})
