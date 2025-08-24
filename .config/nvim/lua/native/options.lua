local opt          = vim.opt
local g            = vim.g
local o            = vim.o
local bo           = vim.bo
local autocmd      = vim.api.nvim_create_autocmd
-- ======================================================
-- Line Numbers
-- ======================================================

opt.number         = true
opt.relativenumber = true

-- ======================================================
-- Wrapping & Linebreaks
-- ======================================================

opt.wrap           = true
opt.linebreak      = true
vim.o.breakindent  = true
opt.showbreak      = '󱞩 '
opt.scrolloff      = 99
opt.sidescrolloff  = 6
vim.o.smoothscroll = true

-- ======================================================
-- Clipboard
-- ======================================================

opt.clipboard      = 'unnamedplus'

-- ======================================================
-- Editing
-- ======================================================

opt.iskeyword:append({ "-", "_" })
opt.backspace    = "indent,eol,start"
opt.modifiable   = true
opt.completeopt  = { "noselect", "menu", "menuone", "preview" }
vim.o.inccommand = 'nosplit'

-- ======================================================
-- Windows, Splits & Buffers
-- ======================================================

opt.splitbelow   = true
opt.autochdir    = false
opt.splitright   = true
o.equalalways    = true
opt.inccommand   = 'split'
opt.hidden       = true
opt.diffopt      = {
	"filler",
	"indent-heuristic",
	"linematch:60",
	"vertical",
}

-- ======================================================
-- Cursor & Statusline
-- ======================================================

o.mouse          = 'a'
opt.mouse        = "a"
opt.cursorline   = true
o.showmode       = false
o.laststatus     = 3
vim.cmd("hi noCursor blend=0 cterm=bold")
vim.opt.guicursor          = "n-v-c:block-blinkwait700-blinkoff400-blinkon250,i:ver25-blinkwait700-blinkoff400-blinkon250,r:hor20"

-- ======================================================
-- Appearance
-- ======================================================

o.signcolumn               = 'yes:1'
opt.winborder              = "rounded"
opt.termguicolors          = true
vim.o.encoding             = "utf-8"
opt.numberwidth            = 4
opt.showmatch              = true
opt.listchars              = {
	tab = "║ ",
	trail = "•",
	nbsp = " ",
}
opt.list                   = true
opt.fillchars              = {
	horiz     = " ",
	horizup   = " ",
	horizdown = " ",
	vert      = " ",
	vertleft  = " ",
	vertright = " ",
	verthoriz = " ",
	fold      = "─",
	eob       = " ",
	diff      = " ",
	msgsep    = " ",
	foldsep   = "│",
	foldclose = "",
	foldopen  = "",
}

-- ======================================================
-- Indenting & Tabs
-- ======================================================

g.python_recommended_style = 1
o.expandtab                = false
o.smartindent              = true
o.autoindent               = true
o.tabstop                  = 8
o.shiftwidth               = 8
o.softtabstop              = 8

autocmd("FileType", {
	pattern = { "python", "markdown" },
	callback = function()
		vim.opt_local.list      = true
		vim.opt_local.listchars = {
			tab = "║ ",
			trail = "•",
			nbsp = " ",
		}
		bo.tabstop              = 4
		bo.shiftwidth           = 4
		bo.softtabstop          = 4
		bo.expandtab            = true
	end,
})

-- ======================================================
-- Folds
-- ======================================================

opt.foldcolumn   = "2"
o.foldmethod     = "expr"
o.foldlevelstart = 99
o.foldenable     = false

-- ======================================================
-- Search
-- ======================================================

opt.path:append("**")
opt.hlsearch    = true
opt.ignorecase  = true
opt.smartcase   = true
opt.incsearch   = true
opt.wildmenu    = true
opt.wildmode    = "longest:full,full"
opt.wildoptions = "pum,fuzzy"
opt.wildignore:append({ "*.o", "*.obj",
	"*.pyc", "*.class", "*.jar" })

-- ======================================================
-- File Handling
-- ======================================================

opt.undodir              = vim.fn.expand("~/.vim/undodir")
opt.undofile             = true
opt.backup               = false
opt.writebackup          = false
opt.swapfile             = false
opt.updatetime           = 100
opt.timeoutlen           = 200
opt.ttimeoutlen          = 0
opt.autoread             = true
opt.autowrite            = false
opt.confirm              = false

-- ======================================================
-- Performance Improvements
-- ======================================================

opt.redrawtime           = 10000
opt.maxmempattern        = 20000

g.loaded_gzip            = 1
g.loaded_tarPlugin       = 1
g.loaded_tutor           = 1
g.loaded_zipPlugin       = 1
g.loaded_2html_plugin    = 1
g.loaded_osc52           = 1
g.loaded_tohtml          = 1
g.loaded_getscript       = 1
g.loaded_getscriptPlugin = 1
g.loaded_logipat         = 1
g.loaded_tar             = 1
g.loaded_rrhelper        = 1
g.loaded_zip             = 1
g.loaded_synmenu         = 1
g.loaded_bugreport       = 1
g.loaded_vimball         = 1
g.loaded_vimballPlugin   = 1
