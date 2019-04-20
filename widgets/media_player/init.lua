-- get dbus reference
assert(dbus)
local dbus = dbus

local db = {}

local dbus_object = "org.freedesktop.DBus.properties"
local match_string =  "path='/org/mpris/mediaplayer2', interface='org.freedesktop.dbus.properties', member='propertieschanged'"

function db.register_listener(listener)
    local function handle_dbus(signal,path,data,...)
        -- signal holds data about the sender of the signal
        -- path is the path of the signal
        -- data contains information from the media player (such as track)
        listener(signal,path,data) 
    end
    dbus.connect_signal(dbus_object,handler)
end

command_format = string.format("dbus-send --print-reply --dest]%s %s %s.%s %s",
                    dbus_object,
                    dbus_

-- add a match for the property we are interested in
dbus.add_math('session',match_string)
