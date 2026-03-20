local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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
        if ft == "markdown" or ft == "yaml" or ext == "html" or ext == "RPP" or ext == "reamake" or ext:lower() == "csv" then
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
