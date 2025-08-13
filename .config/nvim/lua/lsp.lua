local mason_plugins = {
        "https://github.com/williamboman/mason.nvim",
        "https://github.com/williamboman/mason-lspconfig.nvim",
        "https://github.com/neovim/nvim-lspconfig",
}

for _, plugin in ipairs(mason_plugins) do
        vim.pack.add({ { src = plugin, sync = true, silent = true } })
end

-- Safe requires
local has_mason, mason = pcall(require, "mason")
local has_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
local has_lspconfig, lspconfig = pcall(require, "lspconfig")
local has_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

vim.schedule(function()
        if has_mason and has_mason_lsp and has_lspconfig then
                mason.setup({
                        ui = {
                                border = "rounded",
                                icons = {
                                        package_installed = "✓",
                                        package_pending = "➜",
                                        package_uninstalled = "✗"
                                }
                        }
                })
                mason_lspconfig.setup({
                        ensure_installed = {
                                "lua_ls",
                                "pyright",
                        },
                        automatic_installation = false,
                })
                -- Correct function name: setup_handlers (plural)
                -- mason_lspconfig.setup_handlers({
                        -- function(server)
                                -- local opts = {}
                                -- if has_cmp_lsp then
                                -- opts.capabilities = cmp_nvim_lsp.default_capabilities()
                                -- end
                                -- lspconfig[server].setup(opts)
                                -- end,
                                -- })
                        end
                end)
