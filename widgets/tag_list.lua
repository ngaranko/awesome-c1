local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local module = {}

function module.make_tag_list(s)
-- create tag list

local taglist_buttons = gears.table.join(
               awful.button({ }, 1, function(t) t:view_only() end),
               awful.button({ }, 3, function(t) awful.tag.viewtoggle(t) end)
            )

return awful.widget.taglist ({
  screen  = s,
    filter  = awful.widget.taglist.filter.all,
    layout  = wibox.layout.fixed.horizontal,
    widget_template = {
            {
                id = 'taglist_widget',
                {
                    {
                     -- let the text role get set so we can use it
                     id     = 'text_display', 
                     font = beautiful.icon_font .." 21",
                     text = "UNSET",
                     align = 'center',
                     valign = 'top',
                     widget = wibox.widget.textbox,
                    },
                    top = 7,
                    bottom = 2,
                    left = 5,
                    right = 5,
                    widget = wibox.container.margin,
                },
                {
                    id = 'index_box',
                    {
                        {
                            -- index of the tag
                            id     = 'index_role',
                            align = 'center',
                            valign = 'center',
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
        create_callback = function(self, tag, index, tags) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> ' .. tag.name .. ' </b>'
            self:get_children_by_id('text_display')[1].text = beautiful.taglist_icons[tonumber(tag.name)]
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
        update_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '.. c3.name ..' </b>'
        end,
    },
    buttons = taglist_buttons,
  })
end

return module
