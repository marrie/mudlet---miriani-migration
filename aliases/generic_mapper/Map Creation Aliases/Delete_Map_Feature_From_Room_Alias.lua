-- room delete feature [v<room id>] <feature>* or *rdf [v<room id>] <feature>
-- removes a map feature from the room. If the map feature is associated with
-- a character mark and its set on the room, a random character mark from the
-- other map features on the room is chosen to replace it. The room number to
-- delete the feature from can be given with the optional argument (note that
-- there is no space between the v and the ID). 

map.roomDeleteMapFeature(matches[3], matches[2] == "" and map.currentRoom or tonumber(matches[2]))