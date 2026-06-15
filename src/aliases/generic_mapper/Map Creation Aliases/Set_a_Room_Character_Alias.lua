-- rcc <character> or rcc <character> <room ID> - where the character is one 
-- letter/number/symbol.

local room = matches[3] or map.currentRoom
room = tonumber(room) or map.relativeroom(map.currentRoom, room)
if not room or not map.roomexists(room) then
  map.echo("Sorry - which room do you want to put this character in? I don't know where you are at the moment, if you want to do the current room.")
  return
end

local char = matches[2]

if char == "clear" then
  setRoomChar(room, ' ')
  map.echo("Cleared the character from "..room.." ("..getRoomName(room)..")")
else
  setRoomChar(room, char)
  map.echo("Set the "..char:sub(1,1).." character on "..room.." ("..getRoomName(room)..")")
end
centerview(map.currentRoom)