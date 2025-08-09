local icons = require("native.icons")

-- Set the initial colorscheme
vim.cmd.colorscheme("retrobox")

-- vim.g.border_style = "rounded"
vim.g.border = icons.border

-- Diagnostic stuff
vim.diagnostic.config({
        float = {
                border = "rounded",
        },
        signs = {
                text = {
                        [vim.diagnostic.severity.ERROR] = icons.diagn.error,
                        [vim.diagnostic.severity.WARN]  = icons.diagn.warning,
                        [vim.diagnostic.severity.INFO]  = icons.diagn.information,
                        [vim.diagnostic.severity.HINT]  = icons.diagn.hint,
                },
        },
})
vim.fn.sign_define("DiagnosticSignError",
        { text = icons.diagn.error,
                texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
        { text = icons.diagn.warning,
                texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
        { text = icons.diagn.information,
                texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
        { text = icons.diagn.hint,
                texthl = "DiagnosticSignHint" })

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

local override_groups = {
        -- UI elements
        CursorLine       = { bg = "#262626" },
        NoiceCmdlinePopup = { fg = "#ffffff", bg = "NONE" },
        NoiceCmdlinePopupBorder = { fg = "#ffffff", bg = "NONE" },
        StatusLineNC     = { bg = "#444444" },
        Normal           = { bg = "#262626" },
        NormalNC         = { bg = "#262626" },
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
