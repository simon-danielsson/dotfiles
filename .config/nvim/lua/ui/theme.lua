local M = {}

M.colors = {
        fg_main = "#ffffff",
        fg_mid  = "#888888",
        bg_mid  = "#444444",
        bg_mid2 = "#333333",
        bg_deep = "#262626",
}

M.colors_light_mode = {
        fg_main = "#4B0082",
        fg_mid  = "#6A0DAD",
        bg_mid  = "#9B59B6",
        bg_mid2 = "#DDA0DD",
        bg_deep = "#E6CCFF",
}

M.aux_colors = {
        macro_statusline = "#FB4835",
}

function M.background_transparency(is_transparent)
        local colors = M.colors
        local bg = is_transparent and nil or colors.bg_deep
        vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg_main, bg = bg })
end

function M.pink_explosion(enable)
        if enable then
                vim.o.background = "light"
                vim.cmd.colorscheme("peachpuff")
                M.colors = vim.deepcopy(M.colors_light_mode)
                return true
        else
                vim.o.background = "dark"
                vim.cmd.colorscheme("retrobox")
                M.background_transparency(false)
                return false
        end
end

return M
