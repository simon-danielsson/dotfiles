return {
        "nvim-telescope/telescope.nvim",
        version = false, -- or a specific tag like "0.1.6"
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope",
        keys = {
                { "<leader>t", "<cmd>Telescope<cr>", desc = "Find Files" },
                { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
                { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
                { "<leader>d", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
                { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
                { "<leader>k", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },

-- { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
        },
        opts = {
                defaults = {
                        prompt_prefix = " ",
                        selection_caret = " ",
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
        },
        config = function(_, opts)
                require("telescope").setup(opts)

vim.cmd([[
      highlight TelescopeNormal guibg=NONE ctermbg=NONE
      highlight TelescopeBorder guibg=NONE ctermbg=NONE
      ]])
        end,
}
