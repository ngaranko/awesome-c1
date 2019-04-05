--[[
    Battery widget based off lain battery widget toolkit
--]]

local lain = require('lain')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')

-- lookup table for discharging percentages
local perc_discharge = {}
   perc_discharge [0  ] = utf8.char(62850)
   perc_discharge [10 ] = utf8.char(62841)
   perc_discharge [20 ] = utf8.char(62842)
   perc_discharge [30 ] = utf8.char(62843)
   perc_discharge [40 ] = utf8.char(62844)
   perc_discharge [50 ] = utf8.char(62845)
   perc_discharge [60 ] = utf8.char(62846)
   perc_discharge [70 ] = utf8.char(62847)
   perc_discharge [80 ] = utf8.char(62848)
   perc_discharge [90 ] = utf8.char(62849)
   perc_discharge [100] = utf8.char(62840)

--lookup table for charging percentages
local perc_charg = {}
    perc_charg [0  ] = utf8.char(62853)
    perc_charg [10 ] = utf8.char(62853)
    perc_charg [20 ] = utf8.char(62853)
    perc_charg [30 ] = utf8.char(62854)
    perc_charg [40 ] = utf8.char(62855)
    perc_charg [50 ] = utf8.char(62855)
    perc_charg [60 ] = utf8.char(62856)
    perc_charg [70 ] = utf8.char(62856)
    perc_charg [80 ] = utf8.char(62857)
    perc_charg [90 ] = utf8.char(62859)
    perc_charg [100] = utf8.char(62851)


local ret = lain.widget.bat({
    timeout = 120,
    settings = function()
        widget.font = beautiful.taglist_font
        widget.align = 'center'
        widget:buttons(awful.util.table.join(
            awful.button({ }, 1, function() awful.screen.focused().battery_widget:update() end)))
        --customize icon based on percentage
        if bat_now.status == 'Discharging' then
            local round_perc = bat_now.perc - (bat_now.perc % 10)
            widget:set_markup(bat_now.perc .. '\n<span font= "SF Pro Display 26">' .. perc_discharge[round_perc] .. '</span>')
        else
            local round_perc = bat_now.perc - (bat_now.perc % 10)
            widget:set_markup(bat_now.perc .. '\n<span font= "SF Pro Display 26">' .. perc_charg[round_perc] .. '</span>')
        end
    end
})


return ret
