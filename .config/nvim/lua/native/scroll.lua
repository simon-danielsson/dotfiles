-- Always centered cursorline in Neovim
-- (even at top/bottom of buffer)

-- number of virtual blank lines to pad at top/bottom
local PADDING = 999

-- function to add padding when opening a buffer
local function add_padding(bufnr)
        -- don’t modify special buffers (help, NvimTree, quickfix, etc.)
        if vim.bo[bufnr].buftype ~= "" then
                return
        end

        -- create padding lines if not already added
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        if line_count < PADDING * 2 then
                local pad = {}
                for _ = 1, PADDING do
                        table.insert(pad, "")
                end
                -- add padding at top
                vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, pad)
                -- add padding at bottom
                vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, pad)
                -- mark buffer as unmodified
                vim.bo[bufnr].modified = false
        end
end

-- autocommand: add padding whenever a file is read
vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function(args)
                add_padding(args.buf)
                vim.opt_local.scrolloff = PADDING -- keep cursor always centered
        end,
})

-- autocommand: strip padding before saving
vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
                local bufnr = args.buf
                local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

                -- remove top/bottom padding
                while lines[1] == "" do
                        table.remove(lines, 1)
                end
                while lines[#lines] == "" do
                        table.remove(lines, #lines)
                end

                -- write cleaned content back
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        end,
})
