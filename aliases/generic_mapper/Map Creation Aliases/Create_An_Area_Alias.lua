-- area add <area name> - will create a new area and automatically give it an ID.

local t = getAreaTable(); local tr = {}; for k,v in pairs(t) do tr[v] = k end
local newid = table.maxn(tr) + 1

setAreaName( newid, matches[2] )
map.echo(string.format("Created new area %s (%d)", matches[2], newid))
centerview(map.currentRoom)