-- Autosave
_G.autosave_counter = 0
vim.api.nvim_create_autocmd("ModeChanged", {
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
vim.api.nvim_create_autocmd("BufWritePre", {
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
vim.api.nvim_create_autocmd("BufWritePre", {
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

-- Create directory for file if it does not exist
vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
                local dir = vim.fn.expand("%:p:h")
                if vim.fn.isdirectory(dir) == 0 then
                        vim.fn.mkdir(dir, "p")
                end
        end,
})

-- Remove trailing whitespace at ends of lines
vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
                local save_cursor = vim.api.nvim_win_get_cursor(0)
                vim.cmd([[ %s/\s\+$//e ]])
                vim.api.nvim_win_set_cursor(0, save_cursor)
        end,
})

-- Make scripts executable
vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.sh" },
        callback = function()
                vim.fn.system({ "chmod", "+x", vim.fn.expand("%:p") })
        end,
})
