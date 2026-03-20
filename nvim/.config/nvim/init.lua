-- core: general

require("core.general.options")
require("core.general.netrw")
require("core.general.keymaps")
require("core.general.indenting")

-- core: autocmd

require("core.autocmd.templates")
require("core.autocmd.write")
require("core.autocmd.dirs")
require("core.autocmd.cursor")
require("core.autocmd.terminal")
require("core.autocmd.ui")

-- core: ui

local colors = require("core.ui.theme")
colors.colorscheme(2)
colors.background_transparency(true)

require("core.ui.colorscheme")
require("core.ui.statusline")

-- core: plugins

require("core.plugins.pairs").setup()
require("core.plugins.indent_guides").setup()

-- plugins

require("plugins.nvim-telescope")
require("plugins.flash")
require("plugins.noice")
require("plugins.render-markdown")
require("plugins.keymaps")
require("plugins.reamake")

-- lsp

require("lsp.lsp")
require("lsp.cmp")

-- tmux

if os.getenv("TMUX") then
    vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
        callback = function()
            local name = vim.fn.expand("%:t")
            if name == "" then name = "nvim" end
            vim.fn.system({ "tmux", "rename-window", name })
        end,
        desc = "Rename TMUX windows dynamically",
    })
end
