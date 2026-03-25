vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
        },
    },
})

-- rust
vim.lsp.enable('rust_analyzer')

-- c/c++
vim.lsp.enable('clangd')

-- python
vim.lsp.enable('pyright')

-- js/ts
vim.lsp.enable('ts_ls')

-- lua
vim.lsp.config('lua_ls', {
    root_markers = {
        { '.luarc.json',  '.luarc.jsonc' },
        { '.stylua.toml', 'stylua.toml' },
        { 'selene.toml',  'selene.yml' },
        '.git',
    },

    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local nvim_config = vim.fn.stdpath('config')
        local home = vim.env.HOME

        if fname:sub(1, #nvim_config) == nvim_config then
            on_dir(nvim_config)
            return
        end

        local root = vim.fs.root(fname, {
            '.luarc.json',
            '.luarc.jsonc',
            '.stylua.toml',
            'stylua.toml',
            'selene.toml',
            'selene.yml',
            '.git',
        })

        if root and root ~= home then
            on_dir(root)
            return
        end

        on_dir(vim.fs.dirname(fname))
    end,

    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
            },
        },
    },
})
vim.lsp.enable('lua_ls')

-- css
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config('cssls', {
    cmd = { 'vscode-css-language-server', '--stdio' },
    capabilities = capabilities,
})
vim.lsp.enable('cssls')

-- html
vim.lsp.config('html', {
    cmd = { 'vscode-html-language-server', '--stdio' },
    capabilities = capabilities,
})
vim.lsp.enable('html')

-- spell-checking
vim.lsp.config['harper'] = {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = { 'markdown', 'text', 'tex', 'typst' }
}
vim.lsp.enable('harper')
