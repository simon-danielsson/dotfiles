local ok_devicons, devicons = pcall(require, "nvim-web-devicons")
local icons = require("ui.icons").trident
local M = {}

M.buffers = {}
M.max_slots = 6
M.win_id = nil

function M.update_buffers()
        local active_buffers = vim.tbl_filter(function(b)
                return vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_option(b, "buflisted")
        end, vim.api.nvim_list_bufs())
        M.buffers = {}
        for i = 1, M.max_slots do
                M.buffers[i] = active_buffers[i] or nil
        end
end

local function format_buf_line(i, buf)
        if not buf then
                return string.format(" %d %s -", i, icons.fallback)
        end
        local name = vim.api.nvim_buf_get_name(buf)
        local display_name
        if name == "" then
                display_name = "[No Name]"
        else
                local parts = vim.split(name, "/")
                if #parts >= 2 then
                        display_name = parts[#parts - 1] .. "/" .. parts[#parts]
                else
                        display_name = parts[#parts]
                end
        end
        local icon, hl_group = "", nil
        if ok_devicons then
                local ext = display_name:match("^.+%.(.+)$") or ""
                icon, hl_group = devicons.get_icon(display_name, ext, { default = true })
                icon = icon or ""
        end
        if hl_group and icon ~= "" then
                return { line = string.format(" %d %s %s", i, icon, display_name), hl = { icon = icon, hl_group = hl_group } }
        else
                return { line = string.format(" %d %s %s", i, icons.fallback, display_name) }
        end
end

function M.show()
        M.update_buffers()
        local lines = {}
        local highlights = {}
        for i, b in ipairs(M.buffers) do
                local formatted = format_buf_line(i, b)
                table.insert(lines, formatted.line)
                if formatted.hl then
                        table.insert(highlights,
                                {
                                        lnum = i - 1,
                                        col = #string.format(" %d %s ", i, icons.fallback),
                                        icon_len = #formatted.hl.icon - 3,
                                        hl_group = formatted.hl.hl_group
                                })
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
        if ok_devicons then
                for _, h in ipairs(highlights) do
                        vim.api.nvim_buf_add_highlight(buf, -1, h.hl_group, h.lnum, h.col - 5, h.col + h.icon_len)
                end
        end
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
                title = " " .. icons.main_icon .. " ",
                title_pos = "center",
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
        end, {
                noremap = true,
                silent = true,
                desc = "Launch Trident",
        })
end

return M
