-- miriani lever 
-- this table is a random test table which will print the number of the random sound test file. it will not playsound.

test_oneshot_sound_map = {
  lever = {
    "lever1.mp3",
    "lever2.mp3",
    "lever3.mp3",
    "lever4.mp3",
"lever5.mp3"
    
  }
}

--debug function
-- this function  will print the name of the sound chosen at random from the list in the lever table.


function test_pick_random_lever_sound()

  local lever_count = #test_oneshot_sound_map.lever

  local random_index = math.random(1, lever_count)

  local selected_file = test_oneshot_sound_map.lever[random_index]

  print("random lever index: " .. tostring(random_index))
  print("selected lever file: " .. tostring(selected_file))

end

-- test lever sound using true paths
-- this function uses the get home dir  lua call to build paths. It will find and attempt to play a test mp3 sound.

function test_play_random_lever_sound()

  local lever_count = #test_oneshot_sound_map.lever

  local random_index = math.random(1, lever_count)

  local selected_file = test_oneshot_sound_map.lever[random_index]

  local full_path = getMudletHomeDir() .. "/media/sounds/ship/lever/" .. selected_file

  print("random lever index: " .. tostring(random_index))
  print("selected lever file: " .. tostring(selected_file))
  print("full lever path: " .. tostring(full_path))

  local play_result = playSoundFile(full_path)

  print("play result: " .. tostring(play_result))

end
