-- miri sound 04 - wrapper
-- Version 0.1 playback wrapper placeholder.
-- This script will eventually handle sound files, paths, channels, and playback.
-- For now, it only checks whether a loop identity has a mapping.
-- It does not play real sound yet.
-- It does not solve looping yet.


-- miri sound loop map


miri_sound_loop_map = {
  control_room_power_on = {
    file = "placeholder_control_room_power_on.mp3",
    channel = "ambience",
    sound_type = "loop",
    label = "Control room powered ambience"
  },

  control_room_power_off = {
    file = "placeholder_control_room_power_off.mp3",
    channel = "ambience",
    sound_type = "loop",
    label = "Control room unpowered ambience"
  }
}

-- miri sound one shot table map

miri_sound_oneshot_map = {
  lever = {
    folder = "ship/lever",
    files = {
      "lever1.mp3",
      "lever2.mp3",
      "lever3.mp3",
      "lever4.mp3",
      "lever5.mp3"
    }
  },

  ship_power_off = {
    folder = "ship/power down",
    files = {
      "PowerOff1.mp3"
    }
  }
}

-- this is a random picker function which will choose from lever 1 to 5 mp3 file

function miri_sound_wrapper_play_oneshot(category_name)

  local category_entry = miri_sound_oneshot_map[category_name]

  if category_entry == nil then
    print("missing one-shot category: " .. tostring(category_name))
    return false
  end

  local file_count = #category_entry.files

  if file_count == 0 then
    print("one-shot category has no files: " .. tostring(category_name))
    return false
  end

  local selected_file

  if file_count == 1 then
    selected_file = category_entry.files[1]
  else
    local random_index = math.random(1, file_count)
    selected_file = category_entry.files[random_index]
  end

local media_path = "sounds/" .. category_entry.folder .. "/" .. selected_file

print("one-shot category: " .. tostring(category_name))
print("selected one-shot file: " .. tostring(selected_file))
print("one-shot media path: " .. tostring(media_path))

local play_result = playSoundFile(media_path)

  print("one-shot play result: " .. tostring(play_result))

  return play_result

end


function miri_sound_wrapper_play_loop(loop_identity)

  if loop_identity == nil or loop_identity == "" then
    if miri_sound_state and miri_sound_state.debug_enabled then
      print("[miri sound] wrapper: silence requested")
    end
    return
  end

  local sound_entry = miri_sound_loop_map[loop_identity]

  if sound_entry == nil then
    if miri_sound_state and miri_sound_state.debug_enabled then
      print("[miri sound] wrapper: missing mapping for " .. loop_identity)
    end
    return
  end

  if miri_sound_state and miri_sound_state.debug_enabled then
    print("[miri sound] wrapper: mapped " .. loop_identity)
    print("[miri sound] wrapper: file " .. sound_entry.file)
    print("[miri sound] wrapper: channel " .. sound_entry.channel)
    print("[miri sound] wrapper: type " .. sound_entry.sound_type)
  end

end


function miri_sound_wrapper_stop_loop()

  if miri_sound_state and miri_sound_state.debug_enabled then
    print("[miri sound] wrapper: would stop current loop")
  end

end

function miri_sound_event_ship_power_off()

  miri_sound_wrapper_play_oneshot("ship_power_off")

  if miri_sound_state then
    miri_sound_state.power = "off"
  end

  print("miri sound event: ship power off")

end