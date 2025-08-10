local icons = require("native.icons")

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

local bg_dark   =       "#262626"
local bg_dim    =       "#444444"
local fg_white  =       "#ffffff"

-- Helper function for setting highlights
local function set_hl(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
end

-- Fold colors
set_hl("Folded",     { bg = "none", fg = "#A7E22F" })
set_hl("FoldColumn", { bg = "none", fg = "#A7E22F" })

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
        CursorLine            = { bg = bg_dark },
        NoiceCmdlinePopup     = { fg = fg_white, bg = "none" },
        NoiceCmdlinePopupBorder = { fg = fg_white, bg = "none" },
        StatusLineNC          = { bg = bg_dim },
        Normal                = { bg = bg_dark },
        NormalNC              = { bg = bg_dark },
        TabLine               = { bg = bg_dark },
        TabLineFill           = { bg = bg_dark },
        TabLineSel            = { bg = "#bababa", bold = true },
        WinSeparator          = { bg = bg_dark },
        ToolbarButton         = { bg = "#f8f8f2", bold = true, reverse = true },
        EndOfBuffer           = { bg = "none" },
        ColorColumn           = { ctermbg = 0, bg = bg_dark },
        VertSplit             = { ctermbg = 0, bg = "none", fg = "none" },
        Pmenu                 = { bg = bg_dark, fg = "#cccccc" },
        PmenuSel              = { bg = bg_dim, fg = fg_white },
        PmenuSbar             = { bg = bg_dark },
        PmenuThumb            = { bg = bg_dim },
}

-- Apply overrides
for group, opts in pairs(override_groups) do
        set_hl(group, opts)
end
