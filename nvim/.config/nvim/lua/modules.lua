local M = {}

function M.setup()
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
