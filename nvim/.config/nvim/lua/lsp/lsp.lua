local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

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
vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    settings = {
        ['rust-analyzer'] = {},
    },
})
vim.lsp.enable('rust_analyzer')

-- python
vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        '.git',
    },
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic", -- or "strict"
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
})
vim.lsp.enable('pyright')

-- c/c++
vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--completion-style=detailed',
        '--header-insertion=iwyu',
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = {
        'compile_commands.json',
        'compile_flags.txt',
        '.git',
    },
})
vim.lsp.enable('clangd')

-- js/ts
vim.lsp.config('tsserver', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
    },
    root_markers = { 'package.json', 'tsconfig.json', '.git' },
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
            },
        },
    },
})
vim.lsp.enable('tsserver')

-- lua
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.git', '.luarc.json', '.luarc.jsonc' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim' }, -- rec nvim api
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
            telemetry = {
                enable = false,
            },
        },
    },
})
vim.lsp.enable('lua_ls')

-- css
vim.lsp.config('cssls', {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    capabilities = capabilities,
})
vim.lsp.enable('cssls')

-- html
vim.lsp.config('html', {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    capabilities = capabilities,
})
vim.lsp.enable('html')

-- spell-checking
vim.lsp.config['harper'] = {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = { 'markdown', 'text', 'tex', 'typst' }
}
vim.lsp.enable('harper')
