local java_plugins = {
        "https://github.com/mfussenegger/nvim-jdtls.git",
}

for _, plugin in ipairs(java_plugins) do
        vim.pack.add({ { src = plugin, opt = true, sync = true, silent = true } })
end

vim.lsp.enable("jdtls")

vim.lsp.config("jdtls", {
        settings = {
                java = {
                        -- Custom eclipse.jdt.ls options go here
                },
        },
})
vim.lsp.enable("jdtls")

vim.api.nvim_create_autocmd('FileType', {
        pattern = 'Java',
        callback = function(args)
                require 'lsp.jdtls_setup'.setup()
        end
})
