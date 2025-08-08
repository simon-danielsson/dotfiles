-- Basic options
vim.opt.number = true                               -- Line numbers
vim.opt.relativenumber = true                       -- Relative line numbers
vim.opt.cursorline = true                           -- Highlight current line
vim.opt.wrap = true                                 -- Wrap lines
vim.opt.linebreak = true                            -- Don't wrap in the middle of a word
vim.opt.showbreak = '󱞩 '                            -- Symbol at beginning of wrapped line
vim.opt.scrolloff = 10                              -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8                           -- Keep 8 columns left/right of cursor
-- vim.opt.colorcolumn = "85"                          -- Highlight column 100

-- Behavior settings
vim.opt.clipboard = 'unnamedplus'                   -- Use system clipboard
vim.opt.inccommand = 'split'                        -- Show results in split window
vim.opt.hidden = true                               -- Allow hidden buffers
vim.opt.mouse = "a"                                 -- Enable mouse support
vim.opt.iskeyword:append({"-", "_", })                       -- Treat dash as part of word
vim.opt.modifiable = true                           -- Allow buffer modifications
vim.opt.backspace = "indent,eol,start"              -- Better backspace behavior
vim.opt.autochdir = false                           -- Don't auto change directory
vim.opt.iskeyword:append("-")                       -- Treat dash as part of word
vim.opt.path:append("**")                           -- include subdirectories in search
vim.opt.splitbelow = true                           -- Horizontal splits go below
vim.opt.splitright = true                           -- Vertical splits go right
vim.o.expandtab = true                              -- Use spaces instead of tabs
vim.o.tabstop = 8                                   -- Number of visual spaces per tab
vim.o.shiftwidth = 8                                -- Number of spaces for each autoindent
vim.o.softtabstop = 8                               -- Number of spaces when pressing <Tab>
vim.o.smartindent = true                            -- Enable smart indenting
vim.o.autoindent = true                             -- Keep indent from past line
vim.o.laststatus = 3                                -- Set global statusline
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.cmdheight = 0

-- Search options
vim.opt.hlsearch = true                             -- Highlight search results
vim.opt.ignorecase = true                           -- Case insensitive search
vim.opt.smartcase = true                            -- Case sensitive if uppercase in search
vim.opt.incsearch = true                            -- Show matches as you type

-- Aesthetic options
vim.opt.termguicolors = true                        -- Enable 24-bit colors
vim.opt.background = "dark"                         -- Optimize text for dark theme
vim.opt.list = true                                 -- Special characters
vim.opt.listchars:append({
        tab = "│ ",
        trail = "•",
})

-- File handling
vim.opt.backup = false                              -- Don't create backup files
vim.opt.writebackup = false                         -- Don't create backup before writing
vim.opt.swapfile = false                            -- Don't create swap files
vim.opt.undofile = true                             -- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")   -- Undo directory
vim.opt.updatetime = 300                            -- Faster completion
vim.opt.timeoutlen = 500                            -- Key timeout duration
vim.opt.ttimeoutlen = 0                             -- Key code timeout
vim.opt.autoread = true                             -- Auto reload files changed outside vim
vim.opt.autowrite = false                           -- Don't auto save

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
                vim.o.tabstop = 8                                   -- Number of visual spaces per tab
                vim.o.shiftwidth = 8                                -- Number of spaces for each autoindent
                vim.o.softtabstop = 8                               -- Number of spaces when pressing <Tab>
                vim.o.smartindent = true                            -- Enable smart indenting
                vim.o.autoindent = true                             -- Keep indent from past line
        end,
})
