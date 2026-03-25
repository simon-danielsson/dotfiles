local icon = require("core.ui.icons").telescope

vim.pack.add({
    {
        src = "https://github.com/nvim-telescope/telescope.nvim",
        version = "v0.2.1",
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
        winblend = 0,
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        file_ignore_patterns = { "node_modules", ".git/" },
        set_env = { ["COLORTERM"] = "truecolor" },
    },
    pickers = {
        colorscheme = {
            enable_preview = true,
        },
        find_files = {
            hidden = true,
        },
    },
})

local map = vim.keymap.set
local function common(descr)
    return { desc = descr, noremap = true, silent = true }
end

map("n", "<leader>t", "<cmd>Telescope<cr>", common("Telescope"))
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", common("Current buffers"))
map("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", common("List diagnostics"))
map("n", "<leader>r", "<cmd>Telescope oldfiles<cr>", common("Recent files"))
map("n", "<leader>k", "<cmd>Telescope keymaps<cr>", common("Keymaps"))
map("n", "<leader>g", "<cmd>Telescope live_grep<cr>", common("Local grep"))
map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", common("Go to LSP definition"))
