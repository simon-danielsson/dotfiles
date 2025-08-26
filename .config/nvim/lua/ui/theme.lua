local M = {}

M.colors = {
        fg_main  = "#ffffff",
        fg_mid   = "#888888",
        bg_mid   = "#444444",
        bg_mid2  = "#333333",
        bg_deep  = "#212121",
        bg_deep2 = "#1a1a1a",
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
                vim.o.background = "dark"
                vim.cmd.colorscheme("retrobox")
                return true
        else
                if option == 1 then
                        vim.o.background = "dark"
                        vim.cmd.colorscheme("habamax")
                        M.background_transparency(false)
                        return false
                end
        end
end

return M
