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

require("core.plugins.pairs").setup()         -- auto pair paren, quotes etc.
require("core.plugins.indent_guides").setup() -- indent guides
require("core.plugins.flash").setup()         -- jumper
require("core.plugins.biscuits").setup()      -- function annotations
require("core.plugins.hexbg").setup()         -- color hex codes
require("core.plugins.recentfiles").setup()   -- recent files picker
require("core.plugins.diag").setup()          -- buff diagn. picker
require("core.plugins.buff").setup()          -- open buff picker

-- =========================================================
-- plugins

vim.pack.add({
    -- { src = "https://github.com/simon-danielsson/reamake.nvim" },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})

-- =========================================================
-- lsp

require("lsp.lsp")
require("lsp.format")
require("lsp.cmp")
