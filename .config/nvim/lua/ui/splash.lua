-- ======================================================
-- Setup & Imports
-- ======================================================

local colors = require("ui.theme").colors
local icons = require("ui.icons")
local M = {}

-- ======================================================
-- Settings
-- ======================================================

M.splash_keymaps = ({
        new = {
                icon = icons.ui.file,
                desc = "new",
                key = "n",
                action = "enew",
        },
        explore = {
                icon = icons.ui.folder,
                desc = "files",
                key = "f",
                action = "Ex",
        },
        recent = {
                icon = icons.ui.time,
                desc = "recent",
                key = "r",
                action = "Telescope oldfiles",
        },
        quit = {
                icon = icons.ui.quit,
                desc = "quit",
                key = "q",
                action = "qa!",
        },
})

M.banner = {
        "┏┓┳┳┳┓┓┏┳┳┳┓",
        "┗┓┃┃┃┃┃┃┃┃┃┃",
        "┗┛┻┛ ┗┗┛┻┛ ┗",
}

local quotes = {
        "focus", -- English
        "fokus", -- German
        "foco", -- Spanish
        "focus", -- French
        "focus", -- Italian
        "фокус", -- Russian
        "焦点", -- Chinese (Simplified)
        "フォーカス", -- Japanese
        "포커스", -- Korean
        "تركيز", -- Arabic
        "foque", -- Galician
        "enfocar", -- Spanish (verb form)
        "תְּשׂוּמַת לֵב", -- Hebrew
        "foqus", -- Albanian
        "foqueo", -- Spanish (alternate)
        "焦点", -- Chinese (Simplified)
        "專注", -- Chinese (Traditional)
        "フォーカス", -- Japanese
        "포커스", -- Korean
        "ध्यान", -- Hindi
        "توجّه", -- Arabic
        "فوکوس", -- Persian
        "ध्यान", -- Nepali
}

-- ======================================================
-- Splash
-- ======================================================

-- function M.random_banner()
-- math.randomseed(os.time() + os.clock() * 1000000)
-- local banners = { M.banner1, M.banner2, M.banner3 }
-- local chosen_banner = banners[math.random(#banners)]
-- return chosen_banner
-- end
--
-- M.banner = M.random_banner()

M.key_spacing = 0

function M.random_quote()
        math.randomseed(os.time() + os.clock() * 1000000)
        local q = quotes[math.random(#quotes)]
        if type(q) == "table" then
                return table.concat(q, "\n")
        else
                return q
        end
end

local buttons = {
        M.splash_keymaps.new.icon .. M.splash_keymaps.new.desc,
        M.splash_keymaps.explore.icon .. M.splash_keymaps.explore.desc,
        M.splash_keymaps.recent.icon .. M.splash_keymaps.recent.desc,
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

local function build_keymap_lines(banner_width)
        local lines = {}
        local keymap_order = { "new", "explore", "recent", "quit" }
        local max_key_width = 0
        for _, key in ipairs(keymap_order) do
                max_key_width = math.max(max_key_width,
                        disp_width(M.splash_keymaps[key].key))
        end
        for i, key in ipairs(keymap_order) do
                local map = M.splash_keymaps[key]
                local key_text = map.icon .. " " .. map.key
                local desc = map.desc
                local space = banner_width - max_key_width - disp_width(desc) - 2
                space = math.max(space, 1) -- at least 1 space
                local line = key_text .. string.rep(" ", space) .. desc
                table.insert(lines, line)
                if i < #keymap_order then
                        for _ = 1, M.key_spacing do
                                table.insert(lines, "")
                        end
                end
        end
        return lines
end

local function build_content()
        local v = vim.version()
        local quote = M.random_quote()
        local version_line = string.format("v%d.%d.%d", v.major, v.minor, v.patch)
        local content = { version_line, "" }
        vim.list_extend(content, M.banner)
        table.insert(content, "")
        local banner_width = 0
        for _, line in ipairs(M.banner) do
                banner_width = math.max(banner_width, disp_width(line))
        end
        local keymap_lines = build_keymap_lines(banner_width)
        vim.list_extend(content, keymap_lines)
        table.insert(content, "")
        local quote_lines = {}
        for line in quote:gmatch("([^\n]+)") do
                table.insert(content, line)
                table.insert(quote_lines, line)
        end
        return content, #quote_lines
end

-- local saved_guicursor = vim.o.guicursor
-- print(saved_guicursor)
local function set_splash_win_opts(win)
        vim.api.nvim_set_option_value("number", false, { win = win })
        vim.api.nvim_set_option_value("relativenumber", false, { win = win })
        vim.api.nvim_set_option_value("cursorline", false, { win = win })
        vim.api.nvim_set_option_value("wrap", false, { win = win })
        vim.api.nvim_set_option_value("list", false, { win = win })
        vim.api.nvim_set_option_value("fillchars", "", { win = win })
        -- vim.o.guicursor = "a:noCursor/lCursor"
        -- vim.o.guicursor = "a:hor20"
        -- vim.cmd("hi noCursor blend=100 cterm=strikethrough")
        -- vim.api.nvim_set_option_value("guicursor", "a:noCursor/lCursor", { scope = "local" })
end

local function restore_defaults(win)
        if not vim.api.nvim_win_is_valid(win) then return end
        vim.api.nvim_set_option_value("number", true, { win = win })
        vim.api.nvim_set_option_value("relativenumber", true, { win = win })
        vim.api.nvim_set_option_value("cursorline", true, { win = win })
        vim.api.nvim_set_option_value("wrap", true, { win = win })
        vim.api.nvim_set_option_value("list", true, { win = win })
        -- vim.api.nvim_set_option_value("guicursor", saved_guicursor, { scope = "local" })
        -- vim.o.guicursor = saved_guicursor
        -- vim.cmd("hi noCursor blend=0 cterm=bold")
end

local function render(buf, win)
        local width = vim.o.columns
        local height = vim.o.lines
        local content, quote_count = build_content()
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
        vim.api.nvim_buf_add_highlight(buf, -1, "SplashVersion", top_padding, 0, -1)
        for i = 2, (#M.banner + 1) do
                vim.api.nvim_buf_add_highlight(buf, -1, "SplashBanner", top_padding + i, 0, -1)
        end
        local button_start = #final_content - quote_count - #buttons
        for i = button_start - 2, button_start + #buttons do
                vim.api.nvim_buf_add_highlight(buf, -1, "SplashButton", i, 0, -1)
        end
        local quote_start = #final_content - quote_count
        for i = quote_start, #final_content - 1 do
                vim.api.nvim_buf_add_highlight(buf, -1, "SplashVersion", i, 0, -1)
        end
        set_splash_win_opts(win)
end

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
        vim.api.nvim_create_autocmd("VimResized", {
                callback = function()
                        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win) then
                                render(buf, win)
                        end
                end,
        })
        vim.api.nvim_create_autocmd("BufDelete", {
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
