-- provides a chevron widget that hides the system tray from view
local wibox = require('wibox')
local beautiful = require('beautiful')

local chevron = wibox.widget.textbox("Tray")
chevron.font =  beautiful.icon_font .. '22'
chevron.valign = 'center'
chevron.align = 'center'
local systray = wibox.widget.systray()

local widget = wibox.widget{
    {
      chevron,
      top = 4,
      right = 10,
      widget = wibox.container.margin,
    },
    systray,
    spacing = 1,
    layout = wibox.layout.fixed.horizontal,
}

-- when clicked, open systray
widget:connect_signal('mouse::enter', function(textbox)
    systray.visible = true
    chevron.text = "Tray"
end)

widget:connect_signal('mouse::leave', function(textbox)
    systray.visible = true
    chevron.text = "Tray"
end)

-- fun bug means that the systray does not work unless we hide it a bit later
require('gears.timer').delayed_call(function() systray.visible = true end)

return widget
