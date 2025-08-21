local icons = require("ui.icons")
local colors = require("ui.theme").colors
local aux_colors = require("ui.theme").aux_colors

local autocmd = vim.api.nvim_create_autocmd

-- ======================================================
-- Git
-- ======================================================

local git_cache = { status = "", last_update = 0 }
local function git_info()
        local now = vim.loop.hrtime() / 1e9
        if now - git_cache.last_update > 2 then
                git_cache.last_update = now
                local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
                if branch == "" then
                        git_cache.status = ""
                else
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
                        local parts = { "│ " .. (icons.git.branch or "") .. " " .. branch }
                        if ahead > 0 then table.insert(parts, "↑" .. ahead) end
                        if behind > 0 then table.insert(parts, "↓" .. behind) end
                        if added > 0 then table.insert(parts, (icons.git.add or "+") .. " " .. added) end
                        if modified > 0 then table.insert(parts, (icons.git.modify or "~") .. " " .. modified) end
                        if deleted > 0 then table.insert(parts, (icons.git.delete or "-") .. " " .. deleted) end
                        if conflict > 0 then table.insert(parts, (icons.git.conflict or "!") .. " " .. conflict) end
                        git_cache.status = table.concat(parts, " ")
                end
        end
        return git_cache.status
end
-- ======================================================
-- Utilities
-- ======================================================

local function selected_lines()
        if vim.fn.mode():find("[vV]") == nil then
                return ""
        end
        local start_pos = vim.fn.getpos("v")[2]
        local end_pos = vim.fn.getpos(".")[2]
        local lines = math.abs(end_pos - start_pos) + 1
        return " " .. lines .. " lines"
end

_G.macro_recording = ""
autocmd("RecordingEnter", {
        callback = function()
                local reg = vim.fn.reg_recording()
                if reg ~= "" then
                        -- _G.macro_recording = "    " .. icons.ui.rec_macro .. " @" .. reg .. "    "
                        _G.macro_recording = "    " .. icons.ui.rec_macro .. "    "
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
        return wc.words > 0 and (icons.ui.wordcount .. " " .. wc.words .. " words ") or ""
end

local function mode_icon()
        return (icons.modes[vim.fn.mode()] .. " ") or (" " .. vim.fn.mode():upper())
end

local function lsp_info()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients > 0 then
                return "│ " .. icons.ui.gear .. " " .. clients[1].name .. " "
        end
        return ""
end

-- ======================================================
-- Filetype & Filename
-- ======================================================

for ft, entry in pairs(icons.lang) do
        vim.api.nvim_set_hl(0, "FileIcon_" .. ft, { fg = entry.color, bg = colors.bg_deep })
end
local function file_type_icon()
        local ft = vim.bo.filetype
        local entry = icons.lang[ft]
        if entry then
                local hl = "%#FileIcon_" .. ft .. "#"
                return hl .. entry.icon .. "%*"
        else
                return icons.ui.unrec_file
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
        return hl .. short_filepath() .. "%*"
end

-- ======================================================
-- Diagnostics
-- ======================================================

local diagnostics_levels = {
        { name = "Error", icon = icons.diagn.error,       severity = vim.diagnostic.severity.ERROR },
        { name = "Warn",  icon = icons.diagn.warning,     severity = vim.diagnostic.severity.WARN },
        { name = "Info",  icon = icons.diagn.information, severity = vim.diagnostic.severity.INFO },
        { name = "Hint",  icon = icons.diagn.hint,        severity = vim.diagnostic.severity.HINT },
}

local function diagnostics_component(name, icon, severity)
        local count = #vim.diagnostic.get(0, { severity = severity })
        return count > 0 and (icon .. " " .. count .. " ") or ""
end

local function diagnostics_summary()
        for _, level in ipairs(diagnostics_levels) do
                if #vim.diagnostic.get(0, { severity = level.severity }) > 0 then
                        return ""
                end
        end
        return ""
end

for _, level in ipairs(diagnostics_levels) do
        vim.api.nvim_set_hl(0, "StatusDiagnostics" .. level.name, { link = "Diagnostic" .. level.name })
end

-- ======================================================
-- Scrollbar
-- ======================================================

local SBAR = { "▔", "🮂", "🬂", "🮃", "▀", "▄", "▃", "🬭", "▂", "▁" }

local function scrollbar()
        local cur = vim.api.nvim_win_get_cursor(0)[1]
        local total = vim.api.nvim_buf_line_count(0)
        if total == 0 then return "" end
        local idx = math.floor((cur - 1) / total * #SBAR) + 1
        idx = math.max(1, math.min(idx, #SBAR))
        return "%#StatusScrollbar#" .. SBAR[idx]:rep(2) .. "%*"
end

-- ======================================================
-- Highlights
-- ======================================================

local statusline_highlights = {
        StatusLine       = { fg = colors.fg_main, bg = colors.bg_deep, bold = false },
        StatusFilename   = { fg = colors.fg_main, bg = colors.bg_deep, bold = false },
        StatusFileType   = { fg = colors.fg_main, bg = colors.bg_deep, bold = false },
        ColumnPercentage = { fg = colors.fg_main, bg = colors.bg_deep, bold = true },
        StatusPosition   = { fg = colors.fg_main, bg = colors.bg_mid, bold = true },
        StatusMode       = { fg = colors.fg_main, bg = colors.bg_mid },
        StatusScrollbar  = { fg = colors.fg_main, bg = colors.fg_mid, bold = true },
        StatusGit        = { fg = colors.fg_mid, bg = colors.bg_deep },
        StatusSelection  = { fg = colors.fg_mid, bg = colors.bg_mid, bold = true },
        MacroRec         = { fg = colors.fg_main, bg = aux_colors.macro_statusline },
}
for group, opts in pairs(statusline_highlights) do
        vim.api.nvim_set_hl(0, group, opts)
end

-- ======================================================
-- Statusline Assembly
-- ======================================================

_G.Statusline = function()
        local parts = {
                "%#StatusMode#  " .. mode_icon() .. " ",
                "%#StatusFileType# " .. file_type_icon() .. " ",
                file_type_filename(),
                " %#StatusGit#" .. git_info(),
                " %#StatusGit#" .. lsp_info() .. " ",
                "%=",
        }
        for _, level in ipairs(diagnostics_levels) do
                table.insert(parts, "%#StatusDiagnostics" .. level.name .. "#")
                table.insert(parts, diagnostics_component(level.name, level.icon, level.severity))
        end
        table.insert(parts, "%#StatusDiagnosticsSummary#" .. diagnostics_summary())
        table.insert(parts, "%#StatusFileSize#" .. word_count())
        table.insert(parts, "%#StatusSelection#" .. selected_lines())
        table.insert(parts, "%#StatusPosition# " .. "%l:%c ")
        table.insert(parts, scrollbar())
        if _G.macro_recording ~= "" then
                table.insert(parts, "%#MacroRec#" .. _G.macro_recording)
        end
        return table.concat(parts)
end

vim.opt.statusline = "%!v:lua.Statusline()"
