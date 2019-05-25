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

return awful.widget.taglist ({
  screen  = s,
    filter  = awful.widget.taglist.filter.all,
    widget_template = {
        {
            {    
                id = 'text_role',
                widget = wibox.widget.textbox,
                align = 'center',
                valign = 'center',
            },
            left = 5,
            right = 5,
            widget = wibox.container.margin,
        },
        id     = 'background_role',
        widget = wibox.container.background,
        -- Add support for hover colors and an index label
        create_callback = function(self, tag, index, tags) 
            self:connect_signal('mouse::enter', function(result)
                self.fg = beautiful.bg_focus 
            end)
            self:connect_signal('mouse::leave', function()
                self.fg = beautiful.fg_normal 
            end)
        end,
        update_callback = function(self, tag, index, taglist) 
        end,
    },
    buttons = taglist_buttons,
  })
end

return module
