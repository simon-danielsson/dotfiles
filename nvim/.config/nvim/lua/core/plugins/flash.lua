local M = {}

local ns = vim.api.nvim_create_namespace("flash")

local defaults = {
    labels = "asdfghjklqwertyuiopzxcvbnm",
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
}

local config = vim.deepcopy(defaults)

local state = {
    active = false,
    winid = nil,
    bufnr = nil,
    pattern = "",
    matches = {},
    reserved = {},
    label_map = {}, -- visible label -> match
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

local function get_visible_range(winid)
    return vim.fn.line("w0", winid), vim.fn.line("w$", winid)
end

local function get_visible_lines(bufnr, winid)
    local top, bot = get_visible_range(winid)
    local lines = vim.api.nvim_buf_get_lines(bufnr, top - 1, bot, false)
    return top, bot, lines
end

local function current_cursor(winid)
    local pos = vim.api.nvim_win_get_cursor(winid)
    return pos[1], pos[2]
end

local function normalize(s)
    if config.case_sensitive then
        return s
    end
    return s:lower()
end

local function is_word_char(ch)
    return ch ~= nil and ch:match("[%w_]") ~= nil
end

local function char_at_byte(line, bytepos1)
    if bytepos1 < 1 or bytepos1 > #line then
        return nil
    end
    return line:sub(bytepos1, bytepos1)
end

local function is_word_start(line, s1)
    local prev = char_at_byte(line, s1 - 1)
    local cur = char_at_byte(line, s1)
    return is_word_char(cur) and not is_word_char(prev)
end

local function collect_matches(pattern)
    if pattern == "" then
        return {}
    end

    local out = {}
    local bufnr = state.bufnr
    local winid = state.winid
    local top, _, lines = get_visible_lines(bufnr, winid)
    local curline, curcol = current_cursor(winid)

    local needle = normalize(pattern)

    for i, line in ipairs(lines) do
        local lnum = top + i - 1
        local hay = normalize(line)
        local start = 1

        while true do
            local s, e = hay:find(needle, start, true)
            if not s then
                break
            end

            if is_word_start(line, s) then
                local col0 = s - 1
                if not (lnum == curline and col0 == curcol) then
                    local next_char = char_at_byte(line, e + 1)
                    out[#out + 1] = {
                        lnum = lnum,
                        col = col0,
                        end_col = e,
                        next_char = next_char,
                        label = nil,
                    }
                    if #out >= config.max_matches then
                        return out
                    end
                end
            end

            start = s + 1
        end
    end

    return out
end

local function compute_reserved(matches)
    local reserved = {}

    for _, m in ipairs(matches) do
        if m.next_char and is_printable(m.next_char) then
            reserved[normalize(m.next_char)] = true
        end
    end

    return reserved
end

local function available_labels(reserved)
    local out = {}
    for i = 1, #config.labels do
        local ch = config.labels:sub(i, i)
        if not reserved[normalize(ch)] then
            out[#out + 1] = ch
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

local function assign_labels(matches, reserved)
    local label_map = {}

    for _, m in ipairs(matches) do
        m.label = nil
    end

    if vim.fn.strchars(state.pattern) < config.min_pattern_for_labels then
        return label_map
    end

    local labels = available_labels(reserved)
    if #labels == 0 then
        return label_map
    end

    sort_matches(matches)

    local n = math.min(#matches, #labels)
    for i = 1, n do
        local label = labels[i]
        matches[i].label = label
        label_map[normalize(label)] = matches[i]
    end

    return label_map
end

local function refresh_state()
    state.matches = collect_matches(state.pattern)
    state.reserved = compute_reserved(state.matches)
    state.label_map = assign_labels(state.matches, state.reserved)
end

local function render_prompt()
    local parts = {
        { config.prompt .. " ", config.prompt_hl },
        { state.pattern,        "Normal" },
    }

    if vim.fn.strchars(state.pattern) < config.min_pattern_for_labels then
        parts[#parts + 1] = {
            "  [type more]",
            config.note_hl,
        }
    else
        parts[#parts + 1] = {
            "  [next chars continue, labels jump]",
            config.note_hl,
        }
    end

    vim.api.nvim_echo(parts, false, {})
end

local function render()
    clear_ns()

    for i, m in ipairs(state.matches) do
        vim.api.nvim_buf_set_extmark(state.bufnr, ns, m.lnum - 1, m.col, {
            end_row = m.lnum - 1,
            end_col = m.end_col,
            hl_group = (i == 1) and config.highlight.current or config.highlight.match,
            priority = 200,
        })

        if m.label then
            vim.api.nvim_buf_set_extmark(state.bufnr, ns, m.lnum - 1, m.col, {
                virt_text = { { m.label, config.highlight.label } },
                virt_text_pos = "overlay",
                hl_mode = "replace",
                priority = 300,
            })
        end
    end

    render_prompt()
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

    if vim.fn.strchars(state.pattern) >= config.min_pattern_for_labels then
        local labeled = state.label_map[key]
        if labeled then
            jump_to(labeled)
            return
        end
    end

    state.pattern = state.pattern .. ch
    refresh_state()

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
    refresh_state()
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
            if #state.pattern > 0 then
                state.pattern = state.pattern:sub(1, -2)
                refresh_state()
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
    config = vim.tbl_deep_extend("force", config, opts or {})

    vim.keymap.set({ "n", "x", "o" }, "s", function()
        require("core.plugins.flash").jump()
    end, { desc = "Native Flash-like jump" })
end

return M
