local M = {}
M.pairs = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
}

M.quotes = {
    ["'"] = true,
    ['"'] = true,
    ["`"] = true,
}

local function getline()
    return vim.fn.getline(".")
end

local function col()
    return vim.fn.col(".")
end

local function get_char_at(pos)
    local line = getline()
    return line:sub(pos, pos)
end

local function is_word_char(c)
    return c:match("[%w_]")
end

local function is_escaped(pos)
    local line = getline()
    local count = 0
    pos = pos - 1
    while pos > 0 and line:sub(pos, pos) == "\\" do
        count = count + 1
        pos = pos - 1
    end
    return count % 2 == 1
end

local function has_unmatched_closer(open, close)
    local line = getline()
    local c = col()
    local balance = 0

    for i = c, #line do
        local ch = line:sub(i, i)
        if ch == open then
            balance = balance + 1
        elseif ch == close then
            if balance == 0 then
                return true
            end
            balance = balance - 1
        end
    end

    return false
end

function M.open(char)
    local c = col()
    local prev = get_char_at(c - 1)
    local next = get_char_at(c)

    if M.quotes[char] then
        if is_escaped(c) then
            return char
        end

        if is_word_char(prev) or is_word_char(next) then
            return char
        end

        if next == char then
            return "<Right>"
        end

        return char .. char .. "<Left>"
    end

    local close = M.pairs[char]
    if not close then
        return char
    end

    if has_unmatched_closer(char, close) then
        return char
    end

    return char .. close .. "<Left>"
end

function M.close(char)
    local next = get_char_at(col())
    if next == char then
        return "<Right>"
    end
    return char
end

function M.backspace()
    local c = col()
    local prev = get_char_at(c - 1)
    local next = get_char_at(c)

    if M.pairs[prev] == next or (M.quotes[prev] and prev == next) then
        return "<BS><Del>"
    end

    return "<BS>"
end

function M.newline()
    local c = col()
    local prev = get_char_at(c - 1)
    local next = get_char_at(c)

    if M.pairs[prev] == next then
        return "<CR><Esc>O"
    end

    return "<CR>"
end

function M.setup()
    local expr = { expr = true, noremap = true }

    for o, c in pairs(M.pairs) do
        vim.keymap.set("i", o, function() return M.open(o) end, expr)
        vim.keymap.set("i", c, function() return M.close(c) end, expr)
    end

    for q, _ in pairs(M.quotes) do
        vim.keymap.set("i", q, function() return M.open(q) end, expr)
    end

    vim.keymap.set("i", "<BS>", M.backspace, expr)
    vim.keymap.set("i", "<CR>", M.newline, expr)
end

return M
