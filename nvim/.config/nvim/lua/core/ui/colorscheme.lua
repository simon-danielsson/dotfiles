local icons             = require("core.ui.icons")
local colors            = require("core.ui.theme").colors
local aux_col           = require("core.ui.theme").aux_colors

-- =========================================================
-- terminal colors

vim.g.terminal_color_0  = "#1e1e2e"      -- black
vim.g.terminal_color_1  = "#f38ba8"      -- red
vim.g.terminal_color_2  = "#a6e3a1"      -- green
vim.g.terminal_color_3  = "#f9e2af"      -- yellow
vim.g.terminal_color_4  = "#89b4fa"      -- blue
vim.g.terminal_color_5  = "#f5c2e7"      -- magenta
vim.g.terminal_color_6  = "#94e2d5"      -- cyan
vim.g.terminal_color_7  = colors.fg_main -- white
vim.g.terminal_color_8  = colors.fg_mid
vim.g.terminal_color_9  = "#f38ba8"      -- bright red
vim.g.terminal_color_10 = "#a6e3a1"      -- bright green
vim.g.terminal_color_11 = "#f9e2af"      -- bright yellow
vim.g.terminal_color_12 = "#89b4fa"      -- bright blue
vim.g.terminal_color_13 = "#f5c2e7"      -- bright magenta
vim.g.terminal_color_14 = "#94e2d5"      -- bright cyan
vim.g.terminal_color_15 = colors.fg_main

-- =========================================================
-- borders

vim.g.border            = icons.border

-- =========================================================
-- diagnostics

local diag_icons        = {
    [vim.diagnostic.severity.ERROR] = icons.diagn.error,
    [vim.diagnostic.severity.WARN]  = icons.diagn.warning,
    [vim.diagnostic.severity.INFO]  = icons.diagn.information,
    [vim.diagnostic.severity.HINT]  = icons.diagn.hint,
}

-- diagnostics display
vim.diagnostic.config({
    float = { border = "rounded" },
    signs = { text = diag_icons },
})

-- diagnostic signs in sign column
for name, icon in pairs({
    DiagnosticSignError = diag_icons[vim.diagnostic.severity.ERROR],
    DiagnosticSignWarn  = diag_icons[vim.diagnostic.severity.WARN],
    DiagnosticSignInfo  = diag_icons[vim.diagnostic.severity.INFO],
    DiagnosticSignHint  = diag_icons[vim.diagnostic.severity.HINT],
}) do
    vim.fn.sign_define(name, { text = icon, texthl = name })
end

-- =========================================================
-- highlight overrides: general

-- helper
local function set_hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

local override_groups = {
    CursorLine       = { bg = aux_col.cursorline_bg },
    LspInlayHint     = { fg = colors.fg_mid },
    TermNormal       = { fg = colors.fg_mid, bg = colors.bg_mid },
    StatusLineNC     = { bg = colors.bg_mid },
    StatusLineNormal = { bg = colors.bg_mid },
    LineNr           = { fg = colors.bg_deep, bg = "none" },
    LineNrBelow      = { fg = colors.bg_deep, bg = "none" },
    CursorLineNr     = { fg = colors.fg_main, bold = true },
    LineNrAbove      = { fg = colors.bg_deep, bg = "none" },
    Comment          = { fg = colors.fg_mid, bold = false },
    IndentGuide      = { fg = colors.bg_deep, bold = false },
    NormalNC         = { bg = colors.bg_deep3, fg = colors.fg_mid },
    TabLine          = { bg = colors.bg_deep },
    TabLineFill      = { bg = colors.bg_deep },
    TabLineSel       = { bg = colors.fg_mid, bold = true },
    WinSeparator     = { bg = "none", fg = aux_col.cursorline_bg },
    ToolbarButton    = { bg = colors.fg_main, bold = true, reverse = true },
    EndOfBuffer      = { bg = "none" },
    ColorColumn      = { ctermbg = 0, bg = colors.bg_deep },
    VertSplit        = { ctermbg = 0, bg = "none", fg = "none" },
    -- popup menu
    Visual           = { bg = colors.bg_deep },
    CurSearch        = { bg = aux_col.accent, fg = colors.bg_deep3 },
    IncSearch        = { bg = aux_col.accent, fg = colors.bg_deep3 },
    Search           = { bg = aux_col.accent, fg = colors.bg_deep3 },
    Substitute       = { bg = colors.bg_deep },

    -- biscuit-nvim
    BiscuitColor     = { fg = colors.bg_deep, bg = aux_col.cursorline_bg },
}

for group, opts in pairs(override_groups) do
    set_hl(group, opts)
end

-- =========================================================
-- highlight overrides: floating menus

local floating_menus = {
    NormalFloat   = { fg = colors.fg_main, bg = "none" },
    FloatBorder   = { fg = colors.fg_mid, bg = "none" },

    Pmenu         = { bg = colors.bg_deep3, fg = colors.fg_mid },
    PmenuSel      = { bg = colors.bg_deep, fg = colors.fg_main },
    PmenuKind     = { bg = colors.bg_deep3, fg = colors.fg_main },
    PmenuExtra    = { bg = colors.bg_deep3, fg = colors.fg_main },
    PmenuMatch    = { bg = colors.bg_deep, fg = colors.fg_main },
    PmenuKindSel  = { bg = colors.bg_deep, fg = aux_col.accent, bold = true },
    PmenuExtraSel = { bg = colors.bg_deep, fg = colors.fg_main, bold = true },
    PmenuMatchSel = { bg = colors.bg_deep, fg = aux_col.accent, bold = true },
    PmenuSbar     = { bg = colors.bg_deep3 },
    PmenuThumb    = { bg = colors.bg_deep3 },
    PmenuBorder   = { fg = colors.fg_mid, bg = "none" },
}

for group, opts in pairs(floating_menus) do
    set_hl(group, opts)
end

-- =========================================================
-- highlight overrides: telescope

local telescope = {
    TelescopeResultsBorder = { fg = colors.fg_mid },
    TelescopePreviewBorder = { fg = colors.fg_mid },
    TelescopeSelection     = { fg = colors.fg_main, bg = colors.bg_deep },
    TelescopeResultsNormal = { fg = colors.fg_main },
    TelescopePromptBorder  = { fg = colors.fg_mid, bg = "none" },
    TelescopePromptNormal  = { bg = "none" },
    TelescopePromptPrefix  = { bg = "none" },
    TelescopePromptCounter = { bg = "none" },
    TelescopeBorder        = { fg = colors.fg_mid, bg = "none" },
    TelescopeNormal        = { fg = "none", bg = "none" },
}

for group, opts in pairs(telescope) do
    set_hl(group, opts)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopePrompt",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})
