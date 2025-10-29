local mp = require 'mp'
local msg = require 'mp.msg'

local duration = nil
local isCustomLoopOn = false
local isTrickology = false


function on_file_loaded()
    duration = mp.get_property_number("duration")
end

-- mp.add_hook("on_unload", 50, function()
--     local playlist = mp.get_property_native("playlist")
--     playlist_length = #playlist

--     msg.info("File is unloading!")
--     msg.info("playlist_length:  " .. tostring(playlist_length))
--     msg.info("isCustomLoopOn:   " .. tostring(isCustomLoopOn))
--     msg.info("isTrickology:     " .. tostring(isTrickology))

--     if playlist_length > 1 and isCustomLoopOn and isTrickology==false then
--         msg.info("CLEARING LOOP")
--         msg.info("CLEARING LOOP")
--         msg.info("CLEARING LOOP")
--         msg.info("CLEARING LOOP")
--         mp.set_property("ab-loop-a", "no")
--         mp.set_property("ab-loop-b", "no")
--         mp.osd_message("Cleared A-B loop")
--         isTrickology = true
--     end

-- end)

-- function on_end(event)
--     local playlist = mp.get_property_native("playlist")
--     playlist_length = #playlist
--     msg.info("    [END] playlist_length ".. playlist_length)
--     msg.info("    [END] isCustomLoopOn ".. tostring(isCustomLoopOn))
--     if playlist_length == 1 then
--         -- local pos = mp.get_property_number("time-pos")
--         -- local duration = mp.get_property_number("duration")
--         -- msg.info("time-pos: " .. pos)

--         msg.info("    [END] LOOP ON")
--         msg.info("    [END] LOOP ON")
--         msg.info("    [END] LOOP ON")
--         msg.info("    [END] LOOP ON")
--         msg.info("    [END] LOOP ON")
--         msg.info("    [END] LOOP ON")
--         msg.info("    [END] LOOP ON")
--         msg.info("    [END] LOOP ON")
--         mp.set_property_number("ab-loop-a", 0)
--         mp.set_property_number("ab-loop-b", duration)
    
--         mp.osd_message("Set A point at " .. 0)
--         mp.osd_message("Set B point at " .. duration)
--         isCustomLoopOn = true
--         isTrickology = false
--         msg.info("    LOOP ON: isCustomLoopOn ".. tostring(isCustomLoopOn))
--         -- mp.commandv("seek", "0", "absolute", "exact")
--     end

-- end

mp.register_script_message("set_ab_loop", function()
    local pos = mp.get_property_number("time-pos")
    local duration = mp.get_property_number("duration")
    msg.info("time-pos: " .. pos)
    msg.info("duration: " .. duration)
    mp.set_property_number("ab-loop-a", 0)
    mp.set_property_number("ab-loop-b", duration)

    mp.osd_message("Set A point at " .. 0)
    mp.osd_message("Set B point at " .. duration)
end)

mp.add_key_binding("p", "ab_loop_custom", function()
    mp.commandv("script-message", "set_ab_loop")
end)



mp.register_event("file-loaded", on_file_loaded)
mp.register_event("end-file", on_end)
-- mp.register_event("file-loaded", on_start_dimensions)