--[[
    theme for awesomewm
    uses gtk as fallback, then sets additional variables via a lua file
--]]
local gtable = require('gears.table')
local theme_file = require('theme.pop')
local final_theme = {}

-- add gtk theme variables

-- override gtk presets
gtable.crush(final_theme,theme_file)


return final_theme
