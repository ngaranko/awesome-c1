local awful = require('awful')
local dbus = require('widgets.dbus_util')
local wibox = require('wibox')
local debug = require('gears.debug')

local beautiful = require('beautiful')

local ICON_FT = beautiful.icon_font .. ' 18'
local PLAYER = 'spotify'

-- connect to dbus signal
local dest = 'org.mpris.MediaPlayer2.' .. PLAYER
local bus = 'session'
local path = '/org/mpris/MediaPlayer2'
local interface = 'org.freedesktop.DBus.Properties'
local member = 'PropertiesChanged'


local function rewind()
    -- last song
    dbus.send(bus,dest,path,'org.mpris.MediaPlayer2.Player.Previous')
end    
local function play()
    -- play the music (or open spotify
    awful.spawn.easy_async('pgrep spotify', function(stdout,stderr,exitreason,exitcode)
        if exitcode ~= 0 then
            -- spawn spotify
            awful.spawn('spotify')
            awful.spawn.easy_async('sleep 1',function() 
                dbus.send(bus,dest,path,'org.mpris.MediaPlayer2.Player.PlayPause')
                end)
        else            
            dbus.send(bus,dest,path,'org.mpris.MediaPlayer2.Player.PlayPause')
        end
    end)
end
local function next()
    -- next song
    dbus.send(bus,dest,path,'org.mpris.MediaPlayer2.Player.Next')
end    
local playing = false

local play_btn = wibox.widget.textbox()
if playing then play_btn.text = utf8.char(63717)
    else play_btn.text = utf8.char(63756) end
play_btn.font = ICON_FT
play_btn:buttons(awful.util.table.join(awful.button({},1,play)))

local rewind_btn = wibox.widget.textbox()
rewind_btn.text = utf8.char(64355)
rewind_btn.font = ICON_FT
rewind_btn:buttons(awful.util.table.join(awful.button({},1,rewind)))

local fwd_btn = wibox.widget.textbox()
fwd_btn.text = utf8.char(64353)
fwd_btn.font = ICON_FT
fwd_btn:buttons(awful.util.table.join(awful.button({},1,next)))


local song_desc = wibox.widget.textbox()
song_desc.text = ''
song_desc.font = beautiful.icon_font .. ' 13'
song_desc.valign = 'center'

-- actual widget declaration

local widget = wibox.widget{
    song_desc,
    {
        -- media controls (in flexbox)
        rewind_btn,
        play_btn,
        fwd_btn,
        spacing = 4,
        layout = wibox.layout.fixed.horizontal,
    },
    spacing = 4,
    layout = wibox.layout.fixed.horizontal,
}

dbus.register_listener(bus,'/org/freedesktop/DBus','org.freedesktop.DBus','NameOwnerChanged',function(data,signal_meta) 
        if signal_meta.signal_data.member == 'NameOwnerChanged' and signal_meta.signal_path== 'org.mpris.MediaPlayer2.spotify' then
            song_desc.text = ''
            play_btn.text = utf8.char(63756)  
        end
    end)

-- register handler

dbus.register_listener(bus,path,interface,member,function (data)
    -- handler updates to playing status here
    playing = data.PlaybackStatus == 'Playing'
    if playing then play_btn.text = utf8.char(63717)
        else play_btn.text = utf8.char(63756) end
    song_desc.text = data.Metadata['xesam:artist'][1] .. "- " .. data.Metadata['xesam:title']
    end)



-- start by polling the player to find out if anything is playing
dbus.getProps(bus,dest,path,'org.mpris.MediaPlayer2.Player',function (data)
    if data == 'ERROR' then
        -- we were unable to poll at this endpoint
    else
        playing = data.PlaybackStatus == 'Playing'
        if playing then play_btn.text = utf8.char(63717)
            else play_btn.text = utf8.char(63756) end
    song_desc.text = data.Metadata['xesam:artist'][1] .. "- " .. data.Metadata['xesam:title']
    end
    end)

return widget
