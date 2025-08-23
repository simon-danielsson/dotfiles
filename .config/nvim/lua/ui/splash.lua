-- ======================================================
-- Setup & Imports
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
                icon = "   " .. icons.ui.gear .. " ",
                desc = "[c]onfig",
                key = "c",
                action = "edit ~/dotfiles/.config/nvim/init.lua",
        },
        quit = {
                icon = " " .. icons.ui.quit .. " ",
                desc = "[q]uit",
                key = "q",
                action = "qa!",
        },
})

-- ======================================================
-- Helpers
-- ======================================================

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

-- ======================================================
-- Core render
-- ======================================================

local function set_splash_win_opts(win)
        vim.api.nvim_set_option_value("number", false, { win = win })
        vim.api.nvim_set_option_value("relativenumber", false, { win = win })
        vim.api.nvim_set_option_value("cursorline", false, { win = win })
        vim.api.nvim_set_option_value("wrap", false, { win = win })
        vim.api.nvim_set_option_value("list", false, { win = win })
        vim.api.nvim_set_option_value("fillchars", "", { win = win })
end

local function restore_defaults(win)
        if not vim.api.nvim_win_is_valid(win) then return end
        vim.api.nvim_set_option_value("number", true, { win = win })
        vim.api.nvim_set_option_value("relativenumber", true, { win = win })
        vim.api.nvim_set_option_value("cursorline", true, { win = win })
        vim.api.nvim_set_option_value("wrap", true, { win = win })
        vim.api.nvim_set_option_value("list", true, { win = win })
end

local function render(buf, win)
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
        set_splash_win_opts(win)
end

-- ======================================================
-- Splash buffer
-- ======================================================

local function create_splash()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_current_buf(buf)
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
        vim.api.nvim_buf_set_option(buf, "swapfile", false)
        render(buf, win)
        local opts = { noremap = true, silent = true, buffer = buf }
        vim.keymap.set("n", M.splash_keymaps.quit.key, "<cmd>" .. M.splash_keymaps.quit.action .. "<cr>", opts)
        vim.keymap.set("n", M.splash_keymaps.new.key, "<cmd>" .. M.splash_keymaps.new.action .. "<cr>", opts)
        vim.keymap.set("n", M.splash_keymaps.explore.key, "<cmd>" .. M.splash_keymaps.explore.action .. "<cr>", opts)
        vim.keymap.set("n", M.splash_keymaps.recent.key, "<cmd>" .. M.splash_keymaps.recent.action .. "<cr>", opts)
        vim.keymap.set("n", M.splash_keymaps.config.key, "<cmd>" .. M.splash_keymaps.config.action .. "<cr>", opts)
        vim.api.nvim_create_autocmd("VimResized", {
                callback = function()
                        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win) then
                                render(buf, win)
                        end
                end,
        })
        vim.api.nvim_create_autocmd("BufWinLeave", {
                buffer = buf,
                callback = function()
                        restore_defaults(win)
                end,
        })
        vim.api.nvim_create_autocmd("BufLeave", {
                buffer = buf,
                callback = function()
                        if vim.api.nvim_buf_is_valid(buf) then
                                vim.api.nvim_buf_delete(buf, { force = true })
                        end
                end,
        })
end

-- ======================================================
-- Setup
-- ======================================================

M.setup = function()
        vim.api.nvim_set_hl(0, "SplashVersion", { fg = colors.splash_version })
        vim.api.nvim_set_hl(0, "SplashBanner", { fg = colors.splash_banner })
        vim.api.nvim_set_hl(0, "SplashButton", { fg = colors.splash_buttons })
        vim.api.nvim_create_autocmd("UIEnter", {
                callback = function()
                        if vim.fn.argc() ~= 0 then return end
                        create_splash()
                end,
        })
end

function M.show()
        create_splash()
end

return M
