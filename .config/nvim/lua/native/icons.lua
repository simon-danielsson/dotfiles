local M = {}

M.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

M.git = {
        add =           "",
        branch =        "",
        diff =          "",
        git =           "󰊢",
        ignore =        "",
        mod =           "M",
        mod_alt =       "",
        remove =        "",
        rename =        "",
        repo =          "",
        unmerged =      "󰘬",
        untracked =     "󰞋",
        unstaged =      "",
        staged =        "",
        conflict =      "",
}

M.ui = {
        location =      "󰟙",
        file =          "",
        memory =        "",
}

M.lang = {
        lua =           { icon = "", color = "#51A1FF" },
        python =        { icon = "", color = "#FFD43B" },
        javascript =    { icon = "", color = "#F7DF1E" },
        html =          { icon = "", color = "#E34C26" },
        css =           { icon = "", color = "#264de4" },
        json =          { icon = "", color = "#cbcb41" },
        markdown =      { icon = "", color = "#519aba" },
        vim =           { icon = "", color = "#019833" },
        sh =            { icon = "", color = "#89e051" },
        gd =            { icon = "", color = "#478cbf" },
        gdscript =      { icon = "", color = "#478cbf" },
        toml =          { icon = "", color = "#6e6e6e" },
        yaml =          { icon = "", color = "#6e6e6e" },
        dockerfile =    { icon = "", color = "#0db7ed" },
        go =            { icon = "󰊠", color = "#00ADD8" },
        rust =          { icon = "", color = "#dea584" },
        typst =         { icon = "", color = "#dea584" },
        c =             { icon = "", color = "#555555" },
        cpp =           { icon = "", color = "#00599C" },
        java =          { icon = "", color = "#b07219" },
        php =           { icon = "", color = "#8892be" },
        ruby =          { icon = "", color = "#701516" },
        swift =         { icon = "", color = "#ffac45" },
        tsx =           { icon = "", color = "#2b7489" },
        jsx =           { icon = "", color = "#61dafb" },
}

M.diagn = {
        error =         "󰯈",
        warning =       "",
        information =   "",
        question =      "",
        hint =          "",
}

M.modes = {
        n =             "",
        i =             "",
        v =             "",
        V =             "",
        ["\22"] =       "󰈚",
        c =             "",
        s =             "",
        S =             "",
        ["\19"] =       "󰈚",
        R =             "",
        r =             "",
        ["!"] =         "",
        t =             "",
}

M.dap = {
        Breakp =        "󰝥",
        BreakpCond =    "󰟃",
        BreakpReje =    "",
        LogPoint =      "",
        Pause =         "",
        Play =          "",
        RunLast =       "↻",
        StepBack =      "",
        StepInto =      "󰆹",
        StepOut =       "󰆸",
        StepOver =      "󰆷",
        Stopped =       "",
        Terminate =     "󰝤",
}

return M
