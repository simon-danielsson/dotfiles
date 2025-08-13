local plugins = {
        { src = "https://github.com/rcarriga/nvim-notify", version = "master" },
        { src = "https://github.com/MunifTanjim/nui.nvim", version = "master" },
        { src = "https://github.com/folke/noice.nvim", version = "v4.10" },
}
for _, plugin in ipairs(plugins) do
        vim.pack.add({ plugin })
end

local highlights = {
        "NoiceCmdlinePopupBorder",
        "NoiceCmdlinePopup",
        "NoicePopupmenuBorder",
        "NoicePopupmenu"
}
for _, group in ipairs(highlights) do
        vim.cmd(string.format("highlight %s guibg=NONE", group))
end

local has_notify, notify = pcall(require, "notify")
if has_notify then
        vim.notify = notify.setup({
                -- options, e.g.,
                stages = "fade",
                timeout = 3000,
                background_colour = "#000000",
        })
end

local has_noice, noice = pcall(require, "noice")
if has_noice then
        noice.setup({
                cmdline = {
                        format = {
                                cmdline = { icon = "", title = "" },
                                search_down = { icon = " " },
                                search_up = { icon = " " },
                                filter = { icon = " " },
                                lua = { icon = " " },
                                help = { icon = " " },
                        },
                },
                lsp = {
                        progress = { enabled = true },
                        signature = { enabled = true },
                        hover = { enabled = true },
                        message = { enabled = true },
                },
                presets = {
                        bottom_search = false,      -- Classic bottom cmdline for search
                        command_palette = true,    -- Cmdline + popup UI
                        long_message_to_split = true,
                        lsp_doc_border = true,     -- Add border to hover/signature help
                },
                views = {
                        cmdline_popup = {
                                position = {
                                        row = "50%",
                                        col = "50%",
                                },
                                size = {
                                        width = 60,
                                        height = "auto",
                                },
                                border = {
                                        style = "rounded",
                                },
                                win_options = {
                                        winblend = 0,
                                },
                        },
                        popupmenu = {
                                border = {
                                        style = "rounded",
                                },
                                win_options = {
                                        winblend = 0,
                                },
                        },
                        hover = {
                                border = {
                                        style = "rounded",
                                },
                                win_options = {
                                        winblend = 0,
                                },
                        },
                        mini = {
                                win_options = {
                                        winblend = 0,
                                },
                        },
                        routes = {
                                filter = { event = "msg_show" },
                                view = "mini",
                        },
                },
        })
end
