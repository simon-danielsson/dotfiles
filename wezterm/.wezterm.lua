local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- general --------------------------------------------------------------------

config.enable_scroll_bar = false
config.term = "xterm-256color"
config.front_end = "OpenGL"
config.min_scroll_bar_height = "2cell"
config.scroll_to_bottom_on_input = true
config.line_height = 1.0
config.cell_width = 1.0
config.animation_fps = 60
config.cursor_blink_rate = 0

-- colors ---------------------------------------------------------------------

config.color_scheme = 'Nebula (base16)'

local custom_c = {
    fg_1 = "#AAB3C0",
    fg_2 = "#6e6e87",
    mg_1 = "#40404f",
    bg_1 = "#2a2a33",
    bg_2 = "#25252d",
}

config.colors = {
    foreground = custom_c.fg_1,
    background = custom_c.bg_2,
    tab_bar = {
        background = custom_c.bg_1,
        active_tab = {
            bg_color = custom_c.bg_2,
            fg_color = custom_c.fg_1,
            intensity = 'Bold',
        },

        new_tab = {
            bg_color = custom_c.bg_1,
            fg_color = custom_c.bg_1,
        },

        inactive_tab = {
            bg_color = custom_c.bg_1,
            fg_color = custom_c.fg_2,
            intensity = 'Normal',
        },
    },
}

-- font -----------------------------------------------------------------------

config.font = wezterm.font 'Maple Mono NF'
config.font_size = 22

-- keybindings ----------------------------------------------------------------

config.keys = {
    {
        key = "+",
        mods = "CMD",
        action = wezterm.action.IncreaseFontSize,
    },
    {
        key = "-",
        mods = "CMD",
        action = wezterm.action.DecreaseFontSize,
    },
    {
        key = "0",
        mods = "CMD",
        action = wezterm.action.ResetFontSize,
    },
}

-- window ---------------------------------------------------------------------

config.window_decorations = "INTEGRATED_BUTTONS"
config.integrated_title_button_style = "MacOsNative"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

wezterm.on("format-tab-title", function(tab)
    local title = tab.active_pane.title
    if #title < 10 then
        title = title .. string.rep(" ", 10 - #title)
    end
    return {
        { Text = " " .. title .. " " },
    }
end)

config.window_frame = {
    font = wezterm.font { family = 'Maple Mono NF', weight = "Bold" },
    font_size = 10.0,
    active_titlebar_bg = custom_c.bg_1,
    inactive_titlebar_bg = custom_c.bg_1,

    button_fg = custom_c.fg_2,
    button_bg = custom_c.bg_2,

    button_hover_fg = custom_c.fg_2,
    button_hover_bg = custom_c.bg_2,
}

return config
