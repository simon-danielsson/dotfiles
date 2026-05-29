-- env ------------------------------------------------------------------------

if vim.env.NVIM_MODE == "term" then
    vim.opt.shell = "/opt/homebrew/bin/fish"
    vim.cmd("terminal")
    vim.cmd("startinsert")
end

-- native ---------------------------------------------------------------------

require('options').setup()
require('keymaps').setup()
require('netrw').setup()
require('statusline').setup()
require('theme').setup()
require('autocommands').setup()
require('terminal').setup()
require('lsp').setup()
require('modules').setup()

-- plugins --------------------------------------------------------------------

vim.pack.add({
    "https://github.com/zk-org/zk-nvim.git",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim.git"
})

require('render-markdown').setup({
    completions = { lsp = { enabled = true } },
})

require('zk').setup({
    "zk-org/zk-nvim",
    name = "zk",
    opts = {
        picker = "select",

        lsp = {
            -- `config` is passed to `vim.lsp.start(config)`
            config = {
                name = "zk",
                cmd = { "zk", "lsp" },
                filetypes = { "markdown" },
                -- on_attach = ...
                -- etc, see `:h vim.lsp.start()`
            },

            -- automatically attach buffers in a zk notebook that match the given filetypes
            auto_attach = {
                enabled = true,
            },
        },
    },
})
