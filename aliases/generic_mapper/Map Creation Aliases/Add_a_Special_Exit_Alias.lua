-- spe <other room> <command> or exit special <other room> <command>, where other
-- room will specify the room to link with, and command the command to us to get
-- to that room.

-- spe clear and spe list match on this
if matches[2] == "clear" or matches[2] == "list" then return end

-- need the current room, but we're lost
if not map.currentRoom or not map.roomexists(map.currentRoom) then map.echo("Don't know where we are at the moment.") return end

local otherroom = tonumber(matches[2]) or map.relativeroom(map.currentRoom, matches[2])

-- need the another room, but it doesn't actually exist
if not otherroom or not map.roomexists(otherroom) then map.echo(matches[2].." doesn't exist.") return end

addSpecialExit(map.currentRoom, tonumber(otherroom), matches[3])
addSpecialExit(map.currentRoom, tonumber(otherroom), matches[3])
map.echo(string.format("Added special exit with command '%s' to %s (%d).", matches[3], getRoomName(otherroom), otherroom))
centerview(map.currentRoom)