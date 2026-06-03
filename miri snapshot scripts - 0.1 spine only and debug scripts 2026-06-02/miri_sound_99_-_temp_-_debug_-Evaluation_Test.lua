  registerAnonymousEventHandler("sysProtocolEnabled", function(event, protocol)
  print("Protocol enabled: " .. protocol)
end)

function test_sound()
  tempTimer(0.1, function()
    playSoundFile({ name = "C:/Users/marri/.config/mudlet/profiles/mirianiSandBox/media/hit.mp3", volume = 30 })
  end)
end