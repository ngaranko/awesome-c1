local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local module = {}

function module.make_tag_list(s)
-- create tag list

local taglist_buttons = gears.table.join(
               awful.button({ }, 1, function(t) t:view_only() end)
            )

return awful.widget.taglist ({
  screen  = s,
    filter  = awful.widget.taglist.filter.all,
    layout  = wibox.layout.fixed.vertical,
    widget_template = {
            {
                id = 'taglist_widget',
                {
                    {
                        -- custom text for the widget, use font icons
                        id     = 'text_display', 
                        font = beautiful.icon_font,
                        text = "UNSET",
                        align = 'center',
                        widget = wibox.widget.textbox,
                    },
                    margins = 5,
                    widget = wibox.container.margin,
                },
                {
                    id = 'index_box',
                    {
                        {
                            -- index of the tag
                            id     = 'index_role',
                            widget = wibox.widget.textbox,
                        },
                        margins = 0,
                        widget  = wibox.container.margin,
                    },
                    bg     = beautiful.index_bg,
                    shape  = gears.shape.circle,
                    visible = false,
                    widget = wibox.container.background,
                },
            layout = wibox.layout.stack,
            },
        id     = 'background_role',
        widget = wibox.container.background,
        -- Add support for hover colors and an index label
        create_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
            self:get_children_by_id('text_display')[1].text = beautiful.taglist_icons[index]
            self:connect_signal('mouse::enter', function()
                if  self.bg ~= beautiful.bg_focus then
                    self.backup     = self.bg
                    self.has_backup = true
                    self.bg = beautiful.bg_focus
                end
                
            end)
            self:connect_signal('mouse::leave', function()
                if self.has_backup and index ~= awful.screen.focused().selected_tag.index then 
                    self.bg = self.backup 
                end
            end)
        end,
        update_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
        end,
    },
    buttons = taglist_buttons,
  })
end

return module
