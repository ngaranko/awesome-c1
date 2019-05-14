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
            id = 'text_role',
            widget = wibox.widget.textbox,
            align = 'center',
            valign = 'center',
        },
        id     = 'background_role',
        widget = wibox.container.background,
        -- Add support for hover colors and an index label
        create_callback = function(self, tag, index, tags) 
            self:connect_signal('mouse::enter', function()
                if  self.bg ~= beautiful.bg_focus then
                    self.backup     = self.bg
                    self.has_backup = true
                    local tag = awful.screen.focused().tags[index]
                    self.backup_sel = tag.selected
                    self.bg = beautiful.bg_focus
                end
                
            end)
            self:connect_signal('mouse::leave', function()
                local tag = awful.screen.focused().tags[index]
                if self.has_backup and self.backup_sel == tag.selected then 
                    self.bg = self.backup 
                    self.has_backup = false
                end
            end)
        end,
        update_callback = function(self, tag, index, taglist) 
        end,
    },
    buttons = taglist_buttons,
  })
end

return module
