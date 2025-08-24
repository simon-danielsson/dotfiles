local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ======================================================
-- Write
-- ======================================================
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
                local ignore = { "markdown", "make", "txt", "typ" } -- ignore list for non-Python files
                local ft = vim.bo.filetype

                if vim.tbl_contains(ignore, ft) then
                        return -- skip formatting
                end

                local pos = vim.api.nvim_win_get_cursor(0)
                local clients = vim.lsp.get_clients({ bufnr = 0 })

                if ft == "python" then
                        -- Run Black only for Python files
                        vim.cmd("silent !black %") -- format current buffer
                        vim.cmd("edit")            -- reload the buffer after formatting
                elseif #clients > 0 then
                        -- Other filetypes with LSP: normal LSP formatting
                        vim.lsp.buf.format({ async = false })
                else
                        -- Fallback: Tree-sitter '=' operator
                        vim.cmd("normal! gg=G")
                end

                -- Restore cursor position
                vim.api.nvim_win_set_cursor(0, pos)
        end,
        desc = "Format buffer on save using LSP/Tree-sitter and Black for Python",
})

vim.api.nvim_create_autocmd("BufWritePre", {
        group = write_group,
        pattern = "*",
        callback = function()
                local pos = vim.api.nvim_win_get_cursor(0)
                -- Remove trailing empty lines at the end of the file
                vim.cmd([[silent! %s/\s\+$//e]])
                -- Collapse multiple consecutive empty lines into a single empty line
                -- without touching indented lines
                vim.cmd([[silent! %s/\(\n\)\{3,}/\r\r/e]])
                vim.api.nvim_win_set_cursor(0, pos)
        end,
        desc = "Trim trailing whitespace and collapse multiple empty lines safely",
})

autocmd("BufWritePre", {
        group = write_group,
        pattern = "*",
        callback = function()
                local save_cursor = vim.api.nvim_win_get_cursor(0)
                vim.cmd([[ %s/\s\+$//e ]])
                vim.api.nvim_win_set_cursor(0, save_cursor)
        end,
        desc = "Remove trailing whitespace at ends of lines on write",
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
        pattern = { "*.sh" },
        callback = function()
                vim.fn.system({ "chmod", "+x", vim.fn.expand("%:p") })
        end,
        desc = "Make shell scripts executable",
})

-- ======================================================
-- Directories & Files
-- ======================================================
local files_group = augroup("FileCommands", { clear = true })

autocmd("BufNewFile", {
        group = files_group,
        command = "silent! 0r "
            .. vim.fn.stdpath("config")
            .. "/templates/template.%:e",
        desc = "If one exists, use a template when opening a new file",
})

autocmd("BufEnter", {
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

-- ======================================================
-- Cursor
-- ======================================================
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

-- ======================================================
-- Terminal
-- ======================================================

local terminal_group = augroup("TerminalCommands", { clear = true })

autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
        group = terminal_group,
        pattern = "term://*",
        callback = function()
                vim.cmd("startinsert")
        end,
        desc = "Auto-enter insert mode when switching to a terminal",
})

autocmd("TermClose", {
        group = terminal_group,
        callback = function()
                vim.cmd("bdelete!")
        end,
        desc = "Close terminal buffer on process exit",
})

-- ======================================================
-- User Interface
-- ======================================================
local ui_group = augroup("UiCommands", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
        group = ui_group,
        callback = function()
                vim.opt.formatoptions:remove { "c", "r", "o" }
        end,
        desc = "Disable new line comment",
})

autocmd({ "BufRead", "BufNewFile" }, {
        group = ui_group,
        pattern = { "*.txt", "*.md", "*.typ" },
        callback = function()
                vim.opt.spell = true
                vim.opt.spelllang = { "en_us" }
        end,
        desc = "Enable spell checking for certain file types",
})

vim.api.nvim_create_autocmd("BufEnter", {
        group = ui_group,
        callback = function()
                vim.cmd([[
                setlocal foldmethod=expr
                setlocal foldexpr=getline(v:lnum)=~'^\\s*$'?0:1
                setlocal foldlevelstart=99
                setlocal foldenable
                ]])
        end,
        desc = "Add folds for paragraphs separated by empty lines",
})

autocmd("VimResized", {
        group = ui_group,
        callback = function()
                vim.cmd("tabdo wincmd =")
        end,
        desc = "Auto-resize splits when window is resized",
})

vim.api.nvim_create_autocmd('BufWinEnter', {
        group = user_autocmds_augroup,
        pattern = { '*.txt' },
        callback = function()
                if vim.o.filetype == 'help' then vim.cmd.wincmd('L') end
        end,
        desc = "Open help window in a vertical split to the right",
})
