local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ==== Templates ====

local template_dir = vim.fn.stdpath("config") .. "/templates"

vim.api.nvim_create_autocmd("BufNewFile", {
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

-- ==== Write ====

local write_group = augroup("WriteCommands", { clear = true })

_G.autosave_counter = 0
autocmd("ModeChanged", {
        group = write_group,
        pattern = "*:n",
        callback = function()
                _G.autosave_counter = _G.autosave_counter + 1
                if _G.autosave_counter >= 8 then
                        _G.autosave_counter = 0
                        vim.cmd("silent! write")
                end
        end,
        desc = "Autosave every 8th time normal mode is entered",
})

vim.api.nvim_create_autocmd("BufWritePre", {
        group = write_group,
        pattern = "*",
        callback = function()
                local ft = vim.bo.filetype
                local ignore = {
                        ["markdown"] = true,
                        ["make"]     = true,
                        ["text"]     = true,
                        ["typ"]      = true,
                        ["toml"]     = true,
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

vim.api.nvim_create_autocmd("BufWritePre", {
        group = write_group,
        pattern = "*",
        callback = function()
                local ft = vim.bo.filetype
                local ext = vim.fn.expand("%:e")
                if ft == "markdown" or ft == "yaml" or ext == "RPP" or ext:lower() == "csv" then
                        return
                end
                local pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd([[silent! %s/\s\+$//e]])
                vim.cmd([[silent! %s/\(\n\)\{3,}/\r\r/e]])
                vim.api.nvim_win_set_cursor(0, pos)
        end,
        desc = "Trim trailing whitespace and collapse multiple empty lines safely",
})

vim.api.nvim_create_autocmd("BufWritePost", {
        group = write_group,
        pattern = "*.typ",
        callback = function()
                vim.cmd("LspTinymistExportPdf")
        end,
        desc = "Export Typst to PDF on write",
})

autocmd("BufWritePost", {
        group = write_group,
        pattern = { "*.sh", "*.desktop" },
        callback = function()
                vim.fn.system({ "chmod", "+x", vim.fn.expand("%:p") })
        end,
        desc = "Make shell scripts and .desktop files executable",
})

-- ==== Directories & Files ====

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

-- ==== Cursor ====

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

local ignore_filetypes = { "TelescopePrompt" }
local function should_ignore()
        return vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
end
autocmd({ "BufEnter", "WinEnter" }, {
        group = cursor_group,
        callback = function()
                if not should_ignore() then
                        vim.opt_local.cursorline = true
                else
                        vim.opt_local.cursorline = false
                end
        end,
        desc = "Highlight cursorline in active window (except Telescope)",
})

autocmd("WinLeave", {
        group = cursor_group,
        callback = function()
                if not should_ignore() then
                        vim.opt_local.cursorline = false
                end
        end,
        desc = "Do not highlight cursorline in inactive windows",
})

autocmd("TextYankPost", {
        group = cursor_group,
        callback = function()
                vim.highlight.on_yank()
        end,
        desc = "Highlight yanked text",
})

-- ==== Terminal ====

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
vim.api.nvim_create_autocmd("FileType", {
        group = term_group,
        pattern = "python",
        callback = function()
                vim.keymap.set("n", "<leader>m", function()
                        vim.cmd('write')
                        local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python3"
                        local file = vim.fn.expand("%")
                        local build_path = vim.fn.expand("%:p:h") .. "/build.sh"
                        local fallback_cmd = python .. " " .. file
                        run_build_or_fallback(build_path, fallback_cmd)
                end, { buffer = true, desc = "Run Python file" })
        end,
})

-- Html
vim.api.nvim_create_autocmd("FileType", {
        group = term_group,
        pattern = "html",
        callback = function()
                vim.keymap.set("n", "<leader>m", function()
                        vim.cmd('write')
                        local file = vim.fn.expand("%")
                        local outfile = vim.fn.expand("%:r") -- same name, no extension
                        local build_path = vim.fn.expand("%:p:h") .. "/build.sh"
                        local fallback_cmd = string.format(
                        "echo \"error whilst launching build script, try launching it from your index.html\"")
                        run_build_or_fallback(build_path, fallback_cmd)
                end, { buffer = true, desc = "Run html (host on local server" })
        end,
})

-- C
vim.api.nvim_create_autocmd("FileType", {
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
vim.api.nvim_create_autocmd("FileType", {
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
vim.api.nvim_create_autocmd("BufEnter", {
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
vim.api.nvim_create_autocmd("TermClose", {
        group = term_group,
        callback = function()
                if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
                        vim.cmd("bdelete! " .. term_buf)
                        term_buf, term_win, term_job = nil, nil, nil
                end
        end,
        desc = "Close terminal buffer on process exit",
})

-- ==== User Interface ====

local ui_group = augroup("UiCommands", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
        group = ui_group,
        callback = function()
                vim.opt.formatoptions:remove { "c", "r", "o" }
        end,
        desc = "Disable new line comment",
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
                vim.opt.relativenumber = false
        end,
        desc = "Disable relative line numbers in insert mode",
})

vim.api.nvim_create_autocmd("InsertLeave", {
        group = ui_group,
        pattern = "*",
        callback = function()
                vim.opt.relativenumber = true
        end,
        desc = "Enable relative line numbers in normal mode",
})
