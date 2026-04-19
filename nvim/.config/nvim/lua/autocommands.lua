local M       = {}

local cmd     = vim.cmd
local map     = vim.keymap.set
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

    local run_compile_keymap = "<leader>m"

    local function run_build_or_fallback(build_path, fallback_cmd)
        -- check if build.sh exists
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
                local file = vim.fn.expand("%"); local outfile = vim.fn.expand("%:r") -- same name, no extension
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
                local file = vim.fn.expand("%"); local outfile = vim.fn.expand("%:r")
                local build_path = vim.fn.expand("%:p:h") .. "/../build.sh"
                local fallback_cmd = string.format("gcc -std=c23 -Wall -Wextra -O2 \"%s\" -o \"%s\" && ./\"%s\"",
                    file, outfile, outfile)
                run_build_or_fallback(build_path, fallback_cmd)
            end, { buffer = true, desc = "Compile and run C file" })
        end,
    })

    -- Odin
    autocmd("FileType", {
        group = term_group,
        pattern = "odin",
        callback = function()
            map("n", run_compile_keymap, function()
                cmd('write')
                local file = vim.fn.expand("%"); local outfile = vim.fn.expand("%:r")
                local build_path = vim.fn.expand("%:p:h") .. "/../build.sh"
                local fallback_cmd = string.format("echo \"no build.sh was found\"",
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
                cmd("bdelete! " .. term_buf); term_buf, term_win, term_job = nil, nil, nil
            end
        end,
        desc = "Close terminal buffer on process exit",
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
