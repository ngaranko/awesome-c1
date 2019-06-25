local shape = require('gears.shape')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local current_vol = nil
local mute = nil

local volume_table = {
    high = "H",
    low = "L",
    off = "X",
    mute = "M",
}



local volume_icn = wibox.widget.textbox()
volume_icn.font = beautiful.icon_font .. '17'

local volume_slider = wibox.widget{
    bar_shape = shape.rounded_rect,
    bar_height = 3,
    bar_color = beautiful.fg_normal,
    handle_color = beautiful.fg_normal,
    handle_shape = shape.circle,
    handle_border_color = beautiful.bg_normal,
    handle_border_width = 3,
    value = 0,
    forced_width = 75,
    widget = wibox.widget.slider,
}
volume_slider:connect_signal('property::value',function(state)
    current_vol = state.value
    awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ ' .. tostring(current_vol) .. '%')
end)

local widget = wibox.widget{
    {
        volume_icn,
        top = 3,
        widget = wibox.container.margin,
    },
    volume_slider,
    layout = wibox.layout.fixed.horizontal,
    spacing = 7,
}

local function update_widget()
    if not mute then
        if current_vol >= 40 then
            volume_icn.text = volume_table.high
        elseif current_vol>0 then
            volume_icn.text = volume_table.low
        else
            volume_icn.text = volume_table.off
        end
    else
        volume_icn.text = volume_table.mute
    end
    volume_slider.value = current_vol
end


-- get sink props
awful.spawn.easy_async('pactl list sinks',function(stdout)
    current_vol = tonumber(stdout:match('Volume:.* (%d*)%%.*%d*%%'))
    mute = stdout:match('Mute: (%a*)') == 'yes'
    update_widget()
end)

function widget.raise_volume()
    current_vol = current_vol + 5
    if current_vol > 100 then current_vol = 100 end
    awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ ' .. tostring(current_vol) .. '%')
    -- update our widget
    update_widget()
end

function widget.lower_volume()
    current_vol = current_vol - 5
    if current_vol < 0 then current_vol = 0 end
    awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ ' .. tostring(current_vol) .. '%')
    -- update our widget
    update_widget()
end

function widget.toggle_mute()
    mute = not mute
    awful.spawn('pactl set-sink-mute @DEFAULT_SINK@ toggle')
    update_widget()
end
-- add click to mute on volume icon
volume_icn:buttons(awful.util.table.join(awful.button({}, 1, widget.toggle_mute)))

return widget
