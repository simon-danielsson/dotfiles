local icons = require("ui.icons")
local colors = require("ui.theme").colors
local aux_colors = require("ui.theme").aux_colors

local autocmd = vim.api.nvim_create_autocmd

-- ==== git ====

local git_cache = { status = "", last_update = 0 }
local max_repo_name_length = 15

local function git_info()
    local now = vim.loop.hrtime() / 1e9
    if now - git_cache.last_update > 2 then
        git_cache.last_update = now
        local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
        if branch == "" then
            git_cache.status = ""
        else
            local toplevel = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
            local repo = vim.fn.fnamemodify(toplevel, ":t")
            if #repo > max_repo_name_length then
                repo = repo:sub(1, max_repo_name_length) .. "..."
            end
            local status = vim.fn.systemlist("git status --porcelain=v2 --branch 2>/dev/null")
            local ahead, behind = 0, 0
            local added, modified, deleted, conflict = 0, 0, 0, 0
            for _, line in ipairs(status) do
                local a, b = line:match("^# branch%.ab%s+([%+%-]?%d+)%s+([%+%-]?%d+)")
                if a and b then
                    ahead, behind = tonumber(a) or 0, tonumber(b) or 0
                end
                local first_char = line:sub(1, 1)
                if first_char == "1" or first_char == "2" then
                    local parts_line = vim.split(line, "%s+")
                    local xy = parts_line[2] or ""
                    local x, y = xy:sub(1, 1), xy:sub(2, 2)
                    if x == "A" or y == "A" then added = added + 1 end
                    if x == "M" or y == "M" then modified = modified + 1 end
                    if x == "D" or y == "D" then deleted = deleted + 1 end
                elseif first_char == "?" then
                    added = added + 1
                elseif first_char == "u" then
                    conflict = conflict + 1
                end
            end
            local parts = {
                "│ " .. (icons.git.repo or "") .. " " .. repo,
                (icons.git.branch or "") .. " " .. branch
            }
            git_cache.status = table.concat(parts, " ")
        end
    end
    return git_cache.status
end

-- ==== utilities ====

local function python_venv()
    local ft = vim.bo.filetype
    local ext = vim.fn.expand("%:e")
    if ft ~= "python" and ext ~= "py" then
        return ""
    end
    local venv = vim.env.VIRTUAL_ENV
    if not venv or venv == "" then
        return ""
    end
    local venv_name = vim.fn.fnamemodify(venv, ":t")
    if venv_name == "venv" or venv_name == ".venv" or venv_name == "env" then
        local project = vim.fn.fnamemodify(venv, ":h:t")
        return " " .. "" .. project .. " "
    end
    return "  " .. " " .. venv_name .. " "
end

_G.macro_recording = ""
autocmd("RecordingEnter", {
    callback = function()
        local reg = vim.fn.reg_recording()
        if reg ~= "" then
            _G.macro_recording = " " .. ""
        end
    end,
})
autocmd("RecordingLeave", {
    callback = function()
        _G.macro_recording = ""
    end,
})

local function word_count()
    local ext = vim.fn.expand("%:e")
    if ext ~= "md" and ext ~= "typ" and ext ~= "txt" then
        return ""
    end
    local wc = vim.fn.wordcount()
    return wc.words > 0 and (" " .. wc.words .. " words │ ") or ""
end

local function mode_icon()
    -- return (icons.modes[vim.fn.mode()] .. " ") or (" " .. vim.fn.mode():upper())
    return (icons.modes[vim.fn.mode()] .. " ") or (" " .. vim.fn.mode():upper())
end

local function lsp_info()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
        return " │ " .. icons.ui.gear .. " " .. clients[1].name .. " "
    end
    return ""
end

-- ==== file ====

for ft, entry in pairs(icons.lang) do
    vim.api.nvim_set_hl(0, "FileIcon_" .. ft, { fg = entry.color, bg = "none" })
end
local function file_type_icon()
    local ft = vim.bo.filetype
    local entry = icons.lang[ft]
    if entry then
        local hl = " %#FileIcon_" .. ft .. "#"
        return hl .. entry.icon .. "%*"
    else
        return " " .. icons.ui.unrec_file
    end
end

local function short_filepath()
    local path = vim.fn.expand("%:p")
    local parts = vim.split(path, "/", { trimempty = true })
    local count = #parts
    return table.concat({
        parts[count - 2] or "",
        parts[count - 1] or "",
        parts[count] or ""
    }, "/")
end

local function file_type_filename()
    local ft = vim.bo.filetype
    local entry = icons.lang[ft]
    local hl = entry and "%#FileIcon_" .. ft .. "#" or "%#StatusFilename#"
    return hl .. " " .. short_filepath() .. " " .. "%*"
end

-- ==== scrollbar ====

local SBAR = { "󱃓 ", "󰪞 ", "󰪟 ", "󰪠 ", "󰪡 ", "󰪢 ", "󰪣 ", "󰪤 ", "󰪥 " }

local function scrollbar()
    local cur = vim.api.nvim_win_get_cursor(0)[1]
    local total = vim.api.nvim_buf_line_count(0)
    if total == 0 then return "" end
    local idx = math.floor((cur - 1) / total * #SBAR) + 1
    idx = math.max(1, math.min(idx, #SBAR))
    return "%#StatusScrollbar# " .. SBAR[idx]:rep(1) .. "%*"
end

-- ==== highlights ====

local g_bg = "none"

local statusline_highlights = {
    StatusLine       = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusLineNC     = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusLineNormal = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusLineTermNC = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusFilename   = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusFileType   = { fg = colors.fg_main, bg = g_bg, bold = false },
    StatusKey        = { fg = colors.fg_mid, bg = g_bg, bold = false },
    ColumnPercentage = { fg = colors.fg_main, bg = g_bg, bold = true },
    endBit           = { fg = colors.bg_deep2, bg = g_bg, },
    StatusPosition   = { fg = colors.fg_mid, bg = g_bg, bold = false },
    StatusMode       = { fg = colors.fg_mid, bg = g_bg },
    StatusScrollbar  = { fg = aux_colors.accent, bg = g_bg, bold = true },
    StatusSelection  = { fg = colors.fg_mid, bg = g_bg, bold = false },
    StatusGit        = { fg = colors.fg_mid, bg = g_bg },
    StatusLsp        = { fg = colors.fg_mid, bg = g_bg },
    MacroRec         = { fg = aux_colors.macro_statusline, bg = "none" },
}
for group, opts in pairs(statusline_highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end

-- ==== assembly ====

_G.Statusline = function()
    local parts = {
        "%#StatusMode#  " .. mode_icon() .. " │",
        "%#StatusFileType#" .. file_type_icon() .. "",
        file_type_filename(),
        "%#StatusGit#" .. git_info(),
        "%#StatusLsp#" .. lsp_info() .. "",
        "%#StatusLsp#" .. python_venv() .. "",
        "%=",
    }

    table.insert(parts, "%#StatusMode#" .. word_count())
    table.insert(parts, "%#StatusPosition#" .. "%l:" .. "%c")
    table.insert(parts, scrollbar())
    if _G.macro_recording ~= "" then
        table.insert(parts, "%#MacroRec#" .. "" .. _G.macro_recording)
    end

    return table.concat(parts)
end

vim.api.nvim_create_autocmd("TermClose", {
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline()"
    end,
})
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.opt_local.winhighlight = "Normal:Normal,StatusLine:Normal,StatusLineNC:Normal"
        vim.opt_local.statusline = " "
    end,
})
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline()"
    end,
})
