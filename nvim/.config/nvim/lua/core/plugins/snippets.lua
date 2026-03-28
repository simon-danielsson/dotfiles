local M = {}

---@param defs table<string, string>  -- trigger -> snippet body
---@param opts? { modes?: string|string[], key?: string, match?: fun(before: string, trigger: string): boolean }
function M.setup(defs, opts)
    opts = opts or {}

    local modes = opts.modes or "i"
    local key = opts.key or "<C-x>"
    local match = opts.match or function(before, trigger)
        -- default: trigger must be immediately before the cursor
        return before:sub(- #trigger) == trigger
    end

    -- Prefer longer triggers first, so "issue_open" wins over "issue"
    local triggers = vim.tbl_keys(defs)
    table.sort(triggers, function(a, b)
        return #a > #b
    end)

    vim.keymap.set(modes, key, function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        local before = line:sub(1, col)

        for _, trigger in ipairs(triggers) do
            if match(before, trigger) then
                local start_col = col - #trigger

                -- Delete just the trigger text before the cursor.
                -- nvim_buf_set_text() uses 0-based row/col indices.
                vim.api.nvim_buf_set_text(0, row - 1, start_col, row - 1, col, { "" })

                -- Put cursor where the trigger started, then expand snippet.
                vim.api.nvim_win_set_cursor(0, { row, start_col })
                vim.snippet.expand(defs[trigger])
                return
            end
        end

        -- Optional fallback: insert literal <C-x> if no trigger matched
        vim.api.nvim_feedkeys(vim.keycode(key), "n", false)
    end, { desc = "Expand snippet trigger" })
end

return M
