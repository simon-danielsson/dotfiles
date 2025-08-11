return {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
                require("nvim-treesitter.configs").setup({
                        ensure_installed = {
                                "lua",
                                "python",
                                "javascript",
                                "html",
                                "json",
                                "rust",
                                "markdown",
                                "markdown_inline",
                                "css",
                                "c",
                        },
                        auto_install = true,
                        highlight = {
                                enable = true,
                                additional_vim_regex_highlighting = false,
                        },
                        indent = {
                                enable = true,
                                disable = { "python" },
                        },
                        fold = {
                                enable = true,
                                disable = { "python" },
                        },
                })
        end,
}
