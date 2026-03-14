state = {
  environment = "ship",
  power = "on",
  room = "engineering"
}

current_active_loop_identity = ""

function evaluate_state()
  if state.power == "off" then
    return state.room .. "_power_off"
  end

  if state.power == "on" then
    return state.room .. "_power_on"
  end

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