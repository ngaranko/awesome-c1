-- [[ very simple widget to start an app based on a certain tag's icon (uses indicies)
--]]

local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')

local spawntable = {
    '',
    'firefox',
    'mailspring',
    'konsole',
    'konsole',
    'slack',
    'spotify',
    'xournal'
}

local widget = wibox.widget.textbox()
widget.text = utf8.char(61846)
widget.align = 'center'
widget.font = 'SF Pro Display 27'

widget:buttons(awful.util.table.join(awful.button({},1,function ()
    -- spawn based on index
    local index = awful.screen.focused().selected_tag.index
    awful.spawn(spawntable[index])
    end)))
return widget
