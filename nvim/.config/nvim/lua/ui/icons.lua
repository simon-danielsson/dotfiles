local M = {}

M.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

M.indent = {
        big_thick = "█",
        med_thick = "▊",
        sma_thick = "▐",
        double = "║",
        thin = "│",
        dotted = "┊",
        dotted_alt = "⋮",
}

M.git = {
        add = "",
        branch = "",
        diff = "",
        git = "󰊢",
        ignore = "",
        modify = "",
        delete = "",
        rename = "",
        repo = "",
        unmerged = "󰘬",
        untracked = "󰞋",
        unstaged = "",
        staged = "",
        conflict = "",
}

M.ui = {
        location = "󰟙",
        file = "",
        wordcount = "",
        memory = "",
        unrec_file = "",
        rec_macro = "󰻂",
        arrow_left = "",
        arrow_right = "",
        arrow_up = "",
        arrow_down = "",
        gear = "",
        folder = "󰷏",
        time = "",
        quit = "󰈆",
        virtual_env = "",
}

M.lang = {
        python = { icon = "", color = "#FED141" },
        haskell = { icon = "", color = "#C678DD" },
        javascript = { icon = "", color = "#F6DE42" },
        html = { icon = "", color = "#E34C26" },
        css = { icon = "", color = "#28AAE1" },
        json = { icon = "", color = "#cbcb41" },
        markdown = { icon = "", color = "#036F36" },
        vim = { icon = "", color = "#019833" },
        sh = { icon = "", color = "#89e051" },
        gd = { icon = "", color = "#478cbf" },
        gdscript = { icon = "", color = "#478cbf" },
        toml = { icon = "", color = "#6e6e6e" },
        yaml = { icon = "", color = "#6e6e6e" },
        dockerfile = { icon = "", color = "#0db7ed" },
        go = { icon = "󰊠", color = "#00ADD8" },
        rust = { icon = "", color = "#EC4E45" },
        typst = { icon = "", color = "#dea584" },
        c = { icon = "", color = "#6798D1" },
        cpp = { icon = "", color = "#00599C" },
        lua = { icon = "", color = "#51A1FF" },
        java = { icon = "", color = "#F34335" },
        php = { icon = "", color = "#8892be" },
        ruby = { icon = "", color = "#701516" },
        swift = { icon = "", color = "#ffac45" },
        tsx = { icon = "", color = "#2b7489" },
        jsx = { icon = "", color = "#61dafb" },
}

M.noice = {
        title = "",
        cmd = "",
        search_down = " ",
        search = "",
        search_up = " ",
        filter = "󰈳",
        lua = "",
        help = "",
}

M.telescope = {
        prompt_prefix = " ",
        selection_caret = " ",
}

M.trident = {
        main_icon = "󰆹",
        fallback = "",
}

M.diagn = {
        error = "󰯈",
        warning = "",
        information = "",
        question = "",
        hint = "",
}

M.modes = {
        n = "",
        i = "",
        v = "",
        V = "",
        ["\22"] = "󰈚",
        c = "",
        s = "",
        S = "",
        ["\19"] = "󰈚",
        R = "",
        r = "",
        ["!"] = "",
        t = "",
}

M.dap = {
        Breakp = "󰝥",
        BreakpCond = "󰟃",
        BreakpReje = "",
        LogPoint = "",
        Pause = "",
        Play = "",
        RunLast = "↻",
        StepBack = "",
        StepInto = "󰆹",
        StepOut = "󰆸",
        StepOver = "󰆷",
        Stopped = "",
        Terminate = "󰝤",
}

return M
