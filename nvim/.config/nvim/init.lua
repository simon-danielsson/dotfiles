-- ==== Native ====

require("native.options")
require("native.autocmds")
require("native.netrw")
require("native.keymaps")
require("native.indenting")
require("native.pairs").setup()

-- ==== UI ====

local colors = require("ui.theme")
colors.colorscheme(2)
colors.background_transparency(true)

require("ui.colorscheme")
require("ui.statusline")

-- ==== Plugins ====

require("plugins.nvim-telescope")
require("plugins.flash")
require("plugins.noice")
require("plugins.render-markdown")
require("plugins.indent-blankline")
require("plugins.keymaps")
require("plugins.reamake")

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
