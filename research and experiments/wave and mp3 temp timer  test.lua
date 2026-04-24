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