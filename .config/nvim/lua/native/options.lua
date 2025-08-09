-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = '󱞩 '
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

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
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum,fuzzy"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Aesthetic options
vim.opt.guicursor = "n-v-c:block-blinkon1,i-ci-ve:ver25-blinkon1,r-cr:hor20-blinkon1"
vim.opt.termguicolors = true
vim.opt.numberwidth = 4
vim.opt.list = true
vim.opt.listchars = { tab = "│ ", trail = "•" }
vim.opt.fillchars = {
        horiz = "━",
        horizup = "┻",
        horizdown = "┳",
        vert = "┃",
        vertleft = "┨",
        vertright = "┣",
        verthoriz = "╋",
        fold = "⠀",
        eob = " ",
        diff = "┃",
        msgsep = "‾",
        foldsep = "│",
        foldclose = "▶",
        foldopen = "▼",
}
-- File handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false
vim.opt.confirm = false

-- Performance improvements
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

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

-- Don't load at startup
vim.g.loaded_gzip = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_osc52 = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_logipat = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_tar = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_zip = 1
vim.g.loaded_synmenu = 1
vim.g.loaded_bugreport = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
