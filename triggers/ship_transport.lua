-- Delete the current line
deleteLine()

  -- The next line will now be at the current position, so delete it too
deleteLine()

-- Play the sound
playSoundFile({
    name = "D:/mudlet/miriani/sounds/ship/misc/clang.wav",
    volume = 50
})