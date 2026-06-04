-- miri sound 04 - wrapper
-- Version 0.1 playback wrapper placeholder.
-- This script will eventually handle sound files, paths, channels, and playback.
-- For now, it only checks whether a loop identity has a mapping.
-- It does not play real sound yet.
-- It does not solve looping yet.

miri_sound_loop_map = {
  control_room_power_on = {
    file = "placeholder_control_room_power_on.mp3",
    channel = "ambience",
    sound_type = "loop"
  },

  control_room_power_off = {
    file = "placeholder_control_room_power_off.mp3",
    channel = "ambience",
    sound_type = "loop"
  }
}


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

