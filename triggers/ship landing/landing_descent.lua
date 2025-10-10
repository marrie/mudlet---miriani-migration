if landingInProgress then
    selectCurrentLine()
    replace("")
    
    -- Play descent/acceleration sound
    playSoundFile({
        name = "D:/mudlet/miriani/sounds/ship/move/land.wav",
        volume = 50
    })
end