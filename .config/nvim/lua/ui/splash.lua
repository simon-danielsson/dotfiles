local colors = require("ui.theme").colors
local banner = require("ui.theme").banner

local M = {}

local function disp_width(s)
        return vim.fn.strdisplaywidth(s)
end

local function center_lines(lines, width)
        local out = {}
        for _, line in ipairs(lines) do
                local lw = disp_width(line)
                local pad = math.max(math.floor((width - lw) / 2), 0)
                table.insert(out, string.rep(" ", pad) .. line)
        end
        return out
end

local buttons = {
        " [n]ew",
        "  [f]ind",
        "    [r]ecent",
        " 󰈆 [q]uit",
}

local function build_content()
        local v = vim.version()
        local version_line = string.format("v%d.%d.%d", v.major, v.minor, v.patch)
        local content = { version_line, "" }
        vim.list_extend(content, banner)
        table.insert(content, "")
        vim.list_extend(content, buttons)
        return content
end

local function render(buf)
        local width = vim.o.columns
        local height = vim.o.lines
        local content = build_content()
        local centered = center_lines(content, width)
        local top_padding = math.max(math.floor((height - #centered) / 2), 0)
        local final_content = {}
        for _ = 1, top_padding do
                table.insert(final_content, "")
        end
        vim.list_extend(final_content, centered)
        vim.api.nvim_buf_set_option(buf, "modifiable", true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, final_content)
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_add_highlight(buf, -1, "SplashVersion", top_padding + 0, 0, -1)
        for i = 2, (#banner + 2) do
                vim.api.nvim_buf_add_highlight(buf, -1, "SplashBanner", top_padding + i, 0, -1)
        end
        local button_start = #final_content - #buttons - 2
        for i = button_start + 1, #final_content do
                vim.api.nvim_buf_add_highlight(buf, -1, "SplashButton", i, 0, -1)
        end
end

M.setup = function()
        vim.api.nvim_set_hl(0, "SplashVersion", { fg = colors.splash_version })
        vim.api.nvim_set_hl(0, "SplashBanner", { fg = colors.splash_banner })
        vim.api.nvim_set_hl(0, "SplashButton", { fg = colors.splash_buttons })
        vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                        if vim.fn.argc() ~= 0 then return end
                        local buf = vim.api.nvim_create_buf(false, true)
                        vim.api.nvim_set_current_buf(buf)
                        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
                        vim.api.nvim_buf_set_option(buf, "swapfile", false)
                        local saved_opts = {
                                fillchars = vim.wo.fillchars,
                                list = vim.wo.list,
                                listchars = vim.wo.listchars,
                                cursorline = vim.wo.cursorline,
                                number = vim.wo.number,
                                relativenumber = vim.wo.relativenumber,
                                wrap = vim.wo.wrap,
                        }
                        vim.wo.fillchars = ""
                        vim.wo.list = false
                        vim.wo.listchars = ""
                        vim.wo.cursorline = false
                        vim.wo.number = false
                        vim.wo.relativenumber = false
                        vim.wo.wrap = false
                        render(buf)
                        local opts = { noremap = true, silent = true, buffer = buf }
                        vim.keymap.set("n", "q", "<cmd>qa<cr>", opts)
                        vim.keymap.set("n", "n", "<cmd>enew<cr>", opts)
                        vim.keymap.set("n", "f", "<cmd>Telescope find_files<cr>", opts)
                        vim.keymap.set("n", "r", "<cmd>Telescope oldfiles<cr>", opts)
                        vim.api.nvim_create_autocmd({ "BufLeave", "BufWipeout", "BufUnload" }, {
                                buffer = buf,
                                callback = function()
                                        if vim.api.nvim_buf_is_valid(buf) then
                                                vim.api.nvim_buf_delete(buf, { force = true })
                                                vim.wo.fillchars = saved_opts.fillchars
                                                vim.wo.list = saved_opts.list
                                                vim.wo.listchars = saved_opts.listchars
                                                vim.wo.cursorline = saved_opts.cursorline
                                                vim.wo.number = saved_opts.number
                                                vim.wo.relativenumber = saved_opts.relativenumber
                                                vim.wo.wrap = saved_opts.wrap
                                        end
                                end,
                        })
                        vim.api.nvim_create_autocmd("VimResized", {
                                callback = function()
                                        if vim.api.nvim_buf_is_valid(buf) then
                                                render(buf)
                                        end
                                end,
                        })
                end,
        })
end

return M
