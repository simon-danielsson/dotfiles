-- =========================================================
-- aliases
-- =========================================================

local opt          = vim.opt
local g            = vim.g
local o            = vim.o
local autocmd      = vim.api.nvim_create_autocmd
local augroup      = vim.api.nvim_create_augroup
local map          = vim.keymap.set

-- =========================================================
-- general/options
-- =========================================================

-- line numbers
opt.number         = true
opt.relativenumber = true

-- indenting
o.expandtab        = true
o.smartindent      = true
o.autoindent       = true
o.tabstop          = 4
o.shiftwidth       = 4
o.softtabstop      = 4

-- wrapping & linebreaks
opt.wrap           = true
opt.linebreak      = true
o.breakindent      = true
opt.showbreak      = '󱞩 '
opt.scrolloff      = 999
opt.virtualedit    = "onemore"
opt.sidescrolloff  = 6
o.smoothscroll     = true

-- clipboard
opt.clipboard      = 'unnamedplus'

-- editing
opt.iskeyword:append({ "-", "_" })
opt.backspace  = "indent,eol,start"
opt.modifiable = true

-- windows, splits & buffers
opt.splitbelow = true
opt.autochdir  = false
opt.splitright = true
o.equalalways  = true
opt.inccommand = 'split'
opt.hidden     = true
opt.diffopt    = {
    "filler",
    "indent-heuristic",
    "linematch:60",
    "vertical",
}

-- cursor & statusline
o.mouse        = 'a'
opt.mouse      = "a"
opt.cursorline = true
o.showmode     = false
o.laststatus   = 3
vim.cmd("hi noCursor blend=0 cterm=bold")
vim.opt.guicursor = "n-v-c:block-blinkwait700-blinkoff400-blinkon250,i:ver25-blinkwait700-blinkoff400-blinkon250,r:hor20"

-- appearance
o.signcolumn      = 'yes:1'
opt.winborder     = "rounded"
opt.termguicolors = true
vim.o.encoding    = "utf-8"
opt.numberwidth   = 4
opt.showmatch     = true

opt.list          = true

opt.listchars     = {
    tab = "│ ",
    trail = "•",
    nbsp = " ",
}

opt.fillchars     = {
    eob       = " ",
    diff      = "╱",
    msgsep    = "─",
    foldsep   = "│",
    foldclose = "",
    foldopen  = "",
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
    eob       = " ",
    diff      = " ",
    msgsep    = " ",
    foldsep   = "│",
    foldclose = "",
    foldopen  = "",
}

-- folds
opt.foldcolumn    = "2"
o.foldmethod      = "expr"
o.foldlevelstart  = 99
o.foldenable      = false

-- search
opt.path:append("*")
opt.hlsearch    = true
opt.ignorecase  = true
opt.smartcase   = true
opt.incsearch   = true
opt.wildmenu    = true
opt.wildmode    = "longest:full,full"
opt.wildoptions = "pum,fuzzy"
opt.wildignore:append({ "*.o", "*.obj",
    "*.pyc", "*.class", "*.jar" })

-- file handling
opt.shada                 = "'1000,<50,s10,h"
opt.undodir               = vim.fn.expand("~/.vim/undodir")
opt.undofile              = true
opt.backup                = false
opt.writebackup           = false
opt.swapfile              = false
opt.updatetime            = 100
opt.timeoutlen            = 200
opt.ttimeoutlen           = 0
opt.autoread              = true
opt.autowrite             = false
opt.confirm               = false

-- performance improvements
opt.redrawtime            = 10000
opt.maxmempattern         = 20000
g.loaded_gzip             = 1
g.loaded_tarPlugin        = 1
g.loaded_tutor            = 1
g.loaded_zipPlugin        = 1
g.loaded_2html_plugin     = 1
g.loaded_osc52            = 1
g.loaded_tohtml           = 1
g.loaded_getscript        = 1
g.loaded_getscriptPlugin  = 1
g.loaded_logipat          = 1
g.loaded_tar              = 1
g.loaded_rrhelper         = 1
g.loaded_zip              = 1
g.loaded_synmenu          = 1
g.loaded_bugreport        = 1
g.loaded_vimball          = 1
g.loaded_vimballPlugin    = 1

-- =========================================================
-- general/netrw
-- =========================================================

vim.g.netrw_liststyle     = 3
vim.g.netrw_banner        = 0
vim.g.netrw_preview       = 1
vim.g.netrw_keepdir       = 0
vim.g.netrw_sort_sequence = [[[/]$,\<core\%(\.\d\+\)\=,\.(c|h|cpp|hpp|lua|py|rs|go|ts|js)$,*]]
vim.api.nvim_set_hl(0, "netrwMarkFile", { link = "Visual" })

-- keymaps
autocmd({ "FileType", "BufWinEnter" }, {
    pattern = "netrw",
    callback = function()
        local opts = { buffer = true, noremap = true, silent = true }
        local keymap = vim.keymap.set
        keymap("n", "n", "h", opts)
        keymap("n", "e", "j", opts)
        keymap("n", "o", "k", opts)
        keymap("n", "i", "l", opts)
        vim.wo.relativenumber = true
        vim.wo.number = true
    end,
})

-- close netrw preview on bufenter
autocmd("BufEnter", {
    callback = function()
        vim.cmd("pclose")
    end,
})

-- =========================================================
-- general/keymaps
-- =========================================================

-- leader
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- navigation: local
map("n", "i", "<Nop>")
map("n", "I", "<Nop>")
map("n", "o", "<Nop>")
map("n", "O", "<Nop>")

map({ "n", "v" }, "n", "h",
    { desc = "Move left" })

map({ "n", "v" }, "i", "l",
    { desc = "Move right" })

map({ 'n', 'v' }, 'o', "v:count == 0 ? 'gk' : 'k'",
    {
        expr = true,
        silent = true,
        desc = "Move up (through wrapped lines)"
    })

map({ 'n', 'v' }, 'e', "v:count == 0 ? 'gj' : 'j'",
    {
        expr = true,
        silent = true,
        desc = "Move down (through wrapped lines)"
    })

map("n", ">", "nzzzv",
    { desc = "Next search result (centered)" })

map("n", "<", "Nzzzv",
    { desc = "Previous search result (centered)" })

map("n", "}", "}zz",
    { desc = "Next empty line (centered)" })

map("n", "{", "{zz",
    { desc = "Previous empty line (centered)" })

map("n", "<C-e>", function()
    vim.diagnostic.goto_prev()
    vim.cmd("normal! zz")
end, { desc = "Go to previous diagnostic" })

map("n", "<C-o>", function()
    vim.diagnostic.goto_next()
    vim.cmd("normal! zz")
end, { desc = "Go to next diagnostic" })

-- navigation: global

vim.keymap.set("n", "<leader>f", function()
    dir = vim.fn.getcwd()
    vim.cmd("Explore " .. vim.fn.fnameescape(dir))
end)

map("n", ";", function()
    local bufs = vim.api.nvim_list_bufs()
    -- Filter only listed and loaded buffers
    local open_bufs = {}
    for _, bufnr in ipairs(bufs) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
            table.insert(open_bufs, bufnr)
        end
    end
    if #open_bufs == 0 then return end
    local current = vim.api.nvim_get_current_buf()
    local idx = nil
    for i, bufnr in ipairs(open_bufs) do
        if bufnr == current then
            idx = i
            break
        end
    end
    local next_idx = (idx % #open_bufs) + 1
    vim.api.nvim_set_current_buf(open_bufs[next_idx])
end, { desc = "Cycle through open buffers" })

map('t', '<Esc><Esc>', '<C-\\><C-n>',
    { desc = 'Exit terminal mode' })

map("n", ",", function()
    vim.cmd("wincmd w")
end, { desc = "Cycle through splits" })

map('n', '<Left>', '<cmd>vertical resize +4<cr>',
    { desc = 'Increase Window Width' })

map('n', '<Right>', '<cmd>vertical resize -4<cr>',
    { desc = 'Decrease Window Width' })

-- general

map("n", "<Esc>", "<cmd>nohlsearch<CR>",
    { desc = "Clear search highlights" })

map('n', '<leader>å', function()
        vim.cmd('restart')
    end,
    { desc = 'Restart Neovim' })

-- macros

map("n", "ä", function()
        local reg = vim.fn.reg_recording()
        if reg == "q" then
            -- Stop recording
            vim.cmd("normal! q")
        else
            -- Overwrite previous recording
            vim.cmd("normal! qq")
        end
    end,
    { desc = "Start/stop recording macro in @q" })

map("n", "Ä", function()
        vim.cmd("normal! @q")
    end,
    { desc = "Play macro in @q once" })

-- folds

map('n', 'za', 'za',
    { desc = "Toggle fold under cursor" })

map('n', 'zo', 'zR',
    { desc = "Open all folds" })

map('n', 'zc', 'zM',
    { desc = "Close all folds" })

-- editing

map("n", "<leader>,", [[:%s/<C-r><C-w>//gI<Left><Left><Left>]],
    { desc = "open %s//gI with cword" })

map('n', 'x', '"_x',
    { desc = "Delete single character without yanking to register" })

map("n", "<leader><CR>", "i<CR><Esc>",
    { desc = "Insert newline at cursor in normal mode" })

map("n", "<leader><BS>", "i<BS><Esc>",
    { desc = "Insert backspace at cursor in normal mode" })

map("n", "<leader><leader>", "i<Space><Esc>",
    { desc = "Insert space at cursor in normal mode" })

-- "vip" to go visual inside paragraph (had to be fixed since it broke when I remapped the movement keys)
map("n", "vip", function()
    local cur_line = vim.api.nvim_win_get_cursor(0)[1]
    local total_lines = vim.api.nvim_buf_line_count(0)
    local top = cur_line
    while top > 1 and vim.fn.getline(top - 1):match("^%s*$") == nil do
        top = top - 1
    end
    local bottom = cur_line
    while bottom < total_lines and vim.fn.getline(bottom + 1):match("^%s*$") == nil do
        bottom = bottom + 1
    end
    vim.api.nvim_win_set_cursor(0, { top, 0 })
    vim.cmd("normal! V")
    vim.api.nvim_win_set_cursor(0, { bottom, 0 })
end, { desc = "Smart select paragraph" })

-- New insert mode bindings
map("n", "<leader>i", "i", { desc = "Insert before cursor" })
map("n", "<leader>I", "I", { desc = "Insert at line start" })
map("n", "<leader>o", "o", { desc = "Open new line below" })
map("n", "<leader>O", "O", { desc = "Open new line above" })

map("i", "<Tab>", "<Nop>")
map("i", "<S-Tab>", "<Nop>")
map({ "v", "i" }, "<Tab>", ">gv", { desc = "Indent selection" })
map({ "v", "i" }, "<S-Tab>", "<gv", { desc = "Outdent selection" })
map("n", "<Tab>", ">>", { desc = "Indent line" })
map("n", "<S-Tab>", "<<", { desc = "Outdent line" })
map("i", "<Tab>", "<C-t>", { desc = "Indent line in insert mode" })
map("i", "<S-Tab>", "<C-d>", { desc = "Outdent line in insert mode" })

-- Move selected lines up/down in visual mode using Shift and navigation keys
map("v", "<S-e>", ":m '>+2<CR>gv=gv", { desc = "Move selection down" })
map("v", "<S-o>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- lsp

map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end)
map("n", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end)

map("n", "å", function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
        { bufnr = bufnr }
    )
end, { desc = "Toggle Inlay Hints" })

map("n", "gd", vim.lsp.buf.definition)
map("n", "gr", vim.lsp.buf.references)

-- =========================================================
-- autocommands/write
-- =========================================================

local write_group = augroup("WriteCommands", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
    group = write_group,
    pattern = "*",
    callback = function()
        local ft = vim.bo.filetype
        local ext = vim.fn.expand("%:e")
        if ft == "markdown" or ft == "yaml" or ext == "html" or ext == "RPP" or ext == "reamake" or ext:lower() == "csv" then
            return
        end
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[silent! %s/\s\+$//e]])
        vim.cmd([[silent! %s/\(\n\)\{3,}/\r\r/e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end,
    desc = "Trim trailing whitespace and collapse multiple empty lines",
})

autocmd("BufWritePost", {
    group = write_group,
    pattern = { "*.sh", "*.desktop" },
    callback = function()
        vim.fn.system({ "chmod", "+x", vim.fn.expand("%:p") })
    end,
    desc = "Make shell scripts and .desktop files executable",
})

-- =========================================================
-- autocommands/templates
-- =========================================================

local template_dir = vim.fn.stdpath("config") .. "/templates"

autocmd("BufNewFile", {
    pattern = "*",
    callback = function()
        local ft = vim.bo.filetype
        local file = vim.fn.expand("<afile>") or ""
        local ext = file:match("^.+(%..+)$") or ft
        local template_file = string.format("%s/%s%s", template_dir, ft, ext or "")
        if vim.fn.filereadable(template_file) == 0 then
            template_file = string.format("%s/%s", template_dir, file:match("^.+(%..+)$") or "")
        end
        if vim.fn.filereadable(template_file) == 1 then
            vim.cmd("0r " .. template_file)
        end
    end,
})

-- =========================================================
-- autocommands/files
-- =========================================================

local files_group = augroup("FileCommands", { clear = true })

autocmd({ "BufEnter", "BufWritePre" }, {
    group = files_group,
    pattern = "*",
    callback = function()
        local dir = vim.fn.expand("%:p:h")
        if vim.fn.isdirectory(dir) == 1 then
            vim.cmd("lcd " .. dir)
        end
    end,
    desc = "Auto-change cwd to folder of current buffer",
})

autocmd("BufNewFile", {
    group = files_group,
    command = "silent! 0r "
        .. vim.fn.stdpath("config")
        .. "/templates/template.%:e",
    desc = "If one exists, use a template when opening a new file",
})

autocmd("BufWritePre", {
    group = files_group,
    pattern = "*",
    callback = function()
        local dir = vim.fn.expand("%:p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
    desc = "Auto create directories before save",
})

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

-- =========================================================
-- autocommands/cursor
-- =========================================================

local cursor_group = augroup("CursorCommands", { clear = true })

autocmd("BufReadPost", {
    group = cursor_group,
    callback = function()
        if vim.bo.filetype == "commit" then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
    desc = "Restore cursor location when opening a buffer",
})

autocmd("TextYankPost", {
    group = cursor_group,
    callback = function()
        vim.highlight.on_yank()
    end,
    desc = "Highlight yanked text",
})

-- =========================================================
-- autocommands/terminal
-- =========================================================

local term_group = augroup("TermCommands", { clear = true })

local term_buf = nil
local term_win = nil
local term_job = nil

local function ensure_terminal(cmd)
    local cwd = vim.fn.expand('%:p:h')
    if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
        vim.cmd("botright 15split | terminal")
        term_buf = vim.api.nvim_get_current_buf()
        term_win = vim.api.nvim_get_current_win()
        term_job = vim.b.terminal_job_id
    else
        if not vim.api.nvim_win_is_valid(term_win) then
            vim.cmd("botright 15split")
            vim.api.nvim_set_current_buf(term_buf)
            term_win = vim.api.nvim_get_current_win()
        else
            vim.api.nvim_set_current_win(term_win)
        end
    end
    if term_job and cwd then
        vim.fn.chansend(term_job, "cd " .. cwd .. "\n")
    end
    if cmd and term_job then
        vim.fn.chansend(term_job, cmd .. "\n")
    end
    vim.cmd("startinsert")
end

local function run_build_or_fallback(build_path, fallback_cmd)
    -- Check if build.sh exists
    local stat = vim.loop.fs_stat(build_path)
    if stat then
        -- build.sh exists
        ensure_terminal("clear && bash \"" .. build_path .. "\"")
    else
        -- build.sh doesn't exist, use fallback
        ensure_terminal('echo "build.sh doesn\'t exist, defaulting to regular build command" && ' .. fallback_cmd)
    end
end

-- Python
autocmd("FileType", {
    group = term_group,
    pattern = "python",
    callback = function()
        vim.keymap.set("n", "<leader>m", function()
            vim.cmd('write')
            local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python3.14"
            local file = vim.fn.expand("%")
            local build_path = vim.fn.expand("%:p:h") .. "/build.sh"
            local fallback_cmd = python .. " " .. file
            run_build_or_fallback(build_path, fallback_cmd)
        end, { buffer = true, desc = "Run Python file" })
    end,
})

-- haskell
autocmd("FileType", {
    group = term_group,
    pattern = "haskell",
    callback = function()
        vim.keymap.set("n", "<leader>m", function()
            vim.cmd('write')
            vim.lsp.buf.format({ async = true })
            local file = vim.fn.expand("%")
            local outfile = vim.fn.expand("%:r") -- same name, no extension
            local build_path = vim.fn.expand("%:p:h") .. "/build.sh"
            local fallback_cmd = string.format("ghc \"%s\" && ./\"%s\"",
                file, outfile)
            run_build_or_fallback(build_path, fallback_cmd)
        end, { buffer = true, desc = "Compile and run C file" })
    end,
})

-- C
autocmd("FileType", {
    group = term_group,
    pattern = "c",
    callback = function()
        vim.keymap.set("n", "<leader>m", function()
            vim.cmd('write')
            local file = vim.fn.expand("%")
            local outfile = vim.fn.expand("%:r") -- same name, no extension
            local build_path = vim.fn.expand("%:p:h") .. "/build.sh"
            local fallback_cmd = string.format("gcc -std=c23 -Wall -Wextra -O2 \"%s\" -o \"%s\" && ./\"%s\"",
                file, outfile, outfile)
            run_build_or_fallback(build_path, fallback_cmd)
        end, { buffer = true, desc = "Compile and run C file" })
    end,
})

-- Rust
autocmd("FileType", {
    group = term_group,
    pattern = "rust",
    callback = function()
        vim.keymap.set("n", "<leader>m", function()
            vim.cmd('write')
            -- build.sh is in parent directory for Rust projects
            local build_path = vim.fn.expand("%:p:h") .. "/../build.sh"
            local fallback_cmd = "cargo run"
            run_build_or_fallback(build_path, fallback_cmd)
        end, { buffer = true, desc = "Run Rust project" })
    end,
})

-- Terminal toggle
autocmd("BufEnter", {
    group = term_group,
    pattern = "*",
    callback = function()
        vim.keymap.set("n", "T", function()
            ensure_terminal()
        end, { buffer = true, noremap = true, silent = true, desc = "Open terminal" })
    end,
    desc = "Open terminal in current buffer",
})

-- Cleanup terminal buffer on close
autocmd("TermClose", {
    group = term_group,
    callback = function()
        if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
            vim.cmd("bdelete! " .. term_buf)
            term_buf, term_win, term_job = nil, nil, nil
        end
    end,
    desc = "Close terminal buffer on process exit",
})

-- =========================================================
-- autocommands/ui
-- =========================================================

local ui_group = augroup("UiCommands", { clear = true })

autocmd("VimResized", {
    group = ui_group,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
    desc = "Auto-resize splits when window is resized",
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    group = ui_group,
    pattern = { '*.txt' },
    callback = function()
        if vim.o.filetype == 'help' then vim.cmd.wincmd('L') end
    end,
    desc = "Open help window in a vertical split to the right",
})

vim.api.nvim_create_autocmd("InsertEnter", {
    group = ui_group,
    pattern = "*",
    callback = function()
        if vim.api.nvim_win_get_config(0).relative ~= "" then
            return
        end
        vim.wo.relativenumber = false
    end,
    desc = "Disable relative line numbers in insert mode",
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = ui_group,
    pattern = "*",
    callback = function()
        if vim.api.nvim_win_get_config(0).relative ~= "" then
            return
        end
        vim.wo.relativenumber = true
    end,
    desc = "Enable relative line numbers in normal mode",
})

-- =========================================================
-- lsp/lsp
-- =========================================================

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
        },
    },
})

-- rust
vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    settings = {
        ['rust-analyzer'] = {},
    },
})
vim.lsp.enable('rust_analyzer')

-- python
vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        '.git',
    },
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic", -- or "strict"
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
})
vim.lsp.enable('pyright')

-- c/c++
vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--completion-style=detailed',
        '--header-insertion=iwyu',
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = {
        'compile_commands.json',
        'compile_flags.txt',
        '.git',
    },
})
vim.lsp.enable('clangd')

-- js/ts
vim.lsp.config('tsserver', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
    },
    root_markers = { 'package.json', 'tsconfig.json', '.git' },
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
            },
        },
    },
})
vim.lsp.enable('tsserver')

-- lua
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.git', '.luarc.json', '.luarc.jsonc' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim' }, -- rec nvim api
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
            telemetry = {
                enable = false,
            },
        },
    },
})
vim.lsp.enable('lua_ls')

-- css
vim.lsp.config('cssls', {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    capabilities = capabilities,
})
vim.lsp.enable('cssls')

-- html
vim.lsp.config('html', {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    capabilities = capabilities,
})
vim.lsp.enable('html')

-- spell-checking
vim.lsp.config['harper'] = {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = { 'markdown', 'text', 'tex', 'typst' }
}
vim.lsp.enable('harper')

-- =========================================================
-- lsp/format
-- =========================================================

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local ft = vim.bo.filetype
        local ignore = {
            ["markdown"] = true,
            ["make"]     = true,
            ["text"]     = true,
            ["typ"]      = true,
            ["toml"]     = true,
            ["ana"]      = true,
            [""]         = true,
        }
        if ignore[ft] then
            return
        end
        local has_lsp = #vim.lsp.get_clients({ bufnr = 0 }) > 0
        local pos = vim.api.nvim_win_get_cursor(0)
        if has_lsp then
            vim.lsp.buf.format({ async = false })
        end
        if ft == "c" then
            vim.cmd("normal! gg=G")
        elseif ft == "rust" then
            vim.cmd("normal! gg=G")
        elseif not has_lsp then
            vim.cmd("normal! gg=G")
        end
        local line = math.min(pos[1], vim.api.nvim_buf_line_count(0))
        pcall(vim.api.nvim_win_set_cursor, 0, { line, pos[2] })
    end,
    desc = "Format on save with LSP; force gg=G after format for C/Rust files",
})

-- =========================================================
-- lsp/completion
-- =========================================================

vim.opt.completeopt = { "noselect", "menu", "menuone", "popup" }
vim.o.inccommand    = 'nosplit'
vim.opt.pumborder   = "rounded"

-- code

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local cp = client.server_capabilities.completionProvider
        if cp then
            cp.triggerCharacters = cp.triggerCharacters or {}
            for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._"):gmatch(".") do
                if not vim.tbl_contains(cp.triggerCharacters, c) then
                    table.insert(cp.triggerCharacters, c)
                end
            end
        end
        vim.lsp.completion.enable(true, client.id, args.buf, {
            autotrigger = true,
        })
    end,
})

-- commandline

vim.opt.wildmode = "noselect:lastused,full"
vim.opt.wildoptions = "pum"
vim.api.nvim_create_autocmd("CmdlineChanged", {
    pattern = { ":", "/", "?" },
    callback = function()
        vim.fn.wildtrigger()
    end,
})

-- =========================================================
-- ui
-- =========================================================

local colors = require("ui.theme")
colors.colorscheme()
require("ui.colorscheme")
require("ui.statusline")

-- =========================================================
-- modules
-- =========================================================

require("modules.pairs").setup()         -- auto pair paren, quotes etc.
require("modules.indent_guides").setup() -- indent guides
require("modules.flash").setup()         -- jumper
require("modules.biscuits").setup()      -- function annotations
require("modules.hexbg").setup()         -- color hex codes
require("modules.recentfiles").setup()   -- recent files picker
require("modules.diag").setup()          -- buff diagn. picker
require("modules.buff").setup()          -- open buff picker

require("modules.snippets").setup({      -- snippets (expand with c-x)
    issue = "*brakoll - d: $0, p: 0, t: feature, s: open",
})
