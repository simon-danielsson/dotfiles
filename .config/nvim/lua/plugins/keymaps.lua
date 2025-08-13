local keymap = vim.keymap.set
local function common(descr)
        return { desc = descr, noremap = true, silent = true }
end

-- ======================================================
-- Telescope
-- ======================================================

keymap("n", "<leader>t", "<cmd>Telescope<cr>", common("Telescope"))
keymap("n", "<leader>b", "<cmd>Telescope buffers<cr>", common("Current buffers"))
keymap("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", common("List diagnostics"))
keymap("n", "<leader>r", "<cmd>Telescope oldfiles<cr>", common("Recent files"))
keymap("n", "<leader>k", "<cmd>Telescope keymaps<cr>", common("Keymaps"))
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", common("Local grep"))

-- ======================================================
-- UndoTree
-- ======================================================

keymap("n", "<leader>u", "<cmd>UndotreeToggle<CR>", common("Toggle Undotree"))
