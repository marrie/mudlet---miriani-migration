-- Version 0.1 loop identities
-- control_room_powered
-- control_room_unpowered
-- airlock_powered
-- airlock_unpowered
-- engineering_powered
-- engineering_unpowered
-- empty string means silence or no safe decision

-- Version 0.1 state values
-- environment can be: ship
-- power can be: on, off, unknown
-- room can be: control_room, airlock, engineering, other, unknown


-- Version 0.1 chain
-- event updates state
-- evaluation reads state and returns one loop identity or empty string
-- transition compares target identity to current active identity
-- playback wrapper receives the identity and handles the sound file

-- Lua reading anchors
-- single equals stores a value
-- double equals asks a question
-- return hands a value back
-- print shows a value for debugging

-- Version 0.1 deferred
-- no stun heartbeat changes
-- no soundpack manifest
-- no automatic updater
-- no full sound metadata generator
-- no full sound library
-- no distribution packaging


-- Timer loop WAV test
-- Purpose: test the temp timer function in mudlet.

-- Temporary custom loop test.
-- Change these two values first.

testLoopFile = "C:/Users/marri/Desktop/test.mp3"
testLoopDuration = 16.0   -- length of the file in seconds
testLoopOverlap = 0.5     -- start next play half a second early

testLoopRunning = false
testLoopTimer = nil
testLoopKey = "test_ambience_loop"
testLoopTag = "ambience_test"

function start_test_loop()
  stop_test_loop()

  testLoopRunning = true

  loadSoundFile({
    name = testLoopFile
  })

  play_test_loop_once()
end

function play_test_loop_once()
  if not testLoopRunning then
    return
  end

  playSoundFile({
    name = testLoopFile,
    volume = 50,
    key = testLoopKey,
    tag = testLoopTag
  })

  local nextDelay = testLoopDuration - testLoopOverlap

  if nextDelay < 0.1 then
    nextDelay = 0.1
  end

  testLoopTimer = tempTimer(nextDelay, [[play_test_loop_once()]])
end

function stop_test_loop()
  testLoopRunning = false

  if testLoopTimer then
    killTimer(testLoopTimer)
    testLoopTimer = nil
  end

  stopSounds({
    key = testLoopKey,
    tag = testLoopTag
  })
end