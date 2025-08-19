-- ======================================================
-- User Interface
-- ======================================================

require("ui.colorscheme")
require("ui.statusline")

-- ======================================================
-- Native
-- ======================================================

require("native.options")
require("native.comment")
require("native.autocmds")
require("native.netrw")
require("native.keymaps")

-- ======================================================
-- Plugin
-- ======================================================

require("plugins.indent-blankline")
require("plugins.nvim-treesitter")
require("plugins.nvim-telescope")
require("plugins.undotree")
require("plugins.surround")
require("plugins.noice")
require("plugins.flash")
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
