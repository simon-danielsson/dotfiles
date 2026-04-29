local M = {}

local cmd = vim.cmd
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- keymaps
local run_compile = "<leader>m"
local open_term = "T"

-- constants
local TERM_SIZE = "botright 15split"

function M.setup()
    local term_group = augroup("TermCommands", { clear = true })
    local term_buf = nil
    local term_win = nil
    local term_job = nil

    local function term_buf_valid()
        return term_buf and vim.api.nvim_buf_is_valid(term_buf)
    end

    local function term_win_valid()
        return term_win and vim.api.nvim_win_is_valid(term_win)
    end

    local function create_terminal()
        vim.cmd(TERM_SIZE .. " | terminal")
        term_buf = vim.api.nvim_get_current_buf()
        term_win = vim.api.nvim_get_current_win()
        term_job = vim.b.terminal_job_id
    end

    local function show_terminal()
        if term_win_valid() then
            vim.api.nvim_set_current_win(term_win)
            return
        end

        vim.cmd(TERM_SIZE)
        vim.api.nvim_set_current_buf(term_buf)
        term_win = vim.api.nvim_get_current_win()
    end

    local function ensure_terminal_visible()
        if not term_buf_valid() then
            create_terminal()
        else
            show_terminal()
        end
    end

    local function send_to_terminal(text)
        if term_job then
            vim.fn.chansend(term_job, text .. "\n")
        end
    end

    local function ensure_terminal(command)
        local cwd = vim.fn.expand("%:p:h")

        ensure_terminal_visible()

        if cwd ~= "" then
            send_to_terminal("cd " .. vim.fn.shellescape(cwd))
        end

        if command then
            send_to_terminal(command)
        end

        vim.cmd("startinsert")
    end

    -- search for build.sh/dev in current and parent directories
    -- if no build.sh/dev was found, use fallback command
    local function run_build_or_fallback(fallback_cmd)
        local dir = vim.fn.expand("%:p:h")
        local candidates = { "build.sh", "dev", "run", "cenv" }

        for _ = 1, 4 do
            if not dir or dir == "" then
                break
            end

            for _, filename in ipairs(candidates) do
                local path = dir .. "/" .. filename
                local stat = vim.loop.fs_stat(path)

                if stat and stat.type == "file" then
                    ensure_terminal("clear && bash " .. vim.fn.shellescape(path))
                    return
                end
            end

            local parent = vim.fn.fnamemodify(dir, ":h")
            if parent == dir then
                break
            end
            dir = parent
        end

        ensure_terminal(
            'echo "No build.sh or dev file found, defaulting to regular build command" && ' .. fallback_cmd
        )
    end

    autocmd("FileType", {
        pattern = "*",
        callback = function(args)
            map("n", run_compile, function()
                cmd("write")

                local file = vim.fn.expand("%:p")
                local outfile = vim.fn.expand("%:p:r")

                if args.match == "c" then
                    local fallback_cmd = string.format(
                        'gcc -std=c23 -Wall -Wextra -O2 %s -o %s && %s',
                        vim.fn.shellescape(file),
                        vim.fn.shellescape(outfile),
                        vim.fn.shellescape(outfile)
                    )
                    run_build_or_fallback(fallback_cmd)
                elseif args.match == "python" then
                    local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python3"
                    local fallback_cmd = vim.fn.shellescape(python) .. " " .. vim.fn.shellescape(file)
                    run_build_or_fallback(fallback_cmd)
                elseif args.match == "rust" then
                    run_build_or_fallback("cargo run")
                elseif args.match == "haskell" then
                    vim.lsp.buf.format({ async = true })
                    local fallback_cmd = string.format(
                        "ghc %s && %s",
                        vim.fn.shellescape(file),
                        vim.fn.shellescape(outfile)
                    )
                    run_build_or_fallback(fallback_cmd)
                else
                    run_build_or_fallback('echo "no build.sh was found"')
                end
            end, { buffer = args.buf, desc = "Run file in built-in terminal" })
        end,
    })

    autocmd("BufEnter", {
        group = term_group,
        pattern = "*",
        callback = function(args)
            map("n", open_term, function()
                ensure_terminal()
            end, { buffer = args.buf, noremap = true, silent = true, desc = "Open terminal" })
        end,
        desc = "Open terminal in current buffer",
    })

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
end

return M
