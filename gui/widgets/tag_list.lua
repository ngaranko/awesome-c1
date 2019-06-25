local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local module = {}

local icon_font = beautiful.icon_font .. '21'

function module.make_tag_list(s)
-- create tag list

local taglist_buttons = gears.table.join(
               awful.button({ }, 1, function(t) t:view_only() end),
               awful.button({ }, 3, function(t) awful.tag.viewtoggle(t) end)
            )

return awful.widget.taglist (s, awful.widget.taglist.filter.all, taglist_buttons)
end

return module
