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
        cursor         = "#B8BB25",
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
        cursor         = "#9B59B6",
}

M.aux_colors = {
        macro_statusline = "#FB4835",
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

return M
