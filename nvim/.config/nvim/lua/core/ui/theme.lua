local M = {}

M.colors = {
    fg_main  = "#AAB3C0",
    fg_mid   = "#6e6e87",
    bg_mid   = "#9ec1a3",
    bg_mid2  = "#6e6e87",
    bg_deep  = "#40404f",
    bg_deep3 = "#25252d",
}

M.aux_colors = {
    macro_statusline = "#aa4465",
    -- cursorline_bg = "#25252d", -- if transparent bg
    cursorline_bg = "#2a2a33", -- not transparent bg
    accent = "#9ec1a3",
}

function M.colorscheme()
    vim.o.background = "dark"
    vim.cmd.colorscheme("habamax")
    vim.api.nvim_set_hl(0, "Function", { fg = M.colors.bg_mid })
    vim.api.nvim_set_hl(0, "Module", { fg = M.colors.bg_mid })
    vim.api.nvim_set_hl(0, "Property", { fg = M.colors.bg_mid })
    vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = M.colors.bg_mid })
    vim.api.nvim_set_hl(0, "Normal", { bg = M.colors.bg_deep3 })
end

return M
