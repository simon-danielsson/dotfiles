local M         = {}

local cmd       = vim.cmd

M.colors        = {
    fg_1 = "#AAB3C0",
    fg_2 = "#6e6e87",
    mg_1 = "#40404f",
    bg_1 = "#2a2a33",
    bg_2 = "#25252d",
}

local overrides = {
    -- line numbers
    LineNr              = { ctermfg = 8, bg = "none" },
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
    Comment             = { ctermfg = 8, bg = M.colors.bg_2 },
    IndentGuide         = { ctermfg = 8, bg = M.colors.bg_2 },
    LspInlineCompletion = { fg = M.colors.mg_1, bg = M.colors.bg_2 },
    Biscuit             = { ctermbg = 0, bg = "none", ctermfg = 8 },

    -- normal
    Normal              = { fg = M.colors.fg_1, bg = "none" },
    NormalNC            = { link = "Normal" },

    -- cursor
    CursorLine          = { ctermbg = 0, bg = "none" },
    Visual              = { link = "CursorLine" },

    -- quickfix
    QuickFixLine        = { ctermbg = 0 },
    qfFileName          = { fg = M.colors.fg_1 },

    -- float
    NormalFloat         = { fg = M.colors.fg_2, ctermbg = 0 },
    FloatBorder         = { ctermfg = 8, ctermbg = 0 },

    -- splits
    WinSeparator        = { ctermfg = 8, bg = "none" },
    EndOfBuffer         = { link = "CursorLineNr" },
    ColorColumn         = { ctermbg = 0, bg = M.colors.bg_1 },
    VertSplit           = { ctermbg = 0, bg = "none", fg = "none" },

    -- popup menu
    Pmenu               = { fg = M.colors.fg_2, ctermbg = 0 },
    menuSel             = { ctermbg = 8, bg = "none", ctermfg = 0, bold = true },
    PmenuKind           = { bg = M.colors.bg_2, ctermfg = 8 },
    PmenuExtra          = { bg = M.colors.bg_2, fg = M.colors.fg_1 },
    PmenuMatch          = { bg = M.colors.mg_1, fg = M.colors.fg_1 },
    PmenuKindSel        = { link = "PmenuSel" },
    PmenuMatchSel       = { link = "PmenuSel" },
    PmenuExtraSel       = { link = "PmenuSel" },
    PmenuThumb          = { link = "PmenuSel" },
    PmenuSbar           = { ctermfg = 8, ctermbg = 0 },
    PmenuBorder         = { ctermfg = 0, ctermbg = 0 },

    -- statusline
    StatusLine          = { fg = M.colors.fg_1, ctermbg = 0, bold = false },
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
    -- vim.g.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

    -- diagnostics display
    vim.diagnostic.config({ float = { border = "none" }, })

    vim.o.termguicolors = false
    cmd.colorscheme("habamax")

    for group, opts in pairs(overrides) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

return M
