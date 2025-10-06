-- spev <from room> <to room> <command> - This different than spe, which allows
-- you to link only the current room to another room - this command doesn't
-- require you to be in the starting room. 

local room1, room2 = tonumber(matches[2]), tonumber(matches[3])

if not room1 or not map.roomexists(room1) then
  map.echo("Room #"..matches[2].." doesn't exist - create it first, or make sure you got the room ID right?")
  return
end

if not room2 or not map.roomexists(room2) then
  map.echo("Room #"..matches[3].." doesn't exist - create it first, or make sure you got the room ID right?")
  return
end

addSpecialExit(room1, room2, matches[4])
map.echo(string.format("Added special exit with command '%s' to from %s (%d) to %s (%d).", matches[4], getRoomName(room1), room1, getRoomName(room2), room2))