return {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        lazy = false,
        config = function()
                require("oil").setup({
                        default_file_explorer = true,
                        columns = { "icon" },
                        buf_options = {
                                buflisted = false,
                                bufhidden = "hide",
                        },
                        win_options = {
                                wrap = false,
                                signcolumn = "no",
                                cursorcolumn = false,
                                foldcolumn = "0",
                                relativenumber = true,
                                spell = false,
                                list = false,
                                conceallevel = 3,
                                concealcursor = "nvic",
                        },
                        delete_to_trash = true,
                        skip_confirm_for_simple_edits = false,
                        prompt_save_on_select_new_entry = true,
                        cleanup_delay_ms = 2000,
                        lsp_file_methods = {
                                enabled = true,
                                timeout_ms = 1000,
                                autosave_changes = false,
                        },
                        constrain_cursor = "editable",
                        watch_for_changes = false,
                        keymaps = {
                                ["g?"] = { "actions.show_help", mode = "n" },
                                ["<CR>"] = "actions.select",
                                ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                                ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                                ["<C-t>"] = { "actions.select", opts = { tab = true } },
                                ["<C-p>"] = "actions.preview",
                                ["<C-c>"] = { "actions.close", mode = "n" },
                                ["<C-l>"] = "actions.refresh",
                                ["-"] = { "actions.parent", mode = "n" },
                                ["_"] = { "actions.open_cwd", mode = "n" },
                                ["`"] = { "actions.cd", mode = "n" },
                                ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                                ["gs"] = { "actions.change_sort", mode = "n" },
                                ["gx"] = "actions.open_external",
                                ["g."] = { "actions.toggle_hidden", mode = "n" },
                                ["g\\"] = { "actions.toggle_trash", mode = "n" },
                        },
                        use_default_keymaps = true,
                        view_options = {
                                show_hidden = true,
                                is_hidden_file = function(name, _)
                                        return name:match("^%.") ~= nil
                                end,
                                is_always_hidden = function(_, _)
                                        return false
                                end,
                                natural_order = "fast",
                                case_insensitive = false,
                                sort = {
                                        { "type", "asc" },
                                        { "name", "asc" },
                                },
                                highlight_filename = function(_, _, _, _)
                                        return nil
                                end,
                        },
                        extra_scp_args = {},
                        git = {
                                add = function(_) return false end,
                                mv = function(_, _) return false end,
                                rm = function(_) return false end,
                        },
                        float = {
                                padding = 2,
                                margin = 2,
                                max_width = 0.8,
                                max_height = 0.8,
                                border = "rounded",
                                -- get_win_title = nil,
                                preview_split = "right",
                                override = function(conf)
                                        return conf
                                end,
                        },
                        preview_win = {
                                update_on_cursor_moved = true,
                                preview_method = "fast_scratch",
                                disable_preview = function(_) return false end,
                                win_options = {},
                        },
                        confirmation = {
                                max_width = 0.9,
                                min_width = { 40, 0.4 },
                                max_height = 0.9,
                                min_height = { 5, 0.1 },
                                border = "rounded",
                        },
                        progress = {
                                max_width = 0.9,
                                min_width = { 40, 0.4 },
                                max_height = { 10, 0.9 },
                                min_height = { 5, 0.1 },
                                border = "none",
                                minimized_border = "none",
                        },
                        ssh = {
                                border = "none",
                        },
                        keymaps_help = {
                                border = "none",
                        },
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                        pattern = "*",
                        callback = function()
                                if vim.bo.filetype == "oil" then
                                        require("oil.actions").preview.callback()
                                end
                        end,
                })
        end,
}
