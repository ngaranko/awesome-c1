-- provides a chevron widget that hides the system tray from view
local wibox = require('wibox')
local beautiful = require('beautiful')

local systray = wibox.widget.systray()
systray:set_base_size(20)
local widget = wibox.widget{
  systray,
  spacing = 1,
  layout = wibox.layout.fixed.horizontal,
}


local w = wibox.container.margin()
w.top = 5
w:set_widget(widget)

return w
