-- Set the colorscheme
vim.cmd.colorscheme("retrobox")
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#ffffff", bg = "NONE" })
vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { fg = "#ffffff", bg = "NONE" })
vim.diagnostic.config({
        float = {
                border = "rounded",  -- 'single', 'double', 'rounded', 'solid', or 'shadow'
        },
})

-- SignColumn symbols
vim.fn.sign_define("DiagnosticSignError", { text = " 󰯈", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",  { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",  { text = " ", texthl = "DiagnosticSignHint" })
vim.diagnostic.config({
        signs = {
                text = {
                        [vim.diagnostic.severity.ERROR] = " 󰯈",
                        [vim.diagnostic.severity.WARN]  = " ",
                        [vim.diagnostic.severity.INFO]  = " ",
                        [vim.diagnostic.severity.HINT]  = " ",
                },
        },
})

-- Set color for folds
vim.cmd [[
  highlight Folded guibg=none guifg=#A7E22F
  highlight FoldColumn guibg=none guifg=#A7E22F
]]

-- Transparent main UI elements
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#262626" })
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 0, bg = "#262626" })
vim.api.nvim_set_hl(0, "VertSplit", { ctermbg = 0, bg = "none", fg = "none" })
-- vim.api.nvim_set_hl(0, "WinSeparator", { ctermbg = 0, bg = "none", fg = "none" })
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
-- highlight FloatBorder guibg=NONE ctermbg=NONE

-- Highlight overrides
local override_groups = {
        -- UI elements
        StatusLineNC     = { bg = "#444444" },
        Normal           = { bg = "#262626" },
        NormalNC         = { bg = "#262626" },
        CursorLine       = { bg = "#444444" },
        VertSplit        = { bg = "#262626" },
        TabLine          = { bg = "#262626" },
        TabLineFill      = { bg = "#262626" },
        TabLineSel       = { bg = "#bababa", bold = true },
        WinSeparator     = { bg = "#262626" },
        ToolbarButton    = { bg = "#f8f8f2", bold = true, reverse = true },

-- Diagnostic highlights
        -- DiagnosticError   = { fg = "#F92672"},
        -- DiagnosticWarn    = { fg = "#FD971F"},
        -- DiagnosticInfo    = { fg = "#66D8EF"},
        -- DiagnosticHint    = { fg = "#E6DB73"},
        -- DiagnosticVirtualTextError = { fg = "#F92672"},
        -- DiagnosticVirtualTextWarn  = { fg = "#FD971F"},
        -- DiagnosticVirtualTextInfo  = { fg = "#66D8EF"},
        -- DiagnosticVirtualTextHint  = { fg = "#E6DB73"},
        -- DiagnosticFloatingError = { fg = "#F92672" },
        -- DiagnosticFloatingWarn  = { fg = "#FD971F" },
        -- DiagnosticFloatingInfo  = { fg = "#66D8EF" },
        -- DiagnosticFloatingHint  = { fg = "#E6DB73" },

-- Floating window styling
        -- NormalFloat  = { bg = "#262626" },
        -- FloatBorder  = { bg = "#ffffff" },

-- nvim-cmp popup styling
        Pmenu         = { bg = "#262626", fg = "#cccccc" },
        PmenuSel      = { bg = "#444444", fg = "#ffffff" },
        PmenuSbar     = { bg = "#262626" },
        PmenuThumb    = { bg = "#444444" },

-- Documentation popup in nvim-cmp (if bordered)
        -- CmpDocumentation        = { bg = "#262626" },
        -- CmpDocumentationBorder  = { bg = "#262626", fg = "#888888" },
}

-- Apply highlights
for group, opts in pairs(override_groups) do
        vim.api.nvim_set_hl(0, group, opts)
end
