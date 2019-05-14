--[[
Lays out defenition for our custom sidebar
--]]
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require('beautiful')

-- widgets
local taglist = require('gui.widgets.tag_list')
local module = {}

function module.createbar(s)
    s.layoutbox = awful.widget.layoutbox(s)
    s.volume_control = require('gui.widgets.volume')
    s.layoutbox:buttons(gears.table.join(
                        awful.button({}, 1, function() awful.layout.inc(1) end)))
    s.promptbox = awful.widget.prompt()
    s.textclock = wibox.widget.textclock('%a,  %b %_d <b>%_I:%M %p</b>')
    s.textclock.valign = 'center'
    s.textclock.align = 'center'
    s.textclock.font = beautiful.wibar_font
    s.sidebar_root = awful.wibar({
        screen = s,
        position = "top",
        height = beautiful.wibar_height,
    })
    s.sidebar_root:setup({
        {
            {
                -- left widgets
                {
                    require('gui.widgets.pie'),
                    taglist.make_tag_list(s),
                    s.promptbox,
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 10,
                },
                --middle widget
                {
                    layout = wibox.layout.fixed.horizontal,                    
                },
                -- left widget
                {
                    require('gui.widgets.media_player'),
                    s.volume_control,
                    s.layoutbox,
                    s.textclock,
                    require('gui.widgets.battery'),
                    require('gui.widgets.systray_container'),
                    spacing = 10,
                    layout = wibox.layout.fixed.horizontal,
                },
                layout = wibox.layout.align.horizontal,
            },
        bg = beautiful.wibar_inner_bg,
        shape = function (cr,w,h) return gears.shape.rounded_rect(cr,w,h,beautiful.wibar_radius) end,
        widget = wibox.container.background,
        },
        left = 5,
        right = 5,
        bottom = 0,
        top = 5,
        widget = wibox.container.margin,
    })
end

return module
