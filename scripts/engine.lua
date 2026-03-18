state = {
  environment = "ship",
  power = "on",
  room = "engineering"
}

current_active_loop_identity = ""



function evaluate_state()

  -- guard
  if state.power == nil then
    return ""
  end

  if state.room == nil then
    return ""
  end

  -- power rung
  if state.power == "off" then
    return state.room .. "_power_off"
  end

  -- room rung (only reached if power is not off)
  if state.power == "on" then
    return state.room .. "_power_on"
  end

  -- default silence
  return ""
end

function transition(target_loop_identity)

  if target_loop_identity ~= current_active_loop_identity then
    print("starting " .. target_loop_identity)
    current_active_loop_identity = target_loop_identity
  end

end


function test_engine()
  target = evaluate_state()
  transition(target)

  target = evaluate_state()
  transition(target)
end

function set_power(value)
  state.power = value
  print("power now:", state.power)

  local target = evaluate_state()
  transition(target)
end

function set_room(value)
  state.room = value
  print("room now:", state.room)

  local target = evaluate_state()
  transition(target)
end

function on_room_event(new_room)
  state.room = new_room
  print("[event] room detected:", new_room)

  local target = evaluate_state()
  transition(target)
end

function on_power_event(new_power)
  state.power = new_power
  print("[event] power detected:", new_power)

  local target = evaluate_state()
  transition(target)
end