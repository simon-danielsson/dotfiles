-- =========================================================
-- !!! aliases
-- =========================================================

local opt          = vim.opt
local g            = vim.g
local o            = vim.o
local autocmd      = vim.api.nvim_create_autocmd
local augroup      = vim.api.nvim_create_augroup
local map          = vim.keymap.set

-- =========================================================
-- !!! general/options
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
-- !!! general/netrw
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
        map("n", "n", "h", opts)
        map("n", "e", "j", opts)
        map("n", "o", "k", opts)
        map("n", "i", "l", opts)
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
-- !!! general/keymaps
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

map("n", "<leader>f", function()
    local dir = vim.fn.getcwd()
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
-- !!! autocommands/write
-- =========================================================

local write_group = augroup("WriteCommands", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
    group = write_group,
    callback = function(event)
        -- skip if path is a protocol (e.g., git:, fzf:)
        if event.match:match("^%w%w+:[\\/][\\/]") then return end
        local file = vim.uv.fs_realpath(event.match) or event.match
        local dir = vim.fn.fnamemodify(file, ":p:h") -- parent directory
        vim.fn.mkdir(dir, "p")                       -- create recursively
    end,
    desc = "Auto-create parent directories before saving"
})

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
-- !!! autocommands/templates
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
-- !!! autocommands/files
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
-- !!! autocommands/cursor
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
-- !!! autocommands/terminal
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
        map("n", "<leader>m", function()
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
        map("n", "<leader>m", function()
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
        map("n", "<leader>m", function()
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
        map("n", "<leader>m", function()
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
        map("n", "T", function()
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
-- !!! autocommands/ui
-- =========================================================

local ui_group = augroup("UiCommands", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = ui_group,
    pattern = {
        "markdown",
        "json",
        "jsonc",
        "json5"
    },
    callback = function() vim.opt_local.conceallevel = 0 end,
    desc = "Disable conceal in Markdown and JSON files"
})

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
-- !!! lsp/lsp
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
-- !!! lsp/format
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
-- !!! lsp/completion
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
-- !!! ui/icons
-- =========================================================

local icons      = {}

icons.border     = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

icons.indent     = {
    big_thick = "█",
    med_thick = "▊",
    sma_thick = "▐",
    double = "║",
    thin = "│",
    dotted = "┊",
    dotted_alt = "⋮",
}

icons.git        = {
    add = "",
    branch = "",
    diff = "",
    git = "󰊢",
    ignore = "",
    modify = "",
    delete = "",
    rename = "",
    repo = "",
    unmerged = "󰘬",
    untracked = "󰞋",
    unstaged = "",
    staged = "",
    conflict = "",
}

icons.ui         = {
    location = "󰟙",
    file = "",
    wordcount = "",
    memory = "",
    unrec_file = "",
    rec_macro = "󰻂",
    arrow_left = "",
    arrow_right = "",
    arrow_up = "",
    arrow_down = "",
    gear = "",
    folder = "󰷏",
    time = "",
    quit = "󰈆",
    virtual_env = "",
}

icons.lang       = {
    python = { icon = "", color = "#FED141" },
    config = { icon = "", color = "#6e6e6e" },
    haskell = { icon = "", color = "#C678DD" },
    javascript = { icon = "", color = "#F6DE42" },
    html = { icon = "", color = "#E34C26" },
    css = { icon = "", color = "#28AAE1" },
    json = { icon = "", color = "#cbcb41" },
    markdown = { icon = "", color = "#036F36" },
    vim = { icon = "", color = "#019833" },
    sh = { icon = "", color = "#89e051" },
    gd = { icon = "", color = "#478cbf" },
    gdscript = { icon = "", color = "#478cbf" },
    toml = { icon = "", color = "#9C4221" },
    yaml = { icon = "", color = "#C678dd" },
    dockerfile = { icon = "", color = "#0db7ed" },
    go = { icon = "󰊠", color = "#00ADD8" },
    rust = { icon = "", color = "#DEA584" },
    typst = { icon = "", color = "#dea584" },
    c = { icon = "", color = "#6798D1" },
    cpp = { icon = "", color = "#00599C" },
    lua = { icon = "", color = "#51A1FF" },
    java = { icon = "", color = "#F34335" },
    php = { icon = "", color = "#8892be" },
    ruby = { icon = "", color = "#701516" },
    swift = { icon = "", color = "#ffac45" },
    tsx = { icon = "", color = "#2b7489" },
    jsx = { icon = "", color = "#61dafb" },
}

icons.diagn      = {
    error = "󰯈",
    warning = "",
    information = "",
    question = "",
    hint = "",
}

icons.modes      = {
    n = "",
    i = "",
    v = "",
    V = "",
    ["\22"] = "󰈚",
    c = "",
    s = "",
    S = "",
    ["\19"] = "󰈚",
    R = "",
    r = "",
    ["!"] = "",
    t = "",
}

-- =========================================================
-- !!! ui/theme
-- =========================================================

local theme      = {}

theme.colors     = {
    fg_main  = "#AAB3C0",
    fg_mid   = "#6e6e87",
    bg_mid   = "#9ec1a3",
    bg_mid2  = "#6e6e87",
    bg_deep  = "#40404f",
    bg_deep3 = "#25252d",
}

theme.aux_colors = {
    macro_statusline = "#aa5565",
    cursorline_bg = "#2a2a33",
    accent = "#87afaf",
}

function theme.theme()
    vim.o.background = "dark"
    vim.cmd.colorscheme("habamax")

    vim.api.nvim_set_hl(0, "Function", { fg = theme.colors.bg_mid })
    vim.api.nvim_set_hl(0, "Module", { fg = theme.colors.bg_mid })
    vim.api.nvim_set_hl(0, "Property", { fg = theme.colors.bg_mid })
    vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = theme.colors.bg_mid })
    vim.api.nvim_set_hl(0, "Normal", { bg = theme.colors.bg_deep3 })
end

-- apply it
theme.theme()

-- =========================================================
-- !!! ui/colorscheme
-- =========================================================

local colors            = theme.colors
local aux_col           = theme.aux_colors
-- terminal colors

vim.g.terminal_color_0  = "#1e1e2e"      -- black
vim.g.terminal_color_1  = "#f38ba8"      -- red
vim.g.terminal_color_2  = "#a6e3a1"      -- green
vim.g.terminal_color_3  = "#f9e2af"      -- yellow
vim.g.terminal_color_4  = "#89b4fa"      -- blue
vim.g.terminal_color_5  = "#f5c2e7"      -- magenta
vim.g.terminal_color_6  = "#94e2d5"      -- cyan
vim.g.terminal_color_7  = colors.fg_main -- white
vim.g.terminal_color_8  = colors.fg_mid
vim.g.terminal_color_9  = "#f38ba8"      -- bright red
vim.g.terminal_color_10 = "#a6e3a1"      -- bright green
vim.g.terminal_color_11 = "#f9e2af"      -- bright yellow
vim.g.terminal_color_12 = "#89b4fa"      -- bright blue
vim.g.terminal_color_13 = "#f5c2e7"      -- bright magenta
vim.g.terminal_color_14 = "#94e2d5"      -- bright cyan
vim.g.terminal_color_15 = colors.fg_main

-- borders

vim.g.border            = icons.border

-- diagnostics

local diag_icons        = {
    [vim.diagnostic.severity.ERROR] = icons.diagn.error,
    [vim.diagnostic.severity.WARN]  = icons.diagn.warning,
    [vim.diagnostic.severity.INFO]  = icons.diagn.information,
    [vim.diagnostic.severity.HINT]  = icons.diagn.hint,
}

-- diagnostics display
vim.diagnostic.config({
    float = { border = "rounded" },
    signs = { text = diag_icons },
})

-- diagnostic signs in sign column
for name, icon in pairs({
    DiagnosticSignError = diag_icons[vim.diagnostic.severity.ERROR],
    DiagnosticSignWarn  = diag_icons[vim.diagnostic.severity.WARN],
    DiagnosticSignInfo  = diag_icons[vim.diagnostic.severity.INFO],
    DiagnosticSignHint  = diag_icons[vim.diagnostic.severity.HINT],
}) do
    vim.fn.sign_define(name, { text = icon, texthl = name })
end

-- highlight overrides: general

-- helper
local function set_hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

local override_groups = {
    CursorLine       = { bg = aux_col.cursorline_bg },
    LspInlayHint     = { fg = colors.fg_mid },
    TermNormal       = { fg = colors.fg_mid, bg = colors.bg_mid },
    StatusLineNC     = { bg = colors.bg_mid },
    StatusLineNormal = { bg = colors.bg_mid },
    LineNr           = { fg = colors.bg_deep, bg = "none" },
    LineNrBelow      = { fg = colors.bg_deep, bg = "none" },
    CursorLineNr     = { fg = colors.fg_main, bold = true },
    LineNrAbove      = { fg = colors.bg_deep, bg = "none" },
    Comment          = { fg = colors.fg_mid, bold = false },
    IndentGuide      = { fg = colors.bg_deep, bold = false },
    NormalNC         = { bg = colors.bg_deep3, fg = colors.fg_mid },
    TabLine          = { bg = colors.bg_deep },
    TabLineFill      = { bg = colors.bg_deep },
    TabLineSel       = { bg = colors.fg_mid, bold = true },
    WinSeparator     = { bg = "none", fg = aux_col.cursorline_bg },
    ToolbarButton    = { bg = colors.fg_main, bold = true, reverse = true },
    EndOfBuffer      = { bg = "none" },
    ColorColumn      = { ctermbg = 0, bg = colors.bg_deep },
    VertSplit        = { ctermbg = 0, bg = "none", fg = "none" },
    -- popup menu
    Visual           = { bg = colors.bg_deep },
    CurSearch        = { bg = aux_col.accent, fg = colors.bg_deep3 },
    IncSearch        = { bg = aux_col.accent, fg = colors.bg_deep3 },
    Search           = { bg = aux_col.accent, fg = colors.bg_deep3 },
    Substitute       = { bg = colors.bg_deep },
    QuickFixLine     = { ctermbg = 0 },

    BiscuitColor     = { fg = colors.bg_deep, bg = aux_col.cursorline_bg },
}

for group, opts in pairs(override_groups) do
    set_hl(group, opts)
end

-- highlight overrides: floating menus

local floating_menus = {
    NormalFloat   = { fg = colors.fg_main, bg = "none" },
    FloatBorder   = { fg = colors.fg_mid, bg = "none" },

    Pmenu         = { bg = colors.bg_deep3, fg = colors.fg_mid },
    PmenuSel      = { bg = colors.bg_deep, fg = colors.fg_main },
    PmenuKind     = { bg = colors.bg_deep3, fg = colors.fg_main },
    PmenuExtra    = { bg = colors.bg_deep3, fg = colors.fg_main },
    PmenuMatch    = { bg = colors.bg_deep, fg = colors.fg_main },
    PmenuKindSel  = { bg = colors.bg_deep, fg = aux_col.accent, bold = true },
    PmenuExtraSel = { bg = colors.bg_deep, fg = colors.fg_main, bold = true },
    PmenuMatchSel = { bg = colors.bg_deep, fg = aux_col.accent, bold = true },
    PmenuSbar     = { bg = colors.bg_deep3 },
    PmenuThumb    = { bg = colors.bg_deep3 },
    PmenuBorder   = { fg = colors.fg_mid, bg = "none" },
}

for group, opts in pairs(floating_menus) do
    set_hl(group, opts)
end

-- =========================================================
-- !!! ui/statusline
-- =========================================================

local aux_colors           = theme.aux_colors

-- ==== git ====

local git_cache            = { status = "", last_update = 0 }
local max_repo_name_length = 15

local function git_info()
    local now = vim.loop.hrtime() / 1e9
    if now - git_cache.last_update > 2 then
        git_cache.last_update = now
        local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
        if branch == "" then
            git_cache.status = ""
        else
            local toplevel = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
            local repo = vim.fn.fnamemodify(toplevel, ":t")
            if #repo > max_repo_name_length then
                repo = repo:sub(1, max_repo_name_length) .. "..."
            end
            local parts = {
                "│ " .. (icons.git.repo or "") .. " " .. repo,
                (icons.git.branch or "") .. " " .. branch
            }
            git_cache.status = table.concat(parts, " ")
        end
    end
    return git_cache.status
end

-- ==== utilities ====

_G.macro_recording = ""
autocmd("RecordingEnter", {
    callback = function()
        local reg = vim.fn.reg_recording()
        if reg ~= "" then
            _G.macro_recording = " ██" .. ""
        end
    end,
})
autocmd("RecordingLeave", {
    callback = function()
        _G.macro_recording = ""
    end,
})

local function word_count()
    local ext = vim.fn.expand("%:e")
    if ext ~= "md" and ext ~= "typ" and ext ~= "txt" then
        return ""
    end
    local wc = vim.fn.wordcount()
    return wc.words > 0 and (" " .. wc.words .. " words │ ") or ""
end

local function mode_icon()
    return (icons.modes[vim.fn.mode()] .. " ") or (" " .. vim.fn.mode():upper())
end

local function lsp_info()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
        return " │ " .. icons.ui.gear .. " " .. clients[1].name .. " "
    end
    return ""
end

-- ==== file ====

for ft, entry in pairs(icons.lang) do
    vim.api.nvim_set_hl(0, "FileIcon_" .. ft, { fg = entry.color, bg = "none" })
end
local function file_type_icon()
    local ft = vim.bo.filetype
    local entry = icons.lang[ft]
    if entry then
        local hl = " %#FileIcon_" .. ft .. "#"
        return hl .. entry.icon .. "%*"
    else
        return " " .. icons.ui.unrec_file
    end
end

local function short_filepath()
    local path = vim.fn.expand("%:p")
    local parts = vim.split(path, "/", { trimempty = true })
    local count = #parts
    return table.concat({
        parts[count - 2] or "",
        parts[count - 1] or "",
        parts[count] or ""
    }, "/")
end

local function file_type_filename()
    local ft = vim.bo.filetype
    local entry = icons.lang[ft]
    local hl = entry and "%#FileIcon_" .. ft .. "#" or "%#StatusFilename#"
    return hl .. " " .. short_filepath() .. " " .. "%*"
end

-- ==== scrollbar ====

local SBAR = { "󱃓 ", "󰪞 ", "󰪟 ", "󰪠 ", "󰪡 ", "󰪢 ", "󰪣 ", "󰪤 ", "󰪥 " }

local function scrollbar()
    local cur = vim.api.nvim_win_get_cursor(0)[1]
    local total = vim.api.nvim_buf_line_count(0)
    if total == 0 then return "" end
    local idx = math.floor((cur - 1) / total * #SBAR) + 1
    idx = math.max(1, math.min(idx, #SBAR))
    return "%#StatusScrollbar# " .. SBAR[idx]:rep(1) .. "%*"
end

-- ==== highlights ====

-- local g_bg = "none"
local g_bg = aux_col.cursorline_bg

local statusline_highlights = {
    StatusLine       = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusLineNC     = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusLineNormal = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusLineTermNC = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusFilename   = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusFileType   = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusKey        = { fg = colors.fg_mid, bg = g_bg, bold = false },
    ColumnPercentage = { fg = colors.fg_main, bg = g_bg, bold = true },
    endBit           = { fg = colors.bg_deep2, bg = g_bg, },
    StatusPosition   = { fg = colors.fg_mid, bg = g_bg, bold = false },
    StatusMode       = { fg = colors.fg_mid, bg = g_bg },
    StatusScrollbar  = { fg = aux_colors.accent, bg = g_bg, bold = true },
    StatusSelection  = { fg = colors.fg_mid, bg = g_bg, bold = false },
    StatusGit        = { fg = colors.fg_mid, bg = g_bg },
    StatusLsp        = { fg = colors.fg_mid, bg = g_bg },
    MacroRec         = { fg = aux_colors.macro_statusline, bg = "none" },
}
for group, opts in pairs(statusline_highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end

-- ==== assembly ====

_G.Statusline = function()
    local parts = {
        "%#StatusMode#  " .. mode_icon() .. " │",
        "%#StatusFileType#" .. file_type_icon() .. "",
        file_type_filename(),
        "%#StatusGit#" .. git_info(),
        "%#StatusLsp#" .. lsp_info() .. "",
        "%=",
    }

    table.insert(parts, "%#StatusMode#" .. word_count())
    table.insert(parts, "%#StatusPosition#" .. "%l:" .. "%c")
    table.insert(parts, scrollbar())
    if _G.macro_recording ~= "" then
        table.insert(parts, "%#MacroRec#" .. "" .. _G.macro_recording)
    end

    return table.concat(parts)
end

vim.api.nvim_create_autocmd("TermClose", {
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline()"
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.opt_local.winhighlight = "Normal:Normal,StatusLine:Normal,StatusLineNC:Normal"
        vim.opt_local.statusline = " "
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.filetype == "netrw" then
            vim.opt_local.statusline = " "
        else
            vim.opt_local.statusline = "%!v:lua.Statusline()"
        end
    end,
})

-- =========================================================
-- !!! modules/autopairs
-- =========================================================

local autopairs = {}

autopairs.pairs = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
}

autopairs.quotes = {
    ["'"] = true,
    ['"'] = true,
    ["`"] = true,
}

local closing_to_opening = {}
for open, close in pairs(autopairs.pairs) do
    closing_to_opening[close] = open
end

local function getline()
    return vim.fn.getline(".")
end

local function col()
    return vim.fn.col(".")
end

local function get_char_at(pos)
    if pos < 1 then
        return ""
    end
    local line = getline()
    return line:sub(pos, pos)
end

local function is_word_char(c)
    return c ~= "" and c:match("[%w_]")
end

local function is_escaped(line, pos)
    local count = 0
    pos = pos - 1
    while pos > 0 and line:sub(pos, pos) == "\\" do
        count = count + 1
        pos = pos - 1
    end
    return count % 2 == 1
end

local function can_auto_close_quote(line, pos, quote)
    local prev = line:sub(pos - 1, pos - 1)
    local next = line:sub(pos, pos)
    if is_escaped(line, pos) then
        return false
    end
    if is_word_char(prev) or is_word_char(next) then
        return false
    end
    return true
end

local function build_pair_stack_until(line, stop_pos)
    local stack = {}
    local active_quote = nil

    for i = 1, stop_pos do
        local ch = line:sub(i, i)

        if active_quote then
            if ch == active_quote and not is_escaped(line, i) then
                active_quote = nil
            end
        else
            if autopairs.quotes[ch] and not is_escaped(line, i) then
                active_quote = ch
            elseif autopairs.pairs[ch] then
                stack[#stack + 1] = ch
            elseif closing_to_opening[ch] then
                local expected = closing_to_opening[ch]
                if stack[#stack] == expected then
                    stack[#stack] = nil
                end
            end
        end
    end

    return stack, active_quote
end

local function has_unmatched_closer_ahead(open, close)
    local line = getline()
    local cursor_col = col()

    local stack, active_quote = build_pair_stack_until(line, cursor_col - 1)

    for i = cursor_col, #line do
        local ch = line:sub(i, i)

        if active_quote then
            if ch == active_quote and not is_escaped(line, i) then
                active_quote = nil
            end
        else
            if autopairs.quotes[ch] and not is_escaped(line, i) then
                active_quote = ch
            elseif autopairs.pairs[ch] then
                stack[#stack + 1] = ch
            elseif closing_to_opening[ch] then
                local expected = closing_to_opening[ch]

                if stack[#stack] == expected then
                    stack[#stack] = nil
                else
                    if ch == close and expected == open then
                        return true
                    end
                end
            end
        end
    end

    return false
end

function autopairs.open(char)
    local line = getline()
    local c = col()
    local prev = get_char_at(c - 1)
    local next = get_char_at(c)

    if autopairs.quotes[char] then
        if next == char and not is_escaped(line, c) then
            return "<Right>"
        end
        if not can_auto_close_quote(line, c, char) then
            return char
        end
        return char .. char .. "<Left>"
    end
    local close = autopairs.pairs[char]
    if not close then
        return char
    end
    if has_unmatched_closer_ahead(char, close) then
        return char
    end
    return char .. close .. "<Left>"
end

function autopairs.close(char)
    local next = get_char_at(col())
    if next == char then
        return "<Right>"
    end
    return char
end

function autopairs.backspace()
    local c = col()
    local prev = get_char_at(c - 1)
    local next = get_char_at(c)
    if autopairs.pairs[prev] == next or (autopairs.quotes[prev] and prev == next) then
        return "<BS><Del>"
    end
    return "<BS>"
end

function autopairs.newline()
    local c = col()
    local prev = get_char_at(c - 1)
    local next = get_char_at(c)
    if autopairs.pairs[prev] == next then
        return "<CR><Esc>O"
    end
    return "<CR>"
end

function autopairs.setup()
    local expr = { expr = true, noremap = true }
    for y, c in pairs(autopairs.pairs) do
        map("i", y, function()
            return autopairs.open(y)
        end, expr)

        map("i", c, function()
            return autopairs.close(c)
        end, expr)
    end

    for q, _ in pairs(autopairs.quotes) do
        map("i", q, function()
            return autopairs.open(q)
        end, expr)
    end

    map("i", "<BS>", autopairs.backspace, expr)
    map("i", "<CR>", autopairs.newline, expr)
end

autopairs.setup()

-- =========================================================
-- !!! modules/flash
-- =========================================================

local flash = {}

local ns = vim.api.nvim_create_namespace("flash")

local defaults = {
    labels = "ashtfmneoiqdrwlup",
    min_pattern_for_labels = 2,
    case_sensitive = false,
    highlight = {
        match = "Search",
        current = "IncSearch",
        label = "Substitute",
    },
    prompt_hl = "Title",
    note_hl = "Comment",
    prompt = "Flash",
    max_matches = 200,
    jump_on_unique = false,
    scope = "window", -- "window" | "buffer"
    reserve_labels_by_next_char = true,
    show_counts_in_prompt = true,
}

local config = vim.deepcopy(defaults)

local state = {
    active = false,
    winid = nil,
    bufnr = nil,
    pattern = "",
    matches = {},
    reserved = {},
    label_map = {},
    view = nil,
}

local function clear_ns()
    if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
        vim.api.nvim_buf_clear_namespace(state.bufnr, ns, 0, -1)
    end
end

local function reset()
    clear_ns()
    state.active = false
    state.winid = nil
    state.bufnr = nil
    state.pattern = ""
    state.matches = {}
    state.reserved = {}
    state.label_map = {}
    state.view = nil
    pcall(vim.cmd, "redraw")
end

local function is_cancel(ch)
    return ch == vim.keycode("<Esc>") or ch == vim.keycode("<C-c>")
end

local function is_backspace(ch)
    return ch == vim.keycode("<BS>") or ch == vim.keycode("<Del>")
end

local function is_printable(ch)
    return type(ch) == "string" and vim.fn.strchars(ch) == 1
end

local function normalize(s)
    return config.case_sensitive and s or s:lower()
end

local function char_count(s)
    return vim.fn.strchars(s)
end

local function char_sub(s, start_char, len)
    return vim.fn.strcharpart(s, start_char, len)
end

local function drop_last_char(s)
    local n = char_count(s)
    if n <= 0 then
        return ""
    end
    return char_sub(s, 0, n - 1)
end

local function utf8_chars(s)
    local out = {}
    local n = char_count(s)
    for i = 0, n - 1 do
        out[#out + 1] = char_sub(s, i, 1)
    end
    return out
end

local function current_cursor(winid)
    local pos = vim.api.nvim_win_get_cursor(winid)
    return pos[1], pos[2]
end

local function char_at_byte(line, bytepos1)
    if bytepos1 < 1 or bytepos1 > #line then
        return nil
    end
    return line:sub(bytepos1, bytepos1)
end

local function snapshot_view()
    local bufnr = state.bufnr

    local top, bot
    if config.scope == "buffer" then
        top = 1
        bot = vim.api.nvim_buf_line_count(bufnr)
    else
        local winid = state.winid
        top = vim.fn.line("w0", winid)
        bot = vim.fn.line("w$", winid)
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, top - 1, bot, false)
    local normalized = {}

    for i, line in ipairs(lines) do
        normalized[i] = normalize(line)
    end

    state.view = {
        top = top,
        bot = bot,
        lines = lines,
        normalized = normalized,
    }
end

local function collect_matches_full(pattern)
    if pattern == "" or not state.view then
        return {}
    end

    local out = {}
    local curline, curcol = current_cursor(state.winid)
    local needle = normalize(pattern)

    for i, line in ipairs(state.view.lines) do
        local lnum = state.view.top + i - 1
        local hay = state.view.normalized[i]
        local start = 1

        while true do
            local s, e = hay:find(needle, start, true)
            if not s then
                break
            end

            local col0 = s - 1
            if not (lnum == curline and col0 == curcol) then
                out[#out + 1] = {
                    lnum = lnum,
                    row = i,
                    col = col0,
                    end_col = e,
                    next_char = char_at_byte(line, e + 1),
                    label = nil,
                }

                if #out >= config.max_matches then
                    return out
                end
            end

            start = s + 1
        end
    end

    return out
end

local function filter_matches_incremental(matches, pattern)
    if pattern == "" or not state.view then
        return {}
    end

    local out = {}
    local needle = normalize(pattern)
    local needle_len = #needle

    for _, m in ipairs(matches) do
        local hay = state.view.normalized[m.row]
        local s1 = m.col + 1
        local e1 = s1 + needle_len - 1

        if hay:sub(s1, e1) == needle then
            local next_char = char_at_byte(state.view.lines[m.row], e1 + 1)
            out[#out + 1] = {
                lnum = m.lnum,
                row = m.row,
                col = m.col,
                end_col = e1,
                next_char = next_char,
                label = nil,
            }

            if #out >= config.max_matches then
                return out
            end
        end
    end

    return out
end

local function sort_matches(matches)
    local curline, curcol = current_cursor(state.winid)

    table.sort(matches, function(a, b)
        local da = math.abs(a.lnum - curline) * 1000 + math.abs(a.col - curcol)
        local db = math.abs(b.lnum - curline) * 1000 + math.abs(b.col - curcol)

        if da ~= db then
            return da < db
        end
        if a.lnum ~= b.lnum then
            return a.lnum < b.lnum
        end
        return a.col < b.col
    end)
end

local function available_labels(reserved)
    local out = {}
    for _, ch in ipairs(utf8_chars(config.labels)) do
        if not reserved[normalize(ch)] then
            out[#out + 1] = ch
        end
    end
    return out
end

local function compute_reserved(matches, limit)
    local reserved = {}

    if not config.reserve_labels_by_next_char then
        return reserved
    end

    local n = math.min(#matches, limit or #matches)
    for i = 1, n do
        local m = matches[i]
        if m.next_char and is_printable(m.next_char) then
            reserved[normalize(m.next_char)] = true
        end
    end

    return reserved
end

local function assign_labels(matches, reserved)
    local label_map = {}

    for _, m in ipairs(matches) do
        m.label = nil
    end

    if char_count(state.pattern) < config.min_pattern_for_labels then
        return label_map
    end

    local labels = available_labels(reserved)

    if #labels == 0 then
        labels = utf8_chars(config.labels)
    end

    local n = math.min(#matches, #labels)
    for i = 1, n do
        local label = labels[i]
        matches[i].label = label
        label_map[normalize(label)] = matches[i]
    end

    return label_map
end

local function refresh_state(mode)
    if mode == "grow" and #state.matches > 0 then
        state.matches = filter_matches_incremental(state.matches, state.pattern)
    else
        state.matches = collect_matches_full(state.pattern)
    end

    sort_matches(state.matches)

    local label_count = char_count(config.labels)
    state.reserved = compute_reserved(state.matches, label_count)
    state.label_map = assign_labels(state.matches, state.reserved)
end

local function render_prompt()
    local parts = {
        { config.prompt .. " ", config.prompt_hl },
        { state.pattern,        "Normal" },
    }

    if char_count(state.pattern) < config.min_pattern_for_labels then
        parts[#parts + 1] = { "  [type more]", config.note_hl }
    else
        parts[#parts + 1] = { "  [next chars continue, labels jump]", config.note_hl }
    end

    if config.show_counts_in_prompt then
        parts[#parts + 1] = {
            ("  [matches:%d labels:%d]"):format(#state.matches, vim.tbl_count(state.label_map)),
            config.note_hl,
        }
    end

    vim.api.nvim_echo(parts, false, {})
end

local function render()
    clear_ns()

    for i, m in ipairs(state.matches) do
        local opts = {
            end_row = m.lnum - 1,
            end_col = m.end_col,
            hl_group = (i == 1) and config.highlight.current or config.highlight.match,
            priority = 200,
        }

        if m.label then
            opts.virt_text = { { m.label, config.highlight.label } }
            opts.virt_text_pos = "overlay"
            opts.hl_mode = "replace"
        end

        vim.api.nvim_buf_set_extmark(state.bufnr, ns, m.lnum - 1, m.col, opts)
    end

    render_prompt()
    pcall(vim.cmd, "redraw")
end

local function jump_to(match)
    if not match then
        return
    end

    local winid = state.winid
    reset()
    vim.api.nvim_win_set_cursor(winid, { match.lnum, match.col })
end

local function handle_printable(ch)
    local key = normalize(ch)

    if char_count(state.pattern) >= config.min_pattern_for_labels then
        local labeled = state.label_map[key]
        if labeled then
            jump_to(labeled)
            return
        end
    end

    state.pattern = state.pattern .. ch
    refresh_state("grow")

    if config.jump_on_unique and #state.matches == 1 then
        jump_to(state.matches[1])
    end
end

function flash.jump()
    reset()

    state.active = true
    state.winid = vim.api.nvim_get_current_win()
    state.bufnr = vim.api.nvim_get_current_buf()
    state.pattern = ""

    snapshot_view()
    render()

    while state.active do
        local ok, ch = pcall(vim.fn.getcharstr)
        if not ok then
            reset()
            return
        end

        if is_cancel(ch) then
            reset()
            return
        elseif is_backspace(ch) then
            local next_pattern = drop_last_char(state.pattern)
            if next_pattern ~= state.pattern then
                state.pattern = next_pattern
                refresh_state("rebuild")
                render()
            end
        elseif is_printable(ch) then
            handle_printable(ch)
            if state.active then
                render()
            end
        end
    end
end

function flash.setup(opts)
    config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

    map({ "n", "x", "o" }, "s", function()
        flash.jump()
    end, { desc = "flash-like jump" })
end

flash.setup()

-- =========================================================
-- !!! modules/indent_guides
-- =========================================================

local M = {}

local ns = vim.api.nvim_create_namespace("native_indent_guides")

local defaults = {
    char = "│",
    highlight = "IndentGuide",
    show_first_level = true,
    show_blanklines = true,

    exclude_filetypes = {
        help = true,
        lazy = true,
        mason = true,
        snacks_dashboard = true,
        dashboard = true,
        alpha = true,
        netrw = true,
        Trouble = true,
    },

    exclude_buftypes = {
        terminal = true,
        prompt = true,
        quickfix = true,
        nofile = true,
    },
}

local config = vim.deepcopy(defaults)
local enabled = true

local function is_excluded(bufnr)
    local ft = vim.bo[bufnr].filetype
    local bt = vim.bo[bufnr].buftype
    return config.exclude_filetypes[ft] or config.exclude_buftypes[bt]
end

local function get_shiftwidth(bufnr)
    local sw = vim.bo[bufnr].shiftwidth
    if sw == 0 then
        sw = vim.bo[bufnr].tabstop
    end
    return math.max(sw, 1)
end

local function get_line(bufnr, lnum)
    return vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
end

local function leading_ws_width(line, tabstop)
    local width = 0
    local i = 1

    while i <= #line do
        local ch = line:sub(i, i)
        if ch == " " then
            width = width + 1
        elseif ch == "\t" then
            width = width + (tabstop - (width % tabstop))
        else
            break
        end
        i = i + 1
    end

    return width
end

local function leading_ws_cells(line, tabstop)
    local cells = {}
    local vcol = 0
    local i = 1

    while i <= #line do
        local ch = line:sub(i, i)
        if ch == " " then
            cells[vcol] = true
            vcol = vcol + 1
        elseif ch == "\t" then
            local w = tabstop - (vcol % tabstop)
            for j = 0, w - 1 do
                cells[vcol + j] = true
            end
            vcol = vcol + w
        else
            break
        end
        i = i + 1
    end

    return cells, vcol
end

local function is_blank(line)
    return line == nil or line:match("^%s*$") ~= nil
end

local function get_blankline_indent(bufnr, lnum)
    local tabstop = vim.bo[bufnr].tabstop

    for prev = lnum - 1, 1, -1 do
        local line = get_line(bufnr, prev)
        if line and not is_blank(line) then
            return leading_ws_width(line, tabstop)
        end
    end

    return 0
end

function M.refresh()
    vim.cmd("redraw")
end

function M.enable()
    enabled = true
    M.refresh()
end

function M.disable()
    enabled = false
    M.refresh()
end

function M.toggle()
    enabled = not enabled
    M.refresh()
end

function M.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})

    vim.api.nvim_create_user_command("IndentGuidesEnable", function()
        M.enable()
    end, {})

    vim.api.nvim_create_user_command("IndentGuidesDisable", function()
        M.disable()
    end, {})

    vim.api.nvim_create_user_command("IndentGuidesToggle", function()
        M.toggle()
    end, {})

    vim.api.nvim_set_decoration_provider(ns, {
        on_win = function(_, winid, bufnr)
            if not enabled then
                return false
            end

            if not vim.api.nvim_win_is_valid(winid) then
                return false
            end

            if is_excluded(bufnr) then
                return false
            end

            if vim.wo[winid].diff then
                return false
            end

            if not vim.bo[bufnr].modifiable and vim.bo[bufnr].buftype == "" then
                return false
            end

            return true
        end,

        on_line = function(_, _, bufnr, row)
            if not enabled or is_excluded(bufnr) then
                return
            end

            local lnum = row + 1
            local line = get_line(bufnr, lnum)
            if not line then
                return
            end

            local sw = get_shiftwidth(bufnr)
            local tabstop = vim.bo[bufnr].tabstop
            local start = config.show_first_level and 0 or sw

            local cells, indent_width

            if is_blank(line) then
                if not config.show_blanklines then
                    return
                end
                indent_width = get_blankline_indent(bufnr, lnum)
                cells = {}
                for col = 0, indent_width - 1 do
                    cells[col] = true
                end
            else
                cells, indent_width = leading_ws_cells(line, tabstop)
            end

            if indent_width <= 0 then
                return
            end

            for col = start, indent_width - 1, sw do
                if cells[col] then
                    vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
                        ephemeral = true,
                        virt_text = { { config.char, config.highlight } },
                        virt_text_pos = "overlay",
                        virt_text_win_col = col,
                        hl_mode = "replace",
                        priority = 1,
                    })
                end
            end
        end,
    })
end

M.setup()

-- =========================================================
-- !!! modules/biscuits
-- =========================================================

local M = {}

local ns = vim.api.nvim_create_namespace("native_biscuits")

local config = {
    enabled = true,
    cursor_line_only = true,
    prefix = "",
    hl = "BiscuitColor",
    max_length = 60,
    max_scan = 300,
}

local function line(bufnr, row)
    return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
end

local function trim(s)
    return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function squeeze(s)
    return trim((s or ""):gsub("%s+", " "))
end

local function shorten(s)
    s = squeeze(s)
    if #s > config.max_length then
        return s:sub(1, config.max_length) .. "…"
    end
    return s
end

local function clear(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function classify_closer(s)
    s = trim(s)

    if s:match("^end[%s;,%)}%]]*$") then
        return "lua_end"
    end
    if s:match("^[}]") then
        return "brace"
    end
    if s:match("^[)]") then
        return "paren"
    end
    if s:match("^[]]") then
        return "bracket"
    end

    return nil
end

local function is_lua_opener(s)
    s = trim(s)
    return s:match("^function\b")
        or s:match("^local%s+function\b")
        or (s:match("^if\b") and s:match("%f[%a]then%f[%A]"))
        or s:match("^for\b")
        or s:match("^while\b")
        or s:match("^do%s*$")
        or s:match("^repeat\b")
end

local function is_lua_closer(s)
    return trim(s):match("^end[%s;,%)}%]]*$") ~= nil
end

local function count_char(s, ch)
    local n = 0
    local i = 1
    while i <= #s do
        if s:sub(i, i) == ch then
            n = n + 1
        end
        i = i + 1
    end
    return n
end

local function find_lua_opener(bufnr, row)
    local depth = 0
    local start = math.max(0, row - config.max_scan)

    for r = row, start, -1 do
        local l = line(bufnr, r)

        if is_lua_closer(l) then
            depth = depth + 1
        end

        if is_lua_opener(l) then
            depth = depth - 1
            if depth == 0 then
                return shorten(l)
            end
        end
    end

    return nil
end

local function find_pair_opener(bufnr, row, open_ch, close_ch)
    local depth = 0
    local start = math.max(0, row - config.max_scan)

    for r = row, start, -1 do
        local l = line(bufnr, r)
        depth = depth + count_char(l, close_ch)
        depth = depth - count_char(l, open_ch)

        if depth <= 0 and l:find(open_ch, 1, true) then
            return shorten(l)
        end
    end

    return nil
end

local function find_biscuit_text(bufnr, row)
    local cur = line(bufnr, row)
    local kind = classify_closer(cur)
    if not kind then
        return nil
    end

    if kind == "lua_end" then
        return find_lua_opener(bufnr, row)
    elseif kind == "brace" then
        return find_pair_opener(bufnr, row, "{", "}")
    elseif kind == "paren" then
        return find_pair_opener(bufnr, row, "(", ")")
    elseif kind == "bracket" then
        return find_pair_opener(bufnr, row, "[", "]")
    end

    return nil
end

local function draw_for_window(winid)
    if not config.enabled or not vim.api.nvim_win_is_valid(winid) then
        return
    end

    local bufnr = vim.api.nvim_win_get_buf(winid)
    clear(bufnr)

    local top = vim.fn.line("w0", winid) - 1
    local bot = vim.fn.line("w$", winid) - 1
    local cur = vim.api.nvim_win_get_cursor(winid)[1] - 1

    for row = top, bot do
        if (not config.cursor_line_only) or row == cur then
            local txt = find_biscuit_text(bufnr, row)
            if txt and txt ~= "" then
                vim.api.nvim_buf_set_extmark(bufnr, ns, row, #line(bufnr, row), {
                    virt_text = { { config.prefix .. txt, config.hl } },
                    virt_text_pos = "eol",
                    hl_mode = "replace",
                })
            end
        end
    end
end

function M.refresh()
    draw_for_window(vim.api.nvim_get_current_win())
end

function M.setup(opts)
    config = vim.tbl_extend("force", config, opts or {})

    local aug = vim.api.nvim_create_augroup("NativeBiscuits", { clear = true })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter", "TextChanged", "TextChangedI" }, {
        group = aug,
        callback = function()
            draw_for_window(vim.api.nvim_get_current_win())
        end,
    })

    vim.api.nvim_create_user_command("BiscuitsRefresh", function()
        M.refresh()
    end, {})
end

M.setup()

-- =========================================================
-- !!! modules/hexbg
-- =========================================================

local M = {}

local ns = vim.api.nvim_create_namespace("hexbg")
local group_cache = {}

local PATTERNS = {
    "#%x%x%x%x%x%x%f[^%x]", -- #RRGGBB, only if not followed by another hex char
    "#%x%x%x%f[^%x]",       -- #RGB, only if not followed by another hex char
}

local function normalize_hex(hex)
    hex = hex:upper()

    if #hex == 4 then
        local r = hex:sub(2, 2)
        local g = hex:sub(3, 3)
        local b = hex:sub(4, 4)
        return ("#%s%s%s%s%s%s"):format(r, r, g, g, b, b)
    end

    return hex
end

local function luminance(hex)
    hex = normalize_hex(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    return 0.299 * r + 0.587 * g + 0.114 * b
end

local function highlight_group_for(hex)
    hex = normalize_hex(hex)

    if group_cache[hex] then
        return group_cache[hex]
    end

    local name = "HexBg_" .. hex:sub(2)
    local fg = luminance(hex) > 186 and "#000000" or "#FFFFFF"

    vim.api.nvim_set_hl(0, name, {
        fg = fg,
        bg = hex,
    })

    group_cache[hex] = name
    return name
end

local function add_matches_for_line(bufnr, lnum, line)
    for _, pat in ipairs(PATTERNS) do
        local start = 1

        while true do
            local s, e = line:find(pat, start)
            if not s then
                break
            end

            local hex = line:sub(s, e)
            local hl = highlight_group_for(hex)

            -- start_col is 0-based, end_col is exclusive
            vim.api.nvim_buf_add_highlight(bufnr, ns, hl, lnum, s - 1, e)

            start = e + 1
        end
    end
end

function M.refresh(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_count, false)

    for i, line in ipairs(lines) do
        add_matches_for_line(bufnr, i - 1, line)
    end
end

function M.setup()
    local augroup = vim.api.nvim_create_augroup("HexBg", { clear = true })

    vim.api.nvim_create_autocmd({
        "BufEnter",
        "TextChanged",
        "TextChangedI",
        "InsertLeave",
    }, {
        group = augroup,
        callback = function(args)
            vim.schedule(function()
                M.refresh(args.buf)
            end)
        end,
    })

    vim.schedule(function()
        M.refresh()
    end)
end

M.setup()

-- =========================================================
-- !!! modules/recentfiles
-- =========================================================

local recentfiles = {}

local defaults = {
    title = "Recent files",
    exclude_current = true,
    open_cmd = "copen",
    qf_mappings = true,
    keymap = "<leader>r",
    desc = "Open recent files",
    notify = false,
}

recentfiles.config = vim.deepcopy(defaults)

local function get_opts(opts)
    return vim.tbl_deep_extend("force", {}, recentfiles.config, opts or {})
end

local function normalize_path(path)
    return vim.fn.fnamemodify(path, ":~:.")
end

local function is_readable_file(path)
    return path ~= "" and vim.fn.filereadable(path) == 1
end

local function collect_oldfiles(opts)
    local seen = {}
    local items = {}
    local current = vim.api.nvim_buf_get_name(0)

    for _, path in ipairs(vim.v.oldfiles or {}) do
        local skip =
            not is_readable_file(path)
            or seen[path]
            or (opts.exclude_current and path == current)

        if not skip then
            seen[path] = true
            items[#items + 1] = path
        end
    end

    return items
end

function recentfiles.quickfix_text(info)
    local qf_items = vim.fn.getqflist({ id = info.id, items = 1 }).items
    local lines = {}

    for i = info.start_idx, info.end_idx do
        local item = qf_items[i]
        local name = ""

        if item and item.bufnr > 0 then
            name = vim.api.nvim_buf_get_name(item.bufnr)
        elseif item and item.text then
            name = item.text
        end

        local file = vim.fn.fnamemodify(name, ":t")
        local dir = vim.fn.fnamemodify(name, ":h")

        dir = normalize_path(dir)

        if dir ~= "" and not dir:match("/$") then
            dir = dir .. "/"
        end

        lines[#lines + 1] = string.format("%-25s %s", file, dir)
    end

    return lines
end

function recentfiles.setqflist(opts)
    opts = get_opts(opts)

    local oldfiles = collect_oldfiles(opts)

    if vim.tbl_isempty(oldfiles) then
        if opts.notify then
            vim.notify("No recent files found", vim.log.levels.INFO)
        end
        return false
    end

    _G.recentfiles_quickfix_text = recentfiles.quickfix_text

    vim.fn.setqflist({}, " ", {
        title = opts.title,
        lines = oldfiles,
        efm = "%f",
        quickfixtextfunc = "v:lua.recentfiles_quickfix_text",
    })

    return true
end

function recentfiles.open(opts)
    opts = get_opts(opts)

    if not recentfiles.setqflist(opts) then
        return
    end

    vim.cmd(opts.open_cmd)
end

function recentfiles.setup(opts)
    recentfiles.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

    if recentfiles.config.keymap then
        map("n", recentfiles.config.keymap, function()
            recentfiles.open()
        end, { desc = recentfiles.config.desc })
    end

    if recentfiles.config.qf_mappings then
        local group = vim.api.nvim_create_augroup("RecentFilesQuickfix", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "qf",
            callback = function(args)
                local qf_info = vim.fn.getqflist({ title = 1 })
                if qf_info.title ~= recentfiles.config.title then
                    return
                end

                local ns = vim.api.nvim_create_namespace("RecentFilesHighlight")

                vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)

                local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)

                for i, line in ipairs(lines) do
                    local file, path = line:match("^(%S+)%s+(.*)$")

                    if file and path then
                        local file_end = #file
                        local path_start = line:find(path, 1, true) - 1

                        vim.api.nvim_buf_add_highlight(args.buf, ns, "Normal", i - 1, 0, file_end)
                        vim.api.nvim_buf_add_highlight(args.buf, ns, "Comment", i - 1, path_start, -1)
                    end
                end

                vim.bo[args.buf].buflisted = false

                map("n", "q", "<cmd>cclose<cr>", {
                    buffer = args.buf,
                    silent = true,
                    desc = "Close recent files",
                })

                map("n", "<CR>", function()
                    local idx = vim.fn.line(".")
                    vim.cmd(("cc %d"):format(idx))
                    vim.cmd("cclose")
                end, {
                    buffer = args.buf,
                    silent = true,
                    desc = "Open recent file and close list",
                })
            end,
        })
    end
end

recentfiles.setup()

-- =========================================================
-- !!! modules/jumps
-- =========================================================

local jumps = {}

local defaults = {
    title = "Jumplist",
    open_cmd = "copen",
    qf_mappings = true,
    keymap = "<leader>j",
    desc = "Open current window jumplist",
    notify = false,
    include_current = true,
}

jumps.config = vim.deepcopy(defaults)

local qf_ns = vim.api.nvim_create_namespace("JumpListQuickfix")
local current_idx_hl = "QfJumpCurrent"

local function map(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
end

local function get_opts(opts)
    return vim.tbl_deep_extend("force", {}, jumps.config, opts or {})
end

local function normalize_path(path)
    return vim.fn.fnamemodify(path, ":~:.")
end

local function define_qf_highlights()
    vim.api.nvim_set_hl(0, current_idx_hl, { link = "Visual" })
end

local function get_bufname_from_jump(item)
    if item.bufnr and item.bufnr > 0 then
        local name = vim.api.nvim_buf_get_name(item.bufnr)
        if name ~= "" then
            return name
        end
    end
    return item.filename or ""
end

local function get_line_text(bufnr, lnum)
    if not bufnr or bufnr <= 0 or lnum <= 0 then
        return ""
    end

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return ""
    end

    local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, lnum - 1, lnum, false)
    if not ok or not lines or not lines[1] then
        return ""
    end

    return vim.trim(lines[1])
end

local function collect_jumps(opts)
    local result = vim.fn.getjumplist()
    local jumplist = result[1] or {}
    local current_idx = result[2] or -1
    local items = {}

    for i, jump in ipairs(jumplist) do
        local bufnr = jump.bufnr or 0
        local filename = get_bufname_from_jump(jump)

        if bufnr <= 0 and filename ~= "" then
            bufnr = vim.fn.bufnr(filename, false)
        end

        local lnum = jump.lnum or 1
        local col = jump.col or 1

        local text = ""
        if bufnr > 0 then
            text = get_line_text(bufnr, lnum)
        end
        if text == "" then
            text = filename ~= "" and normalize_path(filename) or "[No text]"
        end

        items[#items + 1] = {
            bufnr = bufnr > 0 and bufnr or nil,
            filename = (bufnr <= 0 and filename ~= "") and filename or nil,
            lnum = lnum,
            col = col,
            text = text,
            user_data = {
                jump_index = i,
                current = opts.include_current and (i == (current_idx + 1)) or false,
            },
        }
    end

    return items, current_idx + 1
end

local function apply_qf_line_highlights(bufnr, qf_id)
    vim.api.nvim_buf_clear_namespace(bufnr, qf_ns, 0, -1)

    local qf_items = vim.fn.getqflist({ id = qf_id, items = 1 }).items or {}

    for i, item in ipairs(qf_items) do
        if item.user_data and item.user_data.current then
            vim.api.nvim_buf_set_extmark(bufnr, qf_ns, i - 1, 0, {
                line_hl_group = current_idx_hl,
                priority = 10,
            })
        end
    end
end

function jumps.quickfix_text(info)
    local qf_items = vim.fn.getqflist({ id = info.id, items = 1 }).items or {}
    local lines = {}

    for i = info.start_idx, info.end_idx do
        local item = qf_items[i]
        if item then
            local name = ""

            if item.bufnr and item.bufnr > 0 then
                name = vim.api.nvim_buf_get_name(item.bufnr)
            elseif item.filename then
                name = item.filename
            end

            local path = normalize_path(name ~= "" and name or "[No Name]")
            local lnum = item.lnum or 0
            local col = item.col or 0
            local text = item.text or ""
            local mark = (item.user_data and item.user_data.current) and "●" or " "

            lines[#lines + 1] = string.format("%s %s:%d:%d: %s", mark, path, lnum, col, text)
        end
    end

    return lines
end

function jumps.setqflist(opts)
    opts = get_opts(opts)

    local items = collect_jumps(opts)

    if vim.tbl_isempty(items) then
        if opts.notify then
            vim.notify("No jumps found in current window", vim.log.levels.INFO)
        end
        return false
    end

    _G.jump_quickfix_text = jumps.quickfix_text

    vim.fn.setqflist({}, " ", {
        title = opts.title,
        items = items,
        quickfixtextfunc = "v:lua.jump_quickfix_text",
    })

    return true
end

function jumps.open(opts)
    opts = get_opts(opts)

    if not jumps.setqflist(opts) then
        return
    end

    vim.cmd(opts.open_cmd)
end

local function jump_to_qf_item()
    local item = vim.fn.getqflist()[vim.fn.line(".")]
    if not item then
        return
    end

    local target_buf = item.bufnr
    local target_file = item.filename
    local lnum = math.max(item.lnum or 1, 1)
    local col = math.max(item.col or 1, 1)

    vim.cmd("cclose")

    if target_buf and target_buf > 0 and vim.api.nvim_buf_is_valid(target_buf) then
        vim.api.nvim_set_current_buf(target_buf)
    elseif target_file and target_file ~= "" then
        vim.cmd.edit(vim.fn.fnameescape(target_file))
        target_buf = vim.api.nvim_get_current_buf()
    else
        return
    end

    local line_count = vim.api.nvim_buf_line_count(0)
    lnum = math.min(lnum, line_count)

    local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
    col = math.min(col, math.max(#line, 1))

    vim.api.nvim_win_set_cursor(0, { lnum, math.max(col - 1, 0) })
    vim.cmd("normal! zv")
end

function jumps.setup(opts)
    jumps.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

    define_qf_highlights()

    if jumps.config.keymap then
        map("n", jumps.config.keymap, function()
            jumps.open()
        end, { desc = jumps.config.desc })
    end

    if jumps.config.qf_mappings then
        local group = vim.api.nvim_create_augroup("JumpListQuickfix", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "qf",
            callback = function(args)
                local qf_info = vim.fn.getqflist({ id = 0, title = 1, items = 0 })
                if qf_info.title ~= jumps.config.title then
                    return
                end

                vim.bo[args.buf].buflisted = false

                apply_qf_line_highlights(args.buf, qf_info.id)

                map("n", "q", "<cmd>cclose<cr>", {
                    buffer = args.buf,
                    silent = true,
                    desc = "Close jumplist",
                })

                map("n", "<CR>", jump_to_qf_item, {
                    buffer = args.buf,
                    silent = true,
                    desc = "Open jump and close list",
                })
            end,
        })
    end
end

jumps.setup()

-- =========================================================
-- !!! modules/diag
-- =========================================================

local diag = {}

local defaults = {
    title = "Diagnostics",
    open_cmd = "copen",
    qf_mappings = true,
    keymap = "<leader>d",
    desc = "Open current buffer diagnostics",
    notify = false,
}

diag.config = vim.deepcopy(defaults)

local qf_ns = vim.api.nvim_create_namespace("BufferDiagnosticsQuickfix")

local severity_to_type = {
    [vim.diagnostic.severity.ERROR] = "E",
    [vim.diagnostic.severity.WARN] = "W",
    [vim.diagnostic.severity.INFO] = "I",
    [vim.diagnostic.severity.HINT] = "N",
}

local severity_to_icon = {
    [vim.diagnostic.severity.ERROR] = icons.diagn.error,
    [vim.diagnostic.severity.WARN] = icons.diagn.warning,
    [vim.diagnostic.severity.INFO] = icons.diagn.information,
    [vim.diagnostic.severity.HINT] = icons.diagn.hint,
}

local severity_to_hl = {
    [vim.diagnostic.severity.ERROR] = "QfDiagError",
    [vim.diagnostic.severity.WARN] = "QfDiagWarn",
    [vim.diagnostic.severity.INFO] = "QfDiagInfo",
    [vim.diagnostic.severity.HINT] = "QfDiagHint",
}

local function get_opts(opts)
    return vim.tbl_deep_extend("force", {}, diag.config, opts or {})
end

local function normalize_path(path)
    return vim.fn.fnamemodify(path, ":~:.")
end

local function define_qf_highlights()
    vim.api.nvim_set_hl(0, "QfDiagError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "QfDiagWarn", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "QfDiagInfo", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "QfDiagHint", { link = "DiagnosticHint" })
end

local function collect_buffer_diagnostics()
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(bufnr)
    local items = {}

    for _, d in ipairs(diagnostics) do
        items[#items + 1] = {
            bufnr = bufnr,
            lnum = d.lnum + 1,
            col = d.col + 1,
            end_lnum = d.end_lnum and (d.end_lnum + 1) or nil,
            end_col = d.end_col and (d.end_col + 1) or nil,
            text = d.message,
            type = severity_to_type[d.severity],
            user_data = {
                severity = d.severity,
            },
        }
    end

    table.sort(items, function(a, b)
        if a.lnum ~= b.lnum then
            return a.lnum < b.lnum
        end
        if a.col ~= b.col then
            return a.col < b.col
        end
        return (a.text or "") < (b.text or "")
    end)

    return items
end

local function apply_qf_line_highlights(bufnr, qf_id)
    vim.api.nvim_buf_clear_namespace(bufnr, qf_ns, 0, -1)

    local qf_items = vim.fn.getqflist({ id = qf_id, items = 1 }).items or {}

    for i, item in ipairs(qf_items) do
        local severity = item.user_data and item.user_data.severity
        local hl = severity_to_hl[severity]

        if hl then
            vim.api.nvim_buf_set_extmark(bufnr, qf_ns, i - 1, 0, {
                line_hl_group = hl,
                priority = 10,
            })
        end
    end
end

function diag.quickfix_text(info)
    local qf_items = vim.fn.getqflist({ id = info.id, items = 1 }).items
    local lines = {}

    for i = info.start_idx, info.end_idx do
        local item = qf_items[i]
        if item then
            local name = item.bufnr > 0 and vim.api.nvim_buf_get_name(item.bufnr) or ""
            local path = normalize_path(name)
            local lnum = item.lnum or 0
            local col = item.col or 0
            local severity = item.user_data and item.user_data.severity
            local icon = severity_to_icon[severity] or (item.type or "")
            local text = item.text or ""

            lines[#lines + 1] = string.format("%s:%d:%d: %s %s", path, lnum, col, icon, text)
        end
    end

    return lines
end

function diag.setqflist(opts)
    opts = get_opts(opts)

    local items = collect_buffer_diagnostics()

    if vim.tbl_isempty(items) then
        if opts.notify then
            vim.notify("No diagnostics found in current buffer", vim.log.levels.INFO)
        end
        return false
    end

    _G.diag_quickfix_text = diag.quickfix_text

    vim.fn.setqflist({}, " ", {
        title = opts.title,
        items = items,
        quickfixtextfunc = "v:lua.diag_quickfix_text",
    })

    return true
end

function diag.open(opts)
    opts = get_opts(opts)

    if not diag.setqflist(opts) then
        return
    end

    vim.cmd(opts.open_cmd)
end

function diag.setup(opts)
    diag.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

    define_qf_highlights()

    if diag.config.keymap then
        map("n", diag.config.keymap, function()
            diag.open()
        end, { desc = diag.config.desc })
    end

    if diag.config.qf_mappings then
        local group = vim.api.nvim_create_augroup("BufferDiagnosticsQuickfix", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "qf",
            callback = function(args)
                local qf_info = vim.fn.getqflist({ id = 0, title = 1, items = 0 })
                if qf_info.title ~= diag.config.title then
                    return
                end

                vim.bo[args.buf].buflisted = false

                apply_qf_line_highlights(args.buf, qf_info.id)

                map("n", "q", "<cmd>cclose<cr>", {
                    buffer = args.buf,
                    silent = true,
                    desc = "Close diagnostics list",
                })

                map("n", "<CR>", function()
                    local idx = vim.fn.line(".")
                    vim.cmd(("cc %d"):format(idx))
                    vim.cmd("cclose")
                end, {
                    buffer = args.buf,
                    silent = true,
                    desc = "Open diagnostic and close list",
                })
            end,
        })
    end
end

diag.setup()

-- =========================================================
-- !!! modules/buff
-- =========================================================

local buffers = {}

local defaults = {
    title = "Open buffers",
    exclude_current = true,
    open_cmd = "copen",
    qf_mappings = true,
    keymap = "<leader>b",
    desc = "Open buffers",
    notify = false,
}

buffers.config = vim.deepcopy(defaults)

local function get_opts(opts)
    return vim.tbl_deep_extend("force", {}, buffers.config, opts or {})
end

local function normalize_path(path)
    return vim.fn.fnamemodify(path, ":~:.")
end

local function is_real_file_buffer(bufinfo)
    local name = bufinfo.name or ""
    if name == "" then
        return false
    end

    local bufnr = bufinfo.bufnr
    local buftype = vim.bo[bufnr].buftype

    return buftype == ""
end

local function collect_buffers(opts)
    local items = {}
    local current = vim.api.nvim_get_current_buf()
    local listed = vim.fn.getbufinfo({ buflisted = 1 })

    table.sort(listed, function(a, b)
        return (a.lastused or 0) > (b.lastused or 0)
    end)

    for _, bufinfo in ipairs(listed) do
        local skip =
            not is_real_file_buffer(bufinfo)
            or (opts.exclude_current and bufinfo.bufnr == current)

        if not skip then
            items[#items + 1] = {
                filename = bufinfo.name,
                bufnr = bufinfo.bufnr,
            }
        end
    end

    return items
end

function buffers.quickfix_text(info)
    local qf_items = vim.fn.getqflist({ id = info.id, items = 1 }).items
    local lines = {}

    for i = info.start_idx, info.end_idx do
        local item = qf_items[i]
        local name = ""

        if item and item.bufnr > 0 then
            name = vim.api.nvim_buf_get_name(item.bufnr)
        elseif item and item.text then
            name = item.text
        end

        local file = vim.fn.fnamemodify(name, ":t")
        local dir = vim.fn.fnamemodify(name, ":h")

        dir = normalize_path(dir)

        if dir ~= "" and not dir:match("/$") then
            dir = dir .. "/"
        end

        lines[#lines + 1] = string.format("%-25s %s", file, dir)
    end

    return lines
end

function buffers.setqflist(opts)
    opts = get_opts(opts)

    local open_buffers = collect_buffers(opts)

    if vim.tbl_isempty(open_buffers) then
        if opts.notify then
            vim.notify("No open buffers found", vim.log.levels.INFO)
        end
        return false
    end

    local items = vim.tbl_map(function(buf)
        return {
            bufnr = buf.bufnr,
            lnum = 1,
            col = 1,
            text = buf.filename,
        }
    end, open_buffers)

    _G.buffers_quickfix_text = buffers.quickfix_text

    vim.fn.setqflist({}, " ", {
        title = opts.title,
        items = items,
        quickfixtextfunc = "v:lua.buffers_quickfix_text",
    })

    return true
end

function buffers.open(opts)
    opts = get_opts(opts)

    if not buffers.setqflist(opts) then
        return
    end

    vim.cmd(opts.open_cmd)
end

function buffers.setup(opts)
    buffers.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

    if buffers.config.keymap then
        map("n", buffers.config.keymap, function()
            buffers.open()
        end, { desc = buffers.config.desc })
    end

    if buffers.config.qf_mappings then
        local group = vim.api.nvim_create_augroup("OpenBuffersQuickfix", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "qf",
            callback = function(args)
                local qf_info = vim.fn.getqflist({ title = 1 })
                if qf_info.title ~= buffers.config.title then
                    return
                end

                local ns = vim.api.nvim_create_namespace("OpenBuffersHighlight")

                vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)

                local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)

                for i, line in ipairs(lines) do
                    local file, path = line:match("^(%S+)%s+(.*)$")

                    if file and path then
                        local file_end = #file
                        local path_start = line:find(path, 1, true) - 1

                        vim.api.nvim_buf_add_highlight(args.buf, ns, "Normal", i - 1, 0, file_end)
                        vim.api.nvim_buf_add_highlight(args.buf, ns, "Comment", i - 1, path_start, -1)
                    end
                end

                vim.bo[args.buf].buflisted = false

                map("n", "q", "<cmd>cclose<cr>", {
                    buffer = args.buf,
                    silent = true,
                    desc = "Close open buffers list",
                })

                map("n", "<CR>", function()
                    local idx = vim.fn.line(".")
                    vim.cmd(("cc %d"):format(idx))
                    vim.cmd("cclose")
                end, {
                    buffer = args.buf,
                    silent = true,
                    desc = "Open buffer and close list",
                })
            end,
        })
    end
end

buffers.setup()

-- =========================================================
-- !!! modules/snippets
-- =========================================================

local M = {}

---@param defs table<string, string>  -- trigger -> snippet body
---@param opts? { modes?: string|string[], key?: string, match?: fun(before: string, trigger: string): boolean }
function M.setup(defs, opts)
    opts = opts or {}

    local modes = opts.modes or "i"
    local key = opts.key or "<C-x>"
    local match = opts.match or function(before, trigger)
        return before:sub(- #trigger) == trigger
    end

    local triggers = vim.tbl_keys(defs)
    table.sort(triggers, function(a, b)
        return #a > #b
    end)

    map(modes, key, function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        local before = line:sub(1, col)

        for _, trigger in ipairs(triggers) do
            if match(before, trigger) then
                local start_col = col - #trigger
                vim.api.nvim_buf_set_text(0, row - 1, start_col, row - 1, col, { "" })
                vim.api.nvim_win_set_cursor(0, { row, start_col })
                vim.snippet.expand(defs[trigger])
                return
            end
        end

        vim.api.nvim_feedkeys(vim.keycode(key), "n", false)
    end, { desc = "Expand snippet trigger" })
end

M.setup({ -- snippets (expand with c-x)
    issue = "*brakoll - d: $0, p: 0, t: feature, s: open",
})
