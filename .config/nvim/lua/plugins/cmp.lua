local cmp_plugins = {
        "https://github.com/hrsh7th/nvim-cmp",
        "https://github.com/hrsh7th/cmp-nvim-lsp",
        "https://github.com/hrsh7th/cmp-buffer",
        "https://github.com/hrsh7th/cmp-path",
        "https://github.com/hrsh7th/cmp-cmdline",
}
for _, plugin in ipairs(cmp_plugins) do
        vim.pack.add({ { src = plugin, sync = true, silent = true } })
end

local has_cmp, cmp = pcall(require, "cmp")
if has_cmp then
        cmp.setup({
                window = {
                        completion = cmp.config.window.bordered({ border = "rounded" }),
                        documentation = cmp.config.window.bordered({ border = "rounded" }),
                },
                mapping = cmp.mapping.preset.insert({
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        ["<Tab>"] = cmp.mapping.select_next_item(),
                        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
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
end
