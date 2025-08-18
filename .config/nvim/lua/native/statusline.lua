local icons = require("native.icons")

local bg_dark = "#262626"
local bg_dim = "#444444"
local fg_white = "#ffffff"

-- ======================================================
-- Git Setup
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
                        local ahead, behind, added, modified, deleted = 0, 0, 0, 0, 0
                        for _, line in ipairs(status) do
                                local a, b = line:match("^# branch%.ab%s+([%+%-]?%d+)%s+([%+%-]?%d+)")
                                if a and b then
                                        ahead, behind = tonumber(a) or 0, tonumber(b) or 0
                                end
                                if line:match("^1 ") or line:match("^2 ") then
                                        local xy = line:sub(3, 4)
                                        if xy:match("A") then added = added + 1 end
                                        if xy:match("M") then modified = modified + 1 end
                                        if xy:match("D") then deleted = deleted + 1 end
                                end
                        end
                        local parts = { icons.git.branch .. " " .. branch }
                        if ahead > 0 then table.insert(parts, "↑" .. ahead) end
                        if behind > 0 then table.insert(parts, "↓" .. behind) end
                        if added > 0 then table.insert(parts, icons.git.add .. " " .. added) end
                        if modified > 0 then table.insert(parts, icons.git.mod_alt .. " " .. modified) end
                        if deleted > 0 then table.insert(parts, icons.git.remove .. " " .. deleted) end
                        git_cache.status = "│ " .. table.concat(parts, " ")
                end
        end
        return git_cache.status
end

-- ======================================================
-- Utilities
-- ======================================================

local function word_count()
        local ext = vim.fn.expand("%:e")
        if ext ~= "md" and ext ~= "typ" and ext ~= "txt" then
                return ""
        end
        local wc = vim.fn.wordcount()
        return wc.words > 0 and (icons.ui.wordcount .. " " .. wc.words .. " words ") or ""
end
local function file_size()
        local size = vim.fn.getfsize(vim.fn.expand('%'))
        if size < 0 then return "" end
        if size < 1024 then
                return size .. "B"
        elseif size < 1024 * 1024 then
                return string.format("%.1fK", size / 1024)
        else
                return string.format("%.1fM", size / 1024 / 1024)
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

local function mode_icon()
        return (icons.modes[vim.fn.mode()] .. " ") or (" " .. vim.fn.mode():upper())
end

-- ======================================================
-- Filetype & Filename
-- ======================================================

for ft, entry in pairs(icons.lang) do
        vim.api.nvim_set_hl(0, "FileIcon_" .. ft, { fg = entry.color, bg = bg_dark })
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

local function file_type_filename()
        local ft = vim.bo.filetype
        local entry = icons.lang[ft]
        local hl = entry and "%#FileIcon_" .. ft .. "#" or "%#StatusFilename#"
        return hl .. short_filepath() .. "%*"
end

-- ======================================================
-- Diagnostics Setup
-- ======================================================

local diagnostics_levels = {
        { name = "Error", icon = icons.diagn.error, severity = vim.diagnostic.severity.ERROR },
        { name = "Warn",  icon = icons.diagn.warning, severity = vim.diagnostic.severity.WARN },
        { name = "Info",  icon = icons.diagn.information, severity = vim.diagnostic.severity.INFO },
        { name = "Hint",  icon = icons.diagn.hint, severity = vim.diagnostic.severity.HINT },
}

local function diagnostics_component(name, icon, severity)
        local count = #vim.diagnostic.get(0, { severity = severity })
        return count > 0 and (icon .. " " .. count .. " ") or ""
end

local function diagnostics_summary()
        for _, level in ipairs(diagnostics_levels) do
                if #vim.diagnostic.get(0, { severity = level.severity }) > 0 then
                        return "│ "
                end
        end
        return ""
end

-- ======================================================
-- Highlights
-- ======================================================

local function set_hl(group, fg, bg, bold)
        vim.api.nvim_set_hl(0, group, { fg = fg, bg = bg, bold = bold })
end

local base_groups = {
        "StatusFilename", "StatusGit", "StatusFileType", "StatusLine",
        "StatusFileSize", "StatusLSP", "ColumnPercentage", "StatusModified"
}
for _, group in ipairs(base_groups) do
        set_hl(group, fg_white, bg_dark, false)
end

set_hl("ColumnPercentage", fg_white, bg_dark, true)
set_hl("StatusPosition", fg_white, bg_dim, true)
set_hl("StatusMode", fg_white, bg_dim, true)
set_hl("StatusModified", "#e06c75", bg_dark, true)

for _, level in ipairs(diagnostics_levels) do
        vim.api.nvim_set_hl(0, "StatusDiagnostics" .. level.name, { link = "Diagnostic" .. level.name })
end

-- ======================================================
-- Statusline Assembly
-- ======================================================

_G.Statusline = function()
        local parts = {
                "%#StatusMode#  " .. mode_icon() .. " ",
                "%#StatusFileType# " .. file_type_icon() .. " ",
                file_type_filename(),
                "%#StatusGit# " .. git_info(),
                "%=",
        }
        for _, level in ipairs(diagnostics_levels) do
                table.insert(parts, "%#StatusDiagnostics" .. level.name .. "#")
                table.insert(parts, diagnostics_component(level.name, level.icon, level.severity))
        end

table.insert(parts, "%#StatusDiagnosticsSummary#" .. diagnostics_summary())
        table.insert(parts, "%#StatusFileSize#" .. word_count())
        table.insert(parts, "%#StatusFileSize#" .. icons.ui.memory .. " " .. file_size() .. " ")
        table.insert(parts, "%#StatusFileSize#" .. icons.ui.file .. " %L ")
        table.insert(parts, "%#StatusPosition# " .. icons.ui.location .. " %l:%c ")

return table.concat(parts)
end

vim.opt.statusline = "%!v:lua.Statusline()"
