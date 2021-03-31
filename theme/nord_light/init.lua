--[[
theme overrides on top of gtk theme
--]]
local t = {}
local dpi = require('beautiful').xresources.apply_dpi
local theme_root = require('gears.filesystem').get_configuration_dir() .. '/theme/pop/'
local shape = require('gears.shape')

-- color scheme
-- See: https://github.com/Jaredk3nt/laserwave
local colors = {
  '#2E3440', -- ?
  '#4C566A', -- 2. Menu, clock, inactive tags
  '#5E81AC', -- 3. Menu active, focused tags
  '#E5E9F0', -- 4. Background of everything
  '#3B4252', -- 5. Occupied tag
  '#E5E9F0', -- 6. Borders
  '#81A1C1', -- 7. Random minor things
  '#ffe261', -- 8. Warnings
  '#4C566A',  -- 9. Greyed out elements
  '#A3BE8C'
}

local invisible = colors[6]

local font = 'Source Code Pro '

--GLOBAL DEFAULTS
t.bg_normal             = colors[4]
t.fg_normal             = colors[2]
t.bg_focus              = colors[3]
t.fg_focus              = colors[2]

t.wallpaper     = theme_root .. 'wallpaper.jpg'
t.font = font .. '10'
t.icon_font         = 'Monaco Nerd Font '
t.icon_theme        = 'Paprius-Light'
t.rofi_theme_name   = 'purple'

-- CLIENT SECTION

t.corner_radius = dpi(2)
t.cust_border_width = dpi(0) -- use this to change side width
t.border_width  = dpi(0)
t.border_color = colors[5]
t.border_normal = invisible
t.border_focus  = invisible
t.border_marked = invisible



-- TITLEBAR SECTION

t.titlebar_height = dpi(0)
t.titlebar_fg_normal    = colors[1]
t.titlebar_bg_normal    = t.border_normal
t.titlebar_fg_focus     = colors[3]
t.titlebar_bg_focus     = t.border_focus
-- CUSTOM TITLEBAR
t.titlebar_bg_focus_custom  = colors[3]
t.titlebar_bg_normal_custom = colors[2]

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

t.tooltip_border_color  = colors[1]
t.tooltip_bg            = colors[1]
t.tooltip_fg            = colors[2]
t.tooltip_font          = font .. '9'
t.tooltip_border_width  = dpi(0)
t.tooltip_opacity       = 40
t.tooltip_shape         = function(cr,w,h) shape.rounded_rect(cr,w,h,5) end
-- WIBAR SECTION

t.wibar_border_color    = invisible
t.wibar_border_width    = dpi(0)
t.wibar_ontop           = false
t.wibar_type            = 'dock'
t.wibar_font            = font .. '10'
t.wibar_fg              = colors[2]
t.wibar_bg              = colors[4]
t.wibar_shape           = shape.rectangle
t.wibar_opacity         = 40
t.wibar_height          = dpi(30)

--CUSTOM WIBAR VARS

t.wibar_inner_bg        = colors[4]
t.wibar_radius          = dpi(5)

-- TAG SECTION --
t.master_width_factor = 0.4
t.useless_gap = dpi(10)
t.gap_single_client = true
t.master_fill_policy = 'expand'
t.master_count = 1
t.column_count = 1

--TAGLIST SECTION --
local layout_ic = theme_root .. '/icons/layouts/'
t.layout_tile = layout_ic .. 'tiled.svg'
t.layout_floating = layout_ic .. 'floating.svg'
t.taglist_fg_focus  = colors[10]
t.taglist_height     = dpi(30)
t.taglist_spacing   =  dpi(1)
t.taglist_font      = 'Source Code Pro 10'
t.taglist_bg_focus  = colors[5]
t.taglist_fg_occupied = colors[5]


-- Tasklist

t.tasklist_font                 = "Source Code Pro 10"
t.tasklist_disable_icon         = true
t.tasklist_fg_focus             = colors[3]
t.tasklist_fg_urgent            = colors[8]
t.tasklist_fg_normal            = colors[2]
t.tasklist_bg_normal            = colors[4]
t.tasklist_bg_focus             = colors[4]
t.tasklist_fg_minimize          = colors[9]
t.tasklist_floating             = "[f] "
t.tasklist_sticky               = "[s] "
t.tasklist_ontop                = "[t] "
t.tasklist_maximized_horizontal = "[M] "
t.tasklist_maximized_vertical   = "[m] "


-- SYSTEM TRAY SECTION
t.systray_icon_spacing = dpi(1)

-- NOTIFICATION THEME
t.notification_font = "Source Code Pro 10"
t.notification_bg   =  colors[4]
t.notification_fg   = colors[5]
t.notification_max_width = dpi(500)
t.notification_icon_size = 20
t.notification_shape = function(cr,w,h) return shape.rounded_rect(cr,w,h,5) end

return t
