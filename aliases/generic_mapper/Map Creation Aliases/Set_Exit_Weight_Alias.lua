-- rwe <optional room ID, otherwise current> <weight> <exit>, where the weight
-- is a positive number (default for exits is 0). Setting a higher weight will
-- make the exit be less likely to be used.

local room = (matches[2] ~= "" and tonumber(matches[2]) or map.currentRoom)

local weight, exit = tonumber(matches[3]), matches[4]

if not roomExists(room) then map.echo("Room "..room.." doesn't exist. It has to before we can set weights on exits.") return end

setExitWeight(room, exit, weight)

map.echo(string.format("Set the weight on the %d room going %s to %s. If it's a two-way exit, please set the reverse exit as well.", room, exit, weight))