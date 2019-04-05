--[[
Theme overrides on top of gtk theme
--]]
local theme = {}
local dpi = require('beautiful').xresources.apply_dpi

theme.font = 'SF Pro Display 10'
theme.border_width  = dpi(2)
theme.border_normal = '#FFFFFF'
theme.border_focus  = '#FFF000'
theme.border_marked = '#000000'

theme.icon_font = 'DroidSansMono Nerd Font 17'

-- TAG SECTION --
theme.master_width_factor = 0.5
theme.useless_gap = dpi(2)
theme.gap_single_client = false
theme.master_fill_policy = 'expand'
theme.master_count = 1
theme.column_count = 1

--TAGLIST SECTION --
theme.taglist_icons = {
    utf8.char(61461),
    utf8.char(63288),
    utf8.char(63215),
    utf8.char(61728),
    utf8.char(61729),
    utf8.char(61848),
    utf8.char(63942),
}





return theme
