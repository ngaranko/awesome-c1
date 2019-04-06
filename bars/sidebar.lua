--[[
Lays out defenition for our custom sidebar
--]]
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require('beautiful')

-- widgets
local taglist = require('widgets.tag_list')
local batt = require('widgets.battery')
local launch = require('widgets.startapp')

local module = {}

function module.createsidebar(s)
    s.taglist = taglist.make_tag_list(s)
    s.battery_widget = batt
    s.layoutbox = awful.widget.layoutbox(s)
    s.systray = wibox.widget.systray()
    s.systray:set_horizontal(false)
    s.layoutbox:buttons(gears.table.join(
                        awful.button({}, 1, function() awful.layout.inc(1) end)))
    s.promptbox = awful.widget.prompt()
    s.textclock = wibox.widget.textclock('<b>%I%n%M</b>')
    s.textclock.align = 'center'
    s.textclock.font = beautiful.taglist_font
    s.sidebar_root = awful.wibar({
        screen = s,
        position = "left",
        width = beautiful.taglist_width,
    })
    s.sidebar_root:setup({
        -- top widgets
        {
            launch,
            s.taglist,
            s.promptbox,
            layout = wibox.layout.fixed.vertical,
        },
        --middle widget
        {
            layout = wibox.layout.fixed.vertical,
        },
        -- bottom widget
        {
            s.layoutbox,
            s.battery_widget,
            s.systray,
            s.textclock,
            spacing = 5,
            layout = wibox.layout.fixed.vertical,
        },
        layout = wibox.layout.align.vertical,
    })
end

return module
