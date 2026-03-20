local map = vim.keymap.set
local function common(descr)
    return { desc = descr, noremap = true, silent = true }
end

map("n", "<leader>t", "<cmd>Telescope<cr>", common("Telescope"))
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", common("Current buffers"))
map("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", common("List diagnostics"))
map("n", "<leader>r", "<cmd>Telescope oldfiles<cr>", common("Recent files"))
map("n", "<leader>k", "<cmd>Telescope keymaps<cr>", common("Keymaps"))
map("n", "<leader>g", "<cmd>Telescope live_grep<cr>", common("Local grep"))
map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", common("Go to LSP definition"))
