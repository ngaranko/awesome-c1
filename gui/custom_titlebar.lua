local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local shape = require('util.custom_shapes')
local gears = require('gears')
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi

local module = {}

local vsize = beautiful.corner_radius
local hsize = beautiful.cust_border_width

function module.create_titlebar(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function() c:kill() end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )



    awful.titlebar(c, {size = dpi(24)}) : setup {
      { -- Left
            wibox.widget.textbox(" "),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
              align  = "center",
              awful.titlebar.widget.iconwidget(c),
              widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            wibox.widget.textbox(" "),
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
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
