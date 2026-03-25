-- core: general

require("core.general.options")
require("core.general.keymaps")
require("core.general.indenting")
require("core.general.netrw")

-- =========================================================
-- core: autocmd

require("core.autocmd.templates")
require("core.autocmd.write")
require("core.autocmd.dirs")
require("core.autocmd.cursor")
require("core.autocmd.terminal")
require("core.autocmd.ui")

-- =========================================================
-- core: ui

local colors = require("core.ui.theme")
colors.colorscheme()
require("core.ui.colorscheme")
require("core.ui.statusline")

-- =========================================================
-- core: plugins

require("core.plugins.pairs").setup()
require("core.plugins.indent_guides").setup()
require("core.plugins.flash").setup()
require("core.plugins.biscuits").setup()
require("core.plugins.hexbg").setup()

-- =========================================================
-- plugins

vim.pack.add({
    -- plenary
    {
        src = "https://github.com/nvim-lua/plenary.nvim",
        version = "master",
        sync = true,
        silent = true
    },
    -- devicons
    { src = "https://github.com/nvim-tree/nvim-web-devicons",  name = "nvim-web-devicons" },
    -- reamake
    { src = "https://github.com/simon-danielsson/reamake.nvim" },
    -- lspconfig
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    -- treesitter
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "master",
        sync = true,
        silent = true
    },
})

require("plugins.nvim-telescope")

-- =========================================================
-- lsp

require("lsp.lsp")
require("lsp.format")
require("lsp.cmp")
