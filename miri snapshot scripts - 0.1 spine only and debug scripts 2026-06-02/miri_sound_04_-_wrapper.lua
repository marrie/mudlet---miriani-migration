-- miri sound 04 - wrapper
-- Version 0.1 playback wrapper placeholder.
-- This script will eventually handle sound files, paths, channels, and playback.
-- For now, it only reports what it would do.
-- It does not solve looping yet.

function miri_sound_wrapper_play_loop(loop_identity)

  if loop_identity == nil or loop_identity == "" then
    if miri_sound_state and miri_sound_state.debug_enabled then
      print("[miri sound] wrapper: silence requested")
    end
    return
  end

  if miri_sound_state and miri_sound_state.debug_enabled then
    print("[miri sound] wrapper: would play loop " .. loop_identity)
  end

end

function miri_sound_wrapper_stop_loop()

  if miri_sound_state and miri_sound_state.debug_enabled then
    print("[miri sound] wrapper: would stop current loop")
  end

end
