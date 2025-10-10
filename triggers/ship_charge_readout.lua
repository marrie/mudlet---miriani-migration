local soundPaths = {
    "D:/mudlet/miriani/sounds/ship/misc/screen1.wav",
    "D:/mudlet/miriani/sounds/ship/misc/screen2.wav",
    "D:/mudlet/miriani/sounds/ship/misc/screen3.wav"
}

-- Pick a random sound from the list
local randomPath = soundPaths[math.random(#soundPaths)]

-- Play the random sound
playSoundFile({
    name = randomPath,
    volume = 75
})