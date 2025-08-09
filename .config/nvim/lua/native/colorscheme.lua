-- Set the initial colorscheme
vim.cmd.colorscheme("retrobox")

vim.g.border_style = "rounded"
vim.g.border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
}

-- Diagnostic stuff
vim.diagnostic.config({
        float = {
                border = "rounded",
        },
        signs = {
                text = {
                        [vim.diagnostic.severity.ERROR] = " 󰯈",
                        [vim.diagnostic.severity.WARN]  = " ",
                        [vim.diagnostic.severity.INFO]  = " ",
                        [vim.diagnostic.severity.HINT]  = " ",
                },
        },
})
vim.fn.sign_define("DiagnosticSignError", { text = " 󰯈", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",  { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",  { text = " ", texthl = "DiagnosticSignHint" })

-- Set color for folds
vim.cmd [[
  highlight Folded guibg=none guifg=#A7E22F
  highlight FoldColumn guibg=none guifg=#A7E22F
]]

-- Transparent main UI elements
vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
                vim.cmd([[
          highlight NormalFloat guibg=NONE ctermbg=NONE
          highlight VertSplit guibg=NONE ctermbg=NONE
          highlight Normal guibg=NONE
          highlight SignColumn guibg=NONE ctermbg=NONE
          highlight LineNr guibg=NONE ctermbg=NONE
          highlight NormalNC guibg=NONE
          highlight WinSeparator guibg=NONE ctermbg=NONE
          highlight CursorLineNr guibg=NONE ctermbg=NONE
          highlight EndOfBuffer guibg=NONE ctermbg=NONE
          ]])
        end,
})

-- Highlight overrides
local override_groups = {
        -- UI elements
        NoiceCmdlinePopup = { fg = "#ffffff", bg = "NONE" },
        NoiceCmdlinePopupBorder = { fg = "#ffffff", bg = "NONE" },
        StatusLineNC     = { bg = "#444444" },
        Normal           = { bg = "#262626" },
        NormalNC         = { bg = "#262626" },
        CursorLine       = { bg = "#444444" },
        TabLine          = { bg = "#262626" },
        TabLineFill      = { bg = "#262626" },
        TabLineSel       = { bg = "#bababa", bold = true },
        WinSeparator     = { bg = "#262626" },
        ToolbarButton    = { bg = "#f8f8f2", bold = true, reverse = true },
        EndOfBuffer      = { bg = "none" },
        ColorColumn      = { ctermbg = 0, bg = "#262626" },
        VertSplit        = { ctermbg = 0, bg = "none", fg = "none" },
        Pmenu         = { bg = "#262626", fg = "#cccccc" },
        PmenuSel      = { bg = "#444444", fg = "#ffffff" },
        PmenuSbar     = { bg = "#262626" },
        PmenuThumb    = { bg = "#444444" },

}
for group, opts in pairs(override_groups) do
        vim.api.nvim_set_hl(0, group, opts)
end
