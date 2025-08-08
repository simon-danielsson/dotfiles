return {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
                "hrsh7th/cmp-nvim-lsp",   -- LSP source
                "hrsh7th/cmp-buffer",     -- Buffer source
                "hrsh7th/cmp-path",       -- Filesystem paths
                "hrsh7th/cmp-cmdline",    -- Command-line completions
        },
        config = function()
                local cmp = require("cmp")
                cmp.setup({
                        window = {
                                completion = cmp.config.window.bordered({
                                        border = "rounded",
                                }),
                                documentation = cmp.config.window.bordered({
                                        border = "rounded",
                                }),
                        },
                        mapping = cmp.mapping.preset.insert({
                                ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Accept completion
                                ['<Tab>'] = cmp.mapping.select_next_item(),
                                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                        }),
                        sources = cmp.config.sources({
                                { name = "nvim_lsp" },
                                { name = "buffer" },
                        }),
                })
                cmp.setup.cmdline(":", {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = {
                                { name = "cmdline" },
                        },
                })
        end,
}
