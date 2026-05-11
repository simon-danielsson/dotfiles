local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- general --------------------------------------------------------------------

config.enable_scroll_bar = false
config.term = "xterm-256color"
config.front_end = "OpenGL"
config.min_scroll_bar_height = "2cell"

config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- colors ---------------------------------------------------------------------

config.color_scheme = 'Catppuccin Frappe'

local custom_c = {
    fg_1 = "#AAB3C0",
    fg_2 = "#6e6e87",
    mg_1 = "#40404f",
    bg_1 = "#2a2a33",
    bg_2 = "#25252d",
}

config.colors = {
    cursor_bg = custom_c.fg_1,
    cursor_border = custom_c.fg_1,
    cursor_fg = custom_c.bg_2,

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

config.enable_kitty_keyboard = false
config.enable_csi_u_key_encoding = false
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
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

    {
        key = "r",
        mods = "CMD",
        action = wezterm.action.PromptInputLine {
            description = "rename tab",
            action = wezterm.action_callback(function(window, _, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },

    {
        key = "d",
        mods = "CMD",
        action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    {
        key = "N",
        mods = "CMD|SHIFT",
        action = wezterm.action.ActivatePaneDirection "Left",
    },
    {
        key = "I",
        mods = "CMD|SHIFT",
        action = wezterm.action.ActivatePaneDirection "Right",
    },

    {
        key = "D",
        mods = "CMD|SHIFT",
        action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
        key = "E",
        mods = "CMD|SHIFT",
        action = wezterm.action.ActivatePaneDirection "Down",
    },
    {
        key = "O",
        mods = "CMD|SHIFT",
        action = wezterm.action.ActivatePaneDirection "Up",
    },
}

-- window ---------------------------------------------------------------------

config.window_decorations = "INTEGRATED_BUTTONS"
config.integrated_title_button_style = "MacOsNative"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

wezterm.on("format-tab-title", function(tab)
    local title = tab.tab_title
    if title == nil or #title == 0 then
        title = tab.active_pane.title
    end
    if #title < 10 then
        title = title .. string.rep(" ", 10 - #title)
    end
    return {
        { Text = " " .. title .. " " },
    }
end)

config.window_frame = {
    font = wezterm.font { family = 'Maple Mono NF', weight = "Bold" },
    active_titlebar_bg = custom_c.bg_1,
    inactive_titlebar_bg = custom_c.bg_1,

    button_fg = custom_c.fg_2,
    button_bg = custom_c.bg_2,

    button_hover_fg = custom_c.fg_2,
    button_hover_bg = custom_c.bg_2,
}

return config
