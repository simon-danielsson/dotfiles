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

local closing_to_opening = {}
for open, close in pairs(M.pairs) do
    closing_to_opening[close] = open
end

local function getline()
    return vim.fn.getline(".")
end

local function col()
    return vim.fn.col(".")
end

local function get_char_at(pos)
    if pos < 1 then
        return ""
    end
    local line = getline()
    return line:sub(pos, pos)
end

local function is_word_char(c)
    return c ~= "" and c:match("[%w_]")
end

local function is_escaped(line, pos)
    local count = 0
    pos = pos - 1
    while pos > 0 and line:sub(pos, pos) == "\\" do
        count = count + 1
        pos = pos - 1
    end
    return count % 2 == 1
end

local function can_auto_close_quote(line, pos, quote)
    local prev = line:sub(pos - 1, pos - 1)
    local next = line:sub(pos, pos)

    if is_escaped(line, pos) then
        return false
    end

    if is_word_char(prev) or is_word_char(next) then
        return false
    end

    return true
end

local function build_pair_stack_until(line, stop_pos)
    local stack = {}
    local active_quote = nil

    for i = 1, stop_pos do
        local ch = line:sub(i, i)

        if active_quote then
            if ch == active_quote and not is_escaped(line, i) then
                active_quote = nil
            end
        else
            if M.quotes[ch] and not is_escaped(line, i) then
                active_quote = ch
            elseif M.pairs[ch] then
                stack[#stack + 1] = ch
            elseif closing_to_opening[ch] then
                local expected = closing_to_opening[ch]
                if stack[#stack] == expected then
                    stack[#stack] = nil
                end
            end
        end
    end

    return stack, active_quote
end

local function has_unmatched_closer_ahead(open, close)
    local line = getline()
    local cursor_col = col()

    local stack, active_quote = build_pair_stack_until(line, cursor_col - 1)

    for i = cursor_col, #line do
        local ch = line:sub(i, i)

        if active_quote then
            if ch == active_quote and not is_escaped(line, i) then
                active_quote = nil
            end
        else
            if M.quotes[ch] and not is_escaped(line, i) then
                active_quote = ch
            elseif M.pairs[ch] then
                stack[#stack + 1] = ch
            elseif closing_to_opening[ch] then
                local expected = closing_to_opening[ch]

                if stack[#stack] == expected then
                    stack[#stack] = nil
                else
                    if ch == close and expected == open then
                        return true
                    end
                end
            end
        end
    end

    return false
end

function M.open(char)
    local line = getline()
    local c = col()
    local prev = get_char_at(c - 1)
    local next = get_char_at(c)

    if M.quotes[char] then
        if next == char and not is_escaped(line, c) then
            return "<Right>"
        end

        if not can_auto_close_quote(line, c, char) then
            return char
        end

        return char .. char .. "<Left>"
    end

    local close = M.pairs[char]
    if not close then
        return char
    end

    if has_unmatched_closer_ahead(char, close) then
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
        vim.keymap.set("i", o, function()
            return M.open(o)
        end, expr)

        vim.keymap.set("i", c, function()
            return M.close(c)
        end, expr)
    end

    for q, _ in pairs(M.quotes) do
        vim.keymap.set("i", q, function()
            return M.open(q)
        end, expr)
    end

    vim.keymap.set("i", "<BS>", M.backspace, expr)
    vim.keymap.set("i", "<CR>", M.newline, expr)
end

return M
