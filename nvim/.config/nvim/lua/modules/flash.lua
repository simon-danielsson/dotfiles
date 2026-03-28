local M = {}

local ns = vim.api.nvim_create_namespace("flash")

local defaults = {
    labels = "ashtfmneoiqdrwlup",
    min_pattern_for_labels = 2,
    case_sensitive = false,
    highlight = {
        match = "Search",
        current = "IncSearch",
        label = "Substitute",
    },
    prompt_hl = "Title",
    note_hl = "Comment",
    prompt = "Flash",
    max_matches = 200,
    jump_on_unique = false,
    scope = "window", -- "window" | "buffer"
    reserve_labels_by_next_char = true,
    show_counts_in_prompt = true,
}

local config = vim.deepcopy(defaults)

local state = {
    active = false,
    winid = nil,
    bufnr = nil,
    pattern = "",
    matches = {},
    reserved = {},
    label_map = {},
    view = nil,
}

local function clear_ns()
    if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
        vim.api.nvim_buf_clear_namespace(state.bufnr, ns, 0, -1)
    end
end

local function reset()
    clear_ns()
    state.active = false
    state.winid = nil
    state.bufnr = nil
    state.pattern = ""
    state.matches = {}
    state.reserved = {}
    state.label_map = {}
    state.view = nil
    pcall(vim.cmd, "redraw")
end

local function is_cancel(ch)
    return ch == vim.keycode("<Esc>") or ch == vim.keycode("<C-c>")
end

local function is_backspace(ch)
    return ch == vim.keycode("<BS>") or ch == vim.keycode("<Del>")
end

local function is_printable(ch)
    return type(ch) == "string" and vim.fn.strchars(ch) == 1
end

local function normalize(s)
    return config.case_sensitive and s or s:lower()
end

local function char_count(s)
    return vim.fn.strchars(s)
end

local function char_sub(s, start_char, len)
    return vim.fn.strcharpart(s, start_char, len)
end

local function drop_last_char(s)
    local n = char_count(s)
    if n <= 0 then
        return ""
    end
    return char_sub(s, 0, n - 1)
end

local function utf8_chars(s)
    local out = {}
    local n = char_count(s)
    for i = 0, n - 1 do
        out[#out + 1] = char_sub(s, i, 1)
    end
    return out
end

local function current_cursor(winid)
    local pos = vim.api.nvim_win_get_cursor(winid)
    return pos[1], pos[2]
end

local function char_at_byte(line, bytepos1)
    if bytepos1 < 1 or bytepos1 > #line then
        return nil
    end
    return line:sub(bytepos1, bytepos1)
end

local function snapshot_view()
    local bufnr = state.bufnr

    local top, bot
    if config.scope == "buffer" then
        top = 1
        bot = vim.api.nvim_buf_line_count(bufnr)
    else
        local winid = state.winid
        top = vim.fn.line("w0", winid)
        bot = vim.fn.line("w$", winid)
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, top - 1, bot, false)
    local normalized = {}

    for i, line in ipairs(lines) do
        normalized[i] = normalize(line)
    end

    state.view = {
        top = top,
        bot = bot,
        lines = lines,
        normalized = normalized,
    }
end

local function collect_matches_full(pattern)
    if pattern == "" or not state.view then
        return {}
    end

    local out = {}
    local curline, curcol = current_cursor(state.winid)
    local needle = normalize(pattern)

    for i, line in ipairs(state.view.lines) do
        local lnum = state.view.top + i - 1
        local hay = state.view.normalized[i]
        local start = 1

        while true do
            local s, e = hay:find(needle, start, true)
            if not s then
                break
            end

            local col0 = s - 1
            if not (lnum == curline and col0 == curcol) then
                out[#out + 1] = {
                    lnum = lnum,
                    row = i,
                    col = col0,
                    end_col = e,
                    next_char = char_at_byte(line, e + 1),
                    label = nil,
                }

                if #out >= config.max_matches then
                    return out
                end
            end

            start = s + 1
        end
    end

    return out
end

local function filter_matches_incremental(matches, pattern)
    if pattern == "" or not state.view then
        return {}
    end

    local out = {}
    local needle = normalize(pattern)
    local needle_len = #needle

    for _, m in ipairs(matches) do
        local hay = state.view.normalized[m.row]
        local s1 = m.col + 1
        local e1 = s1 + needle_len - 1

        if hay:sub(s1, e1) == needle then
            local next_char = char_at_byte(state.view.lines[m.row], e1 + 1)
            out[#out + 1] = {
                lnum = m.lnum,
                row = m.row,
                col = m.col,
                end_col = e1,
                next_char = next_char,
                label = nil,
            }

            if #out >= config.max_matches then
                return out
            end
        end
    end

    return out
end

local function sort_matches(matches)
    local curline, curcol = current_cursor(state.winid)

    table.sort(matches, function(a, b)
        local da = math.abs(a.lnum - curline) * 1000 + math.abs(a.col - curcol)
        local db = math.abs(b.lnum - curline) * 1000 + math.abs(b.col - curcol)

        if da ~= db then
            return da < db
        end
        if a.lnum ~= b.lnum then
            return a.lnum < b.lnum
        end
        return a.col < b.col
    end)
end

local function available_labels(reserved)
    local out = {}
    for _, ch in ipairs(utf8_chars(config.labels)) do
        if not reserved[normalize(ch)] then
            out[#out + 1] = ch
        end
    end
    return out
end

local function compute_reserved(matches, limit)
    local reserved = {}

    if not config.reserve_labels_by_next_char then
        return reserved
    end

    local n = math.min(#matches, limit or #matches)
    for i = 1, n do
        local m = matches[i]
        if m.next_char and is_printable(m.next_char) then
            reserved[normalize(m.next_char)] = true
        end
    end

    return reserved
end

local function assign_labels(matches, reserved)
    local label_map = {}

    for _, m in ipairs(matches) do
        m.label = nil
    end

    if char_count(state.pattern) < config.min_pattern_for_labels then
        return label_map
    end

    local labels = available_labels(reserved)

    if #labels == 0 then
        labels = utf8_chars(config.labels)
    end

    local n = math.min(#matches, #labels)
    for i = 1, n do
        local label = labels[i]
        matches[i].label = label
        label_map[normalize(label)] = matches[i]
    end

    return label_map
end

local function refresh_state(mode)
    if mode == "grow" and #state.matches > 0 then
        state.matches = filter_matches_incremental(state.matches, state.pattern)
    else
        state.matches = collect_matches_full(state.pattern)
    end

    sort_matches(state.matches)

    local label_count = char_count(config.labels)
    state.reserved = compute_reserved(state.matches, label_count)
    state.label_map = assign_labels(state.matches, state.reserved)
end

local function render_prompt()
    local parts = {
        { config.prompt .. " ", config.prompt_hl },
        { state.pattern,        "Normal" },
    }

    if char_count(state.pattern) < config.min_pattern_for_labels then
        parts[#parts + 1] = { "  [type more]", config.note_hl }
    else
        parts[#parts + 1] = { "  [next chars continue, labels jump]", config.note_hl }
    end

    if config.show_counts_in_prompt then
        parts[#parts + 1] = {
            ("  [matches:%d labels:%d]"):format(#state.matches, vim.tbl_count(state.label_map)),
            config.note_hl,
        }
    end

    vim.api.nvim_echo(parts, false, {})
end

local function render()
    clear_ns()

    for i, m in ipairs(state.matches) do
        local opts = {
            end_row = m.lnum - 1,
            end_col = m.end_col,
            hl_group = (i == 1) and config.highlight.current or config.highlight.match,
            priority = 200,
        }

        if m.label then
            opts.virt_text = { { m.label, config.highlight.label } }
            opts.virt_text_pos = "overlay"
            opts.hl_mode = "replace"
        end

        vim.api.nvim_buf_set_extmark(state.bufnr, ns, m.lnum - 1, m.col, opts)
    end

    render_prompt()
    pcall(vim.cmd, "redraw")
end
local function jump_to(match)
    if not match then
        return
    end

    local winid = state.winid
    reset()
    vim.api.nvim_win_set_cursor(winid, { match.lnum, match.col })
end

local function handle_printable(ch)
    local key = normalize(ch)

    if char_count(state.pattern) >= config.min_pattern_for_labels then
        local labeled = state.label_map[key]
        if labeled then
            jump_to(labeled)
            return
        end
    end

    state.pattern = state.pattern .. ch
    refresh_state("grow")

    if config.jump_on_unique and #state.matches == 1 then
        jump_to(state.matches[1])
    end
end

function M.jump()
    reset()

    state.active = true
    state.winid = vim.api.nvim_get_current_win()
    state.bufnr = vim.api.nvim_get_current_buf()
    state.pattern = ""

    snapshot_view()
    render()

    while state.active do
        local ok, ch = pcall(vim.fn.getcharstr)
        if not ok then
            reset()
            return
        end

        if is_cancel(ch) then
            reset()
            return
        elseif is_backspace(ch) then
            local next_pattern = drop_last_char(state.pattern)
            if next_pattern ~= state.pattern then
                state.pattern = next_pattern
                refresh_state("rebuild")
                render()
            end
        elseif is_printable(ch) then
            handle_printable(ch)
            if state.active then
                render()
            end
        end
    end
end

function M.setup(opts)
    config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

    vim.keymap.set({ "n", "x", "o" }, "s", function()
        require("core.plugins.flash").jump()
    end, { desc = "flash-like jump" })
end

return M
