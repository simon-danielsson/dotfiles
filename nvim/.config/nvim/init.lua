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
require("core.plugins.recentfiles").setup()
require("core.plugins.diag").setup()

-- =========================================================
-- plugins

vim.pack.add({
    -- reamake
    { src = "https://github.com/simon-danielsson/reamake.nvim" },

    -- lspconfig
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})

-- =========================================================
-- lsp

require("lsp.lsp")
require("lsp.format")
require("lsp.cmp")
