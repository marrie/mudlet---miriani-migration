-- room create feature [v<room id>] <feature>* or *rcf [v<room id>] <feature>
-- adds a created map feature to the room. If the map feature is associated with
-- a character mark, it will be set on the room and existing marks get overwritten.
-- The room number to add the feature to can be given with the optional argument
-- (note that there is no space between the v and the ID). 

map.roomCreateMapFeature(matches[3], matches[2] == "" and map.currentRoom or tonumber(matches[2]))