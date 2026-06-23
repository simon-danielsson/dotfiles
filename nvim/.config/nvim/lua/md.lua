-- ~/.config/nvim/lua/render_markdown.lua

local M = {}

local ns = vim.api.nvim_create_namespace("render_markdown")

--------------------------------------------------------------------------------
-- MODES
--------------------------------------------------------------------------------

local SUSPEND_MODES = {
    i = true,
    ic = true,
    ix = true,
    v = true,
    V = true,
    ["\22"] = true,
    s = true,
    S = true,
}

local function suspended()
    return SUSPEND_MODES[vim.api.nvim_get_mode().mode] == true
end

--------------------------------------------------------------------------------
-- BASIC HELPERS
--------------------------------------------------------------------------------

local function is_markdown(bufnr)
    return vim.bo[bufnr].filetype == "markdown"
end

local function should_render(bufnr)
    return is_markdown(bufnr) and not suspended()
end

local function cursor_row(winid)
    return vim.api.nvim_win_get_cursor(winid)[1] - 1
end

local function reveal_line(winid, row)
    return cursor_row(winid) == row
end

local function get_line(bufnr, row)
    return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
end

local function redraw()
    vim.schedule(function()
        pcall(vim.cmd, "redraw")
    end)
end

--------------------------------------------------------------------------------
-- PREFIX PARSER (FIXED CORE)
--------------------------------------------------------------------------------

local function parse_prefix(line)
    local i = 1
    local len = #line

    -- leading whitespace (spaces/tabs)
    while i <= len do
        local c = line:sub(i, i)
        if c == " " or c == "\t" then
            i = i + 1
        else
            break
        end
    end

    local indent_str = line:sub(1, i - 1)
    local col = vim.fn.strdisplaywidth(indent_str)

    -- skip spaces after indent
    local j = i
    while j <= len and line:sub(j, j) == " " do
        j = j + 1
    end

    local marker = line:sub(j, j)
    local next_char = line:sub(j + 1, j + 1)
    local rest = line:sub(j + 1)

    -- list items
    if (marker == "-" or marker == "*" or marker == "+") and next_char == " " then
        return indent_str, col, marker, rest
    end

    -- blockquote
    if marker == ">" and next_char == " " then
        return indent_str, col, marker, rest
    end

    return nil
end

--------------------------------------------------------------------------------
-- EXTMARK HELPERS
--------------------------------------------------------------------------------

local function overlay(bufnr, row, col, text, hl, end_col)
    vim.api.nvim_buf_set_extmark(bufnr, ns, row, col, {
        virt_text = { { text, hl } },
        virt_text_pos = "overlay",
        end_col = end_col,
        priority = 200,
    })
end

--------------------------------------------------------------------------------
-- HEADINGS / RULES (unchanged but safe)
--------------------------------------------------------------------------------

local HEADING_ICONS = {
    "󰎤 ",
    "󰎧 ",
    "󰎪 ",
    "󰎭 ",
    "󰎱 ",
    "󰎳 ",
}

local HEADING_HL = {
    "Title",
    "Function",
    "Keyword",
    "Type",
    "Constant",
    "Comment",
}

local function render_heading(bufnr, row, line)
    local hashes, text = line:match("^(#+)%s+(.*)$")
    if not hashes then return end

    local level = math.min(#hashes, 6)

    overlay(bufnr, row, 0,
        HEADING_ICONS[level] .. text,
        HEADING_HL[level],
        #line
    )
end

local function render_rule(bufnr, row, line)
    local stripped = line:gsub("%s+", "")
    if stripped == "---" or stripped == "***" or stripped == "___" then
        overlay(bufnr, row, 0, string.rep("─", 80), "Comment", #line)
    end
end

--------------------------------------------------------------------------------
-- LIST RENDERERS (FIXED)
--------------------------------------------------------------------------------

local function render_bullet(bufnr, row, line)
    local _, col, marker = parse_prefix(line)
    if not marker then return end

    overlay(bufnr, row, col, "•", "Identifier", col + 1)
end

local function render_quote(bufnr, row, line)
    local _, col, marker = parse_prefix(line)
    if marker ~= ">" then return end

    overlay(bufnr, row, col, "│", "Comment", col + 1)
end

local function render_checkbox(bufnr, row, line)
    local _, col, marker, rest = parse_prefix(line)
    if not marker then return end

    local state = rest:match("^%[([ xX])%]")
    if not state then return end

    local icon = (state:lower() == "x") and "☑" or "☐"

    overlay(bufnr, row, col + 2, icon, "Special", col + 5)
end

--------------------------------------------------------------------------------
-- DISPATCH
--------------------------------------------------------------------------------

local function render_line(winid, bufnr, row)
    if reveal_line(winid, row) then
        return
    end

    local line = get_line(bufnr, row)
    if not line or line == "" then return end

    render_heading(bufnr, row, line)
    render_checkbox(bufnr, row, line)
    render_bullet(bufnr, row, line)
    render_quote(bufnr, row, line)
    render_rule(bufnr, row, line)
end

--------------------------------------------------------------------------------
-- PROVIDER
--------------------------------------------------------------------------------

local provider_installed = false

local function install_provider()
    if provider_installed then return end
    provider_installed = true

    vim.api.nvim_set_decoration_provider(ns, {
        on_win = function(_, winid, bufnr)
            if not should_render(bufnr) then
                return false
            end

            -- IMPORTANT: clear every redraw cycle to avoid stale extmarks
            vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

            return true
        end,

        on_line = function(_, winid, bufnr, row)
            render_line(winid, bufnr, row)
        end,
    })
end

--------------------------------------------------------------------------------
-- AUTOCMDS
--------------------------------------------------------------------------------

local function install_autocmds()
    local group = vim.api.nvim_create_augroup("RenderMarkdown", { clear = true })

    vim.api.nvim_create_autocmd({
        "ModeChanged",
        "CursorMoved",
        "CursorMovedI",
        "BufEnter",
        "WinEnter",
    }, {
        group = group,
        callback = redraw,
    })
end

--------------------------------------------------------------------------------
-- SETUP
--------------------------------------------------------------------------------

function M.setup()
    install_provider()
    install_autocmds()
end

return M
