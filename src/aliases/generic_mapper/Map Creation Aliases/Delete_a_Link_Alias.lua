-- urlk or room unlink <direction> - where direction will specify the direction
-- of the exit to unlink. This function will unlink exits both ways, or one way
-- if there is no incoming exit. 


-- need the current room, but we're lost
if not map.currentRoom or not map.roomexists(map.currentRoom) then map.echo("Don't know where we are at the moment.") return end

-- make sure the dir is valid
local dir = map.anytolong(matches[2])
if not dir then map.echo(matches[2].." isn't a valid normal exit.") return end

-- gone already?
if not getRoomExits(map.currentRoom)[dir] then map.echo(dir.." link doesn't exist already.") end

-- locate the room on the other end, so we can unlink it from there as well if necessary
local otherroom
if getRoomExits(getRoomExits(map.currentRoom)[dir])[map.ranytolong(dir)] then
  otherroom = getRoomExits(map.currentRoom)[dir]
end

if map.setExit(map.currentRoom, -1, dir) then
  if otherroom then
    if map.setExit(otherroom, -1, map.ranytolong(dir)) then
      map.echo(string.format("Deleted the %s exit from %s (%d).",
        dir, getRoomName(map.currentRoom), map.currentRoom))
     else map.echo("Couldn't delete the incoming exit.") end
  else
    map.echo(string.format("Deleted the one-way %s exit from %s (%d).",
      dir, getRoomName(map.currentRoom), map.currentRoom))
  end
else
  map.echo("Couldn't delete the outgoing exit.")
end
centerview(map.currentRoom)