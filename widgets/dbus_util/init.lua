-- get dbus reference
local awful = require('awful')

assert(dbus)
local dbus = dbus


local db_wrap = {}

-- dbus endpoint to send messages to
db_wrap.dbus_dest = nil
-- path to listen for messages for
db_wrap.dbus_path = nil
-- interface to listen for
db_wrap.dbus_interface = nil
-- member to watch
db_wrap.member = nil
db_wrap.match_string =  nil
-- avoid adding a match multiple times
db_wrap.match_added = false

db_wrap.bus = 'session'



function get_type(input)
    -- helper function to get the next type in a dbus return
    -- lua doesn't support matching one string OR another, so we have this kludge
    best_idx = 1e309 -- i'm not importing math just to get infiniy
    likely_type = nil
    for i,type in pairs({'dict','array','string','u?int%d%d','double','byte','boolean','objpath'}) do
        index = input:find(type)
        if index ~= nil and index < best_idx then
            likely_type = type
            best_idx = index
        end 
    end
    return likely_type
end

function parse(input)
    -- remove method return data
    input = input:gsub('method return time=[%d%.]* sender=:[%d%.]* %-> destination=:[%d%.]* serial=%d* reply_serial=%d*','')
    -- remove variant (not useful)
    input = input:gsub('variant','')
    -- this bad boi is recursive
    -- start by finding our next data type
    type = get_type(input)
    -- lets get those base cases done
    -- we parse forwards to get the value for these cases
    if type == 'string' then
        value = input:match('string "(.*)"')
        return value
    elseif type == 'u?int%d%d' then
        match = input:match('u?int%d%d (%d*)')
        return tonumber(match)
    elseif type == 'double' then
        match = input:match('double ([%d%.]*)')
        return tonumber(match) 
    elseif type == 'byte' then
        match = input:match('byte (%d*)')
        return tonumber(byte)
    elseif type == 'boolean' then
        match = input:match('boolean (%a*)')
        return match == 'true'
    elseif type == 'objpath' then
        match = input:match('objpath ([%w/]*)')
        return match
    elseif type == nil then
        error('usupported value entered into parser!' .. input)
        return nil
    -- end of base cases! now handle dictionaries and arrays
    -- recursive cases here
    elseif type == 'dict' then
        raw_key = input:match('[^\n\r]*[\n\r]([^\n\r]*)') --get second line
        raw_val = input:match('[^\n\r]*[\n\r][^\n\r]*[\n\r]([^\n\r]*)') --get third line
        key = parse(raw_key)
        val = parse(raw_val)
        ret = {}
        ret[key] = val
        return ret
    elseif type == 'array' then
        i = 1
        arr = {}
        -- iterate over each dict entry in array
        for match in input:gmatch('dict entry%(%s*[^\n\r]*%s*[^\n\r]*%s*%)') do
            data = parse(match)
            arr[i] = data
            i = i + 1
        end
        return arr
    end

end






function db_wrap:init(self, dest, interface, member, path)
    self.dbus_dest = dest
    self.dbus_interface = interface
    self.member = member
    self.dbus_path = path
    self.match_string =  "path='" .. dbus_path .. "', interface='" .. dbus_interface .. "', member='" .. member .. "'"
end

function db_wrap.register_listener(self,listener)
    if not self.dbus_dest then
        error("initilizate this module first")
        return -1
    end
    local function handle_dbus(signal,path,data,...)
        -- signal holds data about the sender of the signal
        -- path is the path of the signal
        -- data contains information from the media player (such as track)
        listener(data) 
    end
    dbus.connect_signal(dbus_interface, handler)
    if self.match_added == false then
        -- add a match for the property we are interested in
        dbus.add_match(db_wrap.bus,match_string)
        self.match_added = true
    end
end


-- sending 

function db_wrap.send(dest,object,message,args)
-- args contains the arguments for your function call. Can be nil.
    local dbus_cmd = string.format("dbus-send --print-reply --dest=%s %s %s",
                    dest,
                    object,
                    message)
    -- now append arguments, if they exist
    if args then
        -- iterate over table's elements
        dbus_cmd = dbus_cmd .. args
    end
    awful.spawn.easy_async(dbus_cmd,function(stdout,stderr,exitreason,exitcode)
        if exitcode != 0 then
            error(stderr)
        end
    end)
end

function db_wrap.getProps(dest,object,interface,callback)
-- gets properties, and returns them to caller. No fun processing done here
-- because I don't want to
    local dbus_cmd = string.format("dbus-send --print-reply --dest=%s %s %s",
                    dest,
                    object,
                    message)
    -- now append arguments, if they exist
    if args then
        -- iterate over table's elements
        dbus_cmd = dbus_cmd .. args
    end
    awful.spawn.easy_async(dbus_cmd,function(stdout,stderr,exitreason,exitcode)
        if exitcode != 0 then
            error(stderr)
        else
            output = parse(stdout)
            callback(output)
        end
    end)
end


return db_wrap
