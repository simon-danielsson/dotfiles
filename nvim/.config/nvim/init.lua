-- core: general

require("core.general.options")
require("core.general.keymaps")
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
-- core: plugin recreations

require("core.plugins.pairs").setup()         -- auto pair paren, quotes etc.
require("core.plugins.indent_guides").setup() -- indent guides
require("core.plugins.flash").setup()         -- jumper
require("core.plugins.biscuits").setup()      -- function annotations
require("core.plugins.hexbg").setup()         -- color hex codes
require("core.plugins.recentfiles").setup()   -- recent files picker
require("core.plugins.diag").setup()          -- buff diagn. picker
require("core.plugins.buff").setup()          -- open buff picker

require("core.plugins.snippets").setup({      -- snippets (expand with c-x)
    issue = "*brakoll\t - d: $0, p: 0, t: feature, s: open",
})

-- =========================================================
-- lsp

require("lsp.lsp")
require("lsp.format")
require("lsp.cmp")
