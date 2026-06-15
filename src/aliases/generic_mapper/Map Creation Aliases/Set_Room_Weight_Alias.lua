-- rw <optional room ID or direction> <weight>, where option is the location
-- or ID of the room whose weight you'd like to change.

local weight = tonumber(matches[3]), room
if matches[2] == '' then room = map.currentRoom
else
  room = tonumber(matches[2]) or map.relativeroom(map.currentRoom, matches[2])
end

if not room or not map.roomexists(room) then
  map.echo("Sorry - which room do you want to set the weight on? I don't know where you are at the moment, if you want to do the current room.")
  return
end

if not weight then
  map.echo("What weight do you want to set on #"..room.."?")
end

local oldweight = getRoomWeight(room)
setRoomWeight(room, weight)

if weight > oldweight then
  map.echo("Increased the room weight on #"..room.." ("..getRoomName(room)..") by "..(weight-oldweight).." to "..weight.." - making it less desirable to travel through.")
elseif weight < oldweight then
  map.echo("Decreased the room weight on #"..room.." ("..getRoomName(room)..") by "..(oldweight-weight).." to "..weight.." - making it more desirable to travel through.")
else
  map.echo("The room weight on #"..room.." ("..getRoomName(room)..") is already "..weight..".")
end