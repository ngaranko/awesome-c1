local awful = require('awful')
-- get dbus reference
assert(dbus)
local dbus = dbus
local debug = require('gears.debug')
local table = require('gears.table')
local db_wrap = {}




local function get_type(input)
    -- helper function to get the next type in a dbus return
    -- lua doesn't support matching one string OR another, so we have this kludge
    local best_idx = 1e309 -- i'm not importing math just to get infiniy
    local likely_type = nil
    for i,type in pairs({'dict','array','string','u?int%d%d','double','byte','boolean','objpath'}) do
        local index = input:find(type)
        if index ~= nil and index < best_idx then
            likely_type = type
            best_idx = index
        end 
    end
    return likely_type
end

local function parse(input)
    -- remove method return data
    input = input:gsub('method return time=[%d%.]* sender=:[%d%.]* %-> destination=:[%d%.]* serial=%d* reply_serial=%d*','')
    -- remove variant (not useful)
    input = input:gsub('variant','')
    -- this bad boi is recursive
    -- start by finding our next data type
    local itype = get_type(input)
    -- lets get those base cases done
    -- we parse forwards to get the value for these cases
    if itype == 'string' then
        value = input:match('string "(.*)"')
        return value
    elseif itype == 'u?int%d%d' then
        match = input:match('u?int%d%d (%d*)')
        return tonumber(match)
    elseif itype == 'double' then
        match = input:match('double ([%d%.]*)')
        return tonumber(match) 
    elseif itype == 'byte' then
        match = input:match('byte (%d*)')
        return tonumber(match)
    elseif itype == 'boolean' then
        match = input:match('boolean (%a*)')
        return match == 'true'
    elseif itype == 'objpath' then
        match = input:match('objpath ([%w/]*)')
        return match
    elseif itype == nil then
        error('usupported value entered into parser!' .. input)
        return nil
    -- end of base cases! now handle dictionaries and arrays
    -- recursive cases here
    elseif itype == 'dict' then
        local raw_key = input:match('[^\n\r]*[\n\r]([^\n\r]*)') --get second line
        local raw_val = input:match('[^\n\r]*[\n\r][^\n\r]*[\n\r](.*)%)') --get rest
        local key = parse(raw_key)
        local val = parse(raw_val)
        local ret = {}
        ret[key] = val
        return ret
    elseif itype == 'array' then
        local arr = {}
        -- arrays preserving order is a sociatal construct
        -- iterate over each data type possible in array and add it to array
        local has_dict = false
        for match in input:gmatch('dict entry%b()') do
            local data = parse(match)
            has_dict = true
            arr = table.join(arr,data)
        end
        local i = 1
        if not has_dict then
            for match in input:gmatch('string ".*"') do
                local data = parse(match)
                arr[i] = data
                i = i+1
            end
        end
        return arr
    end
end



if callback_table == nil then
    callback_table = {} --table to keep track of registered callbacks
end

function db_wrap.register_listener(bus, path, interface, member, listener)
-- bus:system or session
-- path:object path
-- interface: interface object implements
-- member: member of interface
-- listener: callback function
    local function handle_dbus(signal, sig_path, data, ...)
        -- signal holds data about the sender of the signal
        -- path is the path of the signal
        -- data contains information from the media player (such as track)
        if callback_table[signal.interface][signal.path] ~= nil then
            signal_metadata = {
                signal_data = signal,
                signal_path = sig_path,
            }
            signal_metadata = table.join(signal_metadata,{...})
            callback_table[signal.interface][signal.path](data,signal_metadata)
        end
    end
    if callback_table[interface] == nil then
        callback_table[interface]={}
        dbus.connect_signal(interface, handle_dbus)
    end
    callback_table[interface][path] = listener
    match_string =  "path='" .. path .. "', interface='" .. interface .. "', member='" .. member .. "'"
    dbus.add_match(bus,match_string)
end


-- sending 

function db_wrap.send(bus,dest,object,message,args)
-- args contains the argument string for your function call. Can be nil.
    local dbus_cmd = string.format("dbus-send --%s --print-reply --dest=%s %s %s ",
                    bus,
                    dest,
                    object,
                    message)
    -- now append arguments, if they exist
    if args ~= nil then
        -- iterate over table's elements
        dbus_cmd = dbus_cmd .. args
    end
    awful.spawn.easy_async(dbus_cmd,function(stdout,stderr,exitreason,exitcode)
        if exitcode ~=0 then
        end
    end)
end

function db_wrap.getProps(bus,dest,path,interface,callback)
-- destination: endpoint to send message to
-- path: path at endpoint to poll
-- interface: interface of path to get props of
    local dbus_cmd = string.format("dbus-send --%s --print-reply --dest=%s %s org.freedesktop.DBus.Properties.GetAll string:%s",
                    bus,
                    dest,
                    path,
                    interface)
    -- now append arguments, if they exist
    awful.spawn.easy_async(dbus_cmd,function(stdout,stderr,exitreason,exitcode)
        if exitcode ~= 0 then
            callback('ERROR')
        else
            output = parse(stdout)
            collectgarbage()
            callback(output)
        end
    end)
end

return db_wrap
