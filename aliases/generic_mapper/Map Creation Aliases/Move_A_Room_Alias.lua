-- rc or room coords [v<id>] <option>, where option will specify the new
-- location of the room. The room ID is optional, it'll move the current
-- room if you don't provide one.


-- want the current room, but we're lost
if matches[2] == '' and (not map.currentRoom or not map.roomexists(map.currentRoom)) then map.echo("Don't know where we are at the moment.") return end

-- want another room, but it doesn't actually exist
if matches[2] ~= '' and not map.roomexists(matches[2]) then map.echo("v"..matches[2].." doesn't exist.") return end

local m = matches[3]
local rid, rname = (matches[2] ~= "" and matches[2] or map.currentRoom),
  (matches[2] ~= "" and getRoomName(matches[2]) or getRoomName(map.currentRoom))
local x,y,z

local function set() -- small func to set things
  setRoomCoordinates(rid, x, y, z)
  map.echo(string.format("%s (%d) is now at %dx, %dy, %dz.\n", rname, rid, x,y,z))
  centerview(rid)
end

-- let's be flexible and allow several ways if giving an arg
-- rc x y z
x,y,z = string.match(m, "(%-?%d+) (%-?%d+) (%-?%d+)")
if x then
  set(); return
end

-- rc xx? yy? zz?
x,y,z = string.match(m, "(%-?%d+)x"), string.match(m, "(%-?%d+)y"), string.match(m, "(%-?%d+)z")
if x or y or z then
  -- merge w/ old coords if any are missing
  local ox, oy, oz = getRoomCoordinates(rid)
  x = x or ox; y = y or oy; z = z or oz
  set(); return
end

-- rc left/west, right/east, ...
local ox, oy, oz = getRoomCoordinates(rid)
local has = table.contains
for w in string.gmatch(m, "%a+") do
  if has({"west", "left", "w", "l"}, w) then
    x = (x or ox) - 1; y = (y or oy); z = (z or oz)
  elseif has({"east", "right", "e", "r"}, w) then
    x = (x or ox) + 1; y = (y or oy); z = (z or oz)
  elseif has({"north", "top", "n", "t"}, w) then
    x = (x or ox); y = (y or oy) + 1; z = (z or oz)
  elseif has({"south", "bottom", "s", "b"}, w) then
    x = (x or ox); y = (y or oy) - 1; z = (z or oz)
  elseif has({"northwest", "topleft", "nw", "tl"}, w) then
    x = (x or ox) - 1; y = (y or oy) + 1; z = (z or oz)
  elseif has({"northeast", "topright", "ne", "tr"}, w) then
    x = (x or ox) + 1; y = (y or oy) + 1; z = (z or oz)
  elseif has({"southeast", "bottomright", "se", "br"}, w) then
    x = (x or ox) + 1; y = (y or oy) - 1; z = (z or oz)
  elseif has({"southwest", "bottomleft", "sw", "bl"}, w) then
    x = (x or ox) - 1; y = (y or oy) - 1; z = (z or oz)
  elseif has({"up", "u"}, w) then
    x = (x or ox); y = (y or oy); z = (z or oz) + 1
  elseif has({"down", "d"}, w) then
    x = (x or ox); y = (y or oy); z = (z or oz) - 1
  end

end
if x then set(); return end

map.echo([[Where do you want to move the room to?
  You can use direct coordinates or relative directions.]])