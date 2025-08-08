-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = '󱞩 '
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
-- vim.opt.colorcolumn = "85"

-- Behavior settings
vim.opt.clipboard = 'unnamedplus'
vim.opt.inccommand = 'split'
vim.opt.hidden = true
vim.opt.mouse = "a"
vim.opt.iskeyword:append({"-", "_", })
vim.opt.modifiable = true
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.o.expandtab = true
vim.o.tabstop = 8
vim.o.shiftwidth = 8
vim.o.softtabstop = 8
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.laststatus = 3
vim.o.mouse = 'a'
vim.o.showmode = false

-- Search options
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Aesthetic options
vim.opt.termguicolors = true
-- vim.opt.background = "dark"
vim.opt.list = true
vim.opt.listchars = { tab = "│ ", trail = "•" }

-- File handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

-- Performance improvements
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
                vim.bo.tabstop = 8
                vim.bo.shiftwidth = 8
                vim.bo.expandtab = true
                vim.o.tabstop = 8
                vim.o.shiftwidth = 8
                vim.o.softtabstop = 8
                vim.o.smartindent = true
                vim.o.autoindent = true
        end,
})
