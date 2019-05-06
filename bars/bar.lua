--[[
Lays out defenition for our custom sidebar
--]]
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require('beautiful')

-- widgets
local taglist = require('widgets.tag_list')
local launch = require('widgets.pie')
local module = {}

function module.createbar(s)
    s.taglist = taglist.make_tag_list(s)
    s.launch = launch
    s.layoutbox = awful.widget.layoutbox(s)
    s.systray = wibox.widget.systray()
    s.systray.visible = false
    s.layoutbox:buttons(gears.table.join(
                        awful.button({}, 1, function() awful.layout.inc(1) end)))
    s.promptbox = awful.widget.prompt()
    s.textclock = wibox.widget.textclock('<b>%a, %b %_d %_I:%M %p</b>')
    s.textclock.valign = 'center'
    s.textclock.align = 'center'
    s.textclock.font = beautiful.taglist_font
    s.sidebar_root = awful.wibar({
        screen = s,
        position = "top",
    })
    s.sidebar_root:setup({
        -- left widgets
        {
            s.launch,
            s.taglist,
            s.promptbox,
            layout = wibox.layout.fixed.horizontal,
        },
        --middle widget
        {
            layout = wibox.layout.fixed.horizontal,
        },
        -- left widget
        {
            require('widgets.media_player'),
            s.layoutbox,
            s.textclock,
            require('widgets.battery'),
            s.systray,
            spacing = 10,
            layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.align.horizontal,
    })
end

return module
