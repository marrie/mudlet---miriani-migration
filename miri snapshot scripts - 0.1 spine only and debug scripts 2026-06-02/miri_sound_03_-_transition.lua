-- miri sound 03 - transition
-- Version 0.1 transition logic.
-- Receives a target loop identity.
-- Compares it with the current active loop identity.
-- If the target is the same, it does nothing.
-- If the target is different, it asks the wrapper to stop and play.

function miri_sound_transition(target_loop_identity)

  -- guard: state table must exist
  if miri_sound_state == nil then
    return
  end

  -- guard: nil target should behave like empty string
  if target_loop_identity == nil then
    target_loop_identity = ""
  end

  -- if the target is already active, do nothing
  if target_loop_identity == miri_sound_state.current_active_loop_identity then
    if miri_sound_state.debug_enabled then
      print("[miri sound] transition: no change")
    end
    return
  end

  -- target is different, so transition begins
  if miri_sound_state.debug_enabled then
    print("[miri sound] transition: changing loop")
    print("from: " .. miri_sound_state.current_active_loop_identity)
    print("to: " .. target_loop_identity)
  end

  -- ask wrapper to stop the old loop
  miri_sound_wrapper_stop_loop()

  -- record the new active loop identity
  miri_sound_state.current_active_loop_identity = target_loop_identity

  -- ask wrapper to play the new loop, or silence if target is empty
  miri_sound_wrapper_play_loop(target_loop_identity)

end
