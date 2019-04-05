--[[
    theme for awesomewm
    uses gtk as fallback, then sets additional variables via a lua file
--]]
local gtk = require('beautiful.gtk')
local gtable = require('gears.table')
local theme_file = require('theme.material')
local final_theme = {}

-- add gtk theme variables
local gtk_vars = gtk.get_theme_variables()

-- override gtk presets
gtable.crush(final_theme,theme_file)


return final_theme
