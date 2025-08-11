return {
        {
                "neovim/nvim-lspconfig",
                event = { "BufReadPre", "BufNewFile" },
        },
        { "williamboman/mason.nvim", build = ":MasonUpdate" },
        { "williamboman/mason-lspconfig.nvim" },

}
