local icons = require("ui.icons")
local colors = require("ui.theme").colors

-- ======================================================
-- Set Colorscheme
-- ======================================================

vim.g.border = icons.border

-- ======================================================
-- Diagnostics
-- ======================================================

local diag_icons = {
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

-- ======================================================
-- Color Overrides
-- ======================================================

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
                        "LineNr", "NormalNC", "WinSeparator", "CursorLineNr",
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
        CursorLine              = { bg = colors.bg_deep2 },
        NoiceCmdlinePopup       = { fg = colors.fg_mid, bg = "none" },
        NoiceCmdlinePopupBorder = { fg = colors.fg_mid, bg = "none" },
        StatusLineNC            = { bg = colors.bg_mid },
        StatusLineNormal        = { bg = colors.bg_mid },
        CmpGhostText            = { fg = colors.bg_mid },
        LineNr                  = { fg = colors.fg_mid },
        Comment                 = { fg = colors.fg_mid },
        TelescopePromptBorder   = { fg = colors.fg_mid, bg = "none" },
        TelescopePromptNormal   = { bg = colors.bg_deep },
        TelescopePromptPrefix   = { bg = colors.bg_deep },
        FlashMatch              = { fg = colors.fg_mid, bg = colors.bg_mid },
        TelescopePromptCounter  = { bg = "none" },
        TelescopeBorder         = { fg = colors.fg_mid, bg = "none" },
        TelescopeNormal         = { fg = "none", bg = "none" },
        NormalFloat             = { fg = colors.fg_main, bg = "none" },
        FloatBorder             = { fg = colors.fg_mid, bg = "none" },
        TelescopeResultsBorder  = { fg = colors.fg_mid },
        TelescopePreviewBorder  = { fg = colors.fg_mid },
        TelescopeSelection      = { fg = colors.fg_main, bg = colors.bg_deep },
        TelescopeResultsNormal  = { fg = colors.fg_main },
        -- NormalNC                    = { bg = colors.bg_deep },
        TabLine                 = { bg = colors.bg_deep },
        TabLineFill             = { bg = colors.bg_deep },
        TabLineSel              = { bg = colors.fg_mid, bold = true },
        WinSeparator            = { bg = colors.bg_deep },
        ToolbarButton           = { bg = colors.fg_main, bold = true, reverse = true },
        EndOfBuffer             = { bg = "none" },
        ColorColumn             = { ctermbg = 0, bg = colors.bg_deep },
        VertSplit               = { ctermbg = 0, bg = "none", fg = "none" },
        Pmenu                   = { bg = colors.bg_deep, fg = colors.fg_mid },
        PmenuSel                = { bg = colors.bg_mid, fg = colors.fg_main },
        PmenuSbar               = { bg = colors.bg_deep },
        PmenuThumb              = { bg = colors.bg_mid },
}

-- Apply overrides
for group, opts in pairs(override_groups) do
        set_hl(group, opts)
end
