local M         = {}

local cmd       = vim.cmd

M.colors        = {
    fg_1 = "#AAB3C0",
    fg_2 = "#6e6e87",
    mg_1 = "#40404f",
    bg_1 = "#2a2a33",
    bg_2 = "none",
}

local overrides = {
    -- line numbers
    LineNr              = { fg = M.colors.mg_1, bg = "none" },
    LineNrAbove         = { link = "LineNr" },
    LineNrBelow         = { link = "LineNr" },
    CursorLineNr        = { fg = M.colors.fg_1, bg = "none" },
    SignColumn          = { bg = M.colors.bg_2 },

    -- lsp
    cErrInParen         = { fg = M.colors.fg_1 },

    -- folds
    FoldColumn          = { link = "SignColumn" },
    Folded              = { fg = M.colors.fg_2, bg = M.colors.bg_1 },

    -- tabline
    TabLine             = { fg = M.colors.fg_2, bg = M.colors.bg_2 },
    TabLineSel          = { fg = M.colors.fg_1, bg = M.colors.bg_1 },
    TabLineFill         = { fg = M.colors.mg_1, bg = M.colors.bg_1 },
    TabLineSep          = { fg = M.colors.mg_1, bg = M.colors.bg_2 },

    -- hints
    Comment             = { fg = M.colors.fg_2, bg = M.colors.bg_2 },
    IndentGuide         = { fg = M.colors.mg_1, bg = M.colors.bg_2 },
    LspInlineCompletion = { fg = M.colors.mg_1, bg = M.colors.bg_2 },
    Biscuit             = { fg = M.colors.mg_1, bg = M.colors.bg_1 },

    -- normal
    Normal              = { fg = M.colors.fg_1, bg = "none" },
    NormalNC            = { link = "Normal" },

    -- cursor
    CursorLine          = { bg = M.colors.bg_1 },
    Visual              = { bg = M.colors.mg_1 },

    -- quickfix
    QuickFixLine        = { ctermbg = 0 },
    qfFileName          = { fg = M.colors.fg_1 },

    -- float
    NormalFloat         = { link = "CursorLineNr" },
    FloatBorder         = { fg = M.colors.fg_2, bg = "none" },

    -- splits
    WinSeparator        = { fg = M.colors.mg_1, bg = "none" },
    EndOfBuffer         = { link = "CursorLineNr" },
    ColorColumn         = { ctermbg = 0, bg = M.colors.bg_1 },
    VertSplit           = { ctermbg = 0, bg = "none", fg = "none" },

    -- popup menu
    Pmenu               = { fg = M.colors.fg_2, bg = M.colors.bg_2 },
    PmenuSel            = { bg = M.colors.mg_1, fg = M.colors.fg_1 },
    PmenuKind           = { bg = M.colors.bg_2, fg = M.colors.fg_1 },
    PmenuExtra          = { bg = M.colors.bg_2, fg = M.colors.fg_1 },
    PmenuMatch          = { bg = M.colors.mg_1, fg = M.colors.fg_1 },
    PmenuKindSel        = { bg = M.colors.mg_1, bold = true },
    PmenuMatchSel       = { link = "PmenuKindSel" },
    PmenuExtraSel       = { link = "PmenuKindSel" },
    PmenuThumb          = { link = "PmenuKindSel" },
    PmenuSbar           = { bg = M.colors.bg_2 },
    PmenuBorder         = { fg = M.colors.fg_2, bg = "none" },

    -- statusline
    StatusLine          = { fg = M.colors.fg_1, bg = M.colors.bg_1, bold = false },
    StatusLineNormal    = { link = "StatusLine" },
    StatusLineNC        = { link = "StatusLine" },
    StatusLineTerm      = { link = "StatusLine" },
    StatusLineTermNC    = { link = "StatusLine" },
    StatusFilename      = { link = "StatusLine" },
    StatusPosition      = { link = "StatusLine" },
    StatusWords         = { link = "StatusLine" },
    StatusMode          = { link = "StatusLine" },
}

function M.setup()
    -- borders
    vim.g.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

    -- diagnostics display
    vim.diagnostic.config({ float = { border = "rounded" }, })

    vim.o.termguicolors = true
    cmd.colorscheme("habamax")
    vim.o.background = "dark"

    for group, opts in pairs(overrides) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

return M
