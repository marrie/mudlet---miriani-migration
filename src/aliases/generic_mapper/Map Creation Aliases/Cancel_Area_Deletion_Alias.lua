-- cancel area deletion - stop area deletion. This will not restore deleted rooms,
-- merely pauses the process.

if not map.deletingarea then map.echo("I wasn't deleting any areas already.") return end

local areaname = map.deletingarea.areaname
map.deletingarea = nil

map.echo("Stopped deleting rooms in the '"..areaname.."'. The area is partially missing its rooms now, you'll want to restart the process to finish it.")