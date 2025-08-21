local M = {}

M.colors = {
        fg_main        = "#ffffff",
        fg_mid         = "#888888",
        bg_mid         = "#444444",
        bg_mid2        = "#333333",
        bg_deep        = "#262626",
        splash_version = "#444444",
        splash_banner  = "#B8BB25",
        splash_buttons = "#888888",
}

M.colors_pink_explosion = {
        fg_main        = "#4B0082",
        fg_mid         = "#6A0DAD",
        bg_mid         = "#9B59B6",
        bg_mid2        = "#DDA0DD",
        bg_deep        = "#E6CCFF",
        splash_version = "#9B59B6",
        splash_banner  = "#4B0082",
        splash_buttons = "#9B59B6",
}

M.aux_colors = {
        macro_statusline = "#FB4835",
}

function M.background_transparency(is_transparent)
        local colors = M.colors
        local bg = is_transparent and nil or colors.bg_deep
        vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg_main, bg = bg })
end

function M.colorscheme(option)
        if option == 2 then
                vim.o.background = "light"
                vim.cmd.colorscheme("peachpuff")
                M.colors = vim.deepcopy(M.colors_pink_explosion)
                return true
        else
                if option == 1 then
                        vim.o.background = "dark"
                        vim.cmd.colorscheme("retrobox")
                        M.background_transparency(false)
                        return false
                end
        end
end

M.banner = {
        "┏┓┳┳┳┓┓┏┳┳┳┓",
        "┗┓┃┃┃┃┃┃┃┃┃┃",
        "┗┛┻┛ ┗┗┛┻┛ ┗",
}

-- local banners = { M.banner1, M.banner2, M.banner3, M.banner4, M.banner5, M.banner6 }
-- local chosen_banner = banners[math.random(#banners)]
-- M.banner = chosen_banner

return M
