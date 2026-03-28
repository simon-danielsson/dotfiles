local M = {}

local ns = vim.api.nvim_create_namespace("hexbg")
local group_cache = {}

local PATTERNS = {
    "#%x%x%x%x%x%x%f[^%x]", -- #RRGGBB, only if not followed by another hex char
    "#%x%x%x%f[^%x]",     -- #RGB, only if not followed by another hex char
}

local function normalize_hex(hex)
    hex = hex:upper()

    if #hex == 4 then
        local r = hex:sub(2, 2)
        local g = hex:sub(3, 3)
        local b = hex:sub(4, 4)
        return ("#%s%s%s%s%s%s"):format(r, r, g, g, b, b)
    end

    return hex
end

local function luminance(hex)
    hex = normalize_hex(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    return 0.299 * r + 0.587 * g + 0.114 * b
end

local function highlight_group_for(hex)
    hex = normalize_hex(hex)

    if group_cache[hex] then
        return group_cache[hex]
    end

    local name = "HexBg_" .. hex:sub(2)
    local fg = luminance(hex) > 186 and "#000000" or "#FFFFFF"

    vim.api.nvim_set_hl(0, name, {
        fg = fg,
        bg = hex,
    })

    group_cache[hex] = name
    return name
end

local function add_matches_for_line(bufnr, lnum, line)
    for _, pat in ipairs(PATTERNS) do
        local start = 1

        while true do
            local s, e = line:find(pat, start)
            if not s then
                break
            end

            local hex = line:sub(s, e)
            local hl = highlight_group_for(hex)

            -- start_col is 0-based, end_col is exclusive
            vim.api.nvim_buf_add_highlight(bufnr, ns, hl, lnum, s - 1, e)

            start = e + 1
        end
    end
end

function M.refresh(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_count, false)

    for i, line in ipairs(lines) do
        add_matches_for_line(bufnr, i - 1, line)
    end
end

function M.setup()
    local augroup = vim.api.nvim_create_augroup("HexBg", { clear = true })

    vim.api.nvim_create_autocmd({
        "BufEnter",
        "TextChanged",
        "TextChangedI",
        "InsertLeave",
    }, {
        group = augroup,
        callback = function(args)
            vim.schedule(function()
                M.refresh(args.buf)
            end)
        end,
    })

    vim.schedule(function()
        M.refresh()
    end)
end

return M
