-- provides a chevron widget that hides the system tray from view
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

local systray = wibox.widget.systray()
systray:set_base_size(13)
local widget = wibox.widget{
  systray,
  spacing = 1,
  layout = wibox.layout.fixed.horizontal,
}


local w = wibox.container.margin()
w.top = dpi(5)
w.right = dpi(5)
w:set_widget(widget)

return w
