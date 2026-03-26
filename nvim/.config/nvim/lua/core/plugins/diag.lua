local M = {}

local defaults = {
    keymap = "<leader>d",
    title = " Diagnostics ",
    width = 0.75,
    height = 0.60,
    border = "rounded",
    message_hl = "Normal",
    meta_hl = "Comment",
    severity_hl = {
        ERROR = "DiagnosticError",
        WARN = "DiagnosticWarn",
        INFO = "DiagnosticInfo",
        HINT = "DiagnosticHint",
    },
    jump = {
        reuse_win = true,
    },
}

M.opts = vim.deepcopy(defaults)

local state = {
    buf = nil,
    win = nil,
    items = {},
}

local namespace = vim.api.nvim_create_namespace("buffer_diagnostics")

local severity_names = {
    [vim.diagnostic.severity.ERROR] = "ERROR",
    [vim.diagnostic.severity.WARN] = "WARN",
    [vim.diagnostic.severity.INFO] = "INFO",
    [vim.diagnostic.severity.HINT] = "HINT",
}

local function normalize_message(msg)
    if type(msg) ~= "string" then
        return ""
    end

    msg = msg:gsub("\r", " ")
    msg = msg:gsub("\n+", " ")
    msg = msg:gsub("%s+", " ")
    return vim.trim(msg)
end

local function severity_name(severity)
    return severity_names[severity] or "UNKNOWN"
end

local function collect_diagnostics()
    local items = {}
    local diagnostics = vim.diagnostic.get(0)

    table.sort(diagnostics, function(a, b)
        if a.lnum ~= b.lnum then
            return a.lnum < b.lnum
        end
        if a.col ~= b.col then
            return a.col < b.col
        end
        return (a.severity or 999) < (b.severity or 999)
    end)

    for _, d in ipairs(diagnostics) do
        local message = normalize_message(d.message)
        local sev = severity_name(d.severity)
        local pos = string.format("%d:%d", (d.lnum or 0) + 1, (d.col or 0) + 1)

        local meta_parts = { pos, sev }

        if d.source and d.source ~= "" then
            table.insert(meta_parts, d.source)
        end

        if d.code and d.code ~= "" then
            table.insert(meta_parts, tostring(d.code))
        end

        table.insert(items, {
            diagnostic = d,
            message = message,
            meta = table.concat(meta_parts, " "),
            severity = sev,
        })
    end

    return items
end

local function close()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end

    state.buf = nil
    state.win = nil
    state.items = {}
end

local function jump_to(item)
    close()

    if not item or not item.diagnostic then
        return
    end

    local d = item.diagnostic

    vim.api.nvim_win_set_buf(0, d.bufnr or 0)
    vim.api.nvim_win_set_cursor(0, { (d.lnum or 0) + 1, d.col or 0 })
    vim.cmd("normal! zz")
end

local function current_index()
    if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
        return nil
    end
    return vim.api.nvim_win_get_cursor(state.win)[1]
end

local function select_current()
    local idx = current_index()
    if not idx then
        return
    end

    local item = state.items[idx]
    if item then
        jump_to(item)
    end
end

local function move_cursor(delta)
    if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
        return
    end

    local row = vim.api.nvim_win_get_cursor(state.win)[1]
    local count = #state.items
    if count == 0 then
        return
    end

    row = row + delta
    if row < 1 then
        row = count
    elseif row > count then
        row = 1
    end

    vim.api.nvim_win_set_cursor(state.win, { row, 0 })
end

local function calc_size()
    local columns = vim.o.columns
    local lines = vim.o.lines

    local width = M.opts.width
    local height = M.opts.height

    if width > 0 and width < 1 then
        width = math.floor(columns * width)
    end
    if height > 0 and height < 1 then
        height = math.floor(lines * height)
    end

    width = math.max(50, math.min(width, columns - 4))
    height = math.max(8, math.min(height, lines - 4))

    return width, height
end

local function render()
    local lines = {}
    local meta_cols = {}
    local max_message_width = 0

    vim.api.nvim_buf_clear_namespace(state.buf, namespace, 0, -1)

    for _, item in ipairs(state.items) do
        max_message_width = math.max(max_message_width, vim.fn.strdisplaywidth(item.message))
    end

    for i, item in ipairs(state.items) do
        local msg_width = vim.fn.strdisplaywidth(item.message)
        local padding = string.rep(" ", math.max(1, max_message_width - msg_width + 1))
        lines[i] = item.message .. padding .. item.meta
        meta_cols[i] = max_message_width + 1
    end

    vim.bo[state.buf].modifiable = true
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.bo[state.buf].modifiable = false

    for i, item in ipairs(state.items) do
        local line = i - 1
        local meta_col = meta_cols[i]
        local sev_hl = M.opts.severity_hl[item.severity]

        vim.api.nvim_buf_add_highlight(
            state.buf,
            namespace,
            M.opts.message_hl,
            line,
            0,
            meta_col - 1
        )

        vim.api.nvim_buf_add_highlight(
            state.buf,
            namespace,
            M.opts.meta_hl,
            line,
            meta_col,
            -1
        )

        if sev_hl then
            local _, sev_start = lines[i]:find(item.severity, 1, true)
            if sev_start then
                local start_col = sev_start - 1
                local end_col = start_col + #item.severity
                vim.api.nvim_buf_add_highlight(
                    state.buf,
                    namespace,
                    sev_hl,
                    line,
                    start_col,
                    end_col
                )
            end
        end
    end
end

local function set_keymaps()
    local map = function(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, {
            buffer = state.buf,
            nowait = true,
            silent = true,
        })
    end

    map("q", close)
    map("<Esc>", close)
    map("<CR>", select_current)
    map("j", function() move_cursor(1) end)
    map("k", function() move_cursor(-1) end)
    map("<Down>", function() move_cursor(1) end)
    map("<Up>", function() move_cursor(-1) end)
end

function M.open()
    local items = collect_diagnostics()

    if vim.tbl_isempty(items) then
        vim.notify("No diagnostics in current buffer", vim.log.levels.INFO, {
            title = "diagnostics",
        })
        return
    end

    close()

    state.items = items
    state.buf = vim.api.nvim_create_buf(false, true)

    local width, height = calc_size()
    local win_height = math.min(height, #items)
    local row = math.floor((vim.o.lines - win_height) / 2) - 1
    local col = math.floor((vim.o.columns - width) / 2)

    state.win = vim.api.nvim_open_win(state.buf, true, {
        relative = "editor",
        row = math.max(0, row),
        col = math.max(0, col),
        width = width,
        height = win_height,
        style = "minimal",
        border = M.opts.border,
        title = M.opts.title,
        title_pos = "center",
    })

    vim.bo[state.buf].bufhidden = "wipe"
    vim.bo[state.buf].buftype = "nofile"
    vim.bo[state.buf].swapfile = false
    vim.bo[state.buf].filetype = "buffer_diagnostics"

    vim.wo[state.win].cursorline = true
    vim.wo[state.win].number = false
    vim.wo[state.win].relativenumber = false
    vim.wo[state.win].signcolumn = "no"
    vim.wo[state.win].wrap = false

    render()
    set_keymaps()
    vim.api.nvim_win_set_cursor(state.win, { 1, 0 })
end

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, defaults, opts or {})

    vim.keymap.set("n", M.opts.keymap, function()
        require("core.plugins.diag").open()
    end, {
        desc = "Open buffer diagnostics",
        silent = true,
    })
end

return M
