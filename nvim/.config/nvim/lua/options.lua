local M = {}

local opt          = vim.opt
local o            = vim.o
local map          = vim.keymap.set

function M.setup()
    -- line numbers
opt.number         = true; opt.relativenumber = true

-- indenting
o.expandtab        = true; o.smartindent = true
o.autoindent       = true; opt.tabstop = 4
opt.shiftwidth     = 4; opt.softtabstop = 4

-- wrapping & linebreaks
opt.wrap           = true; opt.linebreak = true
o.breakindent      = true; opt.showbreak = '󱞩 '
opt.scrolloff      = 99; opt.virtualedit = "onemore"
opt.sidescrolloff  = 6; opt.smoothscroll = true

-- clipboard
opt.clipboard      = 'unnamedplus'

-- editing
opt.iskeyword:append({ "-", "_" })
opt.backspace     = "indent,eol,start"
opt.modifiable    = true

-- windows, splits & buffers
opt.splitbelow    = true; opt.autochdir = true
opt.splitright    = true; o.equalalways = true
opt.hidden        = true
opt.diffopt       = {
    "filler",
    "indent-heuristic",
    "linematch:60",
    "vertical",
}

-- cursor & statusline
opt.mouse         = "a"; opt.cursorline = true; o.showmode = true; o.laststatus = 3
opt.guicursor     = "n-v-c:block-blinkwait700-blinkoff400-blinkon250,i:ver25-blinkwait700-blinkoff400-blinkon250,r:hor20"

-- appearance
o.signcolumn      = 'yes:1'; opt.winborder = "rounded"
opt.termguicolors = true; o.encoding = "utf-8"
opt.numberwidth   = 4; opt.showmatch = true

opt.list          = true
opt.listchars     = {
    tab = "│ ",
    trail = "•",
    nbsp = " ",
}
opt.fillchars     = {
    horiz     = "─",
    horizup   = "┴",
    horizdown = "┬",
    vert      = "│",
    vertleft  = "┤",
    vertright = "├",
    verthoriz = "┼",
    fold      = "─",
    diff      = "╱",
    msgsep    = "─",
    foldsep   = "│",
    foldclose = "",
    foldopen  = "",
    eob       = " ",
}

-- search
opt.path:append("*"); opt.hlsearch = true; opt.ignorecase = true; opt.smartcase = true
opt.incsearch   = true; opt.wildmenu = true; opt.wildoptions = "pum,fuzzy"
opt.wildmode    = "noselect:lastused,full"
opt.wildignore:append({ "*.o", "*.obj",
    "*.pyc", "*.class", "*.jar" })

-- file handling
opt.shada       = "'100,<50,s10,h,:1000,@1000"; opt.undofile = true; opt.backup = false
opt.writebackup = false; opt.swapfile = false; opt.updatetime = 100; opt.timeoutlen = 200
opt.ttimeoutlen = 0; opt.autoread = true; opt.autowrite = false; opt.confirm = false
local undodir   = vim.fn.expand("~/.vim/undodir"); vim.opt.undodir = undodir
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

-- folds
opt.foldcolumn   = "2"; o.foldmethod = "marker"; o.foldlevelstart = 99; o.foldenable = false
map('n', 'zz', 'za', { desc = "Toggle fold under cursor" })
map({ 'n', 'v' }, 'zn', 'zf', { desc = "New fold" })
map('n', 'zo', 'zR', { desc = "Open all folds" })
map('n', 'zc', 'zM', { desc = "Close all folds" })

end

return M
