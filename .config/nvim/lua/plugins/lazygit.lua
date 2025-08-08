return {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
                { "<leader>ä", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
        },
}
