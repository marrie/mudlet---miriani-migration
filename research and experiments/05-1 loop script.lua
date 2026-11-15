-- Miriani soundpack - loop engine
-- Responsible for starting, replaying, and stopping loops.

-- 1. Runtime state

miri_sound_loop_state = {
    active_identity = "",
    active_path = "",
    active_duration = nil,
    active_volume = nil,
    active_overlap = nil,
    active_key = "",
    active_tag = "",
    active_timer = nil,
    is_running = false
}


-- 2. Reset runtime state


function miri_sound_loop_reset_state()
    local state = miri_sound_loop_state

    state.active_identity = ""
    state.active_path = ""
    state.active_duration = nil
    state.active_volume = nil
    state.active_overlap = nil
    state.active_key = ""
    state.active_tag = ""
    state.active_timer = nil
    state.is_running = false
end -- end of state reset function.

-- 3. Cancel replay timer

function miri_sound_loop_clear_timer()
    local state = miri_sound_loop_state

    if state.active_timer ~= nil then
        killTimer(state.active_timer)
        state.active_timer = nil
    end -- end if 
end -- end cancel function

-- 4. Stop active loop (idempotent)

function miri_sound_loop_stop()
    local state = miri_sound_loop_state

    state.is_running = false

            miri_sound_loop_clear_timer()

    if state.active_key ~= "" then
        stopSounds({key = state.active_key})
    end -- end if

    miri_sound_loop_reset_state()

end -- end function itempotent stop

    -- validator which checks the loop identity, configuration map, sound type, folder, and recording list.

-- 5. Validate loop configuration

-- begin function

    function miri_sound_loop_validate(loop_identity)
    if type(loop_identity) ~= "string" or loop_identity == "" then
        return nil
    end -- end if

    if type(miri_sound_loop_map) ~= "table" then
        return nil
    end -- end if

    local sound_entry = miri_sound_loop_map[loop_identity]

    if type(sound_entry) ~= "table" then
        return nil
    end -- end if
    
    if sound_entry.sound_type ~= "loop" then
        return nil
    end -- end if

    if type(sound_entry.folder) ~= "string" or sound_entry.folder == "" then
        return nil
    end -- end if

    if type(sound_entry.files) ~= "table" or #sound_entry.files == 0 then
        return nil
    end    -- end if

    -- begin loop

    for _, file_entry in ipairs(sound_entry.files) do
        if type(file_entry) ~= "table" then
            return nil
        end -- end if

        if type(file_entry.file) ~= "string" or file_entry.file == "" then
            return nil
        end -- end if

        if type(file_entry.duration) ~= "number" or file_entry.duration <= 0 then
            return nil
        end -- end if
    end -- end loop

        if type(sound_entry.volume) ~= "number"
        or sound_entry.volume < 1
        or sound_entry.volume > 100 then
        return nil
    end -- end if

    if type(sound_entry.overlap) ~= "number"
        or sound_entry.overlap < 0 then
        return nil
    end -- end if

    --begin loop

        for _, file_entry in ipairs(sound_entry.files) do
        if sound_entry.overlap >= file_entry.duration then
            return nil
        end -- end if
    end -- end loop

        if type(sound_entry.key) ~= "string" or sound_entry.key == "" then
        return nil
    end -- end if

    if type(sound_entry.tag) ~= "string" or sound_entry.tag == "" then
        return nil
    end -- end if

        return sound_entry
end -- end miri_sound_loop_validate

    
    -- 6. Select recording


    function miri_sound_loop_select_recording(sound_entry)
    -- count the number of files and choose a random one from the files list.
        
    local file_count = #sound_entry.files
    local selected_index = math.random(1, file_count)
    local selected_file = sound_entry.files[selected_index]
    return selected_file
end -- end miri_sound_loop_select_recording

    -- 7. Play active recording once
function miri_sound_loop_play_once()
    local state = miri_sound_loop_state

    if not state.is_running then
        return false
    end -- end if
    -- call mudlet's internal play sound file  function
        playSoundFile({ -- begin table
        name = state.active_path,
        volume = state.active_volume,
        key = state.active_key,
        tag = state.active_tag
    }) -- end table and playSoundFile call
        return true
end -- end miri_sound_loop_play_once
    
    -- 8. Schedule next playback

    function miri_sound_loop_schedule_next()
    local state = miri_sound_loop_state

    if not state.is_running then
        return false
    end -- end if
        local next_delay = state.active_duration - state.active_overlap

    if next_delay < 0.1 then
        next_delay = 0.1
    end -- end if

        state.active_timer = tempTimer(next_delay, function()
        state.active_timer = nil

        if not state.is_running then
            return
        end -- end if
    end) -- end callback timer function

    -- 9. Start requested loop (idempotent for same identity) 