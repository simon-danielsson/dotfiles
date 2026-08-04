vim.pack.add({
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    "https://github.com/nvim-mini/mini.pairs.git",
    "https://github.com/nvim-tree/nvim-web-devicons.git",
    "https://github.com/nvim-lua/plenary.nvim.git",
    "https://github.com/nvim-telescope/telescope.nvim.git",
    "https://github.com/stevearc/oil.nvim.git",
    "https://github.com/folke/flash.nvim.git"
})

require 'nvim-web-devicons'.setup {
    color_icons = true,
    default = true,
    strict = false,
}

local map = vim.keymap.set

map({ 'n', 'x', 'o' }, 's', function() require("flash").jump() end, { desc = "Flash" })

local t_builtin = require('telescope.builtin')
map('n', '<leader>t', ":Telescope<CR>", { desc = 'Telescope open' })
map('n', '<leader>g', t_builtin.git_files, { desc = 'Telescope git files' })
map('n', '<leader>r', t_builtin.oldfiles, { desc = 'Telescope recent files' })
map('n', '<leader>b', t_builtin.buffers, { desc = 'Telescope buffers' })
map('n', '<leader>d', t_builtin.diagnostics, { desc = 'Telescope diagnostics' })

map("n", "<leader>f", function()
    local dir = vim.fn.getcwd()
    vim.cmd("Oil " .. vim.fn.fnameescape(dir))
end)

require('telescope').setup({
    defaults = {
        prompt_prefix = " ",
        selection_caret = "  ",
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        path_display = {
            "filename_first",
        },
    }
})

require('mini.pairs').setup()
require('render-markdown').setup({
    completions = { lsp = { enabled = true } },
})

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
    pattern = "oil",
    callback = function()
        vim.wo.relativenumber = true
        vim.wo.number = true
        vim.opt_local.syntax = "on"
        vim.api.nvim_set_hl(0, "OilLink", { link = "Identifier" })
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

    use_default_keymaps = true,
    view_options = {
        show_hidden = true,
        is_hidden_file = function(name, bufnr)
            local m = name:match("^%.")
            return m ~= nil
        end,
        case_insensitive = true,
        sort = {
            { "type", "asc" },
            { "name", "asc" },
        },
    },
})
