local M = {}
local custom_c = {
    fg_1 = "#AAB3C0",
    fg_2 = "#6e6e87",
    mg_1 = "#40404f",
    bg_1 = "#2a2a33",
    bg_2 = "#25252d",
}

---@class DimmaColorscheme.InternalConfig
local DEFAULT_SETTINGS = {

    ---@type boolean
    transparent = false,
    ---@type boolean
    bold = true,
    ---@type boolean
    italic = true,

    ---@param highlights table<string, vim.api.keyset.highlight>
    ---@param colors DimmaColorscheme.InternalConfig.colors
    on_highlights = function(highlights, colors) end,

    ---@class DimmaColorscheme.InternalConfig.colors
    colors = {
        fg_1 = custom_c.fg_1,
        fg_2 = custom_c.fg_2,
        mg_1 = custom_c.mg_1,
        bg_1 = custom_c.bg_1,
        bg_2 = custom_c.bg_2,

        ---@type string
        bg = custom_c.bg_2,
        ---@type string
        inactiveBg = custom_c.bg_1,
        ---@type string
        fg = custom_c.fg_1,
        ---@type string
        floatBorder = custom_c.mg_1,
        ---@type string
        line = custom_c.bg_1,
        ---@type string
        comment = custom_c.fg_2,
        ---@type string
        builtin = "#b4d4cf",
        ---@type string
        func = "#c48282",
        ---@type string
        string = "#e8b589",
        ---@type string
        number = "#e0a363",
        ---@type string
        property = "#c3c3d5",
        ---@type string
        constant = "#aeaed1",
        ---@type string
        parameter = "#bb9dbd",
        ---@type string
        visual = "#2a2a33",
        ---@type string
        error = "#d8647e",
        ---@type string
        warning = "#f3be7c",
        ---@type string
        hint = "#7e98e8",
        ---@type string
        operator = "#90a0b5",
        ---@type string
        keyword = "#6e94b2",
        ---@type string
        type = "#9bb4bc",
        ---@type string
        search = custom_c.mg_1,
        ---@type string
        plus = "#7fa563",
        ---@type string
        delta = "#f3be7c",
    },
}

M._DEFAULT_SETTINGS = DEFAULT_SETTINGS
M.current = M._DEFAULT_SETTINGS

local opts = type(vim.g.dimma_colorscheme) == "function" and vim.g.dimma_colorscheme() or vim.g.dimma_colorscheme or {}

---@param user_opts DimmaColorscheme.Config
M.set = function(user_opts) M.current = vim.tbl_deep_extend("force", vim.deepcopy(M.current), user_opts or opts) end

return M
