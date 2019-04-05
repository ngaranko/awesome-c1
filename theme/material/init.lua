--[[
theme overrides on top of gtk theme
--]]
local t = {}
local dpi = require('beautiful').xresources.apply_dpi
local theme_root = require('gears.filesystem').get_configuration_dir() .. '/theme/material/'
local shape = require('gears.shape')

-- reusable colors
local text_normal    = '#abb7bc'
local bg_normal     = '#6b0101'
local text_focus    = '#edf1f2'
local bg_focus      = '#ff3019'
local menu_bg       = '#1e1e1e'
local menu_border   = '#000000'


local font = 'SF Pro Display '

--GLOBAL DEFAULTS
t.bg_normal             = menu_bg
t.fg_normal             = text_focus
t.bg_focus              = bg_focus

t.wallpaper     = theme_root .. 'wallpaper.jpg'
t.font = 'SF Pro Display 14'


-- CLIENT SECTION

t.corner_radius = dpi(3)
t.border_width  = dpi(2)
t.border_normal = menu_bg
t.border_focus  = bg_focus
t.border_marked = bg_focus



-- TITLEBAR SECTION

t.titlebar_fg_normal    = text_normal
t.titlebar_bg_normal    = bg_normal
t.titlebar_fg_focus     = text_focus 
t.titlebar_bg_focus     = bg_focus 

local titlebar_ic = theme_root .. '/icons/titlebar/'

t.titlebar_close_button_normal = titlebar_ic .. "close_normal.svg"
t.titlebar_close_button_normal_hover = titlebar_ic .. "close_normal_hover.svg"
t.titlebar_close_button_focus  = titlebar_ic .."close_focus.svg"
t.titlebar_close_button_focus_hover = titlebar_ic .. "close_focus_hover.svg"

t.titlebar_minimize_button_normal = titlebar_ic .. "min_normal.svg"
t.titlebar_minimize_button_normal_hover = titlebar_ic .. "min_normal_hover.svg"
t.titlebar_minimize_button_focus  = titlebar_ic .. "min_focus.svg"
t.titlebar_minimize_button_focus_hover  = titlebar_ic .. "min_focus_hover.svg"

t.titlebar_maximized_button_normal_inactive = titlebar_ic .. "max_normal.svg"
t.titlebar_maximized_button_normal_active = titlebar_ic .. "max_normal.svg"
t.titlebar_maximized_button_normal_active_hover = titlebar_ic .."max_normal_hover_active.svg"
t.titlebar_maximized_button_normal_inactive_hover = titlebar_ic .."max_normal_hover.svg"
t.titlebar_maximized_button_focus_inactive  = titlebar_ic .. "max_focus.svg"
t.titlebar_maximized_button_focus_active  = titlebar_ic .. "max_focus.svg"
t.titlebar_maximized_button_focus_inactive_hover = titlebar_ic .. "max_focus_hover.svg"
t.titlebar_maximized_button_focus_active_hover = titlebar_ic .. "max_focus_hover_active.svg"

--TOOLTIP SECTION

t.tooltip_border_color  = bg_focus 
t.tooltip_bg            = menu_bg
t.tooltip_fg            = text_focus
t.tooltip_font          = font .. '10'
t.tooltip_border_width  = dpi(1)
t.tooltip_opacity       = 50
t.tooltip_shape         = function(cr,w,h) shape.rounded_rect(cr,w,h,3) end
-- WIBAR SECTION

t.wibar_border_color    = menu_border
t.wibar_border_width    = dpi(0)
t.wibar_ontop           = true
t.wibar_type            = 'dock'
t.wibar_fg              = text_focus
t.wibar_bg              = menu_bg .. 'E3'
t.wibar_shape           = shape.rectangle


-- TAG SECTION --
t.master_width_factor = 0.5
t.useless_gap = dpi(7)
t.gap_single_client = false
t.master_fill_policy = 'expand'
t.master_count = 1
t.column_count = 1

--TAGLIST SECTION --
t.taglist_icons = {
    utf8.char(61461),
    utf8.char(63288),
    utf8.char(63215),
    utf8.char(61728),
    utf8.char(61729),
    utf8.char(61848),
    utf8.char(63942),
    utf8.char(63645),
}
local layout_ic = theme_root .. '/icons/layouts/'
t.layout_tile = layout_ic .. 'tiled.svg'
t.layout_floating = layout_ic .. 'floating.svg'
t.taglist_fg_focus  = text_focus
t.taglist_width     = dpi(40)
t.taglist_spacing   = dpi(3)
t.taglist_font      = 'SF Pro Display 13'
t.icon_font         = 'DroidSansMono Nerd Font 21'
-- color pattern
t.taglist_bg_focus  = 'linear:0,0:' .. t.taglist_width .. ',0:0,' .. bg_focus .. ':0.12,' .. bg_focus .. ':0.12,#00000000:1,' .. '#00000000' 
-- color of index popups
t.index_bg          = '#bfb1b188'


return t
