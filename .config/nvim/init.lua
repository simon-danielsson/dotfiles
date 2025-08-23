-- ======================================================
-- Native
-- ======================================================

require("native.options")
require("native.comment")
require("native.autocmds")
require("native.netrw")
require("native.keymaps")

-- ======================================================
-- UI
-- ======================================================

local colors = require("ui.theme")
colors.colorscheme(1) -- 1 or 2
colors.background_transparency(false)

require("ui.colorscheme")
require("ui.statusline")
require("ui.splash").setup()

-- ======================================================
-- Plugins
-- ======================================================

require("plugins.indent-blankline")
require("plugins.nvim-telescope")
require("plugins.nvim-treesitter")
require("plugins.undotree")
require("plugins.surround")
require("plugins.flash")
require("plugins.cmp")
require("plugins.netrw")

require("plugins.keymaps")

-- ======================================================
-- Native modules that need to be loaded last
-- ======================================================

require("native.trident").setup()
require("native.lsp_hover_win").setup()
require("native.notify")

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
                desc = "Rename TMUX windows dynamically",
        })
end
