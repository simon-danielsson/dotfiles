local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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
        vim.keymap.set("n", "<leader>m", function()
            vim.cmd('write')
            local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python3.14"
            local file = vim.fn.expand("%")
            local build_path = vim.fn.expand("%:p:h") .. "/build.sh"
            local fallback_cmd = python .. " " .. file
            run_build_or_fallback(build_path, fallback_cmd)
        end, { buffer = true, desc = "Run Python file" })
    end,
})

-- Html
autocmd("FileType", {
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

-- haskell
autocmd("FileType", {
    group = term_group,
    pattern = "haskell",
    callback = function()
        vim.keymap.set("n", "<leader>m", function()
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
autocmd("FileType", {
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
autocmd("BufEnter", {
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
