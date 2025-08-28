vim.pack.add({
        {
                src = "https://github.com/michaelrommel/nvim-silicon.git",
                version = "main",
                sync = true,
                silent = true
        },
})

require("nvim-silicon").setup({
        debug = false,
        font = "0xProto Nerd Font",
        theme = "gruvbox-dark",
        background = "#212121",
        background_image = nil,
        pad_horiz = 0,
        pad_vert = 0,
        no_round_corner = true,
        no_window_controls = true,
        no_line_number = true,
        line_offset = function(args)
                return args.line1
        end,
        tab_width = 8,
        language = function()
                return vim.fn.fnamemodify(
                        vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
                        ":e"
                )
        end,
        shadow_blur_radius = 0,
        shadow_offset_x = 0,
        shadow_offset_y = 0,
        shadow_color = nil,
        gobble = true,
        num_separator = nil,
        window_title = function()
                return vim.fn.fnamemodify(
                        vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
                        ":t"
                )
        end,
        command = "silicon",
        output = function()
                return "./" .. os.date("!%Y-%m-%dT%H-%M-%SZ") .. "_code.png"
        end,
})
