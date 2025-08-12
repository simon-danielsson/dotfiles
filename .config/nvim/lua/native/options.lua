local opt = vim.opt
local g = vim.g
local o = vim.o

-- ======================================================
-- Line Numbers
-- ======================================================

opt.number              = true
opt.relativenumber      = true

-- ======================================================
-- Wrapping & Linebreaks
-- ======================================================

opt.wrap                = true
opt.linebreak           = true
opt.showbreak           = '󱞩 '
opt.scrolloff           = 99
opt.sidescrolloff       = 6

-- ======================================================
-- Clipboard
-- ======================================================

opt.clipboard           = 'unnamedplus'

-- ======================================================
-- Editing
-- ======================================================

opt.iskeyword           :append({"-", "_", })
opt.backspace           = "indent,eol,start"
opt.modifiable          = true
opt.completeopt         = { "menu","menuone","preview" }

-- ======================================================
-- Windows, Splits & Buffers
-- ======================================================

opt.splitbelow          = true
opt.autochdir           = false
opt.splitright          = true
opt.inccommand          = 'split'
opt.hidden              = true

-- ======================================================
-- Cursor & Statusline
-- ======================================================

o.mouse                 = 'a'
opt.mouse               = "a"
opt.cursorline          = true
o.showmode              = false
o.laststatus            = 3
opt.guicursor           =
"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,"
.. "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,"
.. "sm:block-blinkwait175-blinkoff150-blinkon175"

-- ======================================================
-- Indenting & Tabs
-- ======================================================

o.expandtab             = true
o.tabstop               = 8
o.shiftwidth            = 8
o.softtabstop           = 8
o.smartindent           = true
o.autoindent            = true

vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
                vim.bo.tabstop          = 8
                vim.bo.shiftwidth       = 8
                vim.bo.expandtab        = true
                o.tabstop               = 8
                o.shiftwidth            = 8
                o.softtabstop           = 8
                o.smartindent           = true
                o.autoindent            = true
        end,
})

vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
                vim.bo.tabstop          = 4
                vim.bo.shiftwidth       = 4
                vim.bo.expandtab        = true
                o.tabstop               = 4
                o.shiftwidth            = 4
                o.softtabstop           = 4
                o.smartindent           = false
                o.autoindent            = false
                vim.bo.indentexpr       = ""
                vim.bo.cindent          = false
        end,
})

-- ======================================================
-- Folds
-- ======================================================

opt.foldcolumn          = "2"
o.foldmethod            = "expr"
o.foldlevelstart        = 99
o.foldenable            = false

-- ======================================================
-- Search
-- ======================================================

opt.path                :append("**")
opt.hlsearch            = true
opt.ignorecase          = true
opt.smartcase           = true
opt.incsearch           = true
opt.wildmenu            = true
opt.wildmode            = "longest:full,full"
opt.wildoptions         = "pum,fuzzy"
opt.wildignore          :append({ "*.o", "*.obj",
"*.pyc", "*.class", "*.jar" })

-- ======================================================
-- Appearance
-- ======================================================

opt.winborder           = "rounded"
opt.termguicolors       = true
opt.numberwidth         = 4
opt.showmatch           = true
opt.list                = true
opt.listchars           = { tab = "║ ", trail = "•" }
opt.fillchars = {
        horiz           = " ",
        horizup         = " ",
        horizdown       = " ",
        vert            = " ",
        vertleft        = " ",
        vertright       = " ",
        verthoriz       = " ",
        fold            = "─",
        eob             = " ",
        diff            = " ",
        msgsep          = " ",
        foldsep         = "│",
        foldclose       = "",
        foldopen        = "",
}

-- ======================================================
-- File Handling
-- ======================================================

opt.undodir             = vim.fn.expand("~/.vim/undodir")
opt.undofile            = true
opt.backup              = false
opt.writebackup         = false
opt.swapfile            = false
opt.updatetime          = 100
opt.timeoutlen          = 200
opt.ttimeoutlen         = 0
opt.autoread            = true
opt.autowrite           = false
opt.confirm             = false

-- ======================================================
-- Performance Improvements
-- ======================================================

opt.redrawtime                  = 10000
opt.maxmempattern               = 20000

g.loaded_gzip                   = 1
g.loaded_netrwPlugin            = 1
g.loaded_tarPlugin              = 1
g.loaded_tutor                  = 1
g.loaded_zipPlugin              = 1
g.loaded_2html_plugin           = 1
g.loaded_osc52                  = 1
g.loaded_tohtml                 = 1
g.loaded_getscript              = 1
g.loaded_getscriptPlugin        = 1
g.loaded_logipat                = 1
g.loaded_netrw                  = 1
g.loaded_netrwSettings          = 1
g.loaded_netrwFileHandlers      = 1
g.loaded_tar                    = 1
g.loaded_rrhelper               = 1
g.loaded_zip                    = 1
g.loaded_synmenu                = 1
g.loaded_bugreport              = 1
g.loaded_vimball                = 1
g.loaded_vimballPlugin          = 1
