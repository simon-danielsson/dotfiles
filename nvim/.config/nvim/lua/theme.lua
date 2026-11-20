local M         = {}

local cmd       = vim.cmd

M.colors        = {
    fg_1 = "#8c8f92",
    fg_2 = "#5f5f63",
    mg_1 = "#414141",
    bg_1 = "#212121",
    bg_2 = "none",
    bg_2_b = "#121212",
    code_1 = "#658594",
    code_2 = "#5D8260",
    code_3 = "#CD614E"
}

local overrides = {

    cTodo              = { fg = M.colors.bg_2_b, bg = M.colors.code_3, bold = true },
    dTodo              = { fg = M.colors.bg_2_b, bg = M.colors.code_3, bold = true },
    csTodo             = { fg = M.colors.bg_2_b, bg = M.colors.code_3, bold = true },

    Biscuit            = { link = "Comment" },
    EndOfBuffer        = { link = "Comment" },
    Normal             = { ctermbg = "none", bg = "none" },
    NormalNC           = { ctermbg = "none", bg = "none" },
    StatusLineHidden   = { fg = "#908CAA" },
    CursorLine         = { bg = "#1F1D2E" },

    NormalFloat        = { link = "CursorLineNr" },
    -- FloatBorder        = { link = "PmenuBorder" },
    -- TelescopeBorder    = { link = "PmenuBorder" },
    TelescopeSelection = { link = "PmenuSel" },

    TelescopeNormal    = { link = "PmenuBorder" },
}

function M.setup()
    vim.g.border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
    vim.diagnostic.config({ float = { border = "rounded" }, })
    vim.opt.pumborder = "rounded"

    vim.pack.add({
        "https://github.com/rose-pine/neovim.git"
    })

    require("rose-pine").setup({
        dim_inactive_windows = true,
    })

    vim.cmd("colorscheme rose-pine")
    -- vim.cmd("colorscheme rose-pine-main")
    -- vim.cmd("colorscheme rose-pine-moon")
    -- vim.cmd("colorscheme rose-pine-dawn")
    -- vim.o.termguicolors = true
    cmd.colorscheme("rose-pine")

    for group, opts in pairs(overrides) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

return M
