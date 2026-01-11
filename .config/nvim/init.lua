-- ==== Native ====

require("native.options")
require("native.autocmds")
require("native.netrw")
require("native.keymaps")

-- ==== UI ====

local colors = require("ui.theme")
colors.colorscheme(1) -- 1: low contr or 2: high contr
colors.background_transparency(true)

require("ui.colorscheme")
require("ui.statusline")

-- ==== Plugins ====

require("plugins.nvim-telescope")
require("plugins.undotree")
require("plugins.flash")
require("plugins.render-markdown")
require("plugins.nvim-treesitter")
require("plugins.keymaps")

-- ==== Native (after) ====

require("native.pairs").setup()
require("native.indent")

-- ==== LSP ====

require("lsp.lsp")
require("lsp.cmp")

-- ==== TMUX ====

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
