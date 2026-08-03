local M = {}

function M.setup()
    vim.pack.add({
        "https://github.com/stevearc/oil.nvim.git"
    })

    vim.keymap.set("n", "<leader>f", function()
        local dir = vim.fn.getcwd()
        vim.cmd("Oil " .. vim.fn.fnameescape(dir))
    end)

    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
        pattern = "oil",
        callback = function()
            vim.wo.relativenumber = true
            vim.wo.number = true
        end,
    })

    require("oil").setup({
        default_file_explorer = true,

        delete_to_trash = false,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 0,

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
            ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
            ["gs"] = { "actions.change_sort", mode = "n" },
            ["gx"] = "actions.open_external",
            ["g."] = { "actions.toggle_hidden", mode = "n" },
            ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,
        view_options = {
            -- Show files and directories that start with "."
            show_hidden = true,
            -- This function defines what is considered a "hidden" file
            is_hidden_file = function(name, bufnr)
                local m = name:match("^%.")
                return m ~= nil
            end,
            -- This function defines what will never be shown, even when `show_hidden` is set
            is_always_hidden = function(name, bufnr)
                return false
            end,
            -- Sort file names with numbers in a more intuitive order for humans.
            -- Can be "fast", true, or false. "fast" will turn it off for large directories.
            natural_order = "fast",
            -- Sort file and directory names case insensitive
            case_insensitive = true,
            sort = {
                -- sort order can be "asc" or "desc"
                -- see :help oil-columns to see which columns are sortable
                { "type", "asc" },
                { "name", "asc" },
            },
            -- Customize the highlight group for the file name
            highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
                return nil
            end,
        },
        -- Extra arguments to pass to SCP when moving/copying files over SSH
        extra_scp_args = {},
        -- Extra arguments to pass to aws s3 when creating/deleting/moving/copying files using aws s3
        extra_s3_args = {},
        -- EXPERIMENTAL support for performing file operations with git
        git = {
            -- Return true to automatically git add/mv/rm files
            add = function(path)
                return false
            end,
            mv = function(src_path, dest_path)
                return false
            end,
            rm = function(path)
                return false
            end,
        },
        -- Configuration for the floating window in oil.open_float
        float = {
            -- Padding around the floating window
            padding = 2,
            -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            max_width = 0,
            max_height = 0,
            border = nil,
            win_options = {
                winblend = 0,
            },
            -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
            get_win_title = nil,
            -- preview_split: Split direction: "auto", "left", "right", "above", "below".
            preview_split = "auto",
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            override = function(conf)
                return conf
            end,
        },
    })
end

return M
