local M = {}

M.colors = {
    fg_main  = "#AAB3C0",
    fg_mid   = "#6e6e87",
    bg_mid   = "#9ec1a3",
    bg_mid2  = "#6e6e87",
    bg_deep  = "#40404f",
    bg_deep2 = "#25252d",
}

M.aux_colors = {
    macro_statusline = "#aa4465",
    cursorline_bg = "#25252d", -- when ghostty bg is transparent
    -- cursorline_bg = "#2a2a33", -- when not transparent
    accent = "#9ec1a3",
}

function M.background_transparency(is_transparent)
    local colors = M.colors
    local bg_color = colors.bg_deep
    if is_transparent then
        bg_color = "NONE"
    end
    vim.api.nvim_set_hl(0, "Normal", { bg = bg_color })
end

function M.colorscheme(option)
    if option == 2 then
        vim.o.background = "dark"
        vim.cmd.colorscheme("habamax")
        vim.api.nvim_set_hl(0, "Function", { fg = M.colors.bg_mid })
        vim.api.nvim_set_hl(0, "Module", { fg = M.colors.bg_mid })
        vim.api.nvim_set_hl(0, "Property", { fg = M.colors.bg_mid })
        vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = M.colors.bg_mid })
        return true
    else
        if option == 1 then
            vim.o.background = "dark"
            vim.cmd.colorscheme("retrobox")
            return false
        end
    end
end

return M
