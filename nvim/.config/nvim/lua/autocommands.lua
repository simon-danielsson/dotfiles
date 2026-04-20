local M       = {}

local cmd     = vim.cmd
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

function M.setup()
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
        callback = function() clear_cmdline_after(4000) end,
        desc = "auto-clear messages after cmdline leave",
    })

    autocmd("VimResized", {
        group = ui_group,
        callback = function() cmd("tabdo wincmd =") end,
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

    local cursor_group = augroup("CursorCommands", { clear = true })

    autocmd("BufReadPost", {
        group = cursor_group,
        callback = function()
            if vim.bo.filetype == "commit" then
                return
            end
            local mark = vim.api.nvim_buf_get_mark(0, '"'); local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
        desc = "Restore cursor location when opening a buffer",
    })

    autocmd("TextYankPost", {
        group = cursor_group,
        callback = function() vim.highlight.on_yank() end,
        desc = "Highlight yanked text",
    })
    local files_group = augroup("FileCommands", { clear = true })

    autocmd("BufReadPost", {
        callback = function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local name = vim.api.nvim_buf_get_name(buf); local bt = vim.bo[buf].buftype
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
            local ft = vim.bo.filetype; local ext = vim.fn.expand("%:e")
            if ft == "markdown" or ft == "yaml" or ext == "html" or ext == "RPP" or ext == "reamake" or ext:lower() == "csv" then
                return
            end
            local pos = vim.api.nvim_win_get_cursor(0)
            cmd([[silent! %s/\s\+$//e]]); cmd([[silent! %s/\(\n\)\{3,}/\r\r/e]])
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
end

return M
