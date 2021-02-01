-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Theme handling library
local beautiful = require("beautiful")
beautiful.init(require('theme'))
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Notification library
local naughty = require("naughty")
local lain    = require("lain")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local menubar = require("menubar")

local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
-- gui features (top bar, client decorations)
local bar = require("gui.bar")
local titlebar = require('gui.custom_titlebar')


-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- beautifuls define colours, icons, font and wallpapers.

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = "emacsclient -c "
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    lain.layout.centerwork,
    --awful.layout.suit.max,
    --awful.layout.suit.floating,
    -- awful.layout.suit.spiral,
    --awful.layout.suit.magnifier
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Tasklist things
awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            --c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = dpi(250)}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)


-- Create a textclock widget

-- Create a wibox for each screen and add it
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

local function set_tags(s)
    awful.tag(
      {
        " W ",
        " T ",
        " E ",
        " C ",
        " M ",
        " R ",
        " BS "
      },
      s,
      awful.layout.layouts[1]
    )
    end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
--screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)
    set_tags(s)
    bar.createbar(s)
end)

-- Autostart windowless processes
local function run_once(cmd_arr)
  for _, cmd in ipairs(cmd_arr) do
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
      findme = cmd:sub(0, firstspace-1)
    end
    awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
  end
end

-- entries must be comma-separated
run_once({ "blueman-applet" })
run_once({ "nm-applet -sm-disable" })
-- run_once({ "xfce4-power-manager" })
run_once({ "/usr/bin/numlockx off" })
run_once({ "compton "})
run_once({ "/home/ngaranko/.dropbox-dist/dropboxd" })
run_once({ "emacs --daemon" })

local function set_things_up()
  local handle = io.popen("xrandr | grep 'HDMI-0 connected'")
  local result = handle:read("*a")
  handle:close()

  if result == "" then
    awful.util.spawn("feh --bg-scale /home/ngaranko/.config/awesome/theme/pop/small.jpg")
  else
    awful.util.spawn("xrandr --output HDMI-0 --scale 1x1 --dpi 96 --primary --right-of DP-2 --scale 1x1 --dpi 96")
    awful.util.spawn("feh --bg-scale /home/ngaranko/.config/awesome/theme/pop/big.jpg --bg-fill /home/ngaranko/.config/awesome/theme/pop/small.jpg")
  end
  local hp = io.popen("xrandr | grep 'DP-1 connected'")
  local hp_result = hp:read("*a")
  hp:close()

  if hp_result == "" then
  else
    awful.util.spawn("xrandr --output DP-1 --scale 1x1 --dpi 96 --primary --left-of DP-2 --scale 1x1 --dpi 96")
    awful.util.spawn("feh --bg-scale /home/ngaranko/.config/awesome/theme/pop/big.jpg --bg-fill /home/ngaranko/.config/awesome/theme/pop/small.jpg")
  end
  local hp2 = io.popen("xrandr | grep 'DP-0 connected'")
  local hp2_result = hp2:read("*a")
  hp2:close()

  if hp2_result == "" then
  else
    awful.util.spawn("xrandr --output DP-0 --scale 1x1 --dpi 96 --primary --left-of DP-2 --scale 1x1 --dpi 96")
    awful.util.spawn("feh --bg-scale /home/ngaranko/.config/awesome/theme/pop/big.jpg --bg-fill /home/ngaranko/.config/awesome/theme/pop/small.jpg")
  end
  -- Office
  local office_hp = io.popen("xrandr | grep 'HDMI-2 connected'")
  local office_hp_result = office_hp:read("*a")
  office_hp:close()

  if office_hp_result == "" then
  else
    awful.util.spawn("xrandr --output HDMI-2 --scale 1x1 --dpi 96 --primary --left-of eDP-1 --scale 1x1 --dpi 96")
    awful.util.spawn("feh --bg-scale /home/ngaranko/.config/awesome/theme/pop/work_big.jpg --bg-fill /home/ngaranko/.config/awesome/theme/pop/work_small.jpg")
  end
  local office_hp2 = io.popen("xrandr | grep 'DP-1-2-1 connected'")
  local office_hp2_result = office_hp2:read("*a")
  office_hp2:close()

  if office_hp2_result == "" then
  else
    awful.util.spawn("xrandr --output DP-1-2-1 --scale 1x1 --dpi 96 --primary --left-of eDP-1-1 --scale 1x1 --dpi 96")
    awful.util.spawn("feh --bg-scale /home/ngaranko/.config/awesome/theme/pop/work_big.jpg --bg-fill /home/ngaranko/.config/awesome/theme/pop/work_small.jpg")
  end

 
  local h2 = io.popen("xinput -list | grep -i key | grep HHKB")
  local result2 = h2:read("*a")
  h2:close()
  if result2 == "" then
    --awful.util.spawn("setxkbmap -model macintosh -layout us,ru -option grp:ctrl_alt_toggle -option ctrl:nocaps -option altwin:swap_alt_win")
    --awful.util.spawn("setxkbmap -model macintosh -layout us,ru -option grp:ctrl_alt_toggle")
  else
    --awful.util.spawn("setxkbmap -model hhk -layout us,ru -option grp:ctrl_alt_toggle")
  end
end

-- }}}

local myawesomemenu = {
  { "hotkeys", function() return false, hotkeys_popup.show_help end },
  { "manual", terminal .. " -e man awesome" },
  { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 18,
    before = {
      -- other triads can be put here
    },
    after = {
      { "Awesome", myawesomemenu, beautiful.awesome_icon },
      { "Open terminal", terminal },
      -- other triads can be put here
    }
})

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 8, awful.tag.viewnext),
    awful.button({ }, 9, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
  -- ALSA volume control
  awful.key({  }, "XF86AudioRaiseVolume",
    function ()
      os.execute("amixer -q -D pulse sset Master 10%+")
    end,
    {description = "volume up", group = "hotkeys"}),
  awful.key({  }, "XF86AudioLowerVolume",
    function ()
      os.execute("amixer -q -D pulse sset Master 10%-")
    end,
    {description = "volume down", group = "hotkeys"}),
  awful.key({  }, "XF86AudioMute",
    function ()
      os.execute("amixer -q -D pulse sset Master toggle")
    end,
    {description = "toggle mute", group = "hotkeys"}),
  
    awful.key({ }, "XF86MonBrightnessDown", function ()
      awful.util.spawn("xbacklight -dec 15") end),
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.util.spawn("xbacklight -inc 15") end),

    awful.key({ modkey, }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey, }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j",
      function () awful.client.swap.byidx(  1)    end,
      {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k",
      function () awful.client.swap.byidx( -1)    end,
      {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j",
      function () awful.screen.focus_relative( 1) end,
      {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k",
      function () awful.screen.focus_relative(-1) end,
      {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u",
      awful.client.urgent.jumpto,
      {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return",
      function () awful.spawn(terminal) end,
      {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r",
      awesome.restart,
      {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey,           }, "l",
      function () awful.tag.incmwfact( 0.05)          end,
      {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",
      function () awful.tag.incmwfact(-0.05)          end,
      {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",
      function () awful.tag.incnmaster( 1, nil, true) end,
      {description = "increase the number of master clients",
       group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",
      function () awful.tag.incnmaster(-1, nil, true) end,
      {description = "decrease the number of master clients",
       group = "layout"}),
    awful.key({ modkey, "Control" }, "h",
      function () awful.tag.incncol( 1, nil, true)    end,
      {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",
      function () awful.tag.incncol(-1, nil, true)    end,
      {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space",
      function () awful.layout.inc( 1)                end,
      {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space",
      function () awful.layout.inc(-1)                end,
      {description = "select previous", group = "layout"}),

    -- Prompt

    awful.key({ modkey }, "r", function ()
        os.execute("rofi -no-lazy-grab  -show combi -combi-modi drun,run -theme slate.rasi")
                               end,
      {description = "show rofi", group = "launcher"}),
    awful.key({ modkey }, "`", function ()
        os.execute("rofi -show window -theme " .. beautiful.rofi_theme_name)
                               end,
      {description = "show rofi", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().promptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Control" }, "q",
      function(c) os.execute("slock") end,
      {description = "Lock screen", group = "awesome"}),
    awful.key({ modkey,         }, "F4",
      function (c) c:kill()                         end,
      {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",
      awful.client.floating.toggle                     ,
      {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return",
      function (c) c:swap(awful.client.getmaster()) end,
      {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",
      function (c) c:move_to_screen()               end,
      {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",
      function (c) c.ontop = not c.ontop            end,
      {description = "toggle keep on top", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                              -- move our view to this tag as well
                              tag:view_only()
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     size_hints_honor = false,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {
        type = { "normal", "dialog" }
    }, properties = {
        titlebars_enabled = true }
    },

    { rule = { class = "gnome-terminal-server" },
      properties = { opacity = 0.95 } },
    { rule = { class = "Gnome-terminal" },
      properties = { opacity = 0.95 } },
    { rule = { class = "Emacs" },
      properties = { opacity = 0.95 } },
    { rule = { class = "Telegram" },
      properties = { opacity = 0.95 } },
    { rule = { class = "Slack" },
      properties = { opacity = 0.95 } },
    { rule = { class = "Spotify" },
      properties = { opacity = 0.95 } },
    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
    { rule = { class = "Gnome-terminal" },
      properties = { opacity = 0.95 } },
    { rule = { class = "Emacs" },
      properties = { opacity = 0.95 } },
    { rule = { class = "XTerm" },
      properties = { opacity = 0.95 } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    -- round corners less than titlebar amount to avoid aliasing
    c.shape = function (cr,w,h) return gears.shape.rounded_rect(cr,w,h,beautiful.corner_radius-3) end
end)

client.connect_signal("request::activate", function(client,context,hints)
    gears.table.crush(hints,{switch_to_tag = true})
    awful.ewmh.activate(client,context,hints)
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", titlebar.create_titlebar)

set_things_up()
