-- ======================================================
-- Setup
-- ======================================================

local colors = require("ui.theme").colors
local icons = require("ui.icons")
local M = {}

-- ======================================================
-- Settings
-- ======================================================

local banner = {
        "┏┓┳┳┳┓┓┏┳┳┳┓",
        "┗┓┃┃┃┃┃┃┃┃┃┃",
        "┗┛┻┛ ┗┗┛┻┛ ┗",
}

M.splash_keymaps = ({
        new = {
                icon = "" .. icons.ui.file .. " ",
                desc = "[n]ew",
                key = "n",
                action = "enew",
        },
        explore = {
                icon = "  " .. icons.ui.folder .. " ",
                desc = "[f]iles",
                key = "f",
                action = "Ex",
        },
        recent = {
                icon = "   " .. icons.ui.time .. " ",
                desc = "[r]ecent",
                key = "r",
                action = "Telescope oldfiles",
        },
        config = {
                icon = "  " .. icons.ui.gear .. " ",
                desc = "[c]onfig",
                key = "c",
                action = "edit ~/.config/nvim/init.lua",
        },
        quit = {
                icon = " " .. icons.ui.quit .. " ",
                desc = "[q]uit",
                key = "q",
                action = "qa!",
        },
})

-- ======================================================
-- Splash
-- ======================================================

local saved_opts = {
        cursor = vim.opt.guicursor,
        fillchars = vim.wo.fillchars,
        list = vim.wo.list,
        listchars = vim.wo.listchars,
        cursorline = vim.wo.cursorline,
        number = vim.wo.number,
        relativenumber = vim.wo.relativenumber,
        wrap = vim.wo.wrap,
}

function M.plugin_override_opts()
        vim.wo.cursorline = false
        vim.cmd("hi noCursor blend=100 cterm=strikethrough")
        vim.opt.guicursor:append("a:noCursor/lCursor")
        vim.wo.fillchars = nil
        vim.wo.list = false
        vim.wo.listchars = nil
        vim.wo.cursorline = false
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.wrap = false
end

function M.plugin_restore_opts()
        vim.cmd("hi noCursor blend=0 cterm=bold")
        vim.wo.cursorline = saved_opts.cursorline
        vim.opt.guicursor = saved_opts.cursor
        vim.wo.fillchars = saved_opts.fillchars
        vim.wo.list = saved_opts.list
        vim.wo.listchars = saved_opts.listchars
        vim.wo.cursorline = saved_opts.cursorline
        vim.wo.number = true
        vim.wo.relativenumber = true
        vim.wo.wrap = saved_opts.wrap
end

local buttons = {
        M.splash_keymaps.new.icon .. M.splash_keymaps.new.desc,
        M.splash_keymaps.explore.icon .. M.splash_keymaps.explore.desc,
        M.splash_keymaps.recent.icon .. M.splash_keymaps.recent.desc,
        M.splash_keymaps.config.icon .. M.splash_keymaps.config.desc,
        M.splash_keymaps.quit.icon .. M.splash_keymaps.quit.desc,
}

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
        M.plugin_override_opts()
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

local function create_splash()
        M.plugin_override_opts()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_current_buf(buf)
        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
        vim.api.nvim_buf_set_option(buf, "swapfile", false)
        render(buf)
        local opts = { noremap = true, silent = true, buffer = buf }
        vim.keymap.set("n", M.splash_keymaps.quit.key, "<cmd>" .. M.splash_keymaps.quit.action .. "<cr>", opts)
        vim.keymap.set("n", M.splash_keymaps.new.key, "<cmd>" .. M.splash_keymaps.new.action .. "<cr>", opts)
        vim.keymap.set("n", M.splash_keymaps.explore.key, "<cmd>" .. M.splash_keymaps.explore.action .. "<cr>", opts)
        vim.keymap.set("n", M.splash_keymaps.recent.key, "<cmd>" .. M.splash_keymaps.recent.action .. "<cr>", opts)
        vim.keymap.set("n", M.splash_keymaps.config.key, "<cmd>" .. M.splash_keymaps.config.action .. "<cr>", opts)
        vim.api.nvim_create_autocmd({ "BufLeave", "BufWipeout", "BufUnload" }, {
                buffer = buf,
                callback = function()
                        if vim.api.nvim_buf_is_valid(buf) then
                                vim.api.nvim_buf_delete(buf, { force = true })
                                M.plugin_restore_opts()
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
end

M.setup = function()
        M.plugin_override_opts()
        vim.api.nvim_set_hl(0, "SplashVersion", { fg = colors.splash_version })
        vim.api.nvim_set_hl(0, "SplashBanner", { fg = colors.splash_banner })
        vim.api.nvim_set_hl(0, "SplashButton", { fg = colors.splash_buttons })
        vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                        if vim.fn.argc() ~= 0 then return end
                        M.plugin_override_opts()
                        create_splash()
                end,
        })
end

function M.show()
        create_splash()
end

return M
