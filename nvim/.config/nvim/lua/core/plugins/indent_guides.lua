local M = {}

local ns = vim.api.nvim_create_namespace("native_indent_guides")

local defaults = {
    char = "│",
    highlight = "Comment",
    show_first_level = false,
    show_blanklines = true,

    exclude_filetypes = {
        help = true,
        lazy = true,
        mason = true,
        snacks_dashboard = true,
        dashboard = true,
        alpha = true,
        netrw = true,
        Trouble = true,
    },

    exclude_buftypes = {
        terminal = true,
        prompt = true,
        quickfix = true,
        nofile = true,
    },
}

local config = vim.deepcopy(defaults)
local enabled = true

local function is_excluded(bufnr)
    local ft = vim.bo[bufnr].filetype
    local bt = vim.bo[bufnr].buftype
    return config.exclude_filetypes[ft] or config.exclude_buftypes[bt]
end

local function get_shiftwidth(bufnr)
    local sw = vim.bo[bufnr].shiftwidth
    if sw == 0 then
        sw = vim.bo[bufnr].tabstop
    end
    return math.max(sw, 1)
end

local function get_line(bufnr, lnum)
    return vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
end

local function leading_ws_width(line, tabstop)
    local width = 0
    local i = 1

    while i <= #line do
        local ch = line:sub(i, i)
        if ch == " " then
            width = width + 1
        elseif ch == "\t" then
            width = width + (tabstop - (width % tabstop))
        else
            break
        end
        i = i + 1
    end

    return width
end

local function leading_ws_cells(line, tabstop)
    local cells = {}
    local vcol = 0
    local i = 1

    while i <= #line do
        local ch = line:sub(i, i)
        if ch == " " then
            cells[vcol] = true
            vcol = vcol + 1
        elseif ch == "\t" then
            local w = tabstop - (vcol % tabstop)
            for j = 0, w - 1 do
                cells[vcol + j] = true
            end
            vcol = vcol + w
        else
            break
        end
        i = i + 1
    end

    return cells, vcol
end

local function is_blank(line)
    return line == nil or line:match("^%s*$") ~= nil
end

local function get_blankline_indent(bufnr, lnum)
    local tabstop = vim.bo[bufnr].tabstop

    for prev = lnum - 1, 1, -1 do
        local line = get_line(bufnr, prev)
        if line and not is_blank(line) then
            return leading_ws_width(line, tabstop)
        end
    end

    return 0
end

function M.refresh()
    vim.cmd("redraw")
end

function M.enable()
    enabled = true
    M.refresh()
end

function M.disable()
    enabled = false
    M.refresh()
end

function M.toggle()
    enabled = not enabled
    M.refresh()
end

function M.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})

    vim.api.nvim_create_user_command("IndentGuidesEnable", function()
        M.enable()
    end, {})

    vim.api.nvim_create_user_command("IndentGuidesDisable", function()
        M.disable()
    end, {})

    vim.api.nvim_create_user_command("IndentGuidesToggle", function()
        M.toggle()
    end, {})

    vim.api.nvim_set_decoration_provider(ns, {
        on_win = function(_, winid, bufnr)
            if not enabled then
                return false
            end

            if not vim.api.nvim_win_is_valid(winid) then
                return false
            end

            if is_excluded(bufnr) then
                return false
            end

            if vim.wo[winid].diff then
                return false
            end

            if not vim.bo[bufnr].modifiable and vim.bo[bufnr].buftype == "" then
                return false
            end

            return true
        end,

        on_line = function(_, _, bufnr, row)
            if not enabled or is_excluded(bufnr) then
                return
            end

            local lnum = row + 1
            local line = get_line(bufnr, lnum)
            if not line then
                return
            end

            local sw = get_shiftwidth(bufnr)
            local tabstop = vim.bo[bufnr].tabstop
            local start = config.show_first_level and 0 or sw

            local cells, indent_width

            if is_blank(line) then
                if not config.show_blanklines then
                    return
                end
                indent_width = get_blankline_indent(bufnr, lnum)
                cells = {}
                for col = 0, indent_width - 1 do
                    cells[col] = true
                end
            else
                cells, indent_width = leading_ws_cells(line, tabstop)
            end

            if indent_width <= 0 then
                return
            end

            for col = start, indent_width - 1, sw do
                if cells[col] then
                    vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
                        ephemeral = true,
                        virt_text = { { config.char, config.highlight } },
                        virt_text_pos = "overlay",
                        virt_text_win_col = col,
                        hl_mode = "replace",
                        priority = 1,
                    })
                end
            end
        end,
    })
end

return M
