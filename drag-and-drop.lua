
-- Get the mp module which provides MPV's scripting API
local mp = require 'mp'
local msg = require 'mp.msg'

local my_variable = 0
-- local playlist_drag_n_drop = {}
local playlist_drag_n_drop_map = {}
local hacky_playlist_map = {}
local current_file = ''
local is_first_run = true
local id_counter = 1

local playlist_bski = {}

function on_start_file(event)
    --msg.info("    -------- START 1 ---------")
    mp.set_property("pause", "no")
    local start_file = mp.get_property("path")

    --msg.info("    [START] .........................................")
    --msg.info("    [START] start-file. start_file: " .. start_file)
    local playlist = mp.get_property_native("playlist")
    for i, entry in pairs(playlist) do
        local is_current = entry.current and "[CURRENT] " or ""
        --msg.info("    [START] " .. i .. is_current .. " - id:".. entry.id .." " .. entry.filename)
        -- playlist_bski[id_counter] = entry.filename
        playlist_bski[entry.filename] = true
        id_counter = id_counter + 1
    end

    for entry, _ in pairs(playlist_bski) do
        local hasIt = false
        --msg.info("    [START] BSKI : ")
        for i2, item in pairs(playlist) do
            if item.filename:find(entry, 1, true) then
                hasIt = true
                break
            end
        end
        if hasIt == false then
            --msg.info("    [START] BSKI ADDING: " .. entry)
            mp.commandv("loadfile", entry, "append")
        end
    end
    --msg.info("    [START] .........................................")
    --msg.info("    [START] -------- START.2 ---------")
end

function on_end(event)
    ------------------------------------
    -- event.reason = stop ---> drag file to playlist
    -- event.reason = quit ---> I closed it
    -- event.reason = eof ---> player reached the end
    ------------------------------------

    --msg.info("[END] *********** TOP ************** ")
    --msg.info("[END] event.reason    : " .. event.reason)
    for k, v in pairs(event) do
        print("[END] event." .. k .. " = " .. tostring(v))
    end

    if event.reason == "stop" then
        local playlist = mp.get_property_native("playlist")
        --msg.info("[END] event.reason    : " .. event.reason)
    end
end


-- r key = remove
function remove_current_from_map()
    local playlist = mp.get_property_native("playlist")
    for i, entry in pairs(playlist) do
        if entry.current then
            if playlist_bski[entry.filename] then
                playlist_bski[entry.filename] = nil
                msg.info("[REMOVE] Removed from custom map: " .. entry.filename)
                mp.commandv("playlist-remove", i - 1) -- mpv uses 0-based index
            else
                msg.info("[REMOVE] Not in custom map: " .. entry.filename)
            end
            return
        end
    end
end






function deepcopy(orig)
    local copy
    if type(orig) == "table" then
        copy = {}
        for k, v in next, orig, nil do
            copy[deepcopy(k)] = deepcopy(v)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

function len(some_map)
    cnt = 0
    for _ in pairs(some_map) do
        cnt = cnt + 1
    end
    return cnt
end

mp.add_key_binding("r", "remove-current-from-map", remove_current_from_map)
mp.register_event("start-file", on_start_file)
mp.register_event("end-file", on_end)








-- mp.observe_property("playlist", "native", function(name, value)
--     if value == nil then
--         print("Playlist is now empty or invalid.")
--         return
--     end

--     print("Playlist changed. Current entries:")
--     print("Playlist changed. Current entries:")
--     print("Playlist changed. Current entries:")
--     print("Playlist changed. Current entries:")
--     print("Playlist changed. Current entries:")
--     for i, item in ipairs(value) do
--         print(string.format(" %d: %s", i, item.filename))
--     end
-- end)