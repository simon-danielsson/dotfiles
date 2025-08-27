vim.pack.add({
        {
                src = "https://github.com/folke/flash.nvim",
                name = "flash",
                version = "2.1.0",
                sync = true,
                silent = true
        },
})

require("flash").setup({
        highlight = {
                -- show a backdrop with hl FlashBackdrop
                backdrop = true,
                -- Highlight the search matches
                matches = true,
                -- extmark priority
                priority = 5000,
                groups = {
                        match = "FlashMatch",
                        current = "FlashCurrent",
                        backdrop = "FlashBackdrop",
                        label = "FlashLabel",
                },
        },
        modes = {
                search = {
                        enabled = true,
                        highlight = { backdrop = false },
                        jump = { history = true, register = true, nohlsearch = true },
                },
        },
        labels = "ashtfmneoi",
        keys = {
                { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
                { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
                { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
                { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
})
