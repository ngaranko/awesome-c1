local awful = require('awful')
local dbus = require('util.dbus')
local wibox = require('wibox')

local beautiful = require('beautiful')
local naughty = require('naughty')

local ICON_FT = beautiful.icon_font .. '10'

-- connect to dbus signal
local dest = 'org.freedesktop.UPower'
local bus = 'system'
local path = '/org/freedesktop/UPower/devices/battery_BAT0'
local interface = 'org.freedesktop.DBus.Properties'
local member = 'PropertiesChanged'

-- sections of widget will update with polling
local bat_icn = wibox.widget.textbox()
bat_icn.font = ICON_FT
bat_icn.align = 'center'

local bat_txt = wibox.widget.textbox()
bat_txt.font = beautiful.wibar_font

local widget = wibox.widget{
    bat_icn,
    bat_txt,
    spacing = 1,
    layout = wibox.layout.fixed.horizontal,
}

local perc_discharge = {}
   perc_discharge [0  ] = "A"
   perc_discharge [10 ] = "B"
   perc_discharge [20 ] = "C"
   perc_discharge [30 ] = "D"
   perc_discharge [40 ] = "E"
   perc_discharge [50 ] = "F"
   perc_discharge [60 ] = "G"
   perc_discharge [70 ] = "H"
   perc_discharge [80 ] = "I"
   perc_discharge [90 ] = "J"
   perc_discharge [100] = "V"

--lookup table for charging percentages
local perc_charg = {}
    perc_charg [0  ] = " "
    perc_charg [10 ] = " "
    perc_charg [20 ] = " "
    perc_charg [30 ] = " "
    perc_charg [40 ] = " "
    perc_charg [50 ] = " "
    perc_charg [60 ] = " "
    perc_charg [70 ] = " "
    perc_charg [80 ] = " "
    perc_charg [90 ] = " "
    perc_charg [100] = "K"

local state = nil
local percentage = nil

local function update_widget()
    -- state: 1: charging, 2: dischargning
    local round_perc = percentage - (percentage%10)
    if state == 1 or state == 4 then
        bat_icn.text = '+'
    elseif state ==2 then
        bat_icn.text = '-'
    end
    bat_txt.text = string.format('%.0f%% ',percentage)
    -- notify user if battery is below 10%
    if percentage==10 then
        naughty.notify({title = 'Low Battery', text = 'Battery is getting low!'})
    end
end

dbus.register_listener(bus,path,interface,member,function (data)
    if data.Percentage ~= nil then
        percentage = data.Percentage
    end
    if data.State ~= nil then
        state = data.State
    end
    update_widget()
   end)


-- start by polling the player to find out if anything is playing
dbus.getProps(bus,dest,path,'org.freedesktop.UPower.Device',function (data)
    if data == 'ERROR' then
        -- we were unable to poll at this endpoint
        naughty.notify({text = 'Error Getting Battery Level'})
    else
        -- update battery level
        percentage = data.Percentage
        state = data.State
        update_widget()
    end
    end)

return widget
