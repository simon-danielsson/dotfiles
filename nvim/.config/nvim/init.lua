-- =========================================================
-- !!! aliases
-- =========================================================

local opt          = vim.opt; local g = vim.g
local o            = vim.o; local cmd = vim.cmd
local map          = vim.keymap.set; local shl = vim.api.nvim_set_hl
local autocmd      = vim.api.nvim_create_autocmd; local augroup = vim.api.nvim_create_augroup

-- =========================================================
-- !!! general/options
-- =========================================================

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

-- =========================================================
-- !!! general/netrw
-- =========================================================

g.netrw_liststyle     = 3; g.netrw_banner = 0; g.netrw_preview = 1; g.netrw_keepdir = 0
g.netrw_sort_sequence = [[[/]$,\<core\%(\.\d\+\)\=,\.(c|h|cpp|hpp|lua|py|rs|go|ts|js)$,*]]
shl(0, "netrwMarkFile", { link = "Visual" })

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
        cmd("pclose")
    end,
})

-- =========================================================
-- !!! general/folds
-- =========================================================

opt.foldcolumn   = "2"; o.foldmethod = "marker"; o.foldlevelstart = 99; o.foldenable = false

map('n', 'zz', 'za',
    { desc = "Toggle fold under cursor" })

map({ 'n', 'v' }, 'zn', 'zf',
    { desc = "New fold" })

map('n', 'zo', 'zR',
    { desc = "Open all folds" })

map('n', 'zc', 'zM',
    { desc = "Close all folds" })

-- =========================================================
-- !!! general/keymaps
-- =========================================================

-- leader
vim.g.mapleader      = " "; vim.g.maplocalleader = " "

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

local function on_jump(diagnostic, bufnr)
    if not diagnostic then
        return
    end
    vim.schedule(function()
        vim.diagnostic.open_float(bufnr, {
            scope = "line",
            pos = { diagnostic.lnum, diagnostic.col },
        })
    end)
end
map("n", "<C-e>", function()
    vim.diagnostic.jump({ count = -1, on_jump = on_jump })
    cmd("normal! zz")
end, { desc = "Go to previous diagnostic" })

map("n", "<C-o>", function()
    vim.diagnostic.jump({ count = 1, on_jump = on_jump })
    cmd("normal! zz")
end, { desc = "Go to next diagnostic" })

-- navigation: global

map("n", "<leader>f", function()
    local dir = vim.fn.getcwd()
    cmd("Explore " .. vim.fn.fnameescape(dir))
end)

map("n", "<Left>", "<cmd>bprevious<cr>", { desc = "Go to prev buffer" })
map("n", "<Right>", "<cmd>bnext<cr>", { desc = "Go to next buffer" })

map("n", "<c-b>", function()
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    if #bufs == 1 then
        cmd("update")
        cmd("quit")
    else
        cmd("update")
        cmd("bdelete")
    end
end, { desc = "save & close buffer (or quit if last)" })

map("n", ",", function()
    cmd("wincmd w")
end, { desc = "Cycle through splits" })

map('t', '<Esc><Esc>', '<C-\\><C-n>',
    { desc = 'Exit terminal mode' })

-- general

map("n", "<Esc>", "<cmd>nohlsearch<CR>",
    { desc = "Clear search highlights" })

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
    cmd("normal! V")
    vim.api.nvim_win_set_cursor(0, { bottom, 0 })
end, { desc = "Smart select paragraph" })

-- New insert mode bindings
map("n", "<leader>i", "i", { desc = "Insert before cursor" })
map("n", "<leader>I", "I", { desc = "Insert at line start" })
map("n", "<leader>o", "o", { desc = "Open new line below" })
map("n", "<leader>O", "O", { desc = "Open new line above" })

map("v", "<Tab>", ">gv", { desc = "Indent selection" })
map("v", "<S-Tab>", "<gv", { desc = "Outdent selection" })
map("n", "<Tab>", ">>", { desc = "Indent line" })
map("n", "<S-Tab>", "<<", { desc = "Outdent line" })
map("i", "<Tab>", "<C-t>", { desc = "Indent line in insert mode" })
map("i", "<S-Tab>", "<C-d>", { desc = "Outdent line in insert mode" })

-- Move selected lines up/down in visual mode using Shift and navigation keys
map("v", "<S-o>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<S-e>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

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

map("n", "gd", vim.lsp.buf.definition); map("n", "gr", vim.lsp.buf.references)

-- =========================================================
-- !!! ui/theme
-- =========================================================

-- borders
vim.g.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

-- diagnostics display
vim.diagnostic.config({
    float = { border = "rounded" },
})

local theme   = {}

theme.colors  = {
    fg_1 = "#AAB3C0",
    fg_2 = "#6e6e87",
    mg_1 = "#40404f",
    bg_1 = "#2a2a33",
    bg_2 = "#25252d",
}

theme.accents = {
    a1 = "#83C093",
    a2 = "#E67E80",
    a3 = "#bb9cd5",
}

vim.pack.add({
    {
        src = "https://github.com/vague-theme/vague.nvim"
    },
})

require("vague").setup({
    italic = false,
})

function theme.theme()
    vim.o.background = "light"
    cmd.colorscheme("vague")
end

theme.theme()

local overrides = {
    -- line numbers
    LineNr              = { fg = theme.colors.mg_1, bg = "none" },
    LineNrAbove         = { link = "LineNr" },
    LineNrBelow         = { link = "LineNr" },
    CursorLineNr        = { fg = theme.colors.fg_1, bg = "none" },
    SignColumn          = { bg = theme.colors.bg_2 },

    -- folds
    FoldColumn          = { link = "SignColumn" },
    Folded              = { fg = theme.colors.fg_2, bg = theme.colors.bg_1 },

    -- tabline
    TabLine             = { fg = theme.colors.fg_2, bg = theme.colors.bg_2 },
    TabLineSel          = { fg = theme.colors.fg_1, bg = theme.colors.bg_1 },
    TabLineFill         = { fg = theme.colors.mg_1, bg = theme.colors.bg_1 },
    TabLineSep          = { fg = theme.colors.mg_1, bg = theme.colors.bg_2 },

    -- hints
    Comment             = { fg = theme.colors.fg_2, bg = theme.colors.bg_2 },
    IndentGuide         = { fg = theme.colors.mg_1, bg = theme.colors.bg_2 },
    LspInlineCompletion = { fg = theme.colors.mg_1, bg = theme.colors.bg_2 },
    Biscuit             = { fg = theme.colors.mg_1, bg = theme.colors.bg_1 },

    -- normal
    Normal              = { fg = theme.colors.fg_1, bg = theme.colors.bg_2 },
    NormalNC            = { link = "Normal" },

    -- cursor
    CursorLine          = { bg = theme.colors.bg_1 },

    -- quickfix
    QuickFixLine        = { ctermbg = 0 },
    qfFileName          = { fg = theme.colors.fg_1 },

    -- float
    NormalFloat         = { link = "CursorLineNr" },
    FloatBorder         = { fg = theme.colors.fg_2, bg = "none" },

    -- splits
    WinSeparator        = { fg = theme.colors.mg_1, bg = "none" },
    EndOfBuffer         = { link = "CursorLineNr" },
    ColorColumn         = { ctermbg = 0, bg = theme.colors.mg_1 },
    VertSplit           = { ctermbg = 0, bg = "none", fg = "none" },

    -- popup menu
    Pmenu               = { fg = theme.colors.fg_2, bg = theme.colors.bg_2 },
    PmenuSel            = { bg = theme.colors.mg_1, fg = theme.colors.fg_1 },
    PmenuKind           = { bg = theme.colors.bg_2, fg = theme.colors.fg_1 },
    PmenuExtra          = { bg = theme.colors.bg_2, fg = theme.colors.fg_1 },
    PmenuMatch          = { bg = theme.colors.mg_1, fg = theme.colors.fg_1 },
    PmenuKindSel        = { bg = theme.colors.mg_1, bold = true },
    PmenuMatchSel       = { link = "PmenuKindSel" },
    PmenuExtraSel       = { link = "PmenuKindSel" },
    PmenuThumb          = { link = "PmenuKindSel" },
    PmenuSbar           = { bg = theme.colors.bg_2 },
    PmenuBorder         = { fg = theme.colors.fg_2, bg = "none" },

    -- statusline
    StatusLine          = { fg = theme.colors.fg_1, bg = theme.colors.bg_1, bold = false },
    StatusLineNormal    = { link = "StatusLine" },
    StatusLineNC        = { link = "StatusLine" },
    StatusLineTerm      = { link = "StatusLine" },
    StatusLineTermNC    = { link = "StatusLine" },
    StatusFilename      = { link = "StatusLine" },
    StatusPosition      = { link = "StatusLine" },
    StatusWords         = { link = "StatusLine" },
    StatusMode          = { link = "StatusLine" },
}

for group, opts in pairs(overrides) do
    shl(0, group, opts)
end

-- =========================================================
-- !!! ui/statusline
-- =========================================================

local function short_filepath()
    local path = vim.fn.expand("%:p"); local home = vim.loop.os_homedir()
    if path:sub(1, #home) == home then
        path = "~" .. path:sub(#home + 1)
    end
    local parts = vim.split(path, "/", { trimempty = true })
    local count = #parts
    return table.concat({
        parts[count - 2] or "",
        parts[count - 1] or "",
        parts[count] or "",
    }, "/")
end

function _G.statusline_insert()
    local file = short_filepath()
    return table.concat({
        "%*",
        file,

    })
end

local stl = vim.go.statusline
stl = stl:gsub("%%<%%f", "%%{%%v:lua.statusline_insert()%%}", 1)
stl = stl:gsub("%%f", "%%{%%v:lua.statusline_insert()%%}", 1)
vim.go.statusline = " " .. stl .. " "

-- =========================================================
-- !!! autocommands/write
-- =========================================================

local write_group = augroup("WriteCommands", { clear = true })

autocmd("BufWritePre", {
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

autocmd("BufWritePre", {
    group = write_group,
    pattern = "*",
    callback = function()
        local ft = vim.bo.filetype
        local ext = vim.fn.expand("%:e")
        if ft == "markdown" or ft == "yaml" or ext == "html" or ext == "RPP" or ext == "reamake" or ext:lower() == "csv" then
            return
        end
        local pos = vim.api.nvim_win_get_cursor(0)
        cmd([[silent! %s/\s\+$//e]])
        cmd([[silent! %s/\(\n\)\{3,}/\r\r/e]])
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
-- !!! autocommands/files
-- =========================================================

local files_group = augroup("FileCommands", { clear = true })

autocmd("BufReadPost", {
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.api.nvim_buf_get_name(buf)
            local bt = vim.bo[buf].buftype
            if name == "" and bt == "" then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
        end
    end,
    desc = "auto delete intro screen",
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

local term_buf = nil; local term_win = nil; local term_job = nil

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

local run_compile_keymap = "<leader>c"

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
        map("n", run_compile_keymap, function()
            cmd('write')
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
        map("n", run_compile_keymap, function()
            cmd('write')
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
        map("n", run_compile_keymap, function()
            cmd('write')
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
        map("n", run_compile_keymap, function()
            cmd('write')
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
            cmd("bdelete! " .. term_buf)
            term_buf, term_win, term_job = nil, nil, nil
        end
    end,
    desc = "Close terminal buffer on process exit",
})

-- =========================================================
-- !!! autocommands/ui
-- =========================================================

local ui_group = augroup("UiCommands", { clear = true })

local function clear_cmdline_after(delay)
    vim.defer_fn(function()
        if vim.api.nvim_get_mode().mode == "n" then
            cmd("echo ''")
        end
    end, delay)
end

autocmd("CmdlineLeave", {
    group = ui_group,
    callback = function()
        clear_cmdline_after(4000) -- 4 seconds
    end,
    desc = "auto-clear messages after cmdline leave",
})

autocmd("VimResized", {
    group = ui_group,
    callback = function()
        cmd("tabdo wincmd =")
    end,
    desc = "Auto-resize splits when window is resized",
})

autocmd('BufWinEnter', {
    group = ui_group,
    pattern = { '*.txt' },
    callback = function()
        if vim.o.filetype == 'help' then cmd.wincmd('L') end
    end,
    desc = "Open help window in a vertical split to the right",
})

-- =========================================================
-- !!! lsp/lsp
-- =========================================================

autocmd("FileType", {
    pattern = { "markdown", "text" },
    callback = function()
        vim.opt_local.spell = true; vim.opt_local.spelllang = { "en" }
    end,
    desc = "spell checking inside markdown and text files",
})

-- preview color on hex/rgb codes etc.
-- (only works with lsps that support this, ex: css_ls)
vim.lsp.document_color.enable(true, nil, { style = '■ ' })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_servers = {
    rust_analyzer = {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
        settings = {
            ['rust-analyzer'] = {},
        },
    },

    bashls = {
        cmd = { 'bash-language-server', 'start' },
        filetypes = { 'bash', 'sh' },
        root_markers = { '.git' },
        settings = {
            bashIde = {},
        },
    },

    marksman = {
        cmd = { 'marksman', 'server' },
        filetypes = { 'markdown' },
        root_markers = { '.git' },
        capabilities = capabilities,
    },

    pyright = {
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
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                },
            },
        },
    },

    clangd = {
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
    },

    tsserver = {
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
    },

    lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.git', '.luarc.json', '.luarc.jsonc' },
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = { 'vim' },
                    disable = { 'redefined-local' },
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
    },

    cssls = {
        cmd = { 'vscode-css-language-server', '--stdio' },
        filetypes = { 'css', 'scss', 'less' },
        capabilities = capabilities,
    },

    html = {
        cmd = { 'vscode-html-language-server', '--stdio' },
        filetypes = { 'html' },
        capabilities = capabilities,
    },

    copilot = {
        cmd = { 'copilot-language-server', '--stdio' },
        root_markers = { '.git' },
        filetypes = {
            'lua',
            'python',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'go',
            'rust',
            'c',
            'cpp',
            'java',
        },

        init_options = {
            editorInfo = {
                name = "Neovim",
                version = tostring(vim.version()),
            },
            editorPluginInfo = {
                name = "Neovim",
                version = tostring(vim.version()),
            },
        },

        on_attach = function(client, bufnr)
            if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
                vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
            end
        end,
    },
}

for name, config in pairs(lsp_servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end

vim.keymap.set("i", "<C-l>", function()
    if not vim.lsp.inline_completion.get({ bufnr = 0 }) then
        return "<C-l>"
    end
end, { expr = true, desc = "Accept Copilot" })

-- =========================================================
-- !!! lsp/format
-- =========================================================

autocmd("BufWritePre", {
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
            cmd("normal! gg=G")
        elseif ft == "rust" then
            cmd("normal! gg=G")
        elseif not has_lsp then
            cmd("normal! gg=G")
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
vim.o.inccommand    = 'nosplit'; vim.opt.pumborder = "rounded"

-- code
autocmd("LspAttach", {
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
autocmd("CmdlineChanged", {
    pattern = { ":", "/", "?" },
    callback = function()
        vim.fn.wildtrigger()
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

local function can_auto_close_quote(line, pos, _)
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
    local stack = {}; local active_quote = nil

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
    local line = getline(); local cursor_col = col()
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
    local line = getline(); local c = col(); local next = get_char_at(c)
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
    local c = col(); local prev = get_char_at(c - 1); local next = get_char_at(c)
    if autopairs.pairs[prev] == next or (autopairs.quotes[prev] and prev == next) then
        return "<BS><Del>"
    end
    return "<BS>"
end

function autopairs.newline()
    local c = col(); local prev = get_char_at(c - 1); local next = get_char_at(c)
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

local flash = {}; local ns = vim.api.nvim_create_namespace("flash")
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
    pcall(cmd, "redraw")
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

    local out = {}; local curline, curcol = current_cursor(state.winid); local needle = normalize(pattern)

    for i, line in ipairs(state.view.lines) do
        local lnum = state.view.top + i - 1; local hay = state.view.normalized[i]; local start = 1
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

    local out = {}; local needle = normalize(pattern); local needle_len = #needle

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
    pcall(cmd, "redraw")
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

local indent_guides = {}; local ns = vim.api.nvim_create_namespace("native_indent_guides")
local defaults = {
    char = "│",
    highlight = "IndentGuide",
    show_first_level = true,
    show_blanklines = true,
    exclude_filetypes = {
        help = true,
        netrw = true,
    },
    exclude_buftypes = {
        terminal = true,
        prompt = true,
        quickfix = true,
        nofile = true,
    },
}

local config = vim.deepcopy(defaults); local enabled = true

local function is_excluded(bufnr)
    local ft = vim.bo[bufnr].filetype; local bt = vim.bo[bufnr].buftype
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
    local width = 0; local i = 1
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
    local cells = {}; local vcol = 0; local i = 1
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

function indent_guides.refresh()
    cmd("redraw")
end

function indent_guides.enable()
    enabled = true
    indent_guides.refresh()
end

function indent_guides.disable()
    enabled = false
    indent_guides.refresh()
end

function indent_guides.toggle()
    enabled = not enabled
    indent_guides.refresh()
end

function indent_guides.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})

    vim.api.nvim_create_user_command("IndentGuidesEnable", function()
        indent_guides.enable()
    end, {})
    vim.api.nvim_create_user_command("IndentGuidesDisable", function()
        indent_guides.disable()
    end, {})

    vim.api.nvim_create_user_command("IndentGuidesToggle", function()
        indent_guides.toggle()
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

            local lnum = row + 1; local line = get_line(bufnr, lnum)
            if not line then
                return
            end

            local sw = get_shiftwidth(bufnr); local tabstop = vim.bo[bufnr].tabstop
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

indent_guides.setup()

-- =========================================================
-- !!! modules/biscuits
-- =========================================================

local biscuits = {}; local ns = vim.api.nvim_create_namespace("native_biscuits")
local config = {
    enabled = true,
    cursor_line_only = true,
    prefix = "",
    hl = "Biscuit",
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
    local n = 0; local i = 1
    while i <= #s do
        if s:sub(i, i) == ch then
            n = n + 1
        end
        i = i + 1
    end
    return n
end

local function find_lua_opener(bufnr, row)
    local depth = 0; local start = math.max(0, row - config.max_scan)

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
    local depth = 0; local start = math.max(0, row - config.max_scan)
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
    local cur = line(bufnr, row); local kind = classify_closer(cur)
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

    local top = vim.fn.line("w0", winid) - 1; local bot = vim.fn.line("w$", winid) - 1
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

function biscuits.refresh()
    draw_for_window(vim.api.nvim_get_current_win())
end

function biscuits.setup(opts)
    config = vim.tbl_extend("force", config, opts or {})
    local aug = vim.api.nvim_create_augroup("NativeBiscuits", { clear = true })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter", "TextChanged", "TextChangedI" }, {
        group = aug,
        callback = function()
            draw_for_window(vim.api.nvim_get_current_win())
        end,
    })
    vim.api.nvim_create_user_command("BiscuitsRefresh", function()
        biscuits.refresh()
    end, {})
end

biscuits.setup()

-- =========================================================
-- !!! modules/qf_picker
-- =========================================================

local api, fn, cmd = vim.api, vim.fn, vim.cmd
local map = vim.keymap.set

local norm = function(p) return fn.fnamemodify(p or "", ":~:.") end
local line = function(buf, lnum)
    if not (buf and buf > 0 and lnum > 0 and api.nvim_buf_is_valid(buf)) then return "" end
    local ok, s = pcall(api.nvim_buf_get_lines, buf, lnum - 1, lnum, false)
    return ok and s and s[1] and vim.trim(s[1]) or ""
end
local jump_cur = function()
    cmd.cc({ count = fn.line(".") }); pcall(cmd, "cclose")
end
local bufname = function(item)
    local b = item.bufnr or 0
    if b > 0 then
        local n = api.nvim_buf_get_name(b)
        if n ~= "" then return n end
    end
    return item.filename or ""
end
local filedir = function(name)
    local file, dir = fn.fnamemodify(name, ":t"), norm(fn.fnamemodify(name, ":h"))
    return file, dir ~= "" and (dir:match("/$") and dir or dir .. "/") or dir
end
local hl_split_cols = function(buf, ns)
    api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for i, s in ipairs(api.nvim_buf_get_lines(buf, 0, -1, false)) do
        local f, p = s:match("^(%S+)%s+(.*)$")
        if f and p then
            local r, c = i - 1, s:find(p, 1, true) - 1
            vim.hl.range(buf, ns, "Normal", { r, 0 }, { r, #f })
            vim.hl.range(buf, ns, "Comment", { r, c }, { r, #s })
        end
    end
end

local function create_qf_picker(spec)
    local picker = {
        config = vim.tbl_deep_extend("force", {
            title = "Picker",
            open_cmd = "copen",
            qf_mappings = true,
            notify = false,
            keymap = nil,
            desc = nil,
        }, spec.defaults or {}),
    }

    local qftf = "_qf_picker_textfunc_" .. (spec.name or tostring(math.random(1, 999999)))
    local opts = function(o) return vim.tbl_deep_extend("force", {}, picker.config, o or {}) end

    function picker.quickfix_text(info)
        local items = fn.getqflist({ id = info.id, items = 1 }).items or {}
        local out = {}
        for i = info.start_idx, info.end_idx do
            if items[i] then out[#out + 1] = spec.format_item(items[i], i, items, norm) end
        end
        return out
    end

    function picker.setqflist(o)
        o = opts(o)
        local items = spec.collect(o) or {}
        if vim.tbl_isempty(items) then
            if o.notify then vim.notify(o.empty_message or ("No " .. o.title:lower() .. " found"), vim.log.levels.INFO) end
            return
        end
        _G[qftf] = picker.quickfix_text
        local payload = { title = o.title, items = items, quickfixtextfunc = "v:lua." .. qftf }
        if spec.after_setqflist then spec.after_setqflist(payload, o, items) end
        fn.setqflist({}, " ", payload)
        return true
    end

    function picker.open(o)
        if picker.setqflist(o) then cmd((opts(o)).open_cmd) end
    end

    function picker.setup(o)
        picker.config = vim.tbl_deep_extend("force", picker.config, o or {})
        if picker.config.keymap then
            map("n", picker.config.keymap, picker.open, { desc = picker.config.desc or picker.config.title })
        end
        if not picker.config.qf_mappings then return end

        local group = api.nvim_create_augroup("QfPicker_" .. (spec.name or picker.config.title), { clear = true })
        api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "qf",
            callback = function(args)
                local qf = fn.getqflist({ id = 0, title = 1, items = 0 })
                if qf.title ~= picker.config.title then return end
                vim.bo[args.buf].buflisted = false
                if spec.decorate_qf then spec.decorate_qf(args.buf, qf.id, picker.config) end
                map("n", "q", "<cmd>cclose<cr>",
                    { buffer = args.buf, silent = true, desc = "Close " .. picker.config.title:lower() })
                map("n", "<CR>", jump_cur, { buffer = args.buf, silent = true, desc = "Open selection" })
                if spec.qf_mappings then spec.qf_mappings(args.buf, qf.id, picker.config) end
            end,
        })
    end

    return picker
end

-- =========================================================
-- !!! modules/jumps
-- =========================================================

shl(0, "QfJumpCurrent", { link = "Visual" })
local jumps_ns = api.nvim_create_namespace("JumpListQuickfix")

local jumps = create_qf_picker({
    name = "jumps",
    defaults = {
        title = "Jumplist",
        keymap = "<leader>j",
        desc = "Open current window jumplist",
        include_current = true,
        empty_message = "No jumps found in current window",
    },

    collect = function(o)
        local jl, idx = unpack(fn.getjumplist())
        local items = {}
        for i, j in ipairs(jl or {}) do
            local b, name = j.bufnr or 0, bufname(j)
            if b <= 0 and name ~= "" then b = fn.bufnr(name, false) end
            local lnum, col = j.lnum or 1, j.col or 1
            local text = b > 0 and line(b, lnum) or ""
            if text == "" then text = name ~= "" and norm(name) or "[No text]" end
            items[#items + 1] = {
                bufnr = b > 0 and b or nil,
                filename = (b <= 0 and name ~= "") and name or nil,
                lnum = lnum,
                col = col,
                text = text,
                user_data = { jump_index = i, current = o.include_current and i == idx + 1 or false },
            }
        end
        return items
    end,

    format_item = function(item, _, _, normalize)
        local p = normalize((bufname(item) ~= "" and bufname(item)) or "[No Name]")
        local m = item.user_data and item.user_data.current and "●" or " "
        return ("%s %s:%d:%d: %s"):format(m, p, item.lnum or 0, item.col or 0, item.text or "")
    end,

    decorate_qf = function(buf, id)
        api.nvim_buf_clear_namespace(buf, jumps_ns, 0, -1)
        for i, item in ipairs(fn.getqflist({ id = id, items = 1 }).items or {}) do
            if item.user_data and item.user_data.current then
                api.nvim_buf_set_extmark(buf, jumps_ns, i - 1, 0, { line_hl_group = "QfJumpCurrent", priority = 10 })
            end
        end
    end,
})
jumps.setup()

-- =========================================================
-- !!! modules/marks
-- =========================================================

shl(0, "QfMarkLocal", { link = "String" })
shl(0, "QfMarkGlobal", { link = "Identifier" })
local marks_ns = api.nvim_create_namespace("MarksQuickfix")

local mark_kind = function(m)
    local c = (m or ""):sub(-1)
    if c == "" or not c:match("[%a%d]") then return "builtin" end
    if c:match("%l") then return "local" end
    if c:match("[%u%d]") then return "global" end
end

local mark_item = function(mi)
    local pos, b, m = mi.pos or {}, (mi.pos or {})[1] or 0, mi.mark or ""
    local lnum, col = pos[2] or 1, pos[3] or 1
    local name = (b > 0 and api.nvim_buf_is_valid(b)) and api.nvim_buf_get_name(b) or mi.file or ""
    if b <= 0 and name ~= "" then b = fn.bufnr(name, false) end
    local text = b > 0 and line(b, lnum) or ""
    if text == "" then text = name ~= "" and norm(name) or "[No text]" end
    local kind = mark_kind(m)
    return {
        bufnr = b > 0 and b or nil,
        filename = (b <= 0 and name ~= "") and name or nil,
        lnum = lnum,
        col = col,
        text = text,
        user_data = { mark = m, local_mark = kind == "local", global_mark = kind == "global" },
    }
end

local marks = create_qf_picker({
    name = "marks",
    defaults = {
        title = "marks",
        keymap = "<leader>m",
        desc = "Open marks picker",
        include_local = true,
        include_global = true,
        include_builtin = false,
        empty_message = "No marks found",
    },

    collect = function(o)
        local items, seen = {}, {}
        local function add(xs)
            for _, mi in ipairs(xs or {}) do
                local m, k = mi.mark or "", mark_kind(mi.mark)
                if m ~= "" and ((k == "builtin" and o.include_builtin) or (k == "local" and o.include_local) or (k == "global" and o.include_global)) then
                    local it = mark_item(mi)
                    local key = table.concat(
                        { it.user_data.mark or "", it.filename or "", it.bufnr or 0, it.lnum or 0, it.col or 0 }, ":")
                    if not seen[key] then seen[key], items[#items + 1] = true, it end
                end
            end
        end
        if o.include_local then add(fn.getmarklist(api.nvim_get_current_buf())) end
        if o.include_global then add(fn.getmarklist()) end
        table.sort(items, function(a, b) return (a.user_data.mark or "") < (b.user_data.mark or "") end)
        return items
    end,

    format_item = function(item, _, _, normalize)
        return ("%s %s:%d:%d: %s"):format(
            (item.user_data and item.user_data.mark) or "?",
            normalize((bufname(item) ~= "" and bufname(item)) or "[No Name]"),
            item.lnum or 0, item.col or 0, item.text or ""
        )
    end,

    decorate_qf = function(buf, id)
        api.nvim_buf_clear_namespace(buf, marks_ns, 0, -1)
        for i, item in ipairs(fn.getqflist({ id = id, items = 1 }).items or {}) do
            local u = item.user_data or {}; local hl = u.local_mark and "QfMarkLocal" or u.global_mark and "QfMarkGlobal"
            if hl then
                api.nvim_buf_set_extmark(buf, marks_ns, i - 1, 0, { line_hl_group = hl, priority = 10 })
            end
        end
    end,
})
marks.setup()

-- =========================================================
-- !!! modules/diagnostics
-- =========================================================

for k, v in pairs({
    QfDiagError = "DiagnosticError",
    QfDiagWarn  = "DiagnosticWarn",
    QfDiagInfo  = "DiagnosticInfo",
    QfDiagHint  = "DiagnosticHint",
}) do shl(0, k, { link = v }) end

local diag_ns = api.nvim_create_namespace("BufferDiagnosticsQuickfix")
local sev_type = {
    [vim.diagnostic.severity.ERROR] = "E",
    [vim.diagnostic.severity.WARN]  = "W",
    [vim.diagnostic.severity.INFO]  = "I",
    [vim.diagnostic.severity.HINT]  = "N",
}
local sev_hl = {
    [vim.diagnostic.severity.ERROR] = "QfDiagError",
    [vim.diagnostic.severity.WARN]  = "QfDiagWarn",
    [vim.diagnostic.severity.INFO]  = "QfDiagInfo",
    [vim.diagnostic.severity.HINT]  = "QfDiagHint",
}

local diag = create_qf_picker({
    name = "diag",
    defaults = {
        title = "Diagnostics",
        keymap = "<leader>d",
        desc = "Open current buffer diagnostics",
        empty_message = "No diagnostics found in current buffer",
    },

    collect = function()
        local b, items = api.nvim_get_current_buf(), {}
        for _, d in ipairs(vim.diagnostic.get(b)) do
            items[#items + 1] = {
                bufnr = b,
                lnum = d.lnum + 1,
                col = d.col + 1,
                end_lnum = d.end_lnum and d.end_lnum + 1 or nil,
                end_col = d.end_col and d.end_col + 1 or nil,
                text = d.message,
                type = sev_type[d.severity],
                user_data = { severity = d.severity },
            }
        end
        table.sort(items, function(a, b)
            return a.lnum < b.lnum
                or a.lnum == b.lnum and (a.col < b.col
                    or a.col == b.col and (a.text or "") < (b.text or ""))
        end)
        return items
    end,

    format_item = function(item, _, _, normalize)
        return ("%s:%d:%d: %s %s"):format(
            normalize(item.bufnr > 0 and api.nvim_buf_get_name(item.bufnr) or ""),
            item.lnum or 0, item.col or 0, item.type or "", item.text or ""
        )
    end,

    decorate_qf = function(buf, id)
        api.nvim_buf_clear_namespace(buf, diag_ns, 0, -1)
        for i, item in ipairs(fn.getqflist({ id = id, items = 1 }).items or {}) do
            local hl = sev_hl[item.user_data and item.user_data.severity]
            if hl then
                api.nvim_buf_set_extmark(buf, diag_ns, i - 1, 0, { line_hl_group = hl, priority = 10 })
            end
        end
    end,
})
diag.setup()

-- =========================================================
-- !!! modules/recentfiles
-- =========================================================

local recent_ns = api.nvim_create_namespace("RecentFilesHighlight")

local recentfiles = create_qf_picker({
    name = "recentfiles",
    defaults = {
        title = "Recent files",
        keymap = "<leader>r",
        desc = "Open recent files",
        exclude_current = true,
        empty_message = "No recent files found",
    },

    collect = function(o)
        local items, seen, cur = {}, {}, api.nvim_buf_get_name(0)
        for _, p in ipairs(vim.v.oldfiles or {}) do
            if p ~= "" and fn.filereadable(p) == 1 and not seen[p] and not (o.exclude_current and p == cur) then
                seen[p], items[#items + 1] = true, { filename = p, text = p }
            end
        end
        return items
    end,

    format_item = function(item)
        local f, d = filedir(item.filename or item.text or "")
        return ("%-25s %s"):format(f, d)
    end,

    decorate_qf = function(buf) hl_split_cols(buf, recent_ns) end,
})
recentfiles.setup()

-- =========================================================
-- !!! modules/buffers
-- =========================================================

local buffers_ns = api.nvim_create_namespace("OpenBuffersHighlight")

local buffers = create_qf_picker({
    name = "buffers",
    defaults = {
        title = "Open buffers",
        keymap = "<leader>b",
        desc = "Open buffers",
        exclude_current = true,
        empty_message = "No open buffers found",
    },

    collect = function(o)
        local items, cur = {}, api.nvim_get_current_buf(); local listed = fn.getbufinfo({ buflisted = 1 })
        table.sort(listed, function(a, b) return (a.lastused or 0) > (b.lastused or 0) end)
        for _, bi in ipairs(listed) do
            local name, bt = bi.name or "", vim.bo[bi.bufnr].buftype
            if name ~= "" and bt == "" and not (o.exclude_current and bi.bufnr == cur) then
                items[#items + 1] = { bufnr = bi.bufnr }
            end
        end
        return items
    end,

    format_item = function(item)
        local f, d = filedir(item.bufnr > 0 and api.nvim_buf_get_name(item.bufnr) or item.text or "")
        return ("%-25s %s"):format(f, d)
    end,

    decorate_qf = function(buf) hl_split_cols(buf, buffers_ns) end,
})
buffers.setup()

-- =========================================================
-- !!! modules/grep
-- =========================================================

vim.opt.grepprg = "rg --vimgrep -uu"; local grep_picker = {}

local defaults = {
    title = "Grep Results",
    open_cmd = "copen",
    qf_mappings = true,
    keymap = "<leader>g",
    desc = "Run grep and open results in qf",
    notify = false,
    prompt = "Grep > ",
}
grep_picker.config = vim.deepcopy(defaults)

local function map(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, opts) end
local function get_opts(opts) return vim.tbl_deep_extend("force", {}, grep_picker.config, opts or {}) end
local function get_qf_items() return vim.fn.getqflist({ id = 0, items = 1 }).items or {} end
local function normalize_path(path) return vim.fn.fnamemodify(path or "", ":~:.") end

function grep_picker.quickfix_text(info)
    local qf_items = vim.fn.getqflist({ id = info.id, items = 1 }).items or {}; local lines = {}

    for i = info.start_idx, info.end_idx do
        local item = qf_items[i]
        if item then
            local name = ""

            if item.bufnr and item.bufnr > 0 then
                name = vim.api.nvim_buf_get_name(item.bufnr)
            elseif item.filename then
                name = item.filename
            end
            local path = normalize_path(name ~= "" and name or ""); local lnum = item.lnum or 0
            local col = item.col or 0; local text = vim.trim(item.text or "")

            lines[#lines + 1] = string.format("%s:%d:%d: %s", path, lnum, col, text)
        end
    end
    return lines
end

local function jump_to_qf_item()
    local item = get_qf_items()[vim.fn.line(".")]
    if not item then
        return
    end

    local target_buf = item.bufnr; local target_file = item.filename
    local lnum = math.max(item.lnum or 1, 1); local col = math.max(item.col or 1, 1)
    cmd("cclose")
    if target_buf and target_buf > 0 and vim.api.nvim_buf_is_valid(target_buf) then
        vim.api.nvim_set_current_buf(target_buf)
    elseif target_file and target_file ~= "" then
        cmd.edit(vim.fn.fnameescape(target_file))
        target_buf = vim.api.nvim_get_current_buf()
    else
        return
    end
    local line_count = vim.api.nvim_buf_line_count(0)
    lnum = math.min(lnum, line_count)
    local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
    col = math.min(col, math.max(#line, 1))
    vim.api.nvim_win_set_cursor(0, { lnum, math.max(col - 1, 0) })
    cmd("normal! zv")
end

local function has_results()
    local items = get_qf_items()
    return not vim.tbl_isempty(items)
end

function grep_picker.run(query, opts)
    opts = get_opts(opts)

    if not query or vim.trim(query) == "" then
        if opts.notify then
            vim.notify("Grep cancelled", vim.log.levels.INFO)
        end
        return
    end
    _G.grep_picker_quickfix_text = grep_picker.quickfix_text
    cmd("silent grep! " .. vim.fn.fnameescape(query))
    if not has_results() then
        if opts.notify then
            vim.notify("No grep results found", vim.log.levels.INFO)
        end
        return
    end

    vim.fn.setqflist({}, "a", {
        title = opts.title,
        quickfixtextfunc = "v:lua.grep_picker_quickfix_text",
    })
    cmd(opts.open_cmd)
end

function grep_picker.prompt(opts)
    opts = get_opts(opts)
    vim.ui.input({
        prompt = opts.prompt,
    }, function(input)
        if input == nil or vim.trim(input) == "" then
            if opts.notify then
                vim.notify("Grep cancelled", vim.log.levels.INFO)
            end
            return
        end

        grep_picker.run(input, opts)
    end)
end

function grep_picker.setup(opts)
    grep_picker.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
    if grep_picker.config.keymap then
        map("n", grep_picker.config.keymap, function()
            grep_picker.prompt()
        end, { desc = grep_picker.config.desc })
    end

    if grep_picker.config.qf_mappings then
        local group = vim.api.nvim_create_augroup("GrepQuickfix", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "qf",
            callback = function(args)
                local qf_info = vim.fn.getqflist({ id = 0, title = 1, items = 0 })
                if qf_info.title ~= grep_picker.config.title then
                    return
                end
                vim.bo[args.buf].buflisted = false

                map("n", "q", "<cmd>cclose<cr>", {
                    buffer = args.buf,
                    silent = true,
                    desc = "Close grep results",
                })

                map("n", "<CR>", jump_to_qf_item, {
                    buffer = args.buf,
                    silent = true,
                    desc = "Open grep result and close list",
                })
            end,
        })
    end
end

grep_picker.setup()

-- =========================================================
-- !!! modules/snippets
-- =========================================================

local snippets = {}
---@param defs table<string, string>  -- trigger -> snippet body
---@param opts? { modes?: string|string[], key?: string, match?: fun(before: string, trigger: string): boolean }
function snippets.setup(defs, opts)
    opts = opts or {}

    local modes = opts.modes or "i"; local key = opts.key or "<C-x>"
    local match = opts.match or function(before, trigger)
        return before:sub(- #trigger) == trigger
    end
    local triggers = vim.tbl_keys(defs)
    table.sort(triggers, function(a, b)
        return #a > #b
    end)

    map(modes, key, function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line(); local before = line:sub(1, col)
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

snippets.setup({ -- snippets (expand with c-x)
    issue = "*brakoll - d: $0, p: 0, t: feature, s: open",
})

-- =========================================================
-- !!! modules/undotree
-- =========================================================

cmd("packadd nvim.undotree")
map("n", "<leader>u", function()
    require("undotree").open({
        command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
    })
end, { desc = "Undotree toggle" })

-- =========================================================
-- !!! modules/lsp_attach
-- =========================================================

autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            print("LSP attached: " .. client.name)
        end
    end,
    desc = "notify at LSP client attach",
})

-- =========================================================
-- !!! modules/tabline
-- =========================================================

local function center_text(text, width)
    local text_width = vim.fn.strdisplaywidth(text)
    local total_pad = width - text_width; local left = math.floor(total_pad / 2)
    local right = total_pad - left
    return string.rep(" ", left) .. text .. string.rep(" ", right)
end

vim.o.showtabline = 2

function _G.my_tabline()
    local current = vim.api.nvim_get_current_buf(); local buffers = {}

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted then
            local name = vim.api.nvim_buf_get_name(bufnr)
            if name == "" then
                name = "[No Name]"
            else
                name = vim.fn.fnamemodify(name, ":t")
            end
            table.insert(buffers, { bufnr = bufnr, name = name })
        end
    end

    local total_width = vim.o.columns
    local count = #buffers
    if count == 0 then
        local s = "%#TabLineFill#"
        s = s .. string.rep(" ", math.max(0, total_width))
        s = s .. "%="
        return s
    end

    local sep = ""; local sep_width = vim.fn.strdisplaywidth(sep); local total_sep_width = math.max(0, count - 1) *
        sep_width
    local content_width = math.max(1, total_width - total_sep_width); local base_width = math.floor(content_width / count)
    local remainder = content_width % count

    local s = ""
    for i, buf in ipairs(buffers) do
        if i > 1 then
            s = s .. "%#TabLineSep#" .. sep
        end
        local cell_width = base_width
        if i <= remainder then
            cell_width = cell_width + 1
        end
        if buf.bufnr == current then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#TabLine#"
        end

        s = s .. center_text(buf.name, math.max(cell_width, 1))
    end
    s = s .. "%#TabLineFill#%="
    return s
end

vim.o.tabline = "%!v:lua.my_tabline()"

local function update_tabline_visibility()
    local count = 0
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted then
            count = count + 1
            if count > 1 then break end
        end
    end
    vim.o.showtabline = (count > 1) and 2 or 0
end

vim.api.nvim_create_autocmd({
    "BufAdd",
    "BufDelete",
    "BufEnter",
}, {
    callback = update_tabline_visibility,
})
