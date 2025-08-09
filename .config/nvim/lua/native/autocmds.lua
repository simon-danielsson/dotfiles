local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
autocmd("TextYankPost", {
        group = augroup,
        callback = function()
                vim.highlight.on_yank()
        end,
})

-- Auto-change cwd to current file's folder
autocmd("BufEnter", {
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
        group = augroup,
        callback = function()
                vim.cmd("tabdo wincmd =")
        end,
})

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
