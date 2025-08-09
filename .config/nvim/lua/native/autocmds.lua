local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general_group = augroup("GeneralCommands", { clear = true })
local write_group = augroup("WriteCommands", { clear = true })
local terminal_group = augroup("TerminalCommands", { clear = true })

-- ======================================================
-- Write
-- ======================================================

-- Autosave every 8th time normal mode is entered
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
})

-- Fix indents
autocmd("BufWritePre", {
        group = write_group,
        pattern = "*",
        callback = function()
                local ignore = { "markdown", "make", "oil", "txt" }
                if vim.tbl_contains(ignore, vim.bo.filetype) then return end
                local pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd("normal! gg=G")
                vim.api.nvim_win_set_cursor(0, pos)
        end,
})

-- Remove trailing empty lines and collapse multiple empty lines
autocmd("BufWritePre", {
        group = write_group,
        pattern = "*",
        callback = function()
                local pos = vim.api.nvim_win_get_cursor(0)
                if vim.fn.getline(1):match("^%s*$") then
                        vim.api.nvim_buf_set_lines(0, 0, 1, false, {})
                end
                vim.cmd([[%s#\($\n\s*\)\+\%$##e]])
                vim.cmd([[%s/\(\n\s*\)\{2,}/\r\r/e]])
                vim.api.nvim_win_set_cursor(0, pos)
        end,
})

-- Auto create directories before save
autocmd("BufWritePre", {
        group = write_group,
        pattern = "*",
        callback = function()
                local dir = vim.fn.expand("%:p:h")
                if vim.fn.isdirectory(dir) == 0 then
                        vim.fn.mkdir(dir, "p")
                end
        end,
})

-- Remove trailing whitespace at ends of lines
autocmd("BufWritePre", {
        group = write_group,
        pattern = "*",
        callback = function()
                local save_cursor = vim.api.nvim_win_get_cursor(0)
                vim.cmd([[ %s/\s\+$//e ]])
                vim.api.nvim_win_set_cursor(0, save_cursor)
        end,
})

-- Make scripts executable
autocmd("BufWritePost", {
        group = write_group,
        pattern = { "*.sh" },
        callback = function()
                vim.fn.system({ "chmod", "+x", vim.fn.expand("%:p") })
        end,
})

-- ======================================================
-- Cursor
-- ======================================================

-- Restore cursor position
autocmd("BufReadPost", {
        group = cursor_group,
        callback = function()
                local mark = vim.api.nvim_buf_get_mark(0, '"')
                local lcount = vim.api.nvim_buf_line_count(0)
                if mark[1] > 0 and mark[1] <= lcount then
                        pcall(vim.api.nvim_win_set_cursor, 0, mark)
                end
        end,
})

-- Return to last edit position when opening files
autocmd("BufRead", {
        group = cursor_group,
        callback = function()
                local last_pos = vim.fn.line("'\"")
                if last_pos > 0 and last_pos <= vim.fn.line("$") and vim.bo.filetype ~= "commit" then
                        vim.cmd("normal! g'\"")
                end
        end,
})

-- Highlight yanked text
autocmd("TextYankPost", {
        group = cursor_group,
        callback = function()
                vim.highlight.on_yank()
        end,
})

-- ======================================================
-- Terminal
-- ======================================================

-- Auto-enter insert mode when switching to a terminal
autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
        group = terminal_group,
        pattern = "term://*",
        callback = function()
                vim.cmd("startinsert")
        end,
})

-- Close terminal buffer on process exit
autocmd("TermClose", {
        group = terminal_group,
        callback = function()
                vim.cmd("bdelete!")
        end,
})

-- ======================================================
-- General
-- ======================================================

-- Enable spell checking for certain file types
autocmd({ "BufRead", "BufNewFile" }, {
        group = general_group,
        pattern = { "*.txt", "*.md" },
        callback = function()
                vim.opt.spell = true
                vim.opt.spelllang = "en_us"
        end,
})

-- Auto-change cwd to current file's folder
autocmd("BufEnter", {
        group = general_group,
        pattern = "*",
        callback = function()
                local dir = vim.fn.expand("%:p:h")
                if vim.fn.isdirectory(dir) == 1 then
                        vim.cmd("lcd " .. dir)
                end
        end,
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
        group = general_group,
        callback = function()
                vim.cmd("tabdo wincmd =")
        end,
})

-- ======================================================
-- Miscellaneous
-- ======================================================

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
        vim.fn.mkdir(undodir, "p")
end

-- Suppress notify inside Oil buffers
local original_notify = vim.notify
autocmd("FileType", {
        pattern = "oil",
        callback = function()
                vim.notify = function(msg, level, notify_opts)
                        if level == vim.log.levels.ERROR then
                                return
                        end
                        return original_notify(msg, level, notify_opts)
                end
        end,
})
autocmd("BufLeave", {
        callback = function()
                if vim.bo.filetype == "oil" then
                        vim.notify = original_notify
                end
        end,
})
