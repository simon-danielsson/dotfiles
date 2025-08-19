vim.pack.add({
        {
                src = "https://github.com/lukas-reineke/indent-blankline.nvim",
                version = "master",
                sync = true,
                silent = true
        },
})

local indent_icon = require("ui.icons").indent
local base_color = require("ui.theme").colors.fg_mid

local function darken_hex(hex, factor)
        local r = tonumber(hex:sub(2,3),16)
        local g = tonumber(hex:sub(4,5),16)
        local b = tonumber(hex:sub(6,7),16)
        r = math.floor(r * factor)
        g = math.floor(g * factor)
        b = math.floor(b * factor)
        return string.format("#%02x%02x%02x", r,g,b)
end

local max_levels = 6
local highlights = {}
for i = 1, max_levels do
        local shade = darken_hex(base_color, 1 - (i-1)*0.1)
        local hl_name = "IndentBlankline"..i
        vim.api.nvim_set_hl(0, hl_name, { fg = shade, bg = "NONE" })
        table.insert(highlights, hl_name)
end

require("ibl").setup({
        indent = {
                char = indent_icon.double,
                highlight = highlights,
                smart_indent_cap = true,
        },
        scope = {
                enabled = true,
                highlight = highlights,
                show_start = true,
                show_end = true,
        },
        enabled = true,
})
