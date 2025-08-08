return {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
                { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
        },
        config = function()
                vim.api.nvim_set_hl(0, "UndotreeNormal", { bg = "NONE" }) -- transparent main panel
                vim.api.nvim_set_hl(0, "UndotreeDiffNormal", { bg = "NONE" }) -- optional preview panel bg
                vim.api.nvim_create_autocmd("FileType", {
                        pattern = "undotree",
                        callback = function()
                                vim.api.nvim_win_set_option(0, "winhighlight", "Normal:UndotreeNormal,VertSplit:UndotreeVertSplit")
                        end,
                })
                vim.api.nvim_create_autocmd("FileType", {
                        pattern = "undotree_diff",
                        callback = function()
                                vim.api.nvim_win_set_option(0, "winhighlight", "Normal:UndotreeDiffNormal")
                        end,
                })
                vim.g.undotree_SplitWidth = 40          -- width of undotree window
                vim.g.undotree_SetFocusWhenToggle = 1   -- focus window on open
                vim.g.undotree_DiffpanelHeight = 10     -- height of preview panel
                vim.g.undotree_HelpLine = 0             -- hide help line at bottom
        end,
}
