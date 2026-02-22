local icons             = require("ui.icons")
local colors            = require("ui.theme").colors
local aux_col           = require("ui.theme").aux_colors

-- ==== terminal colors ====

vim.g.terminal_color_0  = "#1e1e2e" -- black
vim.g.terminal_color_1  = "#f38ba8" -- red
vim.g.terminal_color_2  = "#a6e3a1" -- green
vim.g.terminal_color_3  = "#f9e2af" -- yellow
vim.g.terminal_color_4  = "#89b4fa" -- blue
vim.g.terminal_color_5  = "#f5c2e7" -- magenta
vim.g.terminal_color_6  = "#94e2d5" -- cyan
vim.g.terminal_color_7  = "#ffffff" -- white

vim.g.terminal_color_8  = colors.fg_mid
vim.g.terminal_color_9  = "#f38ba8" -- bright red
vim.g.terminal_color_10 = "#a6e3a1" -- bright green
vim.g.terminal_color_11 = "#f9e2af" -- bright yellow
vim.g.terminal_color_12 = "#89b4fa" -- bright blue
vim.g.terminal_color_13 = "#f5c2e7" -- bright magenta
vim.g.terminal_color_14 = "#94e2d5" -- bright cyan
vim.g.terminal_color_15 = "#ffffff" -- bright white

-- ==== borders ====

vim.g.border            = icons.border

-- ==== Diagnostics ====

local diag_icons        = {
    [vim.diagnostic.severity.ERROR] = icons.diagn.error,
    [vim.diagnostic.severity.WARN]  = icons.diagn.warning,
    [vim.diagnostic.severity.INFO]  = icons.diagn.information,
    [vim.diagnostic.severity.HINT]  = icons.diagn.hint,
}

-- Configure diagnostics display
vim.diagnostic.config({
    float = { border = "rounded" },
    signs = { text = diag_icons },
})

-- Define diagnostic signs in sign column
for name, icon in pairs({
    DiagnosticSignError = diag_icons[vim.diagnostic.severity.ERROR],
    DiagnosticSignWarn  = diag_icons[vim.diagnostic.severity.WARN],
    DiagnosticSignInfo  = diag_icons[vim.diagnostic.severity.INFO],
    DiagnosticSignHint  = diag_icons[vim.diagnostic.severity.HINT],
}) do
    vim.fn.sign_define(name, { text = icon, texthl = name })
end

-- ==== Color Overrides ====

-- Helper function for setting highlights
local function set_hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Fold colors
set_hl("Folded", { bg = "none", fg = colors.fg_mid })
set_hl("FoldColumn", { bg = "none", fg = colors.fg_mid })

-- Transparent UI elements on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local transparent_groups = {
            "VertSplit", "SignColumn",
            "LineNr", "NormalNC", "CursorLineNr",
            "EndOfBuffer",
            "NormalFloat"
        }
        for _, group in ipairs(transparent_groups) do
            vim.cmd(("highlight %s guibg=NONE ctermbg=NONE"):format(group))
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopePrompt",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})

-- Override groups with custom colors and styles
local override_groups = {
    CursorLine                    = { bg = aux_col.cursorline_bg },
    LspInlayHint                  = { fg = colors.fg_mid },
    TermNormal                    = { fg = colors.fg_mid, bg = colors.bg_mid },
    StatusLineNC                  = { bg = colors.bg_mid },
    StatusLineNormal              = { bg = colors.bg_mid },
    LineNr                        = { fg = colors.bg_deep, bg = "none" },
    LineNrBelow                   = { fg = colors.bg_deep, bg = "none" },
    CursorLineNr                  = { fg = colors.fg_main, bold = true },
    LineNrAbove                   = { fg = colors.bg_deep, bg = "none" },
    Comment                       = { fg = colors.fg_mid },
    NormalFloat                   = { fg = colors.fg_main, bg = "none" },
    FloatBorder                   = { fg = colors.fg_mid, bg = "none" },
    NormalNC                      = { bg = colors.bg_deep, fg = colors.fg_mid },
    TabLine                       = { bg = colors.bg_deep },
    TabLineFill                   = { bg = colors.bg_deep },
    TabLineSel                    = { bg = colors.fg_mid, bold = true },
    WinSeparator                  = { bg = "none", fg = colors.fg_mid },
    ToolbarButton                 = { bg = colors.fg_main, bold = true, reverse = true },
    EndOfBuffer                   = { bg = "none" },
    ColorColumn                   = { ctermbg = 0, bg = colors.bg_deep },
    VertSplit                     = { ctermbg = 0, bg = "none", fg = "none" },
    Pmenu                         = { bg = colors.bg_deep, fg = colors.fg_mid },
    PmenuSel                      = { bg = colors.bg_mid, fg = colors.fg_main },
    PmenuSbar                     = { bg = colors.bg_deep },
    PmenuThumb                    = { bg = colors.bg_mid },

    -- render-markdown
    RenderMarkdownCode            = { bg = colors.bg_deep2 },
    RenderMarkdownCodeInline      = { bg = colors.bg_deep2 },
    RenderMarkdownInlineHighlight = { bg = colors.bg_deep2 },

    -- biscuit-nvim
    BiscuitColor                  = { fg = colors.bg_deep },

    -- nvim-cmp
    CmpGhostText                  = { fg = colors.bg_mid },

    -- flash
    FlashMatch                    = { fg = colors.fg_mid, bg = colors.bg_mid },

    -- telescope
    TelescopeResultsBorder        = { fg = colors.fg_mid },
    TelescopePreviewBorder        = { fg = colors.fg_mid },
    TelescopeSelection            = { fg = colors.fg_main, bg = colors.bg_deep },
    TelescopeResultsNormal        = { fg = colors.fg_main },
    TelescopePromptBorder         = { fg = colors.fg_mid, bg = "none" },
    TelescopePromptNormal         = { bg = "none" },
    TelescopePromptPrefix         = { bg = "none" },
    TelescopePromptCounter        = { bg = "none" },
    TelescopeBorder               = { fg = colors.fg_mid, bg = "none" },
    TelescopeNormal               = { fg = "none", bg = "none" },

    -- noice / nvim.notify
    NotifyBackground              = { bg = colors.bg_mid },
    NoiceCmdlinePopup             = { fg = colors.fg_mid, bg = "none" },
    NoiceCmdlinePopupBorder       = { fg = colors.fg_mid, bg = "none" },
}

-- Apply overrides
for group, opts in pairs(override_groups) do
    set_hl(group, opts)
end
