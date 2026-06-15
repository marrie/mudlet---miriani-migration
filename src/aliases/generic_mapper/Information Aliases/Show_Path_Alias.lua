-- showpath roomID - shows you a path from where you are to another room (by it's ID)
-- showpath fromID toID - shows you a path from a given room to another given to 
--                        another room
if not matches[2] and not matches[3] then
  map.echo("Where do you want to showpath to?")
elseif matches[2] and not matches[3] then
  map.echoPath(map.currentRoom, matches[2])
else
  map.echoPath(matches[2], matches[3])
end