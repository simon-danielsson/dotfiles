local M = {}

local surrounds = {
        ["'"] = { "'", "'" },
        ['"'] = { '"', '"' },
        ["("] = { "(", ")" },
        ["["] = { "[", "]" },
        ["{"] = { "{", "}" },
}

local function word_bounds()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.fn.getline(row)
        if #line == 0 then return nil end
        local start_col = col
        while start_col > 0 and line:sub(start_col, start_col):match("[%w_]") do
                start_col = start_col - 1
        end
        start_col = start_col + 1
        local end_col = col
        while end_col <= #line and line:sub(end_col + 1, end_col + 1):match("[%w_]") do
                end_col = end_col + 1
        end
        return row, start_col, row, end_col
end

function M.surround_word(char)
        local pair = surrounds[char]
        if not pair then
                vim.notify("No surround mapping for " .. char, vim.log.levels.WARN)
                return
        end
        local srow, scol, erow, ecol = word_bounds()
        if not srow then return end
        local line = vim.fn.getline(srow)
        local new_line = line:sub(1, scol - 1) .. pair[1] .. line:sub(scol, ecol) .. pair[2] .. line:sub(ecol + 1)
        vim.fn.setline(srow, new_line)
end

local opts = { noremap = true, silent = true }
for k, _ in pairs(surrounds) do
        vim.keymap.set("n", "=" .. k, function()
                M.surround_word(k)
        end, opts)
end

return M
