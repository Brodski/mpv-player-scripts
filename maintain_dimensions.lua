
local mp = require 'mp'
local msg = require 'mp.msg'
-- local width
-- local height
local width  = tonumber(mp.get_property("osd-width"))  or 0
local height  = tonumber(mp.get_property("osd-height")) or 0
local isFullscreen = false
mp.observe_property("osd-width", "number", function(name, value)
    if value then
        -- -- mp.msg.info("Window width changed: " .. value)
        log_width_and_height()
    end
end)

mp.observe_property("osd-height", "number", function(name, value)
    if value then
        -- -- mp.msg.info("Window height changed: " .. value)
        log_width_and_height()
    end
end)

function on_start_dimensions()
    -- mp.msg.info("height" .. height )
    -- mp.msg.info("width" .. width )
    -- if (width ~= nil) or (height ~= nil) or (height ~= 0) or (width ~= 0) then
    if width ~= nil and width ~= 0 and height ~= nil and height ~= 0 then
        set_window_size(width, height)
    end
end


function log_width_and_height(event)
    width  = tonumber(mp.get_property("osd-width"))  or 0
    height  = tonumber(mp.get_property("osd-height")) or 0
    -- mp.msg.info("(log_width_and_height) width: " .. width .. ", height: " .. height)
end

function set_window_size(width, height)
    local geometry = string.format("%dx%d", width, height)
    mp.commandv("set", "geometry", geometry)
    -- mp.msg.info("Setting window size to: " .. geometry)
end

mp.observe_property("time-pos", "number", function(name, value)
    local duration = mp.get_property_number("duration")
    local fps = mp.get_property_number("container-fps") or 30 -- Default to 30 FPS if unknown

    if value and duration and fps then
        local frame_time = 1 / fps
        local remaining_time = duration - value
        
        -- if last frame 
        if remaining_time <= (1 / fps) and remaining_time > 0 then
            -- mp.msg.info("Near end of video. Remaining time: " .. remaining_time .. " seconds")
            log_width_and_height()
        end
    end
end)



mp.register_event("file-loaded", on_start_dimensions)
-- mp.register_event("file-loaded", log_width_and_height)
-- mp.register_event("osd-dimensions", log_width_and_height)
-- mp.observe_property("osd-dimensions", "native", log_width_and_height)




