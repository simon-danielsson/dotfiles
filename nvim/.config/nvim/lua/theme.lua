local M         = {}

local cmd       = vim.cmd

M.colors        = {
    fg_1 = "#AAB3C0",
    fg_2 = "#6e6e87",
    mg_1 = "#40404f",
    bg_1 = "#2a2a33",
    bg_2 = "#25252d",
}

local overrides = {
    -- statusline
    StatusLine       = { fg = M.colors.fg_1, bg = M.colors.bg_1, bold = false },
    StatusLineNormal = { link = "StatusLine" },
    StatusLineNC     = { link = "StatusLine" },
    StatusLineTerm   = { link = "StatusLine" },
    StatusLineTermNC = { link = "StatusLine" },
    StatusFilename   = { link = "StatusLine" },
    StatusPosition   = { link = "StatusLine" },
    StatusWords      = { link = "StatusLine" },
    StatusMode       = { link = "StatusLine" },
}

function M.setup()
    -- borders
    vim.g.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

    -- diagnostics display
    vim.diagnostic.config({ float = { border = "rounded" }, })

    vim.o.termguicolors = false
    cmd.colorscheme("default")
    vim.o.background = "dark"

    for group, opts in pairs(overrides) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

return M
