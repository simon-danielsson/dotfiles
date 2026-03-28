vim.opt.completeopt = { "noselect", "menu", "menuone", "popup" }
vim.o.inccommand    = 'nosplit'
vim.opt.pumborder   = "rounded"

-- code

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local cp = client.server_capabilities.completionProvider
        if cp then
            cp.triggerCharacters = cp.triggerCharacters or {}
            for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._"):gmatch(".") do
                if not vim.tbl_contains(cp.triggerCharacters, c) then
                    table.insert(cp.triggerCharacters, c)
                end
            end
        end
        vim.lsp.completion.enable(true, client.id, args.buf, {
            autotrigger = true,
        })
    end,
})

-- commandline

vim.opt.wildmode = "noselect:lastused,full"
vim.opt.wildoptions = "pum"
vim.api.nvim_create_autocmd("CmdlineChanged", {
    pattern = { ":", "/", "?" },
    callback = function()
        vim.fn.wildtrigger()
    end,
})
