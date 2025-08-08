-- Diagnostic messages on cursor hold
local skip_diagnostic = false
local diag_timer = nil
local last_line = nil
vim.api.nvim_create_autocmd("CursorMoved", {
        callback = function()
                if diag_timer then
                        diag_timer:stop()
                        diag_timer:close()
                        diag_timer = nil
                end
        end,
})

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
        callback = function()
                if skip_diagnostic then
                        skip_diagnostic = false
                        return
                end
                local bufnr = 0
                local line = vim.api.nvim_win_get_cursor(0)[1] - 1
                last_line = line
                if diag_timer then
                        diag_timer:stop()
                        diag_timer:close()
                end
                diag_timer = vim.loop.new_timer()
                diag_timer:start(2000, 0, vim.schedule_wrap(function()
                        if skip_diagnostic then
                                skip_diagnostic = false
                                return
                        end
                        local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
                        if current_line ~= last_line then return end
                        local diagnostics = vim.diagnostic.get(bufnr, { lnum = current_line })
                        if #diagnostics > 0 then
                                vim.diagnostic.open_float(bufnr, {
                                        focusable = false,
                                        close_events = {"BufLeave", "CursorMoved", "InsertEnter", "FocusLost"},
                                        -- border = "rounded",
                                        source = "always",
                                        prefix = " ",
                                        scope = "line",
                                })
                        end
                end))
        end,
})

vim.keymap.set('n', 'K', function()
        skip_diagnostic = true
        if diag_timer then
                diag_timer:stop()
                diag_timer:close()
                diag_timer = nil
        end
        vim.lsp.buf.hover()
end, { noremap = true, silent = true })
