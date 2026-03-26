local M = {}

local defaults = {
    keymap = "<leader>r",
    title = " Recent files ",
    search_title = " Search ",
    cwd_only = false,
    ignore_current = true,
    width = 0.7,
    height = 0.6,
    border = "rounded",
    filename_hl = "Normal",
    parent_hl = "Comment",
    prompt_hl = "Comment",
    search_hl = "Normal",
    no_match_hl = "Comment",
    search_prompt = " ",
}

M.opts = vim.deepcopy(defaults)

local state = {
    buf = nil,
    win = nil,
    prompt_buf = nil,
    prompt_win = nil,
    all_items = {},
    items = {},
    query = "",
}

local namespace = vim.api.nvim_create_namespace("oldfiles")
local prompt_namespace = vim.api.nvim_create_namespace("oldfiles_prompt")

local function normalize(path)
    if type(path) ~= "string" or path == "" then
        return nil
    end

    local expanded = vim.fn.fnamemodify(path, ":p")
    if expanded == "" then
        return nil
    end

    return vim.fs.normalize(expanded)
end

local function file_exists(path)
    return vim.uv.fs_stat(path) ~= nil
end

local function is_current_file(path)
    local current = normalize(vim.api.nvim_buf_get_name(0))
    return current ~= nil and current == path
end

local function in_cwd(path)
    local cwd = normalize(vim.uv.cwd())
    if not cwd then
        return false
    end

    return path == cwd or vim.startswith(path, cwd .. "/")
end

local function split_display_parts(path)
    local filename = vim.fs.basename(path)
    local parent = vim.fs.dirname(path)

    parent = vim.fn.fnamemodify(parent, ":~:.")

    if parent ~= "" and not parent:match("/$") then
        parent = parent .. "/"
    end

    return filename, parent
end

local function collect_oldfiles()
    local seen = {}
    local items = {}

    for _, entry in ipairs(vim.v.oldfiles or {}) do
        local path = normalize(entry)

        if path
            and not seen[path]
            and file_exists(path)
            and (not M.opts.ignore_current or not is_current_file(path))
            and (not M.opts.cwd_only or in_cwd(path))
        then
            seen[path] = true

            local filename, parent = split_display_parts(path)

            table.insert(items, {
                path = path,
                filename = filename,
                parent = parent,
                searchable = string.lower(table.concat({
                    filename,
                    parent,
                    path,
                }, " ")),
            })
        end
    end

    return items
end

local function close()
    if state.prompt_win and vim.api.nvim_win_is_valid(state.prompt_win) then
        vim.api.nvim_win_close(state.prompt_win, true)
    end

    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end

    state.buf = nil
    state.win = nil
    state.prompt_buf = nil
    state.prompt_win = nil
    state.all_items = {}
    state.items = {}
    state.query = ""
end

local function open_file(path)
    close()
    if not path or path == "" then
        return
    end
    vim.cmd.edit(vim.fn.fnameescape(path))
end

local function current_index()
    if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
        return nil
    end

    if #state.items == 0 then
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
        open_file(item.path)
    end
end

local function move_cursor(delta)
    if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
        return
    end

    local count = #state.items
    if count == 0 then
        return
    end

    local row = vim.api.nvim_win_get_cursor(state.win)[1]
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

    width = math.max(40, math.min(width, columns - 4))
    height = math.max(8, math.min(height, lines - 8))

    return width, height
end

local function match_item(item, query)
    if query == "" then
        return true
    end

    return item.searchable:find(query, 1, true) ~= nil
end

local function set_list_cursor_to_first()
    if state.win and vim.api.nvim_win_is_valid(state.win) and #state.items > 0 then
        vim.api.nvim_win_set_cursor(state.win, { 1, 0 })
    end
end

local function apply_filter()
    local query = string.lower(vim.trim(state.query))
    local filtered = {}

    for _, item in ipairs(state.all_items) do
        if match_item(item, query) then
            table.insert(filtered, item)
        end
    end

    state.items = filtered
    set_list_cursor_to_first()
end

local function render_prompt()
    if not (state.prompt_buf and vim.api.nvim_buf_is_valid(state.prompt_buf)) then
        return
    end

    local line = M.opts.search_prompt .. state.query

    local cur_win = vim.api.nvim_get_current_win()
    local in_prompt = state.prompt_win and vim.api.nvim_win_is_valid(state.prompt_win)
        and cur_win == state.prompt_win

    if not in_prompt then
        vim.bo[state.prompt_buf].modifiable = true
        vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, { line })
        vim.bo[state.prompt_buf].modifiable = true
    end

    vim.api.nvim_buf_clear_namespace(state.prompt_buf, prompt_namespace, 0, -1)

    vim.api.nvim_buf_add_highlight(
        state.prompt_buf,
        prompt_namespace,
        M.opts.prompt_hl,
        0,
        0,
        #M.opts.search_prompt
    )

    vim.api.nvim_buf_add_highlight(
        state.prompt_buf,
        prompt_namespace,
        M.opts.search_hl,
        0,
        #M.opts.search_prompt,
        -1
    )

    if state.prompt_win and vim.api.nvim_win_is_valid(state.prompt_win) then
        local col = #M.opts.search_prompt + #state.query
        vim.api.nvim_win_set_cursor(state.prompt_win, { 1, col })
    end
end

local function render_list()
    if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
        return
    end

    local lines = {}
    local max_filename_width = 0

    vim.api.nvim_buf_clear_namespace(state.buf, namespace, 0, -1)

    if #state.items == 0 then
        vim.bo[state.buf].modifiable = true
        vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, { "No matches" })
        vim.bo[state.buf].modifiable = false

        vim.api.nvim_buf_add_highlight(
            state.buf,
            namespace,
            M.opts.no_match_hl,
            0,
            0,
            -1
        )

        return
    end

    for _, item in ipairs(state.items) do
        local width = vim.fn.strdisplaywidth(item.filename)
        if width > max_filename_width then
            max_filename_width = width
        end
    end

    for i, item in ipairs(state.items) do
        local filename_width = vim.fn.strdisplaywidth(item.filename)
        local padding = string.rep(" ", max_filename_width - filename_width + 1)

        if item.parent ~= "" then
            lines[i] = item.filename .. padding .. item.parent
            item._parent_start_col = max_filename_width + 1
        else
            lines[i] = item.filename
            item._parent_start_col = nil
        end
    end

    vim.bo[state.buf].modifiable = true
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.bo[state.buf].modifiable = false

    for i, item in ipairs(state.items) do
        vim.api.nvim_buf_add_highlight(
            state.buf,
            namespace,
            M.opts.filename_hl,
            i - 1,
            0,
            #item.filename
        )

        if item._parent_start_col then
            vim.api.nvim_buf_add_highlight(
                state.buf,
                namespace,
                M.opts.parent_hl,
                i - 1,
                item._parent_start_col,
                -1
            )
        end
    end
end

local function render()
    render_list()
    render_prompt()
end

local function update_query_from_prompt()
    if not (state.prompt_buf and vim.api.nvim_buf_is_valid(state.prompt_buf)) then
        return
    end

    local prompt = M.opts.search_prompt
    local line = vim.api.nvim_buf_get_lines(state.prompt_buf, 0, 1, false)[1] or ""

    if not vim.startswith(line, prompt) then
        local typed = line:gsub("^%s*", "")
        line = prompt .. typed

        vim.bo[state.prompt_buf].modifiable = true
        vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, { line })
        vim.bo[state.prompt_buf].modifiable = true
    end

    state.query = line:sub(#prompt + 1)
    apply_filter()

    render_list()

    if state.prompt_win and vim.api.nvim_win_is_valid(state.prompt_win) then
        vim.api.nvim_win_set_cursor(state.prompt_win, { 1, #prompt + #state.query })
    end

    vim.api.nvim_buf_clear_namespace(state.prompt_buf, prompt_namespace, 0, -1)

    vim.api.nvim_buf_add_highlight(
        state.prompt_buf,
        prompt_namespace,
        M.opts.prompt_hl,
        0,
        0,
        #prompt
    )

    vim.api.nvim_buf_add_highlight(
        state.prompt_buf,
        prompt_namespace,
        M.opts.search_hl,
        0,
        #prompt,
        -1
    )
end

local function prompt_backspace()
    if state.query == "" then
        return
    end

    state.query = state.query:sub(1, -2)

    vim.bo[state.prompt_buf].modifiable = true
    vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, {
        M.opts.search_prompt .. state.query,
    })
    vim.bo[state.prompt_buf].modifiable = true

    apply_filter()
    render()
end

local function focus_prompt()
    if state.prompt_win and vim.api.nvim_win_is_valid(state.prompt_win) then
        vim.api.nvim_set_current_win(state.prompt_win)
        vim.cmd.startinsert()
    end
end

local function focus_list()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_set_current_win(state.win)
    end
end

local function set_list_keymaps()
    local map = function(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { buffer = state.buf, nowait = true, silent = true })
    end

    map("q", close)
    map("<Esc>", close)
    map("<CR>", select_current)
    map("/", focus_prompt)
    map("i", focus_prompt)

    map("j", function()
        move_cursor(1)
    end)

    map("k", function()
        move_cursor(-1)
    end)

    map("<Down>", function()
        move_cursor(1)
    end)

    map("<Up>", function()
        move_cursor(-1)
    end)
end
local function set_prompt_keymaps()
    local nmap = function(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { buffer = state.prompt_buf, nowait = true, silent = true })
    end

    local imap = function(lhs, rhs)
        vim.keymap.set("i", lhs, rhs, { buffer = state.prompt_buf, nowait = true, silent = true })
    end

    nmap("q", close)
    nmap("<Esc>", close)
    nmap("<CR>", select_current)
    nmap("<Down>", function()
        focus_list()
        move_cursor(1)
    end)
    nmap("<Up>", function()
        focus_list()
        move_cursor(-1)
    end)

    imap("<Esc>", function()
        vim.cmd.stopinsert()
        focus_list()
    end)

    imap("<CR>", function()
        vim.cmd.stopinsert()
        select_current()
    end)

    imap("<Down>", function()
        vim.cmd.stopinsert()
        focus_list()
        move_cursor(1)
    end)

    imap("<Up>", function()
        vim.cmd.stopinsert()
        focus_list()
        move_cursor(-1)
    end)
end
local function set_prompt_autocmds()
    local group = vim.api.nvim_create_augroup("OldfilesPrompt" .. state.prompt_buf, { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        buffer = state.prompt_buf,
        callback = function()
            local line = vim.api.nvim_buf_get_lines(state.prompt_buf, 0, 1, false)[1]
            if not line or line == "" then
                vim.bo[state.prompt_buf].modifiable = true
                vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, {
                    M.opts.search_prompt .. state.query,
                })
            end
            render_prompt()
        end,
    })

    vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
        group = group,
        buffer = state.prompt_buf,
        callback = function()
            update_query_from_prompt()
        end,
    })
end
function M.open()
    local items = collect_oldfiles()

    if vim.tbl_isempty(items) then
        vim.notify("No oldfiles found", vim.log.levels.INFO, { title = "oldfiles" })
        return
    end

    close()

    state.all_items = items
    state.items = vim.deepcopy(items)
    state.query = ""

    state.buf = vim.api.nvim_create_buf(false, true)
    state.prompt_buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, {
        M.opts.search_prompt,
    })
    local width, height = calc_size()
    local list_height = math.max(3, height - 3)
    local prompt_height = 1
    local gap = 1
    local total_height = list_height + prompt_height + gap + 2

    local row = math.floor((vim.o.lines - total_height) / 2) - 1
    local col = math.floor((vim.o.columns - width) / 2)

    state.win = vim.api.nvim_open_win(state.buf, false, {
        relative = "editor",
        row = math.max(0, row),
        col = math.max(0, col),
        width = width,
        height = list_height,
        style = "minimal",
        border = M.opts.border,
        title = M.opts.title,
        title_pos = "center",
    })
    vim.api.nvim_set_current_win(state.win)

    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"

    state.prompt_win = vim.api.nvim_open_win(state.prompt_buf, true, {
        relative = "editor",
        row = math.max(0, row) + list_height + gap + 2,
        col = math.max(0, col),
        width = width,
        height = prompt_height,
        style = "minimal",
        border = M.opts.border,
        title = M.opts.search_title,
        title_pos = "center",
    })

    vim.bo[state.prompt_buf].bufhidden = "wipe"
    vim.bo[state.prompt_buf].buftype = "nofile"
    vim.bo[state.prompt_buf].swapfile = false
    vim.bo[state.prompt_buf].filetype = "oldfiles_prompt"
    vim.bo[state.prompt_buf].modifiable = true

    vim.bo[state.prompt_buf].bufhidden = "wipe"
    vim.bo[state.prompt_buf].buftype = "nofile"
    vim.bo[state.prompt_buf].swapfile = false
    vim.bo[state.prompt_buf].filetype = "oldfiles_prompt"

    vim.wo[state.win].cursorline = true
    vim.wo[state.win].number = false
    vim.wo[state.win].relativenumber = false
    vim.wo[state.win].signcolumn = "no"
    vim.wo[state.win].wrap = false

    vim.wo[state.prompt_win].number = false
    vim.wo[state.prompt_win].relativenumber = false
    vim.wo[state.prompt_win].signcolumn = "no"
    vim.wo[state.prompt_win].wrap = false
    vim.wo[state.prompt_win].cursorline = false

    set_list_keymaps()
    set_prompt_keymaps()
    set_prompt_autocmds()
    render()
    set_list_cursor_to_first()
    focus_prompt()
end

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, defaults, opts or {})

    vim.keymap.set("n", M.opts.keymap, function()
        require("core.plugins.recentfiles").open()
    end, {
        desc = "Open recent files",
        silent = true,
    })
end

return M
