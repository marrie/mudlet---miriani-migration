-- miri sound 02 - evaluation
-- Version 0.1 evaluation logic.
-- This script reads state only.
-- It returns one loop identity or an empty string.
-- It does not play sound.
-- It does not change state.

function miri_sound_evaluate_state()

  -- guard: state table must exist
  if miri_sound_state == nil then
    return ""
  end

  -- guard: version 0.1 only handles ship ambience
  if miri_sound_state.environment ~= "ship" then
    return ""
  end

  -- guard: power must be known
  if miri_sound_state.power == "unknown" or miri_sound_state.power == nil then
    return ""
  end

  -- guard: room must be known
  if miri_sound_state.room == "unknown" or miri_sound_state.room == nil then
    return ""
  end

  -- power rung: power off overrides room ambience
  if miri_sound_state.power == "off" then
    return miri_sound_state.room .. "_power_off"
  end

  -- room rung: power on uses the powered version of the current room
  if miri_sound_state.power == "on" then
    return miri_sound_state.room .. "_power_on"
  end

  -- default silence
  return ""

end
