-- helper debug functions

--These functions will make it  easier  to test the  sound system when and if thigns brake.

function miri_sound_debug_run_chain()

  if miri_sound_state == nil then
    print("[miri sound debug] state table missing")
    return
  end

  print("[miri sound debug] environment: " .. tostring(miri_sound_state.environment))
  print("[miri sound debug] power: " .. tostring(miri_sound_state.power))
  print("[miri sound debug] room: " .. tostring(miri_sound_state.room))
  print("[miri sound debug] active: " .. tostring(miri_sound_state.current_active_loop_identity))

  local target_loop_identity = miri_sound_evaluate_state()

  print("[miri sound debug] target: " .. tostring(target_loop_identity))

  miri_sound_transition(target_loop_identity)

end

-- Debug helper: set power and run the chain.
function miri_sound_debug_set_power(value)

  if miri_sound_state == nil then
    print("[miri sound debug] state table missing")
    return
  end

  miri_sound_state.power = value
  print("[miri sound debug] power set to: " .. tostring(value))

  miri_sound_debug_run_chain()

end


-- Debug helper: set room and run the chain.
function miri_sound_debug_set_room(value)

  if miri_sound_state == nil then
    print("[miri sound debug] state table missing")
    return
  end

  miri_sound_state.room = value
  print("[miri sound debug] room set to: " .. tostring(value))

  miri_sound_debug_run_chain()

end
          -- Debug helper: show current state and evaluated target only.
-- This does not change state.
-- This does not call transition.
-- This does not call the wrapper.

function miri_sound_debug_status()

  if miri_sound_state == nil then
    print("[miri sound debug] state table missing")
    return
  end

  print("[miri sound debug] power: " .. tostring(miri_sound_state.power))
  print("[miri sound debug] room: " .. tostring(miri_sound_state.room))
  print("[miri sound debug] active: " .. tostring(miri_sound_state.current_active_loop_identity))
  print("[miri sound debug] target: " .. tostring(miri_sound_evaluate_state()))

end

-- Debug helper: check whether a loop identity exists in the wrapper map.
-- This does not change state.
-- This does not call evaluation.
-- This does not call transition.
-- This does not call playback.

function miri_sound_debug_check_mapping(loop_identity)

  if miri_sound_loop_map == nil then
    print("[miri sound debug] loop map missing")
    return
  end

  if loop_identity == nil or loop_identity == "" then
    print("[miri sound debug] no loop identity provided")
    return
  end

  local sound_entry = miri_sound_loop_map[loop_identity]

  if sound_entry == nil then
    print("[miri sound debug] mapping missing: " .. loop_identity)
    return
  end

  print("[miri sound debug] mapping found: " .. loop_identity)
  print("[miri sound debug] file: " .. tostring(sound_entry.file))
  print("[miri sound debug] label: " .. tostring(sound_entry.label))
  print("[miri sound debug] channel: " .. tostring(sound_entry.channel))
  print("[miri sound debug] type: " .. tostring(sound_entry.sound_type))

end
