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
    ModeMsg             = { fg = M.colors.fg_2, bg = M.colors.bg_2, bold = false },
    MsgArea             = { link = "ModeMsg" },
    MsgSeparator        = { link = "ModeMsg" },
    ErrorMsg            = { link = "ModeMsg" },
}

function M.setup()
    vim.g.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

    vim.diagnostic.config({ float = { border = "rounded" }, })

    vim.o.termguicolors = true
    vim.o.background = "dark"

    vim.pack.add({
        "https://github.com/rebelot/kanagawa.nvim"
    })

    cmd.colorscheme("kanagawa-dragon")

    for group, opts in pairs(overrides) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

local ftypes = {
    python     = { "py", "", "#F6CD42" },
    rust       = { "rs", "", "#835F00" },
    html       = { "html", "", "#DE4B25" },
    terminal   = { "term", "", "#DE4B25" },
    toml       = { "toml", "", "#984120" },
    json       = { "toml", "", "#51816C" },
    css        = { "css", "", "#643294" },
    javascript = { "js", "", "#EFD81C" },
    sh         = { "sh", "", "#5FAF5F" },
    c          = { "c", "", "#A9BACD" },
    h          = { "h", "󰬏", "#A9BACD" },
    go         = { "go", "󰟓", "#66D0DD" },
    markdown   = { "md", "", "#A84AB7" },
    text       = { "txt", "󱞎", M.colors.fg_1 },
    gd         = { "gd", "", "#4488B9" },
    xml        = { "xml", "󰗀", "#A84AB7" },
    odin       = { "odin", "Ø", "#1896F5" },
    lua        = { "lua", "", "#456F91" },
    netrw      = { "net", "", M.colors.fg_1 },
    cs         = { "cs", "󰌛", "#9D76D6" },
    csproj     = { "csproj", "󰌛", "#9D76D6" },
    quickfix   = { "qf", "", M.colors.fg_1 },
    el         = { "el", "", "#7453A8" },
    default    = { "???", "󱀶", M.colors.fg_1 },
}

function M.buffer_icon_col(ft)
    local icon = ftypes[ft] or ftypes.default
    return { icon[1], icon[2], icon[3] }
end

return M
