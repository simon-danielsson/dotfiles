local M         = {}

local cmd       = vim.cmd

M.colors        = {
    fg_1 = "#8c8f92",
    fg_2 = "#5f5f63",
    mg_1 = "#414141",
    bg_1 = "#212121",
    bg_2 = "none",
    bg_2_b = "#121212",
}

local overrides = {
    -- line numbers
    LineNr              = { fg = M.colors.mg_1, bg = "none" },
    LineNrAbove         = { link = "LineNr" },
    LineNrBelow         = { link = "LineNr" },
    CursorLineNr        = { fg = M.colors.fg_1, bg = "none" },
    SignColumn          = { bg = M.colors.bg_2, ctermbg = "none" },
    DiagnosticSignWarn  = { fg = "#ff9e3b", bg = M.colors.bg_2, ctermbg = "none" },
    DiagnosticSignInfo  = { fg = "#658594", bg = M.colors.bg_2, ctermbg = "none" },
    DiagnosticSignHint  = { fg = "#6a9589", bg = M.colors.bg_2, ctermbg = "none" },
    DiagnosticSignError = { fg = "#e82424", bg = M.colors.bg_2, ctermbg = "none" },

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
    Normal              = { fg = M.colors.fg_1, bg = M.colors.bg_2 },
    NormalNC            = { link = "Normal" },

    -- cursor
    CursorLine          = { bg = M.colors.bg_1 },
    Visual              = { bg = M.colors.mg_1 },

    -- quickfix
    QuickFixLine        = { ctermbg = 0 },
    qfFileName          = { fg = M.colors.fg_1 },

    -- splits
    WinSeparator        = { fg = M.colors.mg_1, bg = "none" },
    EndOfBuffer         = { link = "CursorLineNr" },
    ColorColumn         = { ctermbg = 0, bg = M.colors.bg_1 },
    VertSplit           = { ctermbg = 0, bg = "none", fg = "none" },

    -- popup menu
    Pmenu               = { fg = M.colors.fg_2, bg = M.colors.bg_2 },
    PmenuSel            = { bg = M.colors.bg_1, fg = M.colors.fg_1, bold = true },
    PmenuKind           = { bg = M.colors.bg_2, fg = M.colors.fg_1 },
    PmenuExtra          = { bg = M.colors.bg_2, fg = M.colors.fg_1 },
    PmenuMatch          = { bg = M.colors.mg_1, fg = M.colors.fg_1 },
    PmenuKindSel        = { bg = M.colors.bg_1, bold = true },
    PmenuMatchSel       = { link = "PmenuKindSel" },
    PmenuExtraSel       = { link = "PmenuKindSel" },
    PmenuThumb          = { link = "PmenuKindSel" },
    PmenuSbar           = { bg = M.colors.bg_2 },
    PmenuBorder         = { fg = M.colors.fg_2, bg = "none" },

    -- float
    NormalFloat         = { link = "CursorLineNr" },
    FloatBorder         = { link = "PmenuBorder" },
    TelescopeBorder     = { link = "PmenuBorder" },
    TelescopeSelection  = { link = "PmenuSel" },

    -- statusline
    StatusLineHidden    = { fg = M.colors.fg_1, bg = M.colors.bg_2_b, bold = false },
    StatusLine          = { fg = M.colors.fg_1, bg = M.colors.bg_1, bold = false },
    StatusLineNormal    = { link = "StatusLine" },
    TelescopeNormal     = { link = "Normal" },
    ModeMsg             = { fg = M.colors.fg_2, bg = M.colors.bg_2, bold = false },
    MsgArea             = { link = "ModeMsg" },
    MsgSeparator        = { link = "ModeMsg" },
    ErrorMsg            = { link = "ModeMsg" },
}

function M.setup()
    vim.g.border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
    vim.diagnostic.config({ float = { border = "single" }, })
    vim.opt.pumborder   = "single"

    vim.o.termguicolors = true
    vim.o.background    = "dark"

    vim.pack.add({
        "https://github.com/rebelot/kanagawa.nvim"
    })

    cmd.colorscheme("kanagawa-dragon")

    for group, opts in pairs(overrides) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

return M
