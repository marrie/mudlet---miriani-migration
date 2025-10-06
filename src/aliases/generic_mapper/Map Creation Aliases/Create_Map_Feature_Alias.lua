-- feature create <feature> [char <room character>] - will create a new map
-- feature for use on rooms. You can also optionally add a character mark to
-- the feature, which will be set when a map feature is added to a room. 
-- Note: Map feature names are not allowed to contain numbers. 

map.createMapFeature(matches[2]:trim(), (matches[3] and matches[3]:trim()))