icon = require("ui.icons").telescope

vim.pack.add({
        {
                src = "https://github.com/nvim-lua/plenary.nvim",
                version = "master",
                sync = true,
                silent = true
        },
})

vim.pack.add({
        {
                src = "https://github.com/nvim-telescope/telescope.nvim",
                version = "master",
                sync = true,
                silent = true
        },
})

require("telescope").setup({
        cmd = "Telescope",
        defaults = {
                path_display = {
                        filename_first = {
                                reverse_directories = false,
                        },
                },
                prompt_prefix = icon.prompt_prefix,
                selection_caret = icon.selection_caret,
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                        horizontal = {
                                preview_width = 0.4,
                                results_width = 0.8,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                },
                winblend = 0, -- transparency
                border = true,
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }, -- rounded borders
                color_devicons = true,
                file_ignore_patterns = { "node_modules", ".git/" },
                set_env = { ["COLORTERM"] = "truecolor" },
        },
        pickers = {
                find_files = {
                        hidden = true,
                },
        },
})

vim.cmd([[
highlight TelescopeNormal guibg=NONE ctermbg=NONE
highlight TelescopeBorder guibg=NONE ctermbg=NONE
highlight TelescopePromptNormal guibg=NONE ctermbg=NONE
highlight TelescopePreviewNormal guibg=NONE ctermbg=NONE
]])
