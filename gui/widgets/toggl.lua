local wibox = require("wibox")
local awful = require("awful")

togglWidget = wibox.widget.textbox()

local watch = require("awful.widget.watch")

watch([[bash -c "python ~/.config/polybar/toggl_polybar/toggl.py"]], 1,
  function(widget, stdout)
    widget:set_text(stdout)
  end,
  togglWidget
)

return togglWidget
