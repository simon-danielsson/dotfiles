-- core: general

require("core.general.options")
require("core.general.keymaps")
require("core.general.indenting")
require("core.general.netrw")

-- core: autocmd

require("core.autocmd.templates")
require("core.autocmd.write")
require("core.autocmd.dirs")
require("core.autocmd.cursor")
require("core.autocmd.terminal")
require("core.autocmd.ui")

-- core: ui

local colors = require("core.ui.theme")
colors.colorscheme()
require("core.ui.colorscheme")
require("core.ui.statusline")

-- core: plugins

require("core.plugins.pairs").setup()
require("core.plugins.indent_guides").setup()
require("core.plugins.flash").setup()
require("core.plugins.biscuits").setup()

-- plugins

require("plugins.nvim-web-devicons")
require("plugins.nvim-telescope")
require("plugins.nvim-treesitter")

-- lsp

require("lsp.lsp")
require("lsp.format")
require("lsp.cmp")

-- my own plugins

require("plugins.reamake")
