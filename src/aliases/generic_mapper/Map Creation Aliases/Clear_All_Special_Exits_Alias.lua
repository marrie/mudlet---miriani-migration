-- spe clear <option> or exit special clear <option> - where option is the
-- location or the ID of the room you'd like to clear all special exits in. 

-- want the current room, but we're lost
if not matches[2] and (not map.currentRoom or not map.roomexists(map.currentRoom)) then map.echo("Don't know where we are at the moment.") return end

-- want another room, but it doesn't exist
if matches[2] and tonumber(matches[2]) and not map.roomexists(matches[2]) then map.echo("v"..matches[2].." doesn't exist.") return end

-- or a relative one
if matches[2] and not tonumber(matches[2]) and not map.relativeroom(map.currentRoom, matches[2]) then map.echo("There is no room "..matches[2].. " of us.") return end

local rid = (not matches[2] and map.currentRoom or (tonumber(matches[2]) or map.relativeroom(map.currentRoom, matches[2])))

clearSpecialExits(rid)
map.echo(string.format("Cleared all special exits in %s (%d).\n", getRoomName(rid), rid))