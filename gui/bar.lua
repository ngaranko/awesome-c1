--[[
Lays out defenition for our custom sidebar
--]]
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require('beautiful')

-- widgets
local taglist = require('gui.widgets.tag_list')
local toggl = require('gui.widgets.toggl')
local module = {}

function module.createbar(s)
    s.layoutbox = awful.widget.layoutbox(s)
    s.systray = require('gui.widgets.systray_container')
    s.ram_widget = require("gui.widgets.ram-widget.ram-widget")
    s.volume_widget = require("gui.widgets.volumearc-widget.volumearc")
    s.battery_widget = require("gui.widgets.batteryarc-widget.batteryarc")
    s.promptbox = awful.widget.prompt()
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(
      s,
      awful.widget.tasklist.filter.currenttags,
      awful.util.tasklist_buttons
    )
    s.textclock = wibox.widget.textclock('%a,  %b %_d <b>%_I:%M %p</b>  ')
    s.firstspace = wibox.widget.textbox(" ")
    s.textclock.valign = 'center'
    s.textclock.align = 'center'
    s.textclock.font = beautiful.wibar_font
    s.sidebar_root = awful.wibar({
        screen = s,
        position = "bottom",
        width=1800,
        height = beautiful.wibar_height,
    })

    s.sidebar_root:setup({
        {
            {
                -- left widgets
              {
                    s.firstspace,
                    taglist.make_tag_list(s),
                    s.promptbox,
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 4,
                },
                --middle widget
                {
                  layout = wibox.layout.fixed.horizontal,
                  s.mytasklist
                },
                -- left widget
                {
                  s.systray,
                  -- s.ram_widget(),
                  wibox.widget.textbox(" "),
                  s.volume_widget(),
                  --s.battery_widget(),
                  s.textclock,
                  {
                      toggl,
                      bg = beautiful.bg_focus,
                      fg = beautiful.bg_normal,
                      widget = wibox.container.background
                  },
                  spacing = 4,
                  layout = wibox.layout.fixed.horizontal,
                },
                layout = wibox.layout.align.horizontal,
            },
            bg = beautiful.wibar_inner_bg,
            shape = function (cr,w,h) return gears.shape.rounded_rect(
                cr,w,h,beautiful.wibar_radius) end,
            widget = wibox.container.background,
        },
        left = 0,
        right = 0,
        bottom = 2,
        top = 0,
        opacity = 0.83,
        widget = wibox.container.margin,
    })
end

return module
