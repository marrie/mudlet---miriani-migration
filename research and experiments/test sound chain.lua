-- Version 0.1 chain test
-- Purpose: prove state, evaluation, transition, and playback wrapper wiring.
-- This file may start as one script and later split into separate scripts.

-- Planned sections:
-- 1. state
-- 2. evaluation
-- 3. transition
-- 4. playback wrapper
-- 5. manual test events

-- 1. state
-- This section will store the current known world facts.
-- For version 0.1, the facts are environment, power, and room.

-- begin state table

state = {
  environment = "ship",
    power = "unknown",
      room = "unknown"
}
-- end state table


-- 2. evaluation
-- This section will read state only.
-- It will return one loop identity or an empty string.
-- It will not play sound.

-- begin evaluation function
-- The evaluation function will be named evaluate_state.
function evaluate_state()
end



-- 3. transition
-- This section will compare the target loop identity to the current active loop identity.
-- If they are different, it will request a playback change.
-- If they are the same, it will do nothing.

-- 4. playback wrapper
-- This section will receive a loop identity from transition.
-- It will map the identity to a sound file when one exists.
-- If the sound file is missing, it will report that clearly instead of failing silently.

-- 5. manual test events
-- This section will simulate room and power changes by calling small test functions.
-- These test functions stand in for real Mudlet triggers during version 0.1 testing.
-- Real triggers can be added later after the chain works.

