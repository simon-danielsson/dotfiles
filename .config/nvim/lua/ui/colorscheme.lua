local icons = require("ui.icons")
local bg_deep = require("ui.colors").bg_deep
local bg_mid = require("ui.colors").bg_mid
local fg_main = require("ui.colors").fg_main
local fg_mid = require("ui.colors").fg_mid

-- ======================================================
-- Set Colorscheme
-- ======================================================

vim.cmd.colorscheme("retrobox")
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
-- Colour Overrides
-- ======================================================

-- Helper function for setting highlights
local function set_hl(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
end

-- Fold colors
set_hl("Folded",     { bg = "none", fg = fg_mid })
set_hl("FoldColumn", { bg = "none", fg = fg_mid })

-- Transparent UI elements on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
                local transparent_groups = {
                        "NormalFloat", "VertSplit", "Normal", "SignColumn",
                        "LineNr", "NormalNC", "WinSeparator", "CursorLineNr",
                        "EndOfBuffer",
                }
                for _, group in ipairs(transparent_groups) do
                        vim.cmd(("highlight %s guibg=NONE ctermbg=NONE"):format(group))
                end
        end,
})

-- Override groups with custom colors and styles
local override_groups = {
        CursorLine                    = { bg = bg_deep },
        NoiceCmdlinePopup             = { fg = fg_mid, bg = "none" },
        NoiceCmdlinePopupBorder       = { fg = fg_mid, bg = "none" },
        StatusLineNC                  = { bg = bg_mid },
        LineNr                        = { fg = fg_mid },
        Normal                        = { bg = bg_deep },
        Comment                       = { fg = fg_mid },
        NormalFloat                   = { fg = fg_mid },
        FloatBorder                   = { fg = fg_mid },
        TelescopeNormal               = { bg = "none" },
        TelescopePromptNormal         = { guibg = NONE },
        TelescopeBorder               = { fg = fg_mid, bg = "none" },
        TelescopePromptBorder         = { fg = fg_mid, bg = "none" },
        TelescopeResultsBorder        = { fg = fg_mid },
        TelescopePreviewBorder        = { fg = fg_mid },
        IndentBlanklineChar           = { fg = fg_mid },
        IndentBlanklineContextChar    = { fg = fg_mid },
        IndentBlanklineSpaceChar      = { fg = fg_mid },
        IndentBlanklineContextStart   = { fg = fg_mid },
        NormalNC                      = { bg = bg_deep },
        TabLine                       = { bg = bg_deep },
        TabLineFill                   = { bg = bg_deep },
        TabLineSel                    = { bg = fg_mid, bold = true },
        WinSeparator                  = { bg = bg_deep },
        ToolbarButton                 = { bg = fg_main, bold = true, reverse = true },
        EndOfBuffer                   = { bg = "none" },
        ColorColumn                   = { ctermbg = 0, bg = bg_deep },
        VertSplit                     = { ctermbg = 0, bg = "none", fg = "none" },
        Pmenu                         = { bg = bg_deep, fg = fg_mid },
        PmenuSel                      = { bg = bg_mid, fg = fg_main },
        PmenuSbar                     = { bg = bg_deep },
        PmenuThumb                    = { bg = bg_mid },
}

-- Apply overrides
for group, opts in pairs(override_groups) do
        set_hl(group, opts)
end
