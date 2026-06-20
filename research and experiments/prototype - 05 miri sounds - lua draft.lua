-- loop engine test for miriani.
-- purpose: To draft the functionality of a loop in the context of Miriani's sound system.

miri_sound_ambience_loop_state = {
  active_identity = "",
  active_path = "",
  active_duration = nil,
  active_volume = nil,
  active_overlap = nil,
  active_key = "",
  active_tag = "",
  active_timer = nil,
  is_running = false,
  last_error = ""
} -- end miri_sound_ambience_loop_state


miri_sound_loop_map = {
  control_room_power_on = {
    sound_type = "loop",
    channel = "ambience",
    label = "Control room powered ambience",
    folder = "sounds/ship/ambient - cr",

    files = {
      {
        file = "cr1.mp3",
        duration = 16
      } -- end file record cr1.mp3
    }, -- end files list

    volume = 30,
    overlap = 0.18,
    key = "miri_ambience_control_room_power_on",
    tag = "miri_ambience"
  } -- end control_room_power_on
} -- end miri_sound_loop_map


function miri_sound_ambience_debug(message)
  if miri_sound_state and miri_sound_state.debug_enabled then
    print("[Miri ambience] " .. tostring(message))
  end
end -- end miri_sound_ambience_debug

function miri_sound_ambience_reset_state()
  miri_sound_ambience_loop_state.active_identity = ""
  miri_sound_ambience_loop_state.active_path = ""
  miri_sound_ambience_loop_state.active_duration = nil
  miri_sound_ambience_loop_state.active_volume = nil
  miri_sound_ambience_loop_state.active_overlap = nil
  miri_sound_ambience_loop_state.active_key = ""
  miri_sound_ambience_loop_state.active_tag = ""
  miri_sound_ambience_loop_state.active_timer = nil
  miri_sound_ambience_loop_state.is_running = false
  miri_sound_ambience_loop_state.last_error = ""
end -- end miri_sound_ambience_reset_state
function miri_sound_ambience_clear_timer()
  if miri_sound_ambience_loop_state.active_timer then
    killTimer(miri_sound_ambience_loop_state.active_timer)
  end

  miri_sound_ambience_loop_state.active_timer = nil
end -- end miri_sound_ambience_clear_timer


function miri_sound_ambience_stop()
  local active_key = miri_sound_ambience_loop_state.active_key
  local active_tag = miri_sound_ambience_loop_state.active_tag

  miri_sound_ambience_loop_state.is_running = false

  miri_sound_ambience_clear_timer()

  if active_key ~= "" and active_tag ~= "" then
    stopSounds({
      key = active_key,
      tag = active_tag
    })
  else
    miri_sound_ambience_debug("Stop requested, but no active key and tag were set.")
  end

  miri_sound_ambience_reset_state()

  return true
end -- end miri_sound_ambience_stop


function miri_sound_ambience_validate(loop_identity)
  if type(loop_identity) ~= "string" or loop_identity == "" then
    miri_sound_ambience_loop_state.last_error = "Loop identity is missing or empty."
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end loop identity check

  local loop_entry = miri_sound_loop_map[loop_identity]

  if not loop_entry then
    miri_sound_ambience_loop_state.last_error = "No loop entry found for: " .. loop_identity
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end loop entry exists check

  if loop_entry.sound_type ~= "loop" then
    miri_sound_ambience_loop_state.last_error = "Loop entry is not marked as sound_type loop: " .. loop_identity
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end sound type check

  if loop_entry.channel ~= "ambience" then
    miri_sound_ambience_loop_state.last_error = "Loop entry is not marked as ambience channel: " .. loop_identity
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end channel check

  if type(loop_entry.folder) ~= "string" or loop_entry.folder == "" then
    miri_sound_ambience_loop_state.last_error = "Loop entry folder is missing for: " .. loop_identity
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end folder check

  if type(loop_entry.files) ~= "table" or #loop_entry.files == 0 then
    miri_sound_ambience_loop_state.last_error = "Loop entry files list is missing or empty for: " .. loop_identity
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end files list check

  for index, file_record in ipairs(loop_entry.files) do
    if type(file_record.file) ~= "string" or file_record.file == "" then
      miri_sound_ambience_loop_state.last_error = "File record " .. tostring(index) .. " is missing a file name for: " .. loop_identity
      miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
      return false, nil
    end -- end file name check

    if type(file_record.duration) ~= "number" or file_record.duration <= 0 then
      miri_sound_ambience_loop_state.last_error = "File record " .. tostring(index) .. " has an invalid duration for: " .. loop_identity
      miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
      return false, nil
    end -- end duration check
  end -- end files validation loop

  if type(loop_entry.volume) ~= "number" then
    miri_sound_ambience_loop_state.last_error = "Loop entry volume is missing or invalid for: " .. loop_identity
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end volume check

  if type(loop_entry.overlap) ~= "number" or loop_entry.overlap < 0 then
    miri_sound_ambience_loop_state.last_error = "Loop entry overlap is missing or invalid for: " .. loop_identity
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end overlap check

  if type(loop_entry.key) ~= "string" or loop_entry.key == "" then
    miri_sound_ambience_loop_state.last_error = "Loop entry key is missing for: " .. loop_identity
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end key check

  if type(loop_entry.tag) ~= "string" or loop_entry.tag == "" then
    miri_sound_ambience_loop_state.last_error = "Loop entry tag is missing for: " .. loop_identity
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false, nil
  end -- end tag check

  return true, loop_entry
end -- end miri_sound_ambience_validate


function miri_sound_ambience_select_file(loop_entry)
  local file_count = #loop_entry.files

  if file_count == 1 then
    return loop_entry.files[1]
  end

  local selected_index = math.random(file_count)
  return loop_entry.files[selected_index]
end -- end miri_sound_ambience_select_file

function miri_sound_ambience_play_active_once()
  if not miri_sound_ambience_loop_state.is_running then
    return false
  end -- end running check

  if miri_sound_ambience_loop_state.active_path == "" then
    miri_sound_ambience_loop_state.last_error = "Cannot play ambience loop because active_path is empty."
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    miri_sound_ambience_loop_state.is_running = false
    miri_sound_ambience_clear_timer()
    return false
  end -- end active path check

  playSoundFile({
    name = miri_sound_ambience_loop_state.active_path,
    volume = miri_sound_ambience_loop_state.active_volume,
    key = miri_sound_ambience_loop_state.active_key,
    tag = miri_sound_ambience_loop_state.active_tag
  }) -- end playSoundFile options

  return true
end -- end miri_sound_ambience_play_active_once

function miri_sound_ambience_schedule_replay()
  if not miri_sound_ambience_loop_state.is_running then
    return false
  end -- end running check

  if type(miri_sound_ambience_loop_state.active_duration) ~= "number" or miri_sound_ambience_loop_state.active_duration <= 0 then
    miri_sound_ambience_loop_state.last_error = "Cannot schedule ambience replay because active_duration is invalid."
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    miri_sound_ambience_loop_state.is_running = false
    miri_sound_ambience_clear_timer()
    return false
  end -- end active duration check

  if type(miri_sound_ambience_loop_state.active_overlap) ~= "number" or miri_sound_ambience_loop_state.active_overlap < 0 then
    miri_sound_ambience_loop_state.last_error = "Cannot schedule ambience replay because active_overlap is invalid."
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    miri_sound_ambience_loop_state.is_running = false
    miri_sound_ambience_clear_timer()
    return false
  end -- end active overlap check

  local replay_delay = miri_sound_ambience_loop_state.active_duration - miri_sound_ambience_loop_state.active_overlap

  if replay_delay < 0.1 then
    replay_delay = 0.1
  end -- end replay delay minimum check

  miri_sound_ambience_clear_timer()

  miri_sound_ambience_loop_state.active_timer = tempTimer(replay_delay, function()
    miri_sound_ambience_loop_state.active_timer = nil

    if not miri_sound_ambience_loop_state.is_running then
      return
    end -- end timer running check

    if miri_sound_ambience_play_active_once() then
      miri_sound_ambience_schedule_replay()
    end -- end replay scheduling check
  end) -- end tempTimer callback

  return true
end -- end miri_sound_ambience_schedule_replay

function miri_sound_ambience_start(loop_identity)
  if miri_sound_ambience_loop_state.is_running and miri_sound_ambience_loop_state.active_identity == loop_identity then
    miri_sound_ambience_debug("Ambience loop is already running: " .. tostring(loop_identity))
    return true
  end -- end already running check

  local is_valid, loop_entry = miri_sound_ambience_validate(loop_identity)

  if not is_valid then
    return false
  end -- end validation result check

  local selected_file = miri_sound_ambience_select_file(loop_entry)

  if not selected_file then
    miri_sound_ambience_loop_state.last_error = "Could not select ambience file for: " .. tostring(loop_identity)
    miri_sound_ambience_debug(miri_sound_ambience_loop_state.last_error)
    return false
  end -- end selected file check

  local selected_path = loop_entry.folder .. "/" .. selected_file.file

  miri_sound_ambience_stop()

  miri_sound_ambience_loop_state.active_identity = loop_identity
  miri_sound_ambience_loop_state.active_path = selected_path
  miri_sound_ambience_loop_state.active_duration = selected_file.duration
  miri_sound_ambience_loop_state.active_volume = loop_entry.volume
  miri_sound_ambience_loop_state.active_overlap = loop_entry.overlap
  miri_sound_ambience_loop_state.active_key = loop_entry.key
  miri_sound_ambience_loop_state.active_tag = loop_entry.tag
    miri_sound_ambience_loop_state.active_timer = nil
  miri_sound_ambience_loop_state.is_running = true
  miri_sound_ambience_loop_state.last_error = ""

  loadSoundFile({
    name = miri_sound_ambience_loop_state.active_path
  }) -- end loadSoundFile options

  if not miri_sound_ambience_play_active_once() then
    miri_sound_ambience_reset_state()
    return false
  end -- end first play check

  miri_sound_ambience_schedule_replay()

  return true
end -- end miri_sound_ambience_start