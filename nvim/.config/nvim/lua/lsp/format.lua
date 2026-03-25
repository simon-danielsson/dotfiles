vim.api.nvim_create_autocmd("BufWritePre", {
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
