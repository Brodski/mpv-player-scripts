----------------------------------------------------------------------
--                                                                  --
-- autosave.lua                                                     --
-- https://gist.github.com/Hakkin/5489e511bd6c8068a0fc09304c9c5a82  --
--                                                                  --
----------------------------------------------------------------------

local mp = require 'mp'
local msg = require 'mp.msg'

local wait_seconds = 3
local isOn = false

local function save()
	mp.command("write-watch-later-config")
end

local function gobabygo()
    if isOn then
        msg.info("next...")
        save()
        mp.command("playlist-next")
    end
end

local next_period_timer = mp.add_periodic_timer(wait_seconds, gobabygo)
mp.add_timeout((wait_seconds - 1), function()
    next_period_timer:stop()
end)

-- Define the keybinding: Ctrl+z
local isOn = false
mp.add_key_binding("Ctrl+z", "delayed-next-toggle", function()
    isOn = not isOn
    if isOn then
        mp.osd_message("Auto tab ON (ctrl z)")
        next_period_timer:resume()
    else
        mp.osd_message("Auto tab OFF (ctrl z)")
        next_period_timer:stop()
    end
end)
-- Define the keybinding: Ctrl+n
mp.add_key_binding("Ctrl+n", "delayed-next-baby", function()    
    isOn = true
    mp.osd_message("Auto tab on. (alt + n = off)")
    next_period_timer:resume()
end)

mp.add_key_binding("Alt+n", "delayed-next-baby-OFF", function()
    isOn = false
    mp.osd_message("Auto tab off. (ctrl + n = on)")
    next_period_timer:stop()
end)


local function pause(name, paused)
    msg.info("IS PAUSE:" .. tostring(paused))
	if paused then
		next_period_timer:stop()
	else
		next_period_timer:resume()
	end
end

mp.observe_property("pause", "bool", pause)
next_period_timer:stop()