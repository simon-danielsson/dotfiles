local icons = require("ui.icons")
local M = {}

local max_width = 60
local max_height = 6

local opts = {
        focusable = false,
        border = icons.border,
        style = "minimal",
}

local hover_buf = nil
local hover_win = nil

local function update_hover()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then return end
        local client = clients[1]
        local params = vim.lsp.util.make_position_params(nil, client.offset_encoding)
        client.request("textDocument/hover", params, function(err, result)
                if err or not result or not result.contents then
                        if hover_win and vim.api.nvim_win_is_valid(hover_win) then
                                vim.api.nvim_win_close(hover_win, true)
                        end
                        return
                end
                local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
                markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
                if vim.tbl_isempty(markdown_lines) then return end
                local width = 0
                for _, line in ipairs(markdown_lines) do
                        width = math.max(width, #line)
                end
                width = math.min(width, max_width)
                local height = math.max(1, math.min(#markdown_lines - 2, max_height))
                if not hover_buf or not vim.api.nvim_buf_is_valid(hover_buf) then
                        hover_buf = vim.api.nvim_create_buf(false, true)
                else
                        vim.api.nvim_buf_set_lines(hover_buf, 0, -1, false, {})
                end
                vim.api.nvim_buf_set_lines(hover_buf, 0, -1, false, markdown_lines)
                vim.api.nvim_buf_set_option(hover_buf, "filetype", vim.bo.filetype)
                local row = vim.o.lines - height - 4
                local col = vim.o.columns - width - 3
                if hover_win and vim.api.nvim_win_is_valid(hover_win) then
                        vim.api.nvim_win_set_buf(hover_win, hover_buf)
                        vim.api.nvim_win_set_config(hover_win, {
                                relative = "editor",
                                row = row,
                                col = col,
                                width = width,
                                height = height,
                                style = "minimal",
                                border = icons.border,
                                focusable = false,
                        })
                else
                        hover_win = vim.api.nvim_open_win(hover_buf, false, {
                                relative = "editor",
                                row = row,
                                col = col,
                                width = width,
                                height = height,
                                style = "minimal",
                                border = icons.border,
                                focusable = false,
                        })
                end
                vim.lsp.util.stylize_markdown(hover_buf, markdown_lines, { popup = true })
        end, 0)
end

function M.setup()
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                callback = function()
                        vim.schedule(update_hover)
                end,
        })
end

return M
