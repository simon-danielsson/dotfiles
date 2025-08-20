local M = {}

M.buffers = {}
M.max_slots = 6
M.win_id = nil

function M.update_buffers()
        local active_buffers = vim.api.nvim_list_bufs()
        local slots_filled = {}
        for i, b in ipairs(M.buffers) do
                if b and vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_option(b, "buflisted") then
                        slots_filled[i] = b
                else
                        slots_filled[i] = nil
                end
        end
        for _, b in ipairs(active_buffers) do
                if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_option(b, "buflisted") then
                        local already_tracked = false
                        for _, t in pairs(slots_filled) do
                                if t == b then
                                        already_tracked = true
                                        break
                                end
                        end
                        if not already_tracked then
                                for i = 1, M.max_slots do
                                        if not slots_filled[i] then
                                                slots_filled[i] = b
                                                break
                                        end
                                end
                        end
                end
        end
        M.buffers = slots_filled
end

function M.show()
        M.update_buffers()
        local lines = {}
        for i, b in ipairs(M.buffers) do
                if b then
                        local name = vim.api.nvim_buf_get_name(b)
                        if name == "" then
                                name = "[No Name]"
                        else
                                local parts = vim.split(name, "/")
                                if #parts >= 2 then
                                        name = parts[#parts-1] .. "/" .. parts[#parts]
                                else
                                        name = parts[#parts]
                                end
                        end
                        table.insert(lines, string.format(" %d │ %s", i, name))
                else
                        table.insert(lines, string.format(" %d │ -", i))
                end
        end
        local width = 0
        for _, l in ipairs(lines) do
                if #l > width then width = #l end
        end
        width = width + 2
        local height = #lines
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        if M.win_id and vim.api.nvim_win_is_valid(M.win_id) then
                vim.api.nvim_win_close(M.win_id, true)
        end
        M.win_id = vim.api.nvim_open_win(buf, false, {
                relative = "editor",
                width = width,
                height = height,
                row = row,
                col = col,
                style = "minimal",
                border = "rounded",
                focusable = false,
        })
end

function M.jump(slot)
        local buf = M.buffers[slot]
        if buf and vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_set_current_buf(buf)
                if M.win_id and vim.api.nvim_win_is_valid(M.win_id) then
                        vim.api.nvim_win_close(M.win_id, true)
                end
        end
end

function M.setup_keymaps()
        vim.keymap.set("n", '"', function()
                M.show()
                for i = 1, M.max_slots do
                        vim.keymap.set("n", tostring(i), function()
                                M.jump(i)
                        end, { buffer = true, nowait = true })
                end
        end, { noremap = true, silent = true })
end

return M
