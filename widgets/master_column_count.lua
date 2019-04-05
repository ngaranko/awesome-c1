--[[
    Widget to count the number of clients in the master window
--]]

local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

-- define the widget
local widget = wibox.widget 
    {
        {
            id = 'master',
            {
                text = 'M: ',
                widget = wibox.widget.textbox,
            },
            {
                id = 'master_count', --used so we can updated in signal
                text = beautiful.master_count,
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.fixed.horizontal,
        },
        {
            id = 'column',
            {
                text = 'C: ',
                widget = wibox.widget.textbox,
            },
            {
                id= 'column_count',
                text = beautiful.column_count,
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.fixed.vertical,
    }

-- connect to the tag so that this property is updated when the value changes
awful.tag.attached_connect_signal(nil,"property::master_count",function(c)
    -- update our widget
    awful.screen.focused().tag_data_widget.master.master_count.text = c.master_count
    end)

awful.tag.attached_connect_signal(nil,"property::column_count",function(c)
    -- update our widget
    awful.screen.focused().tag_data_widget.column.column_count.text = c.column_count
    end)

awful.tag.attached_connect_signal(nil,"property::selected",function(c)
    -- update our widget
    if not awesome.startup then
        awful.screen.focused().tag_data_widget.master.master_count.text = c.master_count
    end
    end)

awful.tag.attached_connect_signal(nil,"property::selected",function(c)
    -- update our widget
    if not awesome.startup then
        awful.screen.focused().tag_data_widget.column.column_count.text = c.column_count
    end
    end)


return widget
