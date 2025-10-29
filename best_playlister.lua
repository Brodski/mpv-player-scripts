
local utils = require 'mp.utils'


local function print_playlist()
    local playlist = mp.get_property_native("playlist")
    for i, entry in ipairs(playlist) do
        mp.msg.info(string.format("Item %d: %s", i, entry.filename))
    end
end

local function is_exists(my_list, search_for_x)
    local is_found = false
    local idx_found = nil

    for idx, item in ipairs(my_list) do
        if item == search_for_x then
            is_found = true
            idx_found = idx
            break
        end
    end
    return idx_found, is_found
end



function get_files_in_dir(dir)
    local files = {}
    local entries = utils.readdir(dir, "files")  -- "files" filters to files only
    if entries then
        for _, filename in ipairs(entries) do
            local last_dot_index = filename:match(".*()%.")  -- The () captures the position
            if  last_dot_index and last_dot_index > 1 then
                local filename_no_ext = filename:sub(1, last_dot_index - 1)
                mp.msg.info(_ .. "x " .. filename_no_ext)
                table.insert(files, filename_no_ext)
            end
        end
    end
    return files
end



local count = 1

-- local SAVE_DIRECTORY = "D:\\mpv_playlists"
local SAVE_DIRECTORY = "D:\\PLAYLISTS_MPV"


local function save_playlist() 
    -- Generate unique timestamp (reads filenames in Directory)
    local timestamp = os.date("%Y-%m-%d-%H-%M")
    local playlist_names_arr = get_files_in_dir(SAVE_DIRECTORY)
    local idx, is_time_exist =  is_exists(playlist_names_arr, timestamp)
    if is_time_exist then 
        timestamp = timestamp .. "_" .. count
        count = count + 1
    end

    -- Setup Save()-type objects
    local save_path = utils.join_path(SAVE_DIRECTORY, timestamp .. ".m3u8")
    local save_file_io, err = io.open(save_path, "w")
    local playlist = mp.get_property_native("playlist")
    

    if not save_file_io then
        -- mp.msg.error("Failed to open file for writing: " .. (err or "unknown error"))
        return
    end

    -- The Saveing of the playlist
    for i, entry in ipairs(playlist) do
        mp.msg.info(i)
        
        local pwd = mp.get_property("working-directory")
        local filename = mp.get_property('playlist/'.. i-1 ..'/filename') -- mpv lua scripting "syntax" essentially. 
        local fullpath = utils.join_path(pwd, filename)

        -- mp.msg.info("fullpath: " .. fullpath)
        save_file_io:write(fullpath .. "\n")

    end

    save_file_io:close()
    mp.osd_message("Saved!")
    -- mp.msg.info("Playlist saved to " .. save_path)
end


-- mp.register_event("start-file", print_playlist)
mp.add_key_binding("Ctrl+s", "save-playlist", save_playlist)