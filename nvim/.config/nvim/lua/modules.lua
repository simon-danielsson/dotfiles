local M = {}

function M.setup()
    -- biscuits ---------------------------------------------------------------

    local biscuits = {}; local ns = vim.api.nvim_create_namespace("native_biscuits")
    local config = {
        enabled = true,
        cursor_line_only = true,
        prefix = "",
        hl = "Biscuit",
        max_length = 60,
        max_scan = 300,
    }
    vim.api.nvim_set_hl(0, "Biscuit", { fg = "#524E6A", bg = "#1F1D2E" })

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
        if #s > config.max_length then return s:sub(1, config.max_length) .. "…" end
        return s
    end

    local function clear(bufnr) vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1) end

    local function classify_closer(s)
        s = trim(s)
        if s:match("^end[%s;,%)}%]]*$") then return "lua_end" end
        if s:match("^[}]") then return "brace" end
        if s:match("^[)]") then return "paren" end
        if s:match("^[]]") then return "bracket" end
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
        local n = 0; local i = 1
        while i <= #s do
            if s:sub(i, i) == ch then n = n + 1 end
            i = i + 1
        end
        return n
    end

    local function find_lua_opener(bufnr, row)
        local depth = 0; local start = math.max(0, row - config.max_scan)

        for r = row, start, -1 do
            local l = line(bufnr, r)
            if is_lua_closer(l) then depth = depth + 1 end
            if is_lua_opener(l) then
                depth = depth - 1
                if depth == 0 then return shorten(l) end
            end
        end
        return nil
    end

    local function find_pair_opener(bufnr, row, open_ch, close_ch)
        local depth = 0; local start = math.max(0, row - config.max_scan)
        for r = row, start, -1 do
            local l = line(bufnr, r)
            depth = depth + count_char(l, close_ch); depth = depth - count_char(l, open_ch)
            if depth <= 0 and l:find(open_ch, 1, true) then return shorten(l) end
        end
        return nil
    end

    local function find_biscuit_text(bufnr, row)
        local cur = line(bufnr, row); local kind = classify_closer(cur)
        if not kind then return nil end
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
        local bufnr = vim.api.nvim_win_get_buf(winid); clear(bufnr)

        local top = vim.fn.line("w0", winid) - 1; local bot = vim.fn.line("w$", winid) - 1
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

    function biscuits.refresh() draw_for_window(vim.api.nvim_get_current_win()) end

    function biscuits.setup(opts)
        config = vim.tbl_extend("force", config, opts or {})
        local aug = vim.api.nvim_create_augroup("NativeBiscuits", { clear = true })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter", "TextChanged", "TextChangedI" }, {
            group = aug,
            callback = function() draw_for_window(vim.api.nvim_get_current_win()) end,
        })
        vim.api.nvim_create_user_command("BiscuitsRefresh", function() biscuits.refresh() end, {})
    end

    biscuits.setup()

    -- buffers ----------------------------------------------------------------

    local buflist = {}

    local active_hl = "BufListActive"
    local inactive_hl = "BufListInactive"

    vim.api.nvim_set_hl(0, active_hl, { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, active_hl, { bg = "#1F1D2E" })
    vim.api.nvim_set_hl(0, inactive_hl, { link = "LineNr" })

    local buf, win
    local ns = vim.api.nvim_create_namespace("buflist")

    local function listed_buffers()
        return vim.tbl_filter(function(b)
            return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
        end, vim.api.nvim_list_bufs())
    end

    local function list_width(lines)
        local width = 1

        for _, line in ipairs(lines) do
            width = math.max(width, vim.fn.strdisplaywidth(line))
        end

        return math.min(width, vim.o.columns)
    end

    local function label(b)
        local name = vim.api.nvim_buf_get_name(b)
        return name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
    end

    function buflist.render()
        local buffers = listed_buffers()

        if #buffers <= 1 then
            buflist.close()
            return
        end

        if not (win and vim.api.nvim_win_is_valid(win)) then
            return buflist.open()
        end

        local lines = vim.tbl_map(label, buffers)

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false

        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        for i, b in ipairs(buffers) do
            vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
                line_hl_group = b == vim.api.nvim_get_current_buf()
                    and active_hl
                    or inactive_hl,
            })
        end
    end

    function buflist.close()
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        win = nil
    end

    function buflist.open()
        local buffers = listed_buffers()

        if #buffers <= 1 then
            buflist.close()
            return
        end

        if not (buf and vim.api.nvim_buf_is_valid(buf)) then
            buf = vim.api.nvim_create_buf(false, true)
            vim.bo[buf].buftype = "nofile"
            vim.bo[buf].bufhidden = "hide"
            vim.bo[buf].swapfile = false
            vim.bo[buf].modifiable = false
        end

        local lines = vim.tbl_map(label, buffers)
        local width = list_width(lines)
        local height = math.max(1, math.min(#buffers, vim.o.lines - 4))

        win = vim.api.nvim_open_win(buf, false, {
            relative = "editor",
            anchor = "NE",
            row = 0,
            col = vim.o.columns,
            width = width,
            height = height,
            style = "minimal",
            border = "none",
            focusable = false,
            noautocmd = true,
        })

        vim.wo[win].winhl = "Normal:NormalFloat,FloatBorder:FloatBorder"
        buflist.render()
    end

    function buflist.setup()
        buflist.open()

        vim.api.nvim_create_autocmd({
            "BufAdd",
            "BufDelete",
            "BufEnter",
            "BufFilePost",
            "WinEnter",
            "VimResized",
        }, {
            callback = vim.schedule_wrap(function()
                if win and vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                end
                buflist.open()
            end),
        })
    end

    buflist.setup()
end

return M
