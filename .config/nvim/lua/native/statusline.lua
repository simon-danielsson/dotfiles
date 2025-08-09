local icons = require("native.icons")

-- ======================================================
-- Utility Functions
-- ======================================================

local function git_branch()
        local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
        return branch ~= "" and "│  " .. branch or ""
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
        return icons.modes[vim.fn.mode()] or (" " .. vim.fn.mode():upper())
end

-- ======================================================
-- Filetype Icons Setup
-- ======================================================
local filetype_icons = icons.lang
for ft, entry in pairs(filetype_icons) do
        vim.api.nvim_set_hl(0, "FileIcon_" .. ft, { fg = entry.color, bg = "#262626" })
end

local function file_type_icon()
        local entry = filetype_icons[vim.bo.filetype]
        return entry and entry.icon or (vim.bo.filetype or "")
end

-- ======================================================
-- Diagnostics
-- ======================================================

local diagnostics_levels = {
        { name = "Error",
                icon = icons.diagn.error,
                severity = vim.diagnostic.severity.ERROR },
        { name = "Warn",
                icon = icons.diagn.warning,
                severity = vim.diagnostic.severity.WARN },
        { name = "Info",
                icon = icons.diagn.information,
                severity = vim.diagnostic.severity.INFO },
        { name = "Hint",
                icon = icons.diagn.hint,
                severity = vim.diagnostic.severity.HINT },
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

local bg_dark = "#262626"
local bg_dim = "#444444"
local fg_white = "#ffffff"

-- Base highlights
local base_groups = {
        "StatusFilename", "StatusGit", "StatusFileType",   "StatusLine",
        "StatusFileSize", "StatusLSP", "ColumnPercentage", "StatusModified"
}
for _, group in ipairs(base_groups) do
        set_hl(group, fg_white, bg_dark, false)
end

-- Special highlights
set_hl("ColumnPercentage", fg_white, bg_dark, true)
set_hl("StatusMode", fg_white, bg_dim, true)
set_hl("StatusPosition", fg_white, bg_dim, true)
set_hl("StatusModified", "#e06c75", bg_dark, true)

-- Link diagnostic highlights
for _, level in ipairs(diagnostics_levels) do
        vim.api.nvim_set_hl(0, "StatusDiagnostics" .. level.name, { link = "Diagnostic" .. level.name })
end

-- ======================================================
-- Statusline Assembly
-- ======================================================

_G.Statusline = function()
        local parts = {
                "%#StatusMode#  " .. mode_icon() .. " ",
                "%#StatusFileType# " .. file_type_icon(),
                "%#StatusFilename# " .. short_filepath(),
                "%#StatusGit# " .. git_branch(),
                "%=",
        }

-- Diagnostics
        for _, level in ipairs(diagnostics_levels) do
                table.insert(parts, "%#StatusDiagnostics" .. level.name .. "#")
                table.insert(parts, diagnostics_component(level.name, level.icon, level.severity))
        end

-- Summary
        table.insert(parts, "%#StatusDiagnosticsSummary#" .. diagnostics_summary())

-- File size, lines, cursor pos
        table.insert(parts, "%#StatusFileSize#"  .. icons.ui.memory .. " " .. file_size() .. " ")
        table.insert(parts, "%#StatusFileSize#"  .. icons.ui.file .. " %L ")
        table.insert(parts, "%#StatusPosition# " .. icons.ui.location .. " %l:%c ")

return table.concat(parts)
end

vim.opt.statusline = "%!v:lua.Statusline()"
