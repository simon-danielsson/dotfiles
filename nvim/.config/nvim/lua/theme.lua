local M   = {}

local cmd = vim.cmd

function M.setup()
    -- borders
    vim.g.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

    -- diagnostics display
    vim.diagnostic.config({ float = { border = "rounded" }, })

    -- these colors are the ones used in dimma.nvim
    local colors = {
        fg_1 = "#AAB3C0",
        fg_2 = "#6e6e87",
        mg_1 = "#40404f",
        bg_1 = "#2a2a33",
        bg_2 = "#25252d",
    }

    vim.pack.add({
        {
            src = "https://github.com/simon-danielsson/dimma.nvim"
        }
    })

    require('dimma').setup({
        transparent = false, -- if true, background is not set
        bold = true,         -- disable bold globally
        italic = false,      -- disable italic globally
    })

    cmd.colorscheme("dimma")
end

return M
