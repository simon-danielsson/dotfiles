vim.pack.add({
        {
                src = "https://github.com/echasnovski/mini.surround",
                name = "surround",
                sync = true,
                silent = true
        },
})

require("mini.surround").setup({
        highlight_duration = 500,
        mappings = {
                add = '=', -- Add surrounding in Normal and Visual modes
                delete = '', -- Delete surrounding
                find = '', -- Find surrounding (to the right)
                find_left = '', -- Find surrounding (to the left)
                highlight = '', -- Highlight surrounding
                replace = '', -- Replace surrounding
                update_n_lines = '', -- Update `n_lines`
                suffix_last = '', -- Suffix to search with "prev" method
                suffix_next = '', -- Suffix to search with "next" method
        },
        n_lines = 6,
        respect_selection_type = false,
        search_method = 'cover_or_next',
        silent = true,
        custom_surroundings = {
                ["("] = { output = { left = "(", right = ")" } },
                ["["] = { output = { left = "[", right = "]" } },
                ["{"] = { output = { left = "{", right = "}" } },
                ['"'] = { output = { left = '"', right = '"' } },
                ["'"] = { output = { left = "'", right = "'" } },
                ["`"] = { output = { left = "`", right = "`" } },
        },
})
