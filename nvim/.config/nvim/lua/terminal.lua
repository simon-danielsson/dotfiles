local M = {}

local cmd = vim.cmd
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

-- keymaps
local k_build = "<leader>c"
local k_open_term = "T"

-- parameters
local TERM_SIZE = "botright 15split"

function M.setup()
    local term_cmd = ":" .. TERM_SIZE .. " | terminal<cr>i"
    map('n', k_open_term, term_cmd, { desc = "Open terminal", noremap = true })

    local function find_runnable(start_path)
        local candidates = { "build.sh", "run", "run.py" }
        local dir = vim.fn.fnamemodify(start_path, ":p:h")
        while dir ~= "/" do
            for _, candidate in ipairs(candidates) do
                local path = dir .. "/" .. candidate
                if vim.fn.filereadable(path) == 1 then
                    return path
                end
            end

            local entries = vim.fn.readdir(dir)
            for _, entry in ipairs(entries) do
                -- if a file with "git" in its name is found
                -- the current folder is presumed to be root
                if entry:find("git") then
                    return nil
                end
            end

            local parent = vim.fn.fnamemodify(dir, ":h")
            if parent == dir then
                break
            end
            dir = parent
        end

        return nil
    end

    map('n', k_build, function()
        cmd("wa")

        local filename = vim.api.nvim_buf_get_name(0)
        local runnable = find_runnable(filename)
        if not runnable then
            -- try running the file as a standalone script if no build script was found
            if vim.fn.filereadable(filename) == 0 then
                vim.notify("No build script found and current file does not exist", vim.log.levels.WARN)
                return
            end
            runnable = filename
        end

        cmd(TERM_SIZE .. " | terminal bash -c '" .. vim.fn.shellescape(runnable) .. "; exec bash'")
        cmd("startinsert")
    end, { desc = "Run build", noremap = true })

    autocmd("TermClose", {
        callback = function(args)
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(args.buf) then
                    vim.api.nvim_buf_delete(args.buf, { force = true })
                end
            end)
        end,
    })
end

return M
