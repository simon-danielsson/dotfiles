-- ======================================================
-- Native config
-- ======================================================

require("native.options")
require("native.comment")
require("native.autocmds")
require("native.colorscheme")
require("native.statusline")
require("native.netrw")

require("native.keymaps")

-- ======================================================
-- Plugin config
-- ======================================================

require("plugins.indent-blankline")
require("plugins.nvim-treesitter")
require("plugins.nvim-telescope")
require("plugins.undotree")
require("plugins.noice")
require("plugins.cmp")

require("plugins.keymaps")

-- ======================================================
-- LSP
-- ======================================================

require("lsp")
-- ======================================================
-- TMUX
-- ======================================================

if os.getenv("TMUX") then
        vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
                callback = function()
                        local name = vim.fn.expand("%:t")
                        if name == "" then name = "[No Name]" end
                        vim.fn.system({ "tmux", "rename-window", name })
                end,
        })
end
