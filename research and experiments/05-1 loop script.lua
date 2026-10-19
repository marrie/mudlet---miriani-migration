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

-- 5. Validate loop configuration

-- 6. Select recording

-- 7. Play active recording once

-- 8. Schedule next playback

-- 9. Start requested loop (idempotent for same identity) 