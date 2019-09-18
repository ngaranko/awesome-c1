-- [[ very simple widget to start an app based on a certain tag's icon (uses indicies)
--]]

local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')



local widget = wibox.container.margin()
widget.left = 9

local spawner = wibox.widget.textbox()
spawner.text = "c"
spawner.align = 'center'
spawner.valign = 'center'
spawner.font = beautiful.icon_font .. '17'
spawner:buttons(gears.table.join(awful.button({},1,function() awful.spawn("gnome-pie -o 541") end)))

widget:set_widget(spawner)

return widget
