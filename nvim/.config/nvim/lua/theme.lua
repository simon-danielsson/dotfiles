local M   = {}

local cmd = vim.cmd

function M.setup()
    -- borders
    vim.g.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

    -- diagnostics display
    vim.diagnostic.config({ float = { border = "rounded" }, })

    local theme  = {}
    theme.colors = {
        fg_1 = "#AAB3C0",
        fg_2 = "#6e6e87",
        mg_1 = "#40404f",
        bg_1 = "#2a2a33",
        bg_2 = "#25252d",
    }

    -- 'dimma' is my own modified version of vague.nvim
    -- I changed around some colors and added some highlight groups
    -- but apart from that everything is exactly the same.
    -- All credit goes to the creator and contributors of vague.nvim:
    -- https://github.com/vague-theme/vague.nvim

    require('dimma').setup({
        transparent = false, -- if true, background is not set
        bold = true,         -- disable bold globally
        italic = false,      -- disable italic globally
    })

    function theme.theme()
        vim.o.background = "dark"
        cmd.colorscheme("dimma")
    end

    theme.theme()
end

return M
