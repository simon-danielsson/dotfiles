local M = {}

---@param conf DimmaColorscheme.InternalConfig
---@return table
M.get_colors = function(conf)
    local c = conf.colors

    -- stylua: ignore
    local hl = {
        ColorColumn         = { bg = c.line },
        Conceal             = { fg = c.func },
        CurSearch           = { fg = c.fg, bg = c.search },
        CursorColumn        = { bg = c.line },
        CursorLine          = { bg = c.line },
        CursorLineNr        = { fg = c.fg },
        Debug               = { fg = c.constant },
        debugPC             = { fg = c.bg, bg = c.fg },
        debugBreakpoint     = { fg = c.bg, bg = c.operator },
        Directory           = { fg = c.hint },
        OkMsg               = { fg = c.plus },
        ErrorMsg            = { fg = c.error, bold = conf.bold },
        FloatTitle          = { link = "NormalFloat" },
        FloatShadow         = { bg = c.visual },
        FloatShadowThrough  = { bg = c.visual },
        Folded              = { fg = c.comment, bg = not conf.transparent and c.line or nil },
        FoldColumn          = { fg = c.comment },
        IncSearch           = { fg = c.bg, bg = c.search },
        LineNr              = { fg = c.comment },
        MatchParen          = { fg = c.fg, bg = c.visual },
        MoreMsg             = { fg = c.func, bold = conf.bold },
        MsgSeparator        = { fg = c.string, bg = not conf.transparent and c.line or nil, bold = conf.bold },
        NonText             = { fg = c.comment },
        Normal              = { fg = c.fg, bg = not conf.transparent and c.bg or nil },
        NormalFloat         = { fg = c.fg, bg = not conf.transparent and c.inactiveBg or nil },
        ModeMsg             = { fg = c.string },
        Pmenu               = { fg = c.comment, bg = c.bg, bold = false },
        PmenuKindSel        = { bg = c.floatBorder },
        PmenuMatchSel       = { link = "PmenuKindSel" },
        PmenuExtraSel       = { link = "PmenuKindSel" },
        PmenuThumb          = { link = "PmenuKindSel" },
        Question            = { fg = c.constant },
        qfError             = { fg = c.error },
        Search              = { fg = c.fg, bg = c.search },
        SignColumn          = { fg = c.fg },
        SpecialKey          = { fg = c.comment },
        SpellBad            = { sp = c.error, undercurl = true },
        SpellCap            = { sp = c.delta, undercurl = true },
        SpellLocal          = { sp = c.hint, undercurl = true },
        SpellRare           = { sp = c.constant, undercurl = true },
        StatusLine          = { fg = c.fg, bg = not conf.transparent and c.inactiveBg or nil },
        StatusLineTerm      = { fg = c.fg, bg = not conf.transparent and c.inactiveBg or nil },
        StatusLineNC        = { fg = c.comment },
        StatusLineTermNC    = { fg = c.comment },
        Substitute          = { fg = c.type, bg = c.visual },
        Visual              = { bg = c.visual },
        VisualNOS           = { bg = c.comment, underline = true },
        WarningMsg          = { fg = c.warning, bold = conf.bold },
        WildMenu            = { fg = c.bg, bg = c.func },
        WinSeparator        = { fg = c.floatBorder },
        WinBar              = { fg = c.fg, bg = c.inactiveBg },
        WinBarNC            = { fg = c.comment },
        -- custom for my config
        TabLine             = { fg = c.fg_2, bg = not conf.transparent and c.bg_2 or nil },
        cErrInParen         = { link = "Normal" },
        Whitespace          = { link = "Comment" },
        TabLineSel          = { fg = c.fg_1, bg = c.bg_1 },
        TabLineFill         = { fg = c.mg_1, bg = c.bg_1 },
        TabLineSep          = { fg = c.mg_1, bg = c.bg_2 },
        QuickFixLine        = { ctermbg = 0 },
        qfFileName          = { fg = c.fg_1 },
        IndentGuide         = { fg = c.mg_1 },
        LspInlineCompletion = { fg = c.mg_1, bg = c.bg_2 },
        Biscuit             = { fg = c.mg_1, bg = c.bg_1 },
    }

    return hl
end
return M
