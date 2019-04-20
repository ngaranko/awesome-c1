-- [[ very simple widget to start an app based on a certain tag's icon (uses indicies)
--]]

local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')

local spawntable = {
    'konsole',
    'firefox',
    'dolphin',
    'geary',
    'konsole',
    'konsole',
    'slack',
    'spotify',
    'xournal'
}


local widget = wibox.container.margin()
widget.top = 7
widget.bottom = 0
widget.left = 5
widget.right = 5

local spawner = wibox.widget.textbox()
spawner.text = utf8.char(63768)
spawner.align = 'center'
spawner.valign = 'top'
spawner.font = 'Monaco Nerd Font 21'
spawner:buttons(gears.table.join(awful.button({},1,function() awful.spawn("gnome-pie -o 541") end)))

widget:set_widget(spawner)


widget.spawn = function ()
    local index = awful.screen.focused().selected_tag.index
    awful.spawn(spawntable[index])
    end

return widget
