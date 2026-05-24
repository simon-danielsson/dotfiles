local M   = {}

local cmd = vim.cmd

function M.setup()
    -- borders
    vim.g.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

    -- diagnostics display
    vim.diagnostic.config({ float = { border = "rounded" }, })

    vim.o.termguicolors = false
    cmd.colorscheme("default")
    vim.o.background = "dark"
end

return M
