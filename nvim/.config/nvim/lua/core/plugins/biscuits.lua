local M = {}

local ns = vim.api.nvim_create_namespace("native_biscuits")

local config = {
    enabled = true,
    cursor_line_only = true,
    prefix = "",
    hl = "BiscuitColor",
    max_length = 60,
    max_scan = 300,
}

local function line(bufnr, row)
    return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
end

local function trim(s)
    return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function squeeze(s)
    return trim((s or ""):gsub("%s+", " "))
end

local function shorten(s)
    s = squeeze(s)
    if #s > config.max_length then
        return s:sub(1, config.max_length) .. "…"
    end
    return s
end

local function clear(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function classify_closer(s)
    s = trim(s)

    if s:match("^end[%s;,%)}%]]*$") then
        return "lua_end"
    end
    if s:match("^[}]") then
        return "brace"
    end
    if s:match("^[)]") then
        return "paren"
    end
    if s:match("^[]]") then
        return "bracket"
    end

    return nil
end

local function is_lua_opener(s)
    s = trim(s)
    return s:match("^function\b")
        or s:match("^local%s+function\b")
        or (s:match("^if\b") and s:match("%f[%a]then%f[%A]"))
        or s:match("^for\b")
        or s:match("^while\b")
        or s:match("^do%s*$")
        or s:match("^repeat\b")
end

local function is_lua_closer(s)
    return trim(s):match("^end[%s;,%)}%]]*$") ~= nil
end

local function count_char(s, ch)
    local n = 0
    local i = 1
    while i <= #s do
        if s:sub(i, i) == ch then
            n = n + 1
        end
        i = i + 1
    end
    return n
end

local function find_lua_opener(bufnr, row)
    local depth = 0
    local start = math.max(0, row - config.max_scan)

    for r = row, start, -1 do
        local l = line(bufnr, r)

        if is_lua_closer(l) then
            depth = depth + 1
        end

        if is_lua_opener(l) then
            depth = depth - 1
            if depth == 0 then
                return shorten(l)
            end
        end
    end

    return nil
end

local function find_pair_opener(bufnr, row, open_ch, close_ch)
    local depth = 0
    local start = math.max(0, row - config.max_scan)

    for r = row, start, -1 do
        local l = line(bufnr, r)
        depth = depth + count_char(l, close_ch)
        depth = depth - count_char(l, open_ch)

        if depth <= 0 and l:find(open_ch, 1, true) then
            return shorten(l)
        end
    end

    return nil
end

local function find_biscuit_text(bufnr, row)
    local cur = line(bufnr, row)
    local kind = classify_closer(cur)
    if not kind then
        return nil
    end

    if kind == "lua_end" then
        return find_lua_opener(bufnr, row)
    elseif kind == "brace" then
        return find_pair_opener(bufnr, row, "{", "}")
    elseif kind == "paren" then
        return find_pair_opener(bufnr, row, "(", ")")
    elseif kind == "bracket" then
        return find_pair_opener(bufnr, row, "[", "]")
    end

    return nil
end

local function draw_for_window(winid)
    if not config.enabled or not vim.api.nvim_win_is_valid(winid) then
        return
    end

    local bufnr = vim.api.nvim_win_get_buf(winid)
    clear(bufnr)

    local top = vim.fn.line("w0", winid) - 1
    local bot = vim.fn.line("w$", winid) - 1
    local cur = vim.api.nvim_win_get_cursor(winid)[1] - 1

    for row = top, bot do
        if (not config.cursor_line_only) or row == cur then
            local txt = find_biscuit_text(bufnr, row)
            if txt and txt ~= "" then
                vim.api.nvim_buf_set_extmark(bufnr, ns, row, #line(bufnr, row), {
                    virt_text = { { config.prefix .. txt, config.hl } },
                    virt_text_pos = "eol",
                    hl_mode = "replace",
                })
            end
        end
    end
end

function M.refresh()
    draw_for_window(vim.api.nvim_get_current_win())
end

function M.setup(opts)
    config = vim.tbl_extend("force", config, opts or {})

    local aug = vim.api.nvim_create_augroup("NativeBiscuits", { clear = true })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter", "TextChanged", "TextChangedI" }, {
        group = aug,
        callback = function()
            draw_for_window(vim.api.nvim_get_current_win())
        end,
    })

    vim.api.nvim_create_user_command("BiscuitsRefresh", function()
        M.refresh()
    end, {})
end

return M
