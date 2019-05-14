local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local shape = require('util.custom_shapes')
local gears = require('gears')

local module = {}

local vsize = beautiful.corner_radius
local hsize = beautiful.cust_border_width

function module.create_titlebar(client)
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(client)
        end),
        awful.button({ }, 3, function()
            client:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(client)
        end)
    )
    awful.titlebar.enable_tooltip = false
    for pos,thic in pairs({top = vsize,left = hsize,right = hsize, bottom = vsize}) do
        awful.titlebar(client,{size = thic, position = pos}) : setup {
            {
                text = '',
                widget = wibox.widget.textbox, 
            },
            id = 'custom_bg',
            bg = beautiful.titlebar_bg_normal_custom,
            widget = wibox.container.background,
            clip = true,
            shape = function (cr,w,h)
                if pos == 'top' or pos == 'bottom' then
                    return shape.full_round_rect(cr,w,h,pos)
                else
                    return gears.shape.rectangle(cr,w,h)
                end
            end,
            buttons = buttons,
        } 
    end
end

function module.focus_titlebar(client)
    if not client.requests_no_titlebar then 
        for pos,thic in pairs({top = vsize,left = hsize,right = hsize, bottom = vsize}) do
            awful.titlebar(client,{size = thic, position = pos}).custom_bg.bg = beautiful.titlebar_bg_focus_custom
        end
    end
end

function module.unfocus_titlebar(client)
    if not client.requests_no_titlebar then
        for pos,thic in pairs({top = vsize,left = hsize,right = hsize, bottom = vsize}) do
            awful.titlebar(client,{size = thic, position = pos}).custom_bg.bg = beautiful.titlebar_bg_normal_custom    
        end
    end
end

return module
