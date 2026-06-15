-- Jor'Mox's Generic Map Script
-- the script self-updates, changing this value will bring an update to all installations
-- make sure versions.lua has the latest version in it
local version = "2.1.8"

    -- look into options for non-standard door usage for speedwalk
    -- come up with aliases to set translations and custom exits, add appropriate help info

mudlet = mudlet or {}
mudlet.mapper_script = true
map = map or {}

map.help = {[[
    <cyan>Generic Map Script<reset>

    This script allows for semi-automatic mapping using the included triggers.
    While different games can have dramatically different ways of displaying
    information, some effort has been put into giving the script a wide range of
    potential patterns to look for, so that it can work with minimal effort in
    many cases. The script locates the room name by searching up from the
    detected exits line until a prompt is found or it runs out of text to
    search, clearing saved text each time a prompt is detected or a movement
    command is sent, with the room name being set to the last line of text
    found. An accurate prompt pattern is necessary for this to work well, and
    sometimes other text can end up being shown between the prompt and the room
    name, or on the same line as the room name, which can be handled by
    providing appropriate patterns telling the script to ignore that text. Below
    is an overview of the included commands and important events that this
    script uses to work. Additional information on each command or event is
    available in individual help files.

    <cyan>Fundamental Commands:<reset>
        These are commands used to get the mapper functional on a basic level.

        <link: show>map show</link> - Displays or hides a map window.
        <link: quick start>map basics</link> - Shows a quick-start guide with some basic information to
            help get the script working.
        <link: 1>map help [command name]</link> - Shows either this help file or the help file for the
            command given.
        <link: find prompt>find prompt</link> - Instructs the script to look for a prompt that matches
            a known pattern.
        <link: prompt>map prompt <pattern></link> - Provides a specific pattern to the script that
            matches your prompt, uses <urllink: https://www.lua.org/pil/20.2.html>Lua string-library patterns</urllink>.
        <link: ignore>map ignore <pattern></link> - Provides a specific pattern for the script to
            ignore, uses <urllink: https://www.lua.org/pil/20.2.html>Lua string-library patterns</urllink>.
        <link: movemethod>map movemethod <word></link> - Adds a movement method for the script to
            look for when mapping.
        <link: debug>map debug</link> - Toggles on debug mode, in which extra messages are shown with
            the intent of assisting in troubleshooting getting the script setup.
        <link: me>map me</link> - Locates the user on the map, if possible.
        <link: path>map path <room name> [; area name]</link> - Finds a walking path to the named
            room, in the named area if specified.
        <link: character>map character <name></link> - Sets a given name as the current character for
            the purposes of the script, used for different prompt patterns and
            recall locations.
        <link: recall>map recall</link> - Sets the current room as the recall location of the
            current character
        <link: config>map config <configuration> [value]</link> - Sets or toggles the given
            configuration either turning it on or off, if no value is given, or sets it to the given
            value.
        <link: window>map window <configuration> [value]</link> - Sets the given configuration for the
            map window to the given value.
        <link: translate>map translate <english direction> <translated long direction></link>
        <link: translate><translated short direction></link> - Sets the provided translations for the
            given english direction word.

    <cyan>Map Information Commands:<reset>
        These commands show detailed information about your current map.

        <link: areas>map areas</link> - Shows a list of all areas, with links to show a list of
            rooms in the area.
        <link: rooms>map rooms <area name></link> - Shows a list of rooms in the named area.
        <link: room_find>room find|rf <room name></link> - Searches for a room of a given name.
        <link: room_look>room look|rl [roomID]</link> - Displays detailed information about a room.
        <link: showpath>showpath <roomID></link> - Shows you a path from your current location to the
            roomID.
        <link: showpath>showpath <fromID> <toID></link> - Shows you a path from a given location to
            another location.
        <link: spe_list>spe list [filter]</link> - Display a list of all known special exits.
        <link: feature_list>feature list</link> - Lists all map features created via feature create and
            the associated room characters.

    <cyan>Map Creation Commands:<reset>
        These are commands used in the process of actually creating a map.

        <link: start mapping>start mapping [area name]</link> - Starts adding content to the map, using
            either the area of the room the user is currently in or the area
            name provided.
        <link: stop mapping>stop mapping</link> - Stops adding content to the map.
        <link: area_add>area add <area name></link> - Creates a new area.
        <link: area_delete>area delete <area name></link> - Deletes a given area and all rooms within.
        <link: area_cancel>cancel area deletion</link> - Pauses deletion of an area.  This will NOT
            restore delete rooms.
        <link: area_rename>area rename <new area name></link> - Renames the current area you're in.
        <link: set area>set area <area name></link> - Moves the current room to the named area.
        <link: mode>map mode <lazy, simple, normal or complex></link> - Sets the mapping mode, which
            defines how new rooms are added to the map.
        <link: add door>add door <direction> [door status] [one way]</link> - Creates a door in
            the given direction, with the given status(default closed), in both
            directions, unless a one-direction door is specified.
        <link: add portal>add portal [-f] <entry command></link> - Creates a portal in the current room,
            using the given command for entry.
        <link: shift>shift <direction></link> - Moves the current room on the map in the given direction.
        <link: merge rooms>merge rooms</link> - Combines overlapping rooms that have the same name into
            a single room.
        <link: clear moves>clear moves</link> - Clears the list of movement commands maintained by the
            script.
        <link: set exit>set exit <direction> <roomID></link> - Creates a one-way exit in the given
            direction to the room with the specified roomID, can also be used with portals.
        <link: arealock>arealock [area name]</link> - Displays a list of areas you can lock/unlock.
        <link: room_coords>room coords|rc [v<roomID>] <x> <y> <z></link> - Move a room to new map coordinates.
        <link: room_delete>room delete|rld <direction|roomID></link> - Delete a room given a direction or roomID.
        <link: room_weight>rw [direction|roomID] <weight></link> - Set a room weight given a direction or roomID.
        <link: room_weight_exit>rwe [roomID] <weight> <exit></link> - Set the weight of a given exit in
            the current room, or optional roomID.
        <link: room_link>room link|rlk <direction> [one]</link> - Create a link to a room given a direction.
            Optional 'one' to create a one-way link.
        <link: room_unlink>room unlink|urlk <direction></link> - Delete a link in the specified direction.
        <link: room_door>rd [roomID] <direction> <open|closed|locked|clear></link> - Create or delete a door
            from the current room, or optional location.
        <link: room_character>rcc <character> [roomID]</link> - Assign a single character, letter or
            number to the current room, or optional location.
        <link: exit_special>exit special|spe <direction|roomID> <command></link> - Add a special exit
            to a room.
        <link: spev>spev <fromID> <toID> <command></link> - Add a special exit to two remote rooms.
        <link: spe_clear>exit special clear|spe clear <direction|roomID></link> - Delete a special exit.
        <link: room_area>room area [v<roomID>] <area name></link> - Moves a room to the given area.
        <link: room_label>room label [roomID] [fgColor] [bgColor] <message></link> - Adds a label to a room.
        <link: area_labels>area labels <area name></link> - Display all labels in a given area with an
            option to delete.
        <link: feature_create>feature create <feature> [char <room character>]</link> - Create a new
            global map feature.
        <link: room_feature_create>room create feature|rcf [v<room id>] <feature></link> - Adds a map
            feature to the current room, or optional location.
        <link: room_feature_delete>room delete feature|rdf [v<room id>] <feature></link> - Removes a
            map feature from the current room or optional location.
        <link: feature_delete>feature delete <feature></link> - Deletes a global map feature and
            removes it from all rooms.

    <cyan>Sharing and Backup Commands:<reset>

        <link: save>map save</link> - Creates a backup of the map.
        <link: load>map load <remote address></link> - Loads a map backup, or a map file from a
            remote address.
        <link: export>map export <area name></link> - Creates a file from the named area that can
            be shared.
        <link: import>map import <area name></link> - Loads an area from a file.

    <cyan>Mapping Events:<reset>
        These events are used by triggers to direct the script's behavior.

        <link: onNewRoom>onNewRoom</link> - Signals that a room has been detected, optional exits
            argument.
        <link: onMoveFail>onMoveFail</link> - Signals that an attempted move failed.
        <link: onForcedMove>onForcedMove</link> - Signals that the character moved without a command
            being entered, required direction argument.
        <link: onRandomMove>onRandomMove</link> - Signals that the character moved in an unknown
            direction without a command being entered.
        <link: onVisionFail>onVisionFail</link> - Signals that the character moved but some or all of
            the room information was not able to be gathered.

    <cyan>Key Variables:<reset>
        These variables are used by the script to keep track of important
            information.

        <yellow>map.prompt.room<reset> - Can be set to specify the room name.
        <yellow>map.prompt.exits<reset> - Can be set to specify the room exits.
        <yellow>map.prompt.hash<reset> - Can be set to specify the room hash.
            Notice: if you set this, mapper will only find room by
            getRoomIDbyHash(hash)
        <yellow>map.character<reset> - Contains the current character name.
        <yellow>map.save.recall<reset> - Contains a table of recall roomIDs for all
            characters.
        <yellow>map.save.prompt_pattern<reset> - Contains a table of prompt patterns for all
            characters.
        <yellow>map.save.ignore_patterns<reset> - Contains a table of patterns of text the
            script ignores.
        <yellow>map.configs<reset> - Contains a number of different options that can be set
            to modify script behavior.
        <yellow>map.currentRoom<reset> - Contains the roomID of the room your character is
            in, according to the script.
        <yellow>map.currentName<reset> - Contains the name of the room your character is in,
            according to the script.
        <yellow>map.currentExits<reset> - Contains a table of the exits of the room your
            character is in, according to the script.
        <yellow>map.currentArea<reset> - Contains the areaID of the area your character is
            in, according to the script.
]]}
map.help.save = [[
    <cyan>Map Save<reset>
        syntax: <yellow>map save<reset>

        This command creates a copy of the current map and stores it in the
        profile folder as map.dat. This can be useful for creating a backup
        before adding new content, in case of problems, and as a way to share an
        entire map at once.
]]
map.help.load = [[
    <cyan>Map Load<reset>
        syntax: <yellow>map load <optional download address><reset>

        This command replaces the current map with the map stored as map.dat in
        the profile folder. Alternatively, if a download address is provided, a
        map is downloaded from that location and loaded to replace the current
        map. If no filename is given with the download address, the script tries
        to download map.dat. If a filename is given it MUST end with .dat.
]]
map.help.show = [[
    <cyan>Map Show<reset>
        syntax: <yellow>map show<reset>

        This command shows a map window, as specified by the window configs set
        via the <link: window>map window command</link>. It isn't necessary to use this method to
        show a map window to use this script, any map window will work.
]]
map.help.export = [[
    <cyan>Map Export<reset>
        syntax: <yellow>map export <area name><reset>

        This command creates a file containing all the informatino about the
        named area and stores it in the profile folder, with a file name based
        on the area name. This file can then be imported, allowing for easy
        sharing of single map areas. The file name will be the name of the area
        in all lower case, with spaces replaced with underscores, and a .dat
        file extension.
]]
map.help.import = [[
    <cyan>Map Import<reset>
        syntax: <yellow>map import <area name><reset>

        This command imports a file from the profile folder with a name matching
        the name of the file, and uses it to create an area on the map. The area
        name used can be capitalized or not, and may have either spaces or
        underscores between words. The actual area name is stored within the
        file, and is not set by the area name used in this command.
]]
map.help.start_mapping = [[
    <cyan>Start Mapping<reset>
        syntax: <yellow>start mapping [area name]<reset>

        This command instructs the script to add new content to the map when it
        is seen. When first used, an area name is mandatory, so that an area is
        created for new rooms to be placed in. If used with an area name while
        the map shows the character within a room on the map, that room will be
        moved to be in the named area, if it is not already in it. If used
        without an area name, the room is not moved, and mapping begins in the
        area the character is currently located in.
]]
map.help.stop_mapping = [[
    <cyan>Stop Mapping<reset>
        syntax: <yellow>stop mapping<reset>

        This command instructs the script to stop adding new content until
        mapping is resumed at a later time. The map will continue to perform
        other functions.
]]
map.help.find_prompt = [[
    <cyan>Find Prompt<reset>
        syntax: <yellow>find prompt<reset>

        This command instructs the script to begin searching newly arriving text
        for something that matches one of its known prompt patterns. If one is
        found, that pattern will be set as the current prompt pattern. This
        should typically be the first command used to set up this script with a
        new profile. If your prompt appears after using this command, but there
        is no message saying that the prompt has been found, it will be
        necessary to use the map prompt command to manually set a pattern.
]]
map.help.prompt = [[
    <cyan>Map Prompt<reset>
        syntax: <yellow>map prompt <prompt pattern><reset>

        This command manually sets a prompt pattern for the script to use.
        Because of the way this script works, the prompt pattern should match
        the entire prompt, so that if the text matching the pattern were
        removed, the line with the prompt would be blank. The patterns must be
        of the type used by the Lua string library. If you are unsure about what
        pattern to use, seek assistance on the Mudlet Forums or the Mudlet
        Discord channel.
]]
map.help.debug = [[
    <cyan>Map Debug<reset>
        syntax: <yellow>map debug<reset>

        This command toggles the map script's debug mode on or off when it is
        used. Debug mode provides some extra messages to help with setting up
        the script and identifying problems to help with troubleshooting. If you
        are getting assistance with setting up this script, using debug mode may
        make the process faster and easier.
]]
map.help.ignore = [[
    <cyan>Map Ignore<reset>
        syntax: <yellow>map ignore <ignore pattern><reset>

        This command adds the given pattern to a list the script maintains to
        help it locate the room name. Any text that might appear after a command
        is sent to move and before the room name appears, or after the prompt
        and before the room name if several movement commands are sent at once,
        should have an ignore pattern added for it.

        If the given pattern is already in the list of ignore patterns, that
        pattern will be removed from the list.

        Example: <yellow>map ignore ^You are hungry%.$<reset> - match exactly one line
                 <yellow>map ignore ^The clock strikes %d+%.$<reset> - match a number
                 <yellow>map ignore ^You walk %a+%.$<reset> - match a word, e.g. east
]]
map.help.movemethod = [[
    <cyan>Move Method<reset>
        syntax: <yellow>map movemethod <movement word><reset>

        This command will add a movement method for the script to look for
        when moving between rooms. If your game has methods such as "walk north",
        "swim south" or similar, add "walk" or "swim" as necessary. For single
        room movement only.

        If the given method is already in the list of movement methods, that
        method will be removed from the list.
]]
map.help.areas = [[
    <cyan>Map Areas<reset>
        syntax: <yellow>map areas<reset>

        This command displays a linked list of all areas in the map. When
        clicked, the rooms in the selected area will be displayed, as if the
        'map rooms' command had been used with that area as an argument.
]]
map.help.rooms = [[
    <cyan>Map Rooms<reset>
        syntax: <yellow>map rooms <area name><reset>

        This command shows a list of all rooms in the area, with the roomID and
        the room name, as well as a count of how many rooms are in the area
        total. Note that the area name argument is not case sensitive.
]]
map.help.set_area = [[
    <cyan>Set Area<reset>
        syntax: <yellow>set area <area name><reset>

        This command move the current room into the named area, creating the
        area if needed.
]]
map.help.mode = [[
    <cyan>Map Mode<reset>
        syntax: <yellow>map mode <lazy, simple, normal, or complex><reset>

        This command changes the current mapping mode, which determines what
        happens when new rooms are added to the map.

        In lazy mode, connecting exits aren't checked and a room is only added if
        there isn't an adjacent room with the same name.

        In simple mode, if an adjacent room has an exit stub pointing toward the
        newly created room, and the new room has an exit in that direction,
        those stubs are connected in both directions.

        In normal mode (default), the newly created room is connected to the room you left
        from, so long as it has an exit leading in that direction.

        In complex mode, none of the exits of the newly connected room are
        connected automatically when it is created.
]]
map.help.add_door = [[
    <cyan>Add Door<reset>
        syntax: <yellow>add door <direction> [none|open|closed|locked] [yes|no]<reset>

        This command places a door on the exit in the given direction, or
        removes it if "none" is given as the second argument. The door status is
        set as given by the second argument, default "closed". The third
        argument determines if the door is a one-way door, default "no".
]]
map.help.add_portal = [[
    <cyan>Add Portal<reset>
        syntax: <yellow>add portal [-f] <entry command><reset>

        This command creates a special exit in the current room that is entered
        by using the given entry command. The given entry command is then sent,
        moving to the destination room. If the destination room matches an
        existing room, the special exit will link to that room, and if not a new
        room will be created. If the optional "-f" argument is given, a new room
        will be created for the destination regardless of if an existing room
        matches the room seen when arriving at the destination.
]]
map.help.shift = [[
    <cyan>Shift<reset>
        syntax: <yellow>shift <direction><reset>

        This command moves the current room one step in the direction given, on
        the map.
]]
map.help.merge_rooms = [[
    <cyan>Merge Rooms<reset>
        syntax: <yellow>merge rooms<reset>

        This command combines all rooms that share the same coordinates and the
        same room name into a single room, with all of the exits preserved and
        combined.
]]
map.help.clear_moves = [[
    <cyan>Clear Moves<reset>
        syntax: <yellow>clear moves<reset>

        This command clears the script's queue of movement commands, and is
        intended to be used after you attempt to move while mapping but the
        movement is prevented in some way that is not caught and handled by a
        trigger that raises the onMoveFail event.
]]
map.help.set_exit = [[
    <cyan>Set Exit<reset>
        syntax: <yellow>set exit <direction> <destination roomID><reset>

        This command sets the exit in the current room in the given direction to
        connect to the target room, as specified by the roomID. This is a
        one-way connection.
]]
map.help.onnewroom = [[
    <cyan>onNewRoom Event<reset>

        This event is raised to inform the script that a room has been detected.
        When raised, a string containing the exits from the detected room should
        be passed as a second argument to the raiseEvent function, unless those
        exits have previously been stored in map.prompt.exits.
]]
map.help.onmovefail = [[
    <cyan>onMoveFail Event<reset>

        This event is raised to inform the script that a move was attempted but
        the character was unable to move in the given direction, causing that
        movement command to be removed from the script's movement queue.
]]
map.help.onforcedmove = [[
    <cyan>onForcedMove Event<reset>

        This event is raised to inform the script that the character moved in a
        specified direction without a command being entered. When raised, a
        string containing the movement direction must be passed as a second
        argument to the raiseEvent function.

        The most common reason for this event to be raised is when a character
        is following someone else.
]]
map.help.onrandommove = [[
    <cyan>onRandomMove Event<reset>

        This event is raised to inform the script that the character has moved
        in an unknown direction. The script will compare the next room seen with
        rooms that are adjacent to the current room to try to determine the best
        match for where the character has gone.

        In some situations, multiple options are equally viable, so mistakes may
        result. The script will automatically keep verifying positioning with
        each step, and automatically correct the shown location on the map when
        possible.
]]
map.help.onvisionfail = [[
    <cyan>onVisionFail Event<reset>

        This event is raised to inform the script that some or all of the room
        information was not able to be gathered, but the character still
        successfully moved between rooms in the intended direction.
]]
map.help.onprompt = [[
    <cyan>onPrompt Event<reset>

        This event can be raised when using a non-conventional setup to trigger
        waiting messages from the script to be displayed. Additionally, if
        map.prompt.exits exists and isn't simply an empty string, raising this
        event will cause the onNewRoom event to be raised as well. This
        functionality is intended to allow people who have used the older
        version of this script to use this script instead, without having to
        modify the triggers they created for it.
]]
map.help.me = [[
    <cyan>Map Me<reset>
        syntax: <yellow>map me<reset>

        This command forces the script to look at the currently captured room
        name and exits, and search for a potentially matching room, moving the
        map if applicable. Note that this command is generally never needed, as
        the script performs a similar search any time the room name and exits
        don't match expectations.
]]
map.help.path = [[
    <cyan>Map Path<reset>
        syntax: <yellow>map path <room name> [; area name]<reset>

        This command tries to find a walking path from the current room to the
        named room. If an area name is given, only rooms within that area that
        is given are checked. Neither the room name nor the area name are case
        sensitive, but otherwise an exact match is required. Note that a
        semicolon is required between the room name and area name, if an area
        name is given, but spaces before or after the semicolon are optional.

        Example: <yellow>map path main street ; newbie town<reset>
]]
map.help.character = [[
    <cyan>Map Character<reset>
        syntax: <yellow>map character <name><reset>

        This command tells the script what character is currently being used.
        Setting a character is optional, but recall locations and prompt
        patterns are stored by character name, so using this command allows for
        easy switching between different setups. The name given is stored in
        map.character. The name is a case sensitive exact match. The value of
        map.character is not saved between sessions, so this must be set again
        if needed each time the profile is opened.
]]
map.help.recall = [[
    <cyan>Map Recall<reset>
        syntax: <yellow>map recall<reset>

        This command tells the script that the current room is the recall point
        for the current character, as stored in map.character. This information
        is stored in map.save.recall[map.character], and is remembered between
        sessions.
]]
map.help.config = [[
    <cyan>Map Config<reset>
        syntax: <yellow>map config <setting> <optional value><reset>

        This command changes any of the available configurations listed below.
        If no value is given, and the setting is either 'on' or 'off', then the
        value is switched. When naming a setting, spaces can be used in place of
        underscores. Details of what options are available and what each one
        does are provided.

        <yellow>speedwalk_delay<reset> - When using the speedwalk function of the script,
            this is the amount of time the script waits after either sending
            a command or, if speedwalk_wait is set, after arriving in a new
            room, before the next command is sent. This may be any number 0
            or higher.

        <yellow>speedwalk_wait<reset> - When using the speedwalk function of the script,
            this indicates if the script waits for your character to move
            into a new room before sending the next command. This may be true
            or false.

        <yellow>speedwalk_random<reset> - When using the speedwalk function of the script
            with a speedwalk_delay value, introduces a randomness to the wait
            time by adding some amount up to the speedwalk_delay value. This
            may be true or false.

        <yellow>stretch_map<reset> - When adding a new room that would overlap an existing
            room, if this is set the map will stretch out to prevent the
            overlap, with all rooms further in the direction moved getting
            pushed one further in that direction. This may be true or false.

        <yellow>max_search_distance<reset> - When mapping, this is the maximum number of
            rooms that the script will search in the movement direction for a
            matching room before deciding to create a new room. This may be
            false, or any positive whole number. This can also be set to 0,
            which is the same as setting it to false.

        <yellow>search_on_look<reset> - When this is set, using the "look" command causes
            the map to verify your position using the room name and exits
            seen following using the command. This may be true or false.

        <yellow>clear_lines_on_send<reset> - When this is set, any time a command is sent,
            any lines stored from the game used to search for the room name
            are cleared. This may be true or false.

        <yellow>mode<reset> - This is the default mapping mode on startup, and defines how
            new rooms are added to the map. May be "lazy", "simple",
            "normal" or "complex".

        <yellow>download_path<reset> - This is the path that updates are downloaded from.
            This may be any web address where the versions.lua and
            generic_mapper.xml files can be downloaded from.

        <yellow>prompt_test_patterns<reset> - This is a table of default patterns checked
            when using the "find prompt" command. The patterns in this table
            should start with a '^', and be written to be used with the Lua
            string library. Most importantly, '%' is used as the escape
            character instead of '\' as in trigger regex patterns.

        <yellow>custom_exits<reset> - This is a table of custom exit directions and their
            relevant extra pieces of info. Each entry should have the short
            direction as the keyword for a table containing first the long
            direction, then the long direction of the reverse of this
            direction, and then the x, y, and z change in map position
            corresponding to the movement. As an example: us = {'upsouth',
            'downnorth', 0, -1, 1}

        <yellow>custom_name_search<reset> - When this is set, instead of running the default
            function name_search, a user-defined function called
            'mudlet.custom_name_search' is used instead. This may be true or false.

        <yellow>use_description_matching<reset> - When this is set, room descriptions are used
            in addition to room names and exits when matching rooms. The
            description is captured from lines between the room name and the
            prompt, and stored as room user data. This helps distinguish between
            rooms that have the same name but different descriptions. This may
            be true or false.

        <yellow>use_translation<reset> - When this is set, the lang_dirs table is used to
            translate movement and status commands in some other language
            into the English used by the script. This may be true or false.

        <yellow>debug<reset> - When this is set, the script will start in debug mode. This
            may be true or false.
]]
map.help.window = [[
    <yellow>Map Window<reset>
        syntax: <yellow>map window <setting> <value><reset>

        This command changes any of the available configurations listed below,
        which determine the appearance and positioning of the map window when
        the 'map show' command is used. Details of what options are available
        and what each one does are provided.

        <yellow>x<reset> - This is the x position of the map window, and should be a
            positive number of pixels or a percentage of the screen width.

        <yellow>y<reset> - This is the y position of the map window, and should be a
            positive number of pixels or a percentage of the screen height.

        <yellow>w<reset> - This is the width of the map window, and should be a positive
            number of pixels or a percentage of the screen width.

        <yellow>h<reset> - This is the height of the map window, and should be a positive
            number of pixels or a percentage of the screen height.

        <yellow>origin<reset> - This is the corner from which the window position is
            measured, and may be 'topright', 'topleft', 'bottomright', or
            'bottomleft'.

        <yellow>shown<reset> - This determines if the map window is shown immediately upon
            connecting to the game. This may be true or false. If you intend
            to have some other script control the map window, this should be
            set to false.
]]
map.help.translate = [[
    <yellow>Map Translate<reset>
        syntax: <yellow>map translate <english direction> <translated long direction>
            <translated short direction><reset>

        This command sets direction translations for the script to use, either
        for commands entered to move around, or listed exits the game shows when
        you enter a room. Available directions: north, south, east, west,
        northwest, northeast, southwest, southeast, up, down, in, and out.
        Also you can customize special commands sent to mud like 'look'.
]]
map.help.quick_start = [[
    <link: quick_start>map basics</link> (quick start guide)
    ----------------------------------------

    Mudlet Mapper works in tandem with a script, and this generic mapper script needs
    to know 2 things to work:
      - <dim_grey>room name<reset> $ROOM_NAME_STATUS ($ROOM_NAME)
      - <dim_grey>exits<reset>     $ROOM_EXITS_STATUS ($ROOM_EXITS)

    1. <link: start mapping>start mapping <optional area name></link>
       If both room name and exits are good, you can start mapping! Give it the
       area name you're currently in, usually optional but required for the first one.
    2. <link: find prompt>find prompt</link>
       Room name or exits aren't recognised? Try this command then. It will make
       the script start looking for a prompt using several standard prompt
       patterns. If a prompt is found, you will be notified, if not, you will
       need to set a prompt pattern yourself using <link: prompt>map prompt</link>.
       Reach out to the <urllink: https://discord.gg/kuYvMQ9>Mudlet community</urllink> for help, we'd be happy to help
       you figure it out!
    3. <link: debug>map debug</link>
       This toggles debug mode. When on, messages will be displayed showing what
       information is captured and a few additional error messages that can help
       with getting the script fully compatible with your game.
    4. <link: 1>map help</link>
       This will bring up a more detailed help file, starting with the available
       help topics.
]]
map.help.room_find = [[
    <cyan>Room Find<reset>
        syntax: <yellow>room find <room name><reset>
                <yellow>rf <room name><reset>

        This command will search all rooms and return a list of matches.
]]
map.help.room_look = [[
    <cyan>Room Look<reset>
        syntax: <yellow>room look [roomID]<reset>
                <yellow>rl [roomID]<reset>

        This command will display detailed information about the current room.
        Optionally a roomID can be provided.
]]
map.help.showpath = [[
    <cyan>Showpath<reset>
        syntax: <yellow>showpath <roomID><reset>
                <yellow>showpath <fromID> <toID><reset>

        This command displays a path from your current room to the roomID specified.
        If two roomID's are specifed it will display a path from a remote room to another room.
]]
map.help.spe_list = [[
    <cyan>Special Exits List<reset>
        syntax: <yellow>spe list [filter]<reset>

        This command displays a list of all known special exits.  You can alternatively provide an
        optional filter to return a list containing those words.

        Example: <yellow>spe list worm warp<reset>
]]
map.help.feature_list = [[
    <cyan>Feature List<reset>
        syntax: <yellow>feature list<reset>

        This command displays a list of all map features created via feature create and the associated room characters.
]]
map.help.area_add = [[
    <cyan>Area Add<reset>
        syntax: <yellow>area add <area name><reset>

        This command will create a new area and automatically give it an ID.

        Example: <yellow>area add My City<reset> - create a new area called My City
]]
map.help.area_delete = [[
    <cyan>Area Delete<reset>
        syntax: <yellow>area delete <area name><reset>

        This command will delete the given area. If the area is really big
        (thousands of rooms), deleting it at once would take a really long
        while and freeze your Mudlet while doing so. To combat the unpleasant
        experience, the script breaks up area deletion into batches of rooms
        (100 by default). While this still heavily impacts Mudlets performance,
        it allows you to see a progress meter of how far it has gotten and gives
        you an ability to pause it at any time by doing 'cancel area deletion'.

        Example: <yellow>area delete My City<reset> - delete an area called My City
]]
map.help.area_cancel = [[
    <cyan>Cancel Area Deletion<reset>
        syntax: <yellow>cancel area deletion<reset>

        This comand will stop an area deletion that has started. This will NOT
        restore deleted rooms - it merely pauses the process, so you can resume
        it with 'area delete' later on. You can type this in while Mudlet is
        deleting an area - it'll take a short while for letters to show up, but
        they will eventually.
]]
map.help.area_rename = [[
    <cyan>Area Rename<reset>
        syntax: <yellow>area rename <name><reset>

        This command will rename the current area you're in to the new name.

        Example: <yellow>area rename My City<reset> - call the area you're in My City from now on

]]
map.help.arealock = [[
    <cyan>Arealock<reset>
        syntax: <yellow>arealock [filter]<reset>

        This command displays a list of areas you can lock/unlock, you can also
        give it an area name to filter by. If an area is locked the mapper will
        not attempt to speedwalk or go through any of the rooms in the area.

        Example: <yellow>arealock City<reset>
]]
map.help.room_coords = [[
    <cyan>Room Coordinates<reset>
        syntax: <yellow>room coords [v<roomID>] <x> <y> <z><reset>
                <yellow>rc [v<roomID>] <x> <y> <z><reset>

        This command will move a room to the new map coordinates. x,y and z will
        specify the new location of the room. The room ID is optional, it'll move
        the current room if you don't provide one.

        Example: <yellow>rc nw<reset> - move the room to be nw of the current location
                 <yellow>rc v34 w<reset> - move the room ID 34 west, note the letter 'v' in the command
                 <yellow>rc 1 -5 10<reset> - move the current room to those exact coordinates
                 <yellow>rc v12 8 3 -8<reset> - move the room #12 to 8x, 3y and -8z
                 <yellow>rc 14x 5y<reset> - move the current room to be at 14x and 5y, but the
                    same z-level you're on. You can include all three of x, y, z coordinates
                    or only one as you wish
]]
map.help.room_delete = [[
    <cyan>Room Delete<reset>
        syntax: <yellow>room delete <direction|roomID><reset>
                <yellow>rld <direction|roomID><reset>

        This command will delete a room given a relative direction or roomID.

        Example: <yellow>rld<reset> - current room, will delete the room you're currently in
                 <yellow>rld n<reset> - relative direction, will delete the room that's north of you
                 <yellow>rld 513<reset> - using roomID, will delete the room with ID 513
]]
map.help.room_weight = [[
    <cyan>Room Weight<reset>
        syntax: <yellow>room weight [direction|roomID] <weight><reset>
                <yellow>rw [direction|roomID] <weight><reset>

        This command updates the weight of a room, making it more or less
        desirable to travel through.  Direction or roomID is optional and
        defaults to the current room.

        Example: <yellow>rw 10<reset> - will set the room weight of the room you're standing in to 10
                 <yellow>rw n 4<reset> - relative direction, will set the room weight of the room that's
                    to the north of you to four
                 <yellow>rw 2343 2<reset> - using roomID, will set the room weight of room 2343 to 2
]]
map.help.room_weight_exit = [[
    <cyan>Room Weight Exit<reset>
        syntax: <yellow>rwe [roomID] <weight> <exit><reset>

        This command updates the weight of a room exit, where weight is a
        positive number (default for exits is 0). Setting a higher weight will
        make the exit be less likely to be used. The exit can be a cardinal
        direction of either n,e,s,w,ne,se,sw,ne,up,down,in,out or the exact
        special exit text (including the script: part). This alias sets a weight
        one way only, so if you want to set it both ways, use it on the opposite
        side as well. Use 'rl' to check exit weights.

        Example: <yellow>rwe 1 n<reset> -  will set the weight of the exit north to 1
                 <yellow>rwe 2434 0 e<reset> - will reset the exit weight of an east exit that
                    leads out from the 2434 room
]]
map.help.room_link = [[
    <cyan>Room Link<reset>
        syntax: <yellow>room link [roomID] <direction> [one]<reset>
                <yellow>rlk [roomID] <direction> [one]<reset>

        This command will link a room given a direction and optional roomID.
        You can also add 'one' at the end of the command to make it be a one-way
        link.

        Example: <yellow>rlk n<reset> - relative direction, will link if exists
                    a room to the north of this one to your current location
                 <yellow>rlk 351 n<reset> - exact roomID and direction, will
                    link the current room to room #351 via a north exit
                 <yellow>rlk n one<reset> - will make an exit north one-way
]]
map.help.room_unlink = [[
    <cyan>Room Unlink<reset>
        syntax: <yellow>room unlink <direction><reset>
                <yellow>urlk <direction><reset>

                Unlink a room given a direction.  This function will unlink
                exits both ways, or one way if there is no incoming exit.

        Example: <yellow>urlk nw<reset> - relative direction, will unlink to the
                    northwest, and from the northwest room to the southeast
]]
map.help.room_door = [[
    <cyan>Room Door<reset>
        syntax: <yellow>rd [roomID] <direction> <open|closed|locked|clear><reset>

                Will create a door from the current room to a direction
                specified.  Door status can be open or o, closed or c, locked or
                l, clear or gone. To delete a room, use clear or gone. Setting
                doors is one-way - to set two-way doors, use the alias from the
                opposite direction.


        Example: <yellow>rd n<reset> - add a one-way door north from the current room
                 <yellow>rd 23 w closed<reset> - add a closed door leading west in room 23
                 <yellow>rd n clear<reset> - remove the door to the north from the current
                    room on this side only
]]
map.help.room_character = [[
    <cyan>Room Character<reset>
        syntax: <yellow>rcc <character|clear> [roomID]<reset>

        This command will assign a single character, letter or number to the
        current room, or an optional given room.  Using clear will remove any
        characters.

        Example: <yellow>rcc $<reset> - put the dollar sign in the current room 
                    (e.g. to indicate a shop or bank)
                 <yellow>rcc C 234<reset> - put the letter C onto room 234
                 <yellow>rcc clear<reset> - remove any letter from the current
                 room
]]
map.help.exit_special = [[
    <cyan>Special Exits<reset>
        syntax: <yellow>exit special <direction|roomID> <command><reset>
                <yellow>spe <direction|roomID> <command><reset>

        This command will link two rooms via custom or special exit/script.

        Example: <yellow>spe n push rock<reset> - relative direction, will go to
                    the room that's north of you by doing 'push rock'
                 <yellow>spe 125 pull lever<reset> - will go to room 125 from the
                    current one by pulling a lever

        You can also specify a script to do code for you, by starting the exit
        command with script.

        Example: <yellow>spe 125 script: sendAll("pull lever", "enter gate")<reset>


]]
map.help.spev = [[
    <cyan>Remote Special Exits<reset>
        syntax: <yellow>spev <fromID> <toID> <command><reset>

        This command will add a special exit between two remote rooms.

        Example: <yellow>spe 125 560 push rock<reset> - will link room 125 to room 560 with
                    the command 'push rock'
]]
map.help.spe_clear = [[
    <cyan>Clear Special Exits<reset>
        syntax: <yellow>exit special clear <direction|roomID><reset>
                <yellow>spe clear <direction|roomID><reset>

        This command will clear all special exits from the current, relative or
        given roomID.

        Example: <yellow>spe clear<reset> - delete all special exits in the room you're currently in
                 <yellow>spe clear n<reset> - delete all special exits in the room that's north of you
                 <yellow>spe clear 513<reset> - delete all special exits in room #513
]]
map.help.room_area = [[
    <cyan>Room Area<reset>
        syntax: <yellow>room area [v<roomID>] <area name|areaID><reset>

        This command moves the current room to another area or a given optional
        room.

        Example: <yellow>room area My New Area<reset> - move the room you're in to 'My New Area'.
                 <yellow>room area v123 My New Area<reset> - move room 123 to My New Area
                 <yellow>room area 44<reset> - move the current room to the area ID 44
]]
map.help.room_label = [[
    <cyan>Room Label<reset>
        syntax: <yellow>room label [roomID] [fgColor] [bgColor] <message><reset>

        This command adds a label to the current or specified room.  Foreground
        and background color are optional.

        Example: <yellow>room label My Label<reset> - adds a 'My Label' label to the current room
                 <yellow>room label 342 My Label<reset> - adds a label to room #342
                 <yellow>room label green My Label<reset> - adds a green label with a transparent
                    background to the current room
                 <yellow>room label green black My Label<reset> - adds a label with a green
                    foreground and black background to the current room
                 <yellow>room label 34 green black My Label<reset> - adds a label with a green
                    foreground and black background to room #34
]]
map.help.area_labels = [[
    <cyan>Area Labels<reset>
        syntax: <yellow>area labels <area name><reset>

        This command displays all labels in a given area, with a link to delete.

        Example: <yellow>area label My Area<reset>
]]
map.help.feature_create = [[
    <cyan>Feature Create<reset>
        syntax: <yellow>feature create <feature> [char <room character>]<reset>

        This command will create a new map feature for use on rooms. You can
        also optionally add a character mark to the feature, which will be set
        when a map feature is added to a room. Note: Map feature names are not
        allowed to contain numbers.

        Example: <yellow>feature create A Nexus Point char N<reset> - creates a new feature
                    'A Nexus Point' with an assigned room character 'N'
]]
map.help.room_feature_create = [[
    <cyan>Room Create Feature<reset>
        syntax: <yellow>room create feature [v<room id>] <feature><reset>
                <yellow>rcf [v<room id>] <feature><reset>

        This command will add a created map feature to the room. If the map
        feature is associated with a character mark, it will be set on the room
        and existing marks get overwritten. The room number to add the feature
        to can be given with the optional argument (note: there is no space
        between the v and the ID).

        Example: <yellow>rcf A Nexus Point<reset> - add the feature 'A Nexus Point' to
                    the current room
                 <yellow>rcf v123 A Nexus Point<reset> - add the feature 'A Nexus Point'
                    to room #123
]]
map.help.room_feature_delete = [[
    <cyan>Room Delete Feature<reset>
        syntax: <yellow>room delete feature [v<room id>] <feature><reset>
                <yellow>rdf [v<room id>] <feature><reset>

        This command removes a map feature from the room. If the map feature is
        associated with a character mark and its set on the room, a random
        character mark from the other map features on the room is chosen to
        replace it. The room number to delete the feature from can be given with
        the optional argument (note: there is no space between the v and the
        ID).

        Example: <yellow>rdf v123 A Nexus Point<reset> - removes the feature 'A Nexus Point'
                    from the room #123
]]
map.help.feature_delete = [[
    <cyan>Feature Delete<reset>
        syntax: <yellow>feature delete <feature><reset>

        This command deletes a global map feature and removes it from all rooms.

        Example: <yellow>feature delete A Nexus Point<reset> - removes the global feature
                    'A Nexus Point' and removes it from all rooms
]]



map.character = map.character or ""
map.prompt = map.prompt or {}
map.save = map.save or {}
map.save.recall = map.save.recall or {}
map.save.prompt_pattern = map.save.prompt_pattern or {}
map.save.ignore_patterns = map.save.ignore_patterns or {}
map.save.move_methods = map.save.move_methods or {}
map.silentUpdate = map.silentUpdate or true

local oldstring = string
local string = utf8
string.format = oldstring.format
string.trim = oldstring.trim
string.starts = oldstring.starts
string.split = oldstring.split
string.ends = oldstring.ends


local profilePath = getMudletHomeDir()
profilePath = profilePath:gsub("\\","/")

map.defaults = {
    mode = "normal", -- can be lazy, simple, normal, or complex
    stretch_map = true,
    search_on_look = true,
    speedwalk_delay = 1,
    speedwalk_wait = true,
    speedwalk_random = true,
    max_search_distance = 1,
    clear_lines_on_send = true,
    map_window = {
        x = 0,
        y = 0,
        w = "30%",
        h = "40%",
        origin = "topright",
        shown = false,
    },
    prompt_test_patterns = {"^%[?%a*%]?<.*>", "^%[.*%]%s*>", "^%w*[%.?!:]*>", "^%[.*%]", "^[Hh][Pp]:.*>"},
    custom_exits = {},  -- format: short_exit = {long_exit, reverse_exit, x_dif, y_dif, z_dif}
                        -- ex: { us = {"upsouth", "downnorth", 0, -1, 1}, dn = {"downnorth", "upsouth", 0, 1, -1} }
    custom_name_search = false,
    use_description_matching = false,
    use_translation = true,
    lang_dirs = {n = 'n', ne = 'ne', nw = 'nw', e = 'e', w = 'w', s = 's', se = 'se', sw = 'sw',
        u = 'u', d = 'd', ["in"] = 'in', out = 'out', north = 'north', northeast = 'northeast',
        east = 'east', west = 'west', south = 'south', southeast = 'southeast', southwest = 'southwest',
        northwest = 'northwest', up = 'up', down = 'down', l = 'l', look = 'look',
        ed = 'ed', eu = 'eu', eastdown = 'eastdown', eastup = 'eastup',
        nd = 'nd', nu = 'nu', northdown = 'northdown', northup = 'northup',
        sd = 'sd', su = 'su', southdown = 'southdown', southup = 'southup',
        wd = 'wd', wu = 'wu', westdown = 'westdown', westup = 'westup',
    },
    debug = false,
    download_path = "https://raw.githubusercontent.com/Mudlet/Mudlet/development/src/mudlet-lua/lua/generic-mapper",
}

local move_queue, lines = {}, {}
local find_portal, vision_fail, room_detected, random_move, force_portal, find_prompt, downloading, walking, help_shown
local mt = getmetatable(map) or {}

local exitmap = {
    n = 'north',    ne = 'northeast',   nw = 'northwest',   e = 'east',
    w = 'west',     s = 'south',        se = 'southeast',   sw = 'southwest',
    u = 'up',       d = 'down',         ["in"] = 'in',      out = 'out',
    l = 'look',
    ed = 'eastdown',    eu = 'eastup',  nd = 'northdown',   nu = 'northup',
    sd = 'southdown',   su = 'southup', wd = 'westdown',    wu = 'westup',
}

local short = {}
for k,v in pairs(exitmap) do
    short[v] = k
end

local stubmap = {
    north = 1,      northeast = 2,      northwest = 3,      east = 4,
    west = 5,       south = 6,          southeast = 7,      southwest = 8,
    up = 9,         down = 10,          ["in"] = 11,        out = 12,
    northup = 13,   southdown = 14,     southup = 15,       northdown = 16,
    eastup = 17,    westdown = 18,      westup = 19,        eastdown = 20,
    [1] = "north",  [2] = "northeast",  [3] = "northwest",  [4] = "east",
    [5] = "west",   [6] = "south",      [7] = "southeast",  [8] = "southwest",
    [9] = "up",     [10] = "down",      [11] = "in",        [12] = "out",
    [13] = "northup", [14] = "southdown", [15] = "southup", [16] = "northdown",
    [17] = "eastup", [18] = "westdown", [19] = "westup",    [20] = "eastdown",
}

local coordmap = {
    [1] = {0,1,0},      [2] = {1,1,0},      [3] = {-1,1,0},     [4] = {1,0,0},
    [5] = {-1,0,0},     [6] = {0,-1,0},     [7] = {1,-1,0},     [8] = {-1,-1,0},
    [9] = {0,0,1},      [10] = {0,0,-1},    [11] = {0,0,0},     [12] = {0,0,0},
    [13] = {0,1,1},     [14] = {0,-1,-1},   [15] = {0,-1,1},    [16] = {0,1,-1},
    [17] = {1,0,1},     [18] = {-1,0,-1},   [19] = {-1,0,1},    [20] = {1,0,-1},
}

local reverse_dirs = {
    north = "south", south = "north", west = "east", east = "west", up = "down",
    down = "up", northwest = "southeast", northeast = "southwest", southwest = "northeast",
    southeast = "northwest", ["in"] = "out", out = "in",
    northup = "southdown", southdown = "northup", southup = "northdown", northdown = "southup",
    eastup = "westdown", westdown = "eastup", westup = "eastdown", eastdown = "westup",
}

local wait_echo = {}
local mapper_tag = "<112,229,0>(<73,149,0>mapper<112,229,0>): <255,255,255>"
local debug_tag = "<255,165,0>(<200,120,0>debug<255,165,0>): <255,255,255>"
local err_tag = "<255,0,0>(<178,34,34>error<255,0,0>): <255,255,255>"

local function config()
    local defaults = map.defaults
    local configs = map.configs or {}
    local path = profilePath.."/map downloads"
    if not io.exists(path) then lfs.mkdir(path) end
    -- load stored configs from file if it exists
    if io.exists(path.."/configs.lua") then
        table.load(path.."/configs.lua",configs)
    end
    -- overwrite default values with stored config values
    configs = table.update(defaults, configs)
    map.configs = configs
    map.configs.translate = {}
    for k, v in pairs(map.configs.lang_dirs) do
        map.configs.translate[v] = k
    end
    -- incorporate custom exits
    for k,v in pairs(map.configs.custom_exits) do
        exitmap[k] = v[1]
        reverse_dirs[v[1]] = v[2]
        short[v[1]] = k
        local count = #coordmap + 1
        coordmap[count] = {v[3],v[4],v[5]}
        stubmap[count] = v[1]
        stubmap[v[1]] = count
    end
    -- update to the current download path
    if map.configs.download_path == "https://raw.githubusercontent.com/JorMox/Mudlet/development/src/mudlet-lua/lua/generic-mapper" then
        map.configs.download_path = "https://raw.githubusercontent.com/Mudlet/Mudlet/development/src/mudlet-lua/lua/generic-mapper"
    end

    -- setup metatable to store sensitive values
    local protected = {"mapping", "currentRoom", "currentName", "currentExits", "currentArea",
        "prevRoom", "prevName", "prevExits", "mode", "version"}
    mt = getmetatable(map) or {}
    mt.__index = mt
    mt.__newindex = function(tbl, key, value)
            if not table.contains(protected, key) then
                rawset(tbl, key, value)
            else
                error("Protected Map Table Value")
            end
        end
    mt.set = function(key, value)
            if table.contains(protected, key) then
                mt[key] = value
            end
        end
    setmetatable(map, mt)
    map.set("mode", configs.mode)
    map.set("version", version)

    local saves = {}
    if io.exists(path.."/map_save.dat") then
        table.load(path.."/map_save.dat",saves)
    end
    saves.prompt_pattern = saves.prompt_pattern or {}
    saves.ignore_patterns = saves.ignore_patterns or {}
    saves.move_methods = saves.move_methods or {}
    saves.recall = saves.recall or {}
    map.save = saves

    if map.configs.map_window.shown then
        map.showMap(true)
    end
end

local function parse_help_text(text)
  text = text:gsub("%$ROOM_NAME_STATUS", (map.currentName and map.currentName ~= "") and '✔️' or '❌')
  text = text:gsub("%$ROOM_NAME", map.currentName or '')

  text = text:gsub("%$ROOM_EXITS_STATUS", (not map.currentExits or table.is_empty(map.currentExits)) and '❌' or '✔️')
  text = text:gsub("%$ROOM_EXITS", map.currentExits and table.concat(map.currentExits, ' ') or '')

  return text
end

function map.show_help(cmd)
    if cmd and cmd ~= "" then
        if cmd:starts("map ") then cmd = cmd:sub(5) end
        cmd = cmd:lower():gsub(" ","_")
        if not map.help[cmd] then
            map.echo("No help file on that command.")
        end
    else
        cmd = 1
    end

    for w in parse_help_text(map.help[cmd]):gmatch("[^\n]*\n") do
        local url, target = rex.match(w, [[<(url)?link: ([^>]+)>]])
        -- lrexlib returns a non-capture as 'false', so determine which variable the capture went into
        if target == nil then target = url end
        if target then
            local before, linktext, _, link, _, after, ok = rex.match(w,
                          [[(.*)<((url)?link): [^>]+>(.*)<\/(url)?link>(.*)]], 0, 'm')
            -- could not get rex.match to capture the newline - fallback to string.match
            local _, _, after = w:match("(.*)<u?r?l?link: [^>]+>(.*)</u?r?l?link>(.*)")

            cecho(before)
            fg("yellow")
            setUnderline(true)
            if linktext == "urllink" then
                echoLink(link, [[openWebPage("]]..target..[[")]], "Open webpage", true)
            elseif target ~= "1" then
                echoLink(link,[[map.show_help("]]..target..[[")]],"View: map help " .. target,true)
            else
                echoLink(link,[[map.show_help()]],"View: map help",true)
            end
            setUnderline(false)
            resetFormat()
            if after then cecho(after) end
        else
            cecho(w)
        end
    end
    echo("\n")
end

local bool_configs = {'stretch_map', 'search_on_look', 'speedwalk_wait', 'speedwalk_random',
    'clear_lines_on_send', 'debug', 'custom_name_search', 'use_translation'}
-- function intended to be used by an alias to change config values and save them to a file for later
function map.setConfigs(key, val, sub_key)
    if val == "off" or val == "false" then
        val = false
    elseif val == "on" or val == "true" then
        val = true
    end
    local toggle = false
    if val == nil or val == "" then toggle = true end
    key = key:gsub(" ","_")
    if tonumber(val) then val = tonumber(val) end
    if not toggle then
        if key == "map_window" then
            if map.configs.map_window[sub_key] then
                map.configs.map_window[sub_key] = val
                map.echo(string.format("Map config %s set to: %s", sub_key, tostring(val)))
            else
                map.echo("Unknown map config.",false, true)
            end
        elseif key =="lang_dirs" then
            sub_key = exitmap[sub_key] or sub_key
            if map.configs.lang_dirs[sub_key] then
                local long_dir, short_dir = val[1],val[2]
                if #long_dir < #short_dir then long_dir, short_dir = short_dir, long_dir end
                map.configs.lang_dirs[sub_key] = long_dir
                map.configs.lang_dirs[short[sub_key]] = short_dir
                map.echo(string.format("Direction/command %s, abbreviated as %s, now interpreted as %s.", long_dir, short_dir, sub_key))
                map.configs.translate = {}
                for k, v in pairs(map.configs.lang_dirs) do
                    map.configs.translate[v] = k
                end
            else
                map.echo("Invalid direction/command.", false, true)
            end
        elseif key == "prompt_test_patterns" then
            if not table.contains(map.configs.prompt_test_patterns) then
                table.insert(map.configs.prompt_test_patterns, val)
                map.echo("Prompt pattern added to list: " .. val)
            else
                table.remove(map.configs.prompt_test_patterns, table.index_of(map.configs.prompt_test_patterns, val))
                map.echo("Prompt pattern removed from list: " .. val)
            end
        elseif key == "custom_exits" then
            if type(val) == "table" then
                for k, v in pairs(val) do
                    map.configs.custom_exits[k] = v
                    map.echo(string.format("Custom Exit short direction %s, long direction %s",k,v[1]))
                    map.echo(string.format("    set to: x: %s, y: %s, z: %s, reverse: %s",v[3],v[4],v[5],v[2]))
                end
            else
                map.echo("Custom Exit config must be in the form of a table.", false, true)
            end
        elseif map.configs[key] ~= nil then
            map.configs[key] = val
            map.echo(string.format("Config %s set to: %s", key, tostring(val)))
        else
            map.echo("Unknown configuration.",false,true)
            return
        end
    elseif toggle then
        if (type(map.configs[key]) == "boolean" and table.contains(bool_configs, key)) then
            map.configs[key] = not map.configs[key]
            map.echo(string.format("Config %s set to: %s", key, tostring(map.configs[key])))
        elseif key == "map_window" and sub_key == "shown" then
            map.configs.map_window.shown = not map.configs.map_window.shown
            map.echo(string.format("Map config %s set to: %s", "shown", tostring(map.configs.map_window.shown)))
        else
            map.echo("Unknown configuration.",false,true)
            return
        end
    end
    table.save(profilePath.."/map downloads/configs.lua",map.configs)
    config()
end

local function show_err(msg,debug)
    map.echo(msg,debug,true)
    error(msg,2)
end

local function print_echoes(what, debug, err)
    moveCursorEnd("main")
    local curline = getCurrentLine()
    if curline ~= "" then echo("\n") end
    decho(mapper_tag)
    if debug then decho(debug_tag) end
    if err then decho(err_tag) end
    cecho(what)
    echo("\n")
end

local function print_wait_echoes()
    for k,v in ipairs(wait_echo) do
        print_echoes(v[1],v[2],v[3])
    end
    wait_echo = {}
end

function map.echo(what, debug, err, wait)
    if debug and not map.configs.debug then return end
    what = tostring(what) or ""
    if wait then
        table.insert(wait_echo,{what, debug, err})
        return
    end
    print_wait_echoes()
    print_echoes(what, debug, err)
end

local function set_room(roomID)
    -- moves the map to the new room
    if map.currentRoom ~= roomID then
        map.set("prevRoom", map.currentRoom)
        map.set("currentRoom", roomID)
    end
    if getRoomName(map.currentRoom) ~= map.currentName then
        map.set("prevName", map.currentName)
        map.set("prevExits", map.currentExits)
        map.set("currentName", getRoomName(map.currentRoom))
        map.set("currentExits", getRoomExits(map.currentRoom))
        -- check handling of custom exits here
        for i = 13,#stubmap do
            map.currentExits[stubmap[i]] = tonumber(getRoomUserData(map.currentRoom,"exit " .. stubmap[i]))
        end
    end
    map.set("currentArea", getRoomArea(map.currentRoom))
    centerview(map.currentRoom)
    raiseEvent("onMoveMap", map.currentRoom)
end

local function add_door(roomID, dir, status)
    -- create or remove a door in the designated direction
    -- consider options for adding pickable and passable information
    dir = exitmap[dir] or dir
    if not table.contains(exitmap,dir) then
        error("Add Door: invalid direction.",2)
    end
    if type(status) ~= "number" then
        status = assert(table.index_of({"none","open","closed","locked"},status),
            "Add Door: Invalid status, must be none, open, closed, or locked") - 1
    end
    local exits = getRoomExits(roomID)
    -- check handling of custom exits here
    if not exits[dir] then
        setExitStub(roomID,stubmap[dir],true)
    end
    -- check handling of custom exits here
    if not table.contains({'u','d'},short[dir]) then
        setDoor(roomID,short[dir],status)
    else
        setDoor(roomID,dir,status)
    end
end

local function check_doors(roomID,exits)
    -- looks to see if there are doors in designated directions
    -- used for room comparison, can also be used for pathing purposes
    if type(exits) == "string" then exits = {exits} end
    local statuses = {}
    local doors = getDoors(roomID)
    local dir
    for k,v in pairs(exits) do
        dir = short[k] or short[v]
        if table.contains({'u','d'},dir) then
            dir = exitmap[dir]
        end
        if not doors[dir] or doors[dir] == 0 then
            return false
        else
            statuses[dir] = doors[dir]
        end
    end
    return statuses
end

local function find_room(name, area)
    -- looks for rooms with a particular name, and if given, in a specific area
    local rooms = searchRoom(name)
    if type(area) == "string" then
        local areas = getAreaTable() or {}
        for k,v in pairs(areas) do
            if string.lower(k) == string.lower(area) then
                area = v
                break
            end
        end
        area = areas[area] or nil
    end
    for k,v in pairs(rooms) do
        if string.lower(v) ~= string.lower(name) then
            rooms[k] = nil
        elseif area and getRoomArea(k) ~= area then
            rooms[k] = nil
        end
    end
    return rooms
end

local function getRoomStubs(roomID)
    -- turns stub info into table similar to exit table
    local stubs = getExitStubs(roomID)
    if type(stubs) ~= "table" then stubs = {} end
    -- check handling of custom exits here
    local tmp
    for i = 13,#stubmap do
        tmp = tonumber(getRoomUserData(roomID,"stub "..stubmap[i])) or tonumber(getRoomUserData(roomID,"stub"..stubmap[i])) -- for old version
        if tmp then table.insert(stubs,tmp) end
    end

    local exits = {}
    for k,v in pairs(stubs) do
        exits[stubmap[v]] = 0
    end
    return exits
end

local function connect_rooms(ID1, ID2, dir1, dir2, no_check)
    -- makes a connection between rooms
    -- can make backwards connection without a check
    local match = false
    if not ID1 and ID2 and dir1 then
        error("Connect Rooms: Missing Required Arguments.",2)
    end
    dir2 = dir2 or reverse_dirs[dir1]
    -- check handling of custom exits here
    if stubmap[dir1] <= 12 then
        setExit(ID1,ID2,stubmap[dir1])
    else
        addSpecialExit(ID1, ID2, dir1)
        setRoomUserData(ID1,"exit " .. dir1,ID2)
    end
    if stubmap[dir1] > 12 then
        -- check handling of custom exits here
        setRoomUserData(ID1,"stub "..dir1, stubmap[dir1])
    end
    local doors1, doors2 = getDoors(ID1), getDoors(ID2)
    local dstatus1, dstatus2 = doors1[short[dir1]] or doors1[dir1], doors2[short[dir2]] or doors2[dir2]
    if dstatus1 ~= dstatus2 then
        if not dstatus1 then
            add_door(ID1,dir1,dstatus2)
        elseif not dstatus2 then
            add_door(ID2,dir2,dstatus1)
        end
    end
    if map.mode ~= "complex" then
        local stubs = getRoomStubs(ID2)
        if stubs[dir2] then match = true end
        if (match or no_check) then
            -- check handling of custom exits here
            if stubmap[dir1] <= 12 then
                setExit(ID2,ID1,stubmap[dir2])
            else
                addSpecialExit(ID2, ID1, dir2)
                setRoomUserData(ID2,"exit " .. dir2,ID1)
            end
            if stubmap[dir2] > 12 then
                -- check handling of custom exits here
                setRoomUserData(ID2,"stub "..dir2, stubmap[dir2])
            end
        end
    end
end

local function check_room(roomID, name, exits, onlyName)
    -- check to see if room name or/and exits match expectations
    if not roomID then
        error("Check Room Error: No ID",2)
    end
    -- check with room hash id
    if map.prompt.hash then
        if map.prompt.hash == getRoomHashByID(roomID) then
            return true
        else
            return false
        end
    end

    if name ~= getRoomName(roomID) then return false end

    -- used in mode "lazy" to match only the room name
    if onlyName then return true end

    local t_exits = table.union(getRoomExits(roomID),getRoomStubs(roomID))
    -- check handling of custom exits here
    for i = 13,#stubmap do
        t_exits[stubmap[i]] = tonumber(getRoomUserData(roomID,"exit " .. stubmap[i])) or (tonumber(getRoomUserData(roomID,"stub " .. stubmap[i])) and 0) or (tonumber(getRoomUserData(roomID,"stub" .. stubmap[i])) and 0) -- for old version
    end
    for k,v in ipairs(exits) do
        if short[v] and not table.contains(t_exits,v) then return false end
        t_exits[v] = nil
    end
    local exits_match = table.is_empty(t_exits) or check_doors(roomID,t_exits)
    if not exits_match then return false end

    -- check room description if enabled
    if map.configs.use_description_matching and map.prompt.description then
        local room_desc = getRoomUserData(roomID, "description")
        if room_desc and room_desc ~= "" then
            if room_desc ~= map.prompt.description then
                map.echo("Room " .. roomID .. " rejected: description mismatch", true)
                return false
            end
        else
            -- room matched by name+exits, store the description
            setRoomUserData(roomID, "description", map.prompt.description)
            map.echo("Stored description for room " .. roomID, true)
        end
    end

    return true
end

local function stretch_map(dir,x,y,z)
    -- stretches a map to make room for just added room that would overlap with existing room
    local dx,dy,dz
    if not dir then return end
    for k,v in pairs(getAreaRooms(map.currentArea)) do
        if v ~= map.currentRoom then
            dx,dy,dz = getRoomCoordinates(v)
            if dx >= x and string.find(dir,"east") then
                dx = dx + 1
            elseif dx <= x and string.find(dir,"west") then
                dx = dx - 1
            end
            if dy >= y and string.find(dir,"north") then
                dy = dy + 1
            elseif dy <= y and string.find(dir,"south") then
                dy = dy - 1
            end
            if dz >= z and string.find(dir,"up") then
                dz = dz + 1
            elseif dz <= z and string.find(dir,"down") then
                dz = dz - 1
            end
            setRoomCoordinates(v,dx,dy,dz)
        end
    end
end

local function create_room(name, exits, dir, coords)
    -- makes a new room with captured name and exits
    -- links with other rooms as appropriate
    -- links to adjacent rooms in direction of exits if in simple mode
    if map.mapping then
        name = map.sanitizeRoomName(name)
        map.echo("New Room: " .. name,false,false,(dir or find_portal or force_portal) and true or false)
        local newID = createRoomID()
        addRoom(newID)
        setRoomArea(newID, map.currentArea)
        setRoomName(newID, name)
        if map.prompt.hash then
            setRoomIDbyHash(newID, map.prompt.hash)
        end
        if map.configs.use_description_matching and map.prompt.description then
            setRoomUserData(newID, "description", map.prompt.description)
            map.echo("Stored description for room " .. newID, true)
        end
        for k,v in ipairs(exits) do
            if stubmap[v] then
                if stubmap[v] <= 12 then
                    setExitStub(newID, stubmap[v], true)
                else
                    -- add special char to prompt special exit
                    if string.find(v, "up") or string.find(v, "down") then
                        setRoomChar(newID, "◎")
                    end
                    -- check handling of custom exits here
                    setRoomUserData(newID, "stub "..v,stubmap[v])
                end
            end
        end
        if dir then
            connect_rooms(map.currentRoom, newID, dir)
        elseif find_portal or force_portal then
            addSpecialExit(map.currentRoom, newID, (find_portal or force_portal))
            setRoomUserData(newID,"portals",tostring(map.currentRoom)..":"..(find_portal or force_portal))
        end
        setRoomCoordinates(newID,unpack(coords))
        local pos_rooms = getRoomsByPosition(map.currentArea,unpack(coords))
        if not (find_portal or force_portal) and map.configs.stretch_map and table.size(pos_rooms) > 1 then
            set_room(newID)
            stretch_map(dir,unpack(coords))
        end
        if map.mode == "simple" then
            local x,y,z = unpack(coords)
            local dx,dy,dz,rooms
            for k,v in ipairs(exits) do
                if stubmap[v] then
                    dx,dy,dz = unpack(coordmap[stubmap[v]])
                    rooms = getRoomsByPosition(map.currentArea,x+dx,y+dy,z+dz)
                    if table.size(rooms) == 1 then
                        connect_rooms(newID,rooms[0],v)
                    end
                end
            end
        end
        set_room(newID)
    end
end

local function find_area_limits(areaID)
    -- used to find min and max coordinate limits for an area
    if not areaID then
        error("Find Limits: Missing area ID",2)
    end
    local rooms = getAreaRooms(areaID)
    local minx, miny, minz = getRoomCoordinates(rooms[0])
    local maxx, maxy, maxz = minx, miny, minz
    local x,y,z
    for k,v in pairs(rooms) do
        x,y,z = getRoomCoordinates(v)
        minx = math.min(x,minx)
        maxx = math.max(x,maxx)
        miny = math.min(y,miny)
        maxy = math.max(y,maxy)
        minz = math.min(z,minz)
        maxz = math.max(z,maxz)
    end
    return minx, maxx, miny, maxy, minz, maxz
end

local function find_link(name, exits, dir, max_distance)
    -- search for matching room in desired direction
    -- in lazy mode check_room search only by name
    local x,y,z = getRoomCoordinates(map.currentRoom)
    if map.mapping and x then
        if max_distance < 1 then
            max_distance = nil
        else
            max_distance = max_distance - 1
        end
        if not stubmap[dir] or not coordmap[stubmap[dir]] then return end
        local dx,dy,dz = unpack(coordmap[stubmap[dir]])
        local minx, maxx, miny, maxy, minz, maxz = find_area_limits(map.currentArea)
        local rooms, match, stubs
        if max_distance then
            minx, maxx = x - max_distance, x + max_distance
            miny, maxy = y - max_distance, y + max_distance
            minz, maxz = z - max_distance, z + max_distance
        end
        -- find link from room hash first
        if map.prompt.hash then
            local room = getRoomIDbyHash(map.prompt.hash)
            if room > 0 then
                match = room
            end
        else
            repeat
                x, y, z = x + dx, y + dy, z + dz
                rooms = getRoomsByPosition(map.currentArea,x,y,z)
            until (x > maxx or x < minx or y > maxy or y < miny or z > maxz or z < minz or not table.is_empty(rooms))
            for k,v in pairs(rooms) do
                if check_room(v,name,exits,false) then
                    match = v
                    break
                elseif map.mode == "lazy" and check_room(v,name,exits,true) then
                    match = v
                    break
                end
            end
        end
        if match then
            connect_rooms(map.currentRoom, match, dir)
            set_room(match)
        else
            x,y,z = getRoomCoordinates(map.currentRoom)
            create_room(name, exits, dir,{x+dx,y+dy,z+dz})
        end
    end
end

local function move_map()
    -- tries to move the map to the next room
    local move = table.remove(move_queue,1)
    if move or random_move then
        local exits = (map.currentRoom and getRoomExits(map.currentRoom)) or {}
        -- check handling of custom exits here
        if map.currentRoom then
            for i = 13, #stubmap do
                exits[stubmap[i]] = tonumber(getRoomUserData(map.currentRoom,"exit " .. stubmap[i]))
            end
        end
        local special = (map.currentRoom and getSpecialExitsSwap(map.currentRoom)) or {}
        if move and not exits[move] and not special[move] then
            for k,v in pairs(special) do
                if string.starts(k,move) then
                    move = k
                    break
                end
            end
        end
        if find_portal then
            map.find_me(map.currentName,map.currentExits,move)
            find_portal = false
        elseif force_portal then
            find_portal = false
            map.echo("Creating portal destination")
            create_room(map.currentName, map.currentExits, nil, {getRoomCoordinates(map.currentRoom)})
            force_portal = false
        elseif move == "recall" and map.save.recall[map.character] then
            set_room(map.save.recall[map.character])
        elseif move == map.configs.lang_dirs['look'] and map.currentRoom and not check_room(map.currentRoom, map.currentName, map.currentExits) then
            -- this check isn't working as intended, find out why
            map.find_me(map.currentName,map.currentExits)
        else
            local onlyName
            if map.mode == "lazy" then
              onlyName = true
            else
              onlyName = false
            end
            if exits[move] and (vision_fail or check_room(exits[move], map.currentName, map.currentExits, onlyName)) then
                set_room(exits[move])
            elseif special[move] and (vision_fail or check_room(special[move], map.currentName, map.currentExits, onlyName)) then
                set_room(special[move])
            elseif not vision_fail then
                if map.mapping and move then
                    find_link(map.currentName, map.currentExits, move, map.configs.max_search_distance)
                else
                    map.find_me(map.currentName,map.currentExits, move)
                end
            end
        end
        vision_fail = false
    end
end

local function capture_move_cmd(dir,priority)
    -- captures valid movement commands
    local configs = map.configs
    if configs.clear_lines_on_send then
        lines = {}
    end
    dir = string.lower(dir)
    if dir == "/" then dir = "recall" end
    if dir == configs.lang_dirs['l'] then dir = configs.lang_dirs['look'] end
    if configs.use_translation then
        dir = configs.translate[dir] or dir
    end
    local door = string.match(dir,"open (%a+)")
    if map.mapping and door and (exitmap[door] or short[door]) then
        local doors = getDoors(map.currentRoom)
        if not doors[door] and not doors[short[door]] then
            map.set_door(door,"","")
        end
    end
    for i,v in ipairs(map.save.move_methods) do
    	local str = string.match(dir, v .. " (%a+)")
    	if str then 
    		dir = str
    		break
    	end
    end
    local portal = string.match(dir,"enter (%a+)")
    if map.mapping and portal then
        local portals = getSpecialExitsSwap(map.currentRoom)
        if not portals[dir] then
            map.set_portal(dir, true)
        end
    end
    if table.contains(exitmap,dir) or string.starts(dir,"enter ") or dir == "recall" then
      if dir ~= configs.lang_dirs['look'] then
        if priority then
            table.insert(move_queue,1,exitmap[dir] or dir)
        else
            table.insert(move_queue,exitmap[dir] or dir)
        end
      else
        if configs.search_on_look == true then
          table.insert(move_queue, dir)
        end
    end				
    elseif map.currentRoom then
        local special = getSpecialExitsSwap(map.currentRoom) or {}
        if special[dir] then
            if priority then
                table.insert(move_queue,1,dir)
            else
                table.insert(move_queue,dir)
            end
        end
    end
end

local function deduplicate_exits(exits)
  local deduplicated_exits = {}
  for _, v in ipairs(exits) do
    deduplicated_exits[v] = true
  end

  return table.keys(deduplicated_exits)
end
local function capture_room_info(name, exits)
    -- captures room info, and tries to move map to match
    if (not vision_fail) and name and exits then
        map.set("prevName", map.currentName)
        map.set("prevExits", map.currentExits)
        name = string.trim(name)
        map.set("currentName", name)
        if exits:ends(".") then exits = exits:sub(1,#exits-1) end
        if not map.configs.use_translation then
            exits = string.gsub(string.lower(exits)," and "," ")
        end
        map.set("currentExits", {})
        for w in string.gmatch(exits,"%a+") do
            if map.configs.use_translation then
                local dir = map.configs.translate and map.configs.translate[w]
                if dir then table.insert(map.currentExits,dir) end
            else
                table.insert(map.currentExits,w)
            end
        end
        undupeExits = deduplicate_exits(map.currentExits)
        map.set("currentExits", undupeExits)
        map.echo(string.format("Exits Captured: %s (%s)",exits, table.concat(map.currentExits, " ")),true)
        move_map()
    elseif vision_fail then
        move_map()
    end
end

local function find_area(name)
    -- searches for the named area, and creates it if necessary
    local areas = getAreaTable()
    local areaID
    for k,v in pairs(areas) do
        if string.lower(name) == string.lower(k) then
            areaID = v
            break
        end
    end
    if not areaID then areaID = addAreaName(name) end
    if not areaID then
        show_err("Invalid Area. No such area found, and area could not be added.",true)
    end
    map.set("currentArea", areaID)
end

function map.load_map(address)
    local path = profilePath .. "/map downloads/map.dat"
    if not address then
        loadMap(path)
        map.echo("Map reloaded from local copy.")
    else
        if not string.match(address,"/[%a_]+%.dat$") then
            address = address .. "/map.dat"
        end
        downloading = true
        downloadFile(path, address)
        map.echo(string.format("Downloading map file from: %s.",address))
    end
end

function map.set_exit(dir,roomID)
    -- used to set unusual exits from the room you are standing in
    if map.mapping then
        roomID = tonumber(roomID)
        if not roomID then
            show_err("Set Exit: Invalid Room ID")
        end
        if not table.contains(exitmap,dir) and not string.starts(dir, "-p ") then
            show_err("Set Exit: Invalid Direction")
        end

        if not string.starts(dir, "-p ") then
            local exit
            if stubmap[exitmap[dir] or dir] <= 12 then
                exit = short[exitmap[dir] or dir]
                setExit(map.currentRoom,roomID,exit)
            else
                -- check handling of custom exits here
                exit = exitmap[dir] or dir
                exit = "exit " .. exit
                setRoomUserData(map.currentRoom,exit,roomID)
            end
            map.echo("Exit " .. dir .. " now goes to roomID " .. roomID)
        else
            dir = string.gsub(dir,"^-p ","")
            addSpecialExit(map.currentRoom,roomID,dir)
            map.echo("Special exit '" .. dir .. "' now goes to roomID " .. roomID)
        end
    else
        map.echo("Not mapping",false,true)
    end
end

function map.find_path(roomName,areaName,return_tables)
    areaName = (areaName ~= "" and areaName) or nil
    local rooms = find_room(roomName,areaName)
    local found,dirs = false,{}
    local path = {}
    for k,v in pairs(rooms) do
        found = getPath(map.currentRoom,k)
        if found and (#dirs == 0 or #dirs > #speedWalkDir) then
            dirs = speedWalkDir
            path = speedWalkPath
        end
    end
    if return_tables then
        if table.is_empty(path) then
            path, dirs = nil, nil
        end
        return path, dirs
    else
        if #dirs > 0 then
            map.echo("Path to " .. roomName .. ((areaName and " in " .. areaName) or "") .. ": " .. table.concat(dirs,", "))
        else
            map.echo("No path found to " .. roomName .. ((areaName and " in " .. areaName) or "") .. ".",false,true)
        end
    end
end

function map.export_area(name)
    -- used to export a single area to a file
    local areas = getAreaTable()
    name = string.lower(name)
    for k,v in pairs(areas) do
        if name == string.lower(k) then name = k end
    end
    if not areas[name] then
        show_err("No such area.")
    end
    local rooms = getAreaRooms(areas[name])
    local tmp = {}
    for k,v in pairs(rooms) do
        tmp[v] = v
    end
    rooms = tmp
    local tbl = {}
    tbl.name = name
    tbl.rooms = {}
    tbl.exits = {}
    tbl.special = {}
    local rname, exits, stubs, doors, special, portals, door_up, door_down, coords, environment, roomChar
    for k,v in pairs(rooms) do
        rname = getRoomName(v)
        exits = getRoomExits(v)
        stubs = getExitStubs(v)
        doors = getDoors(v)
        special = getSpecialExitsSwap(v)
        portals = getRoomUserData(v,"portals") or ""
	environment = getRoomEnv(v)
	roomChar = getRoomChar(v)
        coords = {getRoomCoordinates(v)}
        tbl.rooms[v] = {name = rname, coords = coords, exits = exits, stubs = stubs, doors = doors, door_up = door_up,
            door_down = door_down, door_in = door_in, door_out = door_out, special = special, portals = portals, environment = environment, roomChar = roomChar}
        tmp = {}
        for k1,v1 in pairs(exits) do
            if not table.contains(rooms,v1) then
                tmp[k1] = {v1, getRoomName(v1)}
            end
        end
        if not table.is_empty(tmp) then
            tbl.exits[v] = tmp
        end
        tmp = {}
        for k1,v1 in pairs(special) do
            if not table.contains(rooms,v1) then
                tmp[k1] = {v1, getRoomName(v1)}
            end
        end
        if not table.is_empty(tmp) then
            tbl.special[v] = tmp
        end
    end
    local path = profilePath.."/"..string.gsub(string.lower(name),"%s","_")..".dat"
    table.save(path,tbl)
    map.echo("Area " .. name .. " exported to " .. path)
end

function map.import_area(name)
    name = profilePath .. "/" .. string.gsub(string.lower(name),"%s","_") .. ".dat"
    local tbl = {}
    table.load(name,tbl)
    if table.is_empty(tbl) then
        show_err("No file found")
    end
    local areas = getAreaTable()
    local areaID = areas[tbl.name] or addAreaName(tbl.name)
    local rooms = {}
    local ID
    for k,v in pairs(tbl.rooms) do
        ID = createRoomID()
        rooms[k] = ID
        addRoom(ID)
        setRoomName(ID,v.name)
        setRoomArea(ID,areaID)
        setRoomCoordinates(ID,unpack(v.coords))
        if type(v.stubs) == "table" then
            for i,j in pairs(v.stubs) do
                setExitStub(ID,j,true)
            end
        end
        for i,j in pairs(v.doors) do
            setDoor(ID,i,j)
        end
        setRoomUserData(ID,"portals",v.portals)
	setRoomEnv(ID,v.environment)
	setRoomChar(ID,v.roomChar)
    end
    for k,v in pairs(tbl.rooms) do
        for i,j in pairs(v.exits) do
            if rooms[j] then
                connect_rooms(rooms[k],rooms[j],i)
            end
        end
        for i,j in pairs(v.special) do
            if rooms[j] then
                addSpecialExit(rooms[k],rooms[j],i)
            end
        end
    end
    for k,v in pairs(tbl.exits) do
        for i,j in pairs(v) do
            if getRoomName(j[1]) == j[2] then
                connect_rooms(rooms[k],j[1],i)
            end
        end
    end
    for k,v in pairs(tbl.special) do
        for i,j in pairs(v) do
            addSpecialExit(k,j[1],i)
        end
    end
    map.fix_portals()
    map.echo("Area " .. tbl.name .. " imported from " .. name)
end

function map.set_recall()
    -- assigned the current room to be recall for the current character
    map.save.recall[map.character] = map.currentRoom
    table.save(profilePath .. "/map downloads/map_save.dat",map.save)
    map.echo("Recall room set to: " .. getRoomName(map.currentRoom) .. ".")
end

function map.set_portal(name, is_auto)
    -- creates a new portal in the room
    if map.mapping then
        if not string.starts(name,"-f ") then
            find_portal = name
        else
            name = string.gsub(name,"^-f ","")
            force_portal = name
        end
        move_queue = {name}
        if not is_auto then
            send(name)
        end
    else
        map.echo("Not mapping",false,true)
    end
end

function map.set_mode(mode)
    -- switches mapping modes
    if not table.contains({"lazy","simple","normal","complex"},mode) then
        show_err("Invalid Map Mode, must be 'lazy', 'simple', 'normal' or 'complex'.")
    end
    map.set("mode", mode)
    map.echo("Current mode set to: " .. mode)
end

function map.start_mapping(area_name)
    -- starts mapping, and sets the current area to the given one, or uses the current one
    if not map.currentName then
        show_err("Room detection not yet working, see <yellow>map basics<reset> for guidance.")
    end
    local rooms
    move_queue = {}
    area_name = area_name ~= "" and area_name or nil
    if map.currentArea and not area_name then
        local areas = getAreaTableSwap()
        area_name = areas[map.currentArea]
    end
    if not area_name then
        show_err("You haven't started mapping yet, how should the first area be called? Set it with: <yellow>start mapping <area name><reset>")
    end
    map.echo("Now mapping in area: " .. area_name)
    map.set("mapping", true)
    find_area(area_name)
    rooms = find_room(map.currentName, map.currentArea)
    if table.is_empty(rooms) then
        if map.currentRoom and getRoomName(map.currentRoom) == map.currentName then
            map.set_area(area_name)
        else
            create_room(map.currentName, map.currentExits, nil, {0,0,0})
        end
    elseif map.currentRoom and map.currentArea ~= getRoomArea(map.currentRoom) then
        map.set_area(area_name)
    end
end

function map.stop_mapping()
    map.set("mapping", false)
    map.echo("Mapping off.")
end

function map.clear_moves()
    local commands_in_queue = #move_queue
    move_queue = {}
    map.echo("Move queue cleared, "..commands_in_queue.." commands removed.")
end

function map.show_moves()
    map.echo("Moves: "..(move_queue and table.concat(move_queue, ', ') or '(queue empty)'))
end

function map.set_area(name)
    -- assigns the current room to the area given, creates the area if necessary
    if map.mapping then
        find_area(name)
        if map.currentRoom and getRoomArea(map.currentRoom) ~= map.currentArea then
            setRoomArea(map.currentRoom,map.currentArea)
            set_room(map.currentRoom)
        end
    else
        map.echo("Not mapping",false,true)
    end
end

function map.set_door(dir,status,one_way)
    -- adds a door on a given exit
    if map.mapping then
        if not map.currentRoom then
            show_err("Make Door: No room found.")
        end
        dir = exitmap[dir] or dir
        if not stubmap[dir] then
            show_err("Make Door: Invalid direction.")
        end
        status = (status ~= "" and status) or "closed"
        one_way = (one_way ~= "" and one_way) or "no"
        if not table.contains({"yes","no"},one_way) then
            show_err("Make Door: Invalid one-way status, must be yes or no.")
        end

        local exits = getRoomExits(map.currentRoom)
        local exit
        -- check handling of custom exits here
        for i = 13,#stubmap do
            exit = "exit " .. stubmap[i]
            exits[stubmap[i]] = tonumber(getRoomUserData(map.currentRoom,exit))
        end
        local target_room = exits[dir]
        if target_room then
            exits = getRoomExits(target_room)
            -- check handling of custom exits here
            for i = 13,#stubmap do
                exit = "exit " .. stubmap[i]
                exits[stubmap[i]] = tonumber(getRoomUserData(target_room,exit))
            end
        end
        if one_way == "no" and (target_room and exits[reverse_dirs[dir]] == map.currentRoom) then
            add_door(target_room,reverse_dirs[dir],status)
        end
        add_door(map.currentRoom,dir,status)
        map.echo(string.format("Adding %s door to the %s", status, dir))
    else
        map.echo("Not mapping",false,true)
    end
end

function map.shift_room(dir)
    -- shifts a room around on the map
    if map.mapping then
        dir = exitmap[dir] or (table.contains(exitmap,dir) and dir)
        if not dir then
            show_err("Shift Room: Exit not found")
        end
        local x,y,z = getRoomCoordinates(map.currentRoom)
        dir = stubmap[dir]
        local coords = coordmap[dir]
        x = x + coords[1]
        y = y + coords[2]
        z = z + coords[3]
        setRoomCoordinates(map.currentRoom,x,y,z)
        centerview(map.currentRoom)
        map.echo("Shifting room",true)
    else
        map.echo("Not mapping",false,true)
    end
end

local function check_link(firstID, secondID, dir)
    -- check to see if two rooms are connected in a given direction
    if not firstID then error("Check Link Error: No first ID",2) end
    if not secondID then error("Check Link Error: No second ID",2) end
    local name = getRoomName(firstID)
    local exits1 = table.union(getRoomExits(firstID),getRoomStubs(firstID))
    local exits2 = table.union(getRoomExits(secondID),getRoomStubs(secondID))
    local exit
    -- check handling of custom exits here
    for i = 13,#stubmap do
        exit = "exit " .. stubmap[i]
        exits1[stubmap[i]] = tonumber(getRoomUserData(firstID,exit))
        exits2[stubmap[i]] = tonumber(getRoomUserData(secondID,exit))
    end
    local checkID = exits2[reverse_dirs[dir]]
    local exits = {}
    for k,v in pairs(exits1) do
        table.insert(exits,k)
    end
    return checkID and check_room(checkID,name,exits)
end

function map.find_me(name, exits, dir, manual)
    -- tries to locate the player using the current room name and exits, and if provided, direction of movement
    -- if direction of movement is given, narrows down possibilities using previous room info
    if move ~= "recall" then move_queue = {} end
    -- find from room hash id - map.find_me(nil, nil, nil, false)
    if map.prompt.hash then
        local room = getRoomIDbyHash(map.prompt.hash)
        if room > 0 then
            set_room(room)
            map.echo("Room found, ID: " .. room, true)
            return
        else
            map.echo("Room not found in map database!", not manual, true)
            return
        end
    end
    local check = dir and map.currentRoom and table.contains(exitmap,dir)
    name = name or map.currentName
    exits = exits or map.currentExits
    if not name and not exits then
        show_err("Room not found, complete room name and exit data not available.")
    end
    local rooms = find_room(name)
    local match_IDs = {}
    for k,v in pairs(rooms) do
        if check_room(k, name, exits) then
            table.insert(match_IDs,k)
        end
    end
    rooms = match_IDs
    match_IDs = {}
    if table.size(rooms) > 1 and check then
        for k,v in pairs(rooms) do
            if check_link(map.currentRoom,v,dir) then
                table.insert(match_IDs,v)
            end
        end
    elseif random_move then
        for k,v in pairs(getRoomExits(map.currentRoom)) do
            if check_room(v,map.currentName,map.currentExits) then
                table.insert(match_IDs,v)
            end
        end
    end
    if table.size(match_IDs) == 0 then
        match_IDs = rooms
    end
    if table.index_of(match_IDs,map.currentRoom) then
        match_IDs = {map.currentRoom}
    end
    if not table.is_empty(match_IDs) and not find_portal then
        set_room(match_IDs[1])
        map.echo("Room found, ID: " .. match_IDs[1],true)
    elseif find_portal then
        if not table.is_empty(match_IDs) then
            map.echo("Found portal destination, linking rooms",false,false,true)
            addSpecialExit(map.currentRoom,match_IDs[1],find_portal)
            local portals = getRoomUserData(match_IDs[1],"portals") or ""
            portals = portals .. "," .. tostring(map.currentRoom)..":"..find_portal
            setRoomUserData(match_IDs[1],"portals",portals)
            set_room(match_IDs[1])
            map.echo("Room found, ID: " .. match_IDs[1],true)
        else
            map.echo("Creating portal destination",false,false,true)
            create_room(map.currentName, map.currentExits, nil, {getRoomCoordinates(map.currentRoom)})
        end
        find_portal = false
    elseif table.is_empty(match_IDs) then
        map.echo("Room not found in map database", not manual, true)
    end
end

function map.fix_portals()
    if map.mapping then
        -- used to clear and update data for portal back-referencing
        local rooms = getRooms()
        local portals
        for k,v in pairs(rooms) do
            setRoomUserData(k,"portals","")
        end
        for k,v in pairs(rooms) do
            for cmd,room in pairs(getSpecialExitsSwap(k)) do
                portals = getRoomUserData(room,"portals") or ""
                if portals ~= "" then portals = portals .. "," end
                portals = portals .. tostring(k) .. ":" .. cmd
                setRoomUserData(room,"portals",portals)
            end
        end
        map.echo("Portals Fixed")
    else
        map.echo("Not mapping",false,true)
    end
end

function map.merge_rooms()
    -- used to combine essentially identical rooms with the same coordinates
    -- typically, these are generated due to mapping errors
    if map.mapping then
        map.echo("Merging rooms")
        local x,y,z = getRoomCoordinates(map.currentRoom)
        local rooms = getRoomsByPosition(map.currentArea,x,y,z)
        local exits, portals, room, cmd, curportals
        local room_count = 1
        for k,v in pairs(rooms) do
            if v ~= map.currentRoom then
                if getRoomName(v) == getRoomName(map.currentRoom) then
                    room_count = room_count + 1
                    for k1,v1 in pairs(getRoomExits(v)) do
                        setExit(map.currentRoom,v1,stubmap[k1])
                        exits = getRoomExits(v1)
                        if exits[reverse_dirs[k1]] == v then
                            setExit(v1,map.currentRoom,stubmap[reverse_dirs[k1]])
                        end
                    end
                    for k1,v1 in pairs(getDoors(v)) do
                        setDoor(map.currentRoom,k1,v1)
                    end
                    for k1,v1 in pairs(getSpecialExitsSwap(v)) do
                        addSpecialExit(map.currentRoom,v1,k1)
                    end
                    portals = getRoomUserData(v,"portals") or ""
                    if portals ~= "" then
                        portals = string.split(portals,",")
                        for k1,v1 in ipairs(portals) do
                            room,cmd = unpack(string.split(v1,":"))
                            addSpecialExit(tonumber(room),map.currentRoom,cmd)
                            curportals = getRoomUserData(map.currentRoom,"portals") or ""
                            if not string.find(curportals,room) then
                                curportals = curportals .. "," .. room .. ":" .. cmd
                                setRoomUserData(map.currentRoom,"portals",curportals)
                            end
                        end
                    end
                    -- check handling of custom exits here for doors and exits, and reverse exits
                    for i = 13,#stubmap do
                        local door = "door " .. stubmap[i]
                        local tmp = tonumber(getRoomUserData(v,door))
                        if tmp then
                            setRoomUserData(map.currentRoom,door,tmp)
                        end
                        local exit = "exit " .. stubmap[i]
                        tmp = tonumber(getRoomUserData(v,exit))
                        if tmp then
                            setRoomUserData(map.currentRoom,exit,tmp)
                            if tonumber(getRoomUserData(tmp, "exit " .. reverse_dirs[stubmap[i]])) == v then
                                setRoomUserData(tmp, exit, map.currentRoom)
                            end
                        end
                    end
                    deleteRoom(v)
                end
            end
        end
        if room_count > 1 then
            map.echo(room_count .. " rooms merged", true)
        end
    else
        map.echo("Not mapping",false,true)
    end
end

function map.findAreaID(areaname, exact)
    local areaname = areaname:lower()
    local list = getAreaTable()

    -- iterate over the list of areas, matching them with substring match.
    -- if we get match a single area, then return its ID, otherwise return
    -- 'false' and a message that there are than one are matches
    local returnid, fullareaname, multipleareas = nil, nil, {}
    for area, id in pairs(list) do
        if (not exact and area:lower():find(areaname, 1, true)) or (exact and areaname == area:lower()) then
            returnid = id
            fullareaname = area
            multipleareas[#multipleareas+1] = area
        end
    end

    if #multipleareas == 1 then
        return returnid, fullareaname
    else
        return nil, nil, multipleareas
    end
end

function map.echoRoomList(areaname, exact)
    local areaid, msg, multiples
    local listcolor, othercolor = "DarkSlateGrey","LightSlateGray"
    if tonumber(areaname) then
        areaid = tonumber(areaname)
        msg = getAreaTableSwap()[areaid]
    else
        areaid, msg, multiples = map.findAreaID(areaname, exact)
    end
    if areaid then
        local roomlist, endresult = getAreaRooms(areaid) or {}, {}

        -- obtain a room list for each of the room IDs we got
        local getRoomName = getRoomName
        for _, id in pairs(roomlist) do
            endresult[id] = getRoomName(id)
        end
        roomlist[#roomlist+1], roomlist[0] = roomlist[0], nil
        -- sort room IDs so we can display them in order
        table.sort(roomlist)

        local echoLink, format, fg, echo = echoLink, string.format, fg, cecho
        -- now display something half-decent looking
        cecho(format("<%s>List of all rooms in <%s>%s<%s> (areaID <%s>%s<%s> - <%s>%d<%s> rooms):\n",
            listcolor, othercolor, msg, listcolor, othercolor, areaid, listcolor, othercolor, #roomlist, listcolor))
        -- use pairs, as we can have gaps between room IDs
        for _, roomid in pairs(roomlist) do
            local roomname = endresult[roomid]
            cechoLink(format("<%s>%7s",othercolor,roomid), 'map.speedwalk('..roomid..')',
                format("Go to %s (%s)", roomid, tostring(roomname)), true)
            cecho(format("<%s>: <%s>%s<%s>.\n", listcolor, othercolor, roomname, listcolor))
        end
    elseif not areaid and #multiples > 0 then
        local allareas, format = getAreaTable(), string.format
        local function countrooms(areaname)
            local areaid = allareas[areaname]
            local allrooms = getAreaRooms(areaid) or {}
            local areac = (#allrooms or 0) + (allrooms[0] and 1 or 0)
            return areac
        end
        map.echo("For which area would you want to list rooms for?")
        for _, areaname in ipairs(multiples) do
            echo("  ")
            setUnderline(true)
            cechoLink(format("<%s>%-40s (%d rooms)", othercolor, areaname, countrooms(areaname)),
                'map.echoRoomList("'..areaname..'", true)', "Click to view the room list for "..areaname, true)
            setUnderline(false)
            echo("\n")
        end
    else
        map.echo(string.format("Don't know of any area named '%s'.", areaname),false,true)
    end
    resetFormat()
end

function map.echoAreaList()
    local totalroomcount = 0
    local rlist = getAreaTableSwap()
    local listcolor, othercolor = "DarkSlateGrey","LightSlateGray"

    -- count the amount of rooms in an area, taking care to count the room in the 0th
    -- index as well if there is one
    -- saves the total room count on the side as well
    local function countrooms(areaid)
        local allrooms = getAreaRooms(areaid) or {}
        local areac = (#allrooms or 0) + (allrooms[0] and 1 or 0)
        totalroomcount = totalroomcount + areac
        return areac
    end

    local getAreaRooms, cecho, fg, echoLink = getAreaRooms, cecho, fg, echoLink
    cecho(string.format("<%s>List of all areas we know of (click to view room list):\n",listcolor))
    for id = 1,table.maxn(rlist) do
        if rlist[id] then
            cecho(string.format("<%s>%7d ", othercolor, id))
            fg(listcolor)
            echoLink(string.format("%-40s (%d rooms)",rlist[id],countrooms(id)), 'map.echoRoomList("'..id..'", true)',
                "View the room list for "..rlist[id], true)
            echo("\n")
        end
    end
    cecho(string.format("<%s>Total amount of rooms in this map: %s\n", listcolor, totalroomcount))
end

function map.search_timer_check()
    if find_prompt then
        map.echo("Prompt not auto-detected, use 'map prompt' to set a prompt pattern.",false,true)
        find_prompt = false
    end
end

function map.find_prompt()
    find_prompt = true
    map.echo("Searching for prompt.")
    send("\n", false)
    tempTimer(5, "map.search_timer_check()")
end

function map.make_prompt_pattern(str)
    if not str:starts("^") then str = "^"..str end
    map.save.prompt_pattern[map.character] = str
    find_prompt = false
    table.save(profilePath .. "/map downloads/map_save.dat",map.save)
    map.echo("Prompt pattern set: " .. str)
end

function map.make_ignore_pattern(str)
    map.save.ignore_patterns = map.save.ignore_patterns or {}
    if not table.contains(map.save.ignore_patterns,str) then
        table.insert(map.save.ignore_patterns,str)
        map.echo("Ignore pattern added: " .. str)
    else
        table.remove(map.save.ignore_patterns, table.index_of(map.save.ignore_patterns, str))
        map.echo("Ignore pattern removed: " .. str)
    end
    table.save(profilePath .. "/map downloads/map_save.dat",map.save)
end

function map.make_move_method(str)
    map.save.move_methods = map.save.move_methods or {}
    if not table.contains(map.save.move_methods,str) then
        table.insert(map.save.move_methods,str)
        map.echo("Move method added: " .. str)
    else
        table.remove(map.save.move_methods, table.index_of(map.save.move_methods, str))
        map.echo("Move method removed: " .. str)
    end
    table.save(profilePath .. "/map downloads/map_save.dat",map.save)
end

local function grab_line()
    table.insert(lines,line)
    if map.save.prompt_pattern[map.character] and string.match(line, map.save.prompt_pattern[map.character]) then
        if map.prompt.exits and map.prompt.exits ~= "" then
            raiseEvent("onNewRoom")
        end
        print_wait_echoes()
        map.echo("Prompt captured",true)
    end
    if find_prompt then
        for k,v in ipairs(map.configs.prompt_test_patterns) do
            if string.match(line,v) then
                map.save.prompt_pattern[map.character] = v
                table.save(profilePath .. "/map downloads/map_save.dat",map.save)
                find_prompt = false
                map.echo("Prompt found")
                break
            end
        end
    end
end

local function name_search()
    local room_name
    local description_lines = {}
    if map.configs.custom_name_search then
        room_name = mudlet.custom_name_search(lines)
    else
        local line_count = #lines + 1
        local cur_line, last_line, last_line_index
        local room_name_line
        local prompt_pattern = map.save.prompt_pattern[map.character]
        if not prompt_pattern then return end
        while not room_name do
            line_count = line_count - 1
            if not lines[line_count] then break end
            cur_line = lines[line_count]
            for k,v in ipairs(map.save.ignore_patterns) do
                cur_line = string.trim(string.gsub(cur_line,v,""))
            end
            if string.find(cur_line,prompt_pattern) then
                cur_line = string.trim(string.gsub(cur_line,prompt_pattern,""))
                if cur_line ~= "" then
                    room_name = cur_line
                    room_name_line = line_count
                else
                    room_name = last_line
                    room_name_line = last_line_index
                end
            elseif line_count == 1 then
                cur_line = string.trim(cur_line)
                if cur_line ~= "" then
                    room_name = cur_line
                    room_name_line = line_count
                else
                    room_name = last_line
                    room_name_line = last_line_index
                end
            elseif not string.match(cur_line,"^%s*$") then
                last_line = cur_line
                last_line_index = line_count
            end
        end
        -- extract description lines (lines after the room name but before prompt/exits)
        if map.configs.use_description_matching and room_name_line then
            for i = room_name_line + 1, #lines do
                local desc_line = lines[i]
                -- skip empty lines and lines matching the prompt pattern
                if desc_line and not string.match(desc_line, "^%s*$") and not string.find(desc_line, prompt_pattern) then
                    for k,v in ipairs(map.save.ignore_patterns) do
                        desc_line = string.trim(string.gsub(desc_line,v,""))
                    end
                    if desc_line ~= "" then
                        table.insert(description_lines, desc_line)
                    end
                end
            end
        end
        lines = {}
        room_name = room_name:sub(1,100)
    end
    -- store description for later use in room matching
    if map.configs.use_description_matching and #description_lines > 0 then
        map.prompt.description = table.concat(description_lines, "\n")
        map.echo("Description captured: " .. map.prompt.description:sub(1, 100) .. (#map.prompt.description > 100 and "..." or ""), true)
    else
        map.prompt.description = nil
    end
    return room_name
end

local function handle_exits(exits)
    local room = map.prompt.room or name_search()
    room = map.sanitizeRoomName(room)
    exits = map.prompt.exits or exits
    exits = string.lower(exits)
    exits = string.gsub(exits,"%a+", exitmap)
    if room then
        map.echo("Room Name Captured: " .. room, true)
        room = string.trim(room)
        capture_room_info(room, exits)
        map.prompt.room = nil
        map.prompt.exits = nil
        map.prompt.description = nil
    end
end

local continue_walk, timerID
continue_walk = function(new_room)
    if not walking then return end
    -- calculate wait time until next command, with randomness
    local wait = map.configs.speedwalk_delay or 0
    if wait > 0 and map.configs.speedwalk_random then
        wait = wait * (1 + math.random(0,100)/100)
    end
    -- if no wait after new room, move immediately
    if new_room and map.configs.speedwalk_wait and wait == 0 then
        new_room = false
    end
    -- send command if we don't need to wait
    if not new_room then
        --handle script exits
        if string.starts(map.walkDirs[1], "script:") then
          map.walkDirs[1] = string.gsub(map.walkDirs[1], "script:", "")
          loadstring(table.remove(map.walkDirs,1))()
        else
          send(table.remove(map.walkDirs,1))
        end
        -- check to see if we are done
        if #map.walkDirs == 0 then
            walking = false
            speedWalkPath, speedWalkWeight = {}, {}
            raiseEvent("sysSpeedwalkFinished")
        end
    end
    -- make tempTimer to send next command if necessary
    if walking and (not map.configs.speedwalk_wait or (map.configs.speedwalk_wait and wait > 0)) then
        if timerID then killTimer(timerID) end
        timerID = tempTimer(wait, function() continue_walk() end)
    end
end

function map.speedwalk(roomID, walkPath, walkDirs)
    roomID = roomID or speedWalkPath[#speedWalkPath]
    getPath(map.currentRoom, roomID)
    walkPath = speedWalkPath
    walkDirs = speedWalkDir
    if #speedWalkPath == 0 then
        map.echo("No path to chosen room found.",false,true)
        return
    end
    table.insert(walkPath, 1, map.currentRoom)
    -- go through dirs to find doors that need opened, etc
    -- add in necessary extra commands to walkDirs table
    local k = 1
    repeat
        local id, dir = walkPath[k], walkDirs[k]
        if exitmap[dir] or short[dir] then
            local door = check_doors(id, exitmap[dir] or dir)
            local status = door and door[dir]
            if status and status > 1 then
                -- if locked, unlock door
                if status == 3 then
                    table.insert(walkPath,k,id)
                    table.insert(walkDirs,k,"unlock " .. (exitmap[dir] or dir))
                    k = k + 1
                end
                -- if closed, open door
                table.insert(walkPath,k,id)
                table.insert(walkDirs,k,"open " .. (exitmap[dir] or dir))
                k = k + 1
            end
        end
        k = k + 1
    until k > #walkDirs
    if map.configs.use_translation then
        for k, v in ipairs(walkDirs) do
            walkDirs[k] = map.configs.lang_dirs[v] or v
        end
    end
    -- perform walk
    walking = true
    if map.configs.speedwalk_wait or map.configs.speedwalk_delay > 0 then
        map.walkDirs = walkDirs
        continue_walk()
    else
        for _,dir in ipairs(walkDirs) do
           if string.starts(dir, "script:") then
              dir = string.gsub(dir, "script:", "")
              loadstring(dir)()
            else
              send(dir)
           end
        end
        walking = false
        raiseEvent("sysSpeedwalkFinished")
    end
end

function doSpeedWalk()
    if #speedWalkPath ~= 0 then
        raiseEvent("sysSpeedwalkStarted")
        map.speedwalk(nil, speedWalkPath, speedWalkDir)
    else
        map.echo("No path to chosen room found.",false,true)
    end
end

function map.pauseSpeedwalk()
    if #speedWalkDir ~= 0 then
        walking = false
        raiseEvent("sysSpeedwalkPaused")
        map.echo("Speedwalking paused.")
    else
        map.echo("Not currently speedwalking.")
    end
end

function map.resumeSpeedwalk(delay)
    if #speedWalkDir ~= 0 then
        map.find_me(nil, nil, nil, true)
        raiseEvent("sysSpeedwalkResumed")
        map.echo("Speedwalking resumed.")
        tempTimer(delay or 0, function() map.speedwalk(nil, speedWalkPath, speedWalkDir) end)
    else
        map.echo("Not currently speedwalking.")
    end
end

function map.stopSpeedwalk()
    if #speedWalkDir ~= 0 then
        walking = false
        map.walkDirs, speedWalkDir, speedWalkPath, speedWalkWeight = {}, {}, {}, {}
        raiseEvent("sysSpeedwalkStopped")
        map.echo("Speedwalking stopped.")
    else
        map.echo("Not currently speedwalking.")
    end
end

function map.toggleSpeedwalk(what)
    assert(what == nil or what == "on" or what == "off", "map.toggleSpeedwalk wants 'on', 'off' or nothing as an argument")

    if what == "on" or (what == nil and walking) then
        map.pauseSpeedwalk()
    elseif what == "off" or (what == nil and not walking) then
        map.resumeSpeedwalk()
    end
end

local function check_version()
    downloading = false
    local path = profilePath .. "/map downloads/versions.lua"
    local versions = {}
    table.load(path, versions)
    local pos = table.index_of(versions, map.version) or 0
    if pos ~= #versions then
        enableAlias("Map Update Alias")
        if not map.silentUpdate then
          map.echo(string.format("The Generic Mapping Script is currently <red>%d<reset> versions behind.",#versions - pos))
          map.echo("To update now, please type: <yellow>map update<reset>")
        else
          map.updateVersion()
        end
    end
    map.update_timer = tempTimer(3600, [[map.checkVersion()]])
end

function map.checkVersion()
    if #getRooms() > 0 then
      map.silentUpdate = false
    end    
    if map.update_timer then
        killTimer(map.update_timer)
        map.update_timer = nil
    end
    if not map.update_waiting and map.configs.download_path ~= "" then
        local path, file = profilePath .. "/map downloads", "/versions.lua"
        downloading = true
        downloadFile(path .. file, map.configs.download_path .. file)
        map.update_waiting = true
    end
end

local function update_version()
    downloading = false
    local path = profilePath .. "/map downloads/generic_mapper.xml"
    disableAlias("Map Update Alias")
    map.updatingMapper = true
    uninstallPackage("generic_mapper")
    installPackage(path)
    map.updatingMapper = nil
    if not map.silentUpdate then
      map.echo("Generic Mapping Script updated successfully.")
    end
end

function map.updateVersion()
    local path, file = profilePath .. "/map downloads", "/generic_mapper.xml"
    downloading = true
    downloadFile(path .. file, map.configs.download_path .. file)
end

function map.showMap(shown)
    local configs = map.configs.map_window
    shown = shown or not configs.shown
    map.configs.map_window.shown = shown
    map.silentUpdate = false
    local x, y, w, h, origin = configs.x, configs.y, configs.w, configs.h, configs.origin
    if string.find(origin,"bottom") then
        if y == 0 or y == "0%" then
            y = h
        end
        if type(y) == "number" then
            y = -y
        else
            y = "-"..y
        end
    end
    if string.find(origin,"right") then
        if x == 0 or x == "0%" then
            x = w
        end
        if type(x) == "number" then
            x = -x
        else
            x = "-"..x
        end
    end
    local mapper = Geyser.Mapper:new({name = "my_mapper", x = x, y = y, w = w, h = h})
    mapper:resize(w,h)
    mapper:move(x,y)
    if shown then
        mapper:show()
    else
        mapper:hide()
    end
end

-- some games embed an ASCII map on the same line, which messes up the room room name
-- extract the longest continuous piece of text from the line to be the room name
function map.sanitizeRoomName(roomtitle)
  -- sometimes we get 'nil' for a room title - ignore that silently
  if type(roomtitle) ~= "string" then
    return roomtitle
  end

  if not roomtitle:match("   ") then
    -- if the whole line does not contain a run of three consecutive spaces then
    -- consider the whole line as the room name; this was previously two spaces
    -- but some MUDs do have titles that are multiple (short) sentances AND
    -- put TWO spaces after a full-stop for the first (e.g. After the Plague MUD
    -- on telnet://atp.pedia.szote.u-szeged.hu:3000)
    return roomtitle
  end

  -- otherwise split the text up in double-spaced chunks and return the longest
  -- run of bytes found in those chunks
  local parts = roomtitle:split("  ")
  table.sort(parts, function(a,b) return #a < #b end)
  local longestpart = parts[#parts]

  local trimmed = utf8.match(longestpart, "[%w ]+"):trim()
  return trimmed
end

function map.eventHandler(event, ...)
    if event == "onNewRoom" then
        handle_exits(arg[1])
        if walking and map.configs.speedwalk_wait then
            continue_walk(true)
        end
    elseif event == "onPrompt" then
        if map.prompt.exits and map.prompt.exits ~= "" then
            raiseEvent("onNewRoom")
        end
        print_wait_echoes()
        map.echo("Prompt Captured",true)
    elseif event == "onMoveFail" then
        map.echo("onMoveFail",true)
        table.remove(move_queue,1)
    elseif event == "onVisionFail" then
        map.echo("onVisionFail",true)
        vision_fail = true
        capture_room_info()
    elseif event == "onRandomMove" then
        map.echo("onRandomMove",true)
        random_move = true
        move_queue = {}
    elseif event == "onForcedMove" then
        map.echo("onForcedMove",true)
        capture_move_cmd(arg[1],arg[2]=="true")
    elseif event == "onNewLine" then
        grab_line()
    elseif event == "sysDataSendRequest" then
        capture_move_cmd(arg[1])
        -- check to prevent multiple version checks in a row without user intervention
        if map.update_waiting and map.update_timer then
            map.update_waiting = nil
        -- check to ensure version check cycle is started
        elseif not map.update_waiting and not map.update_timer then
            map.checkVersion()
        end
    elseif event == "sysDownloadDone" and downloading then
        local file = arg[1]
        if string.ends(file,"/map.dat") then
            loadMap(file)
            downloading = false
            map.echo("Map File Loaded.")
        elseif string.ends(file,"/versions.lua") then
            check_version()
        elseif string.ends(file,"/generic_mapper.xml") then
            update_version()
        end
    elseif event == "sysDownloadError" and downloading then
        local file = arg[1]
        if string.ends(file,"/versions.lua") and mudlet.translations.interfacelanguage == "zh_CN" then
            -- update to the current download path for chinese user
            if map.configs.download_path == "https://raw.githubusercontent.com/Mudlet/Mudlet/development/src/mudlet-lua/lua/generic-mapper" then
                map.configs.download_path = "https://gitee.com/mudlet/Mudlet/raw/development/src/mudlet-lua/lua/generic-mapper"
                map.checkVersion()
            end
        end
    elseif event == "sysLoadEvent" or event == "sysInstall" then
        config()
        raiseEvent("mapperScriptLoaded", "generic_mapper")
    elseif event == "mapOpenEvent" then
        if not help_shown and not map.save.prompt_pattern[map.character or ""] then
            map.find_prompt()
            send(map.configs.lang_dirs['look'], true)
            tempTimer(3, function() map.show_help("quick_start"); help_shown = true end)
        end
    elseif event == "mapStop" then
        map.set("mapping", false)
        walking = false
        map.echo("Mapping and speedwalking stopped.")
    elseif event == "sysManualLocationSetEvent" then
      set_room(arg[1])
    elseif event == "sysUninstallPackage" and not map.updatingMapper and arg[1] == "generic_mapper" then
        for _,id in ipairs(map.registeredEvents) do
            killAnonymousEventHandler(id)
        end
    end
end

map.registeredEvents = {
registerAnonymousEventHandler("sysDownloadDone", "map.eventHandler"),
registerAnonymousEventHandler("sysDownloadError", "map.eventHandler"),
registerAnonymousEventHandler("sysLoadEvent", "map.eventHandler"),
registerAnonymousEventHandler("sysConnectionEvent", "map.eventHandler"),
registerAnonymousEventHandler("sysInstall", "map.eventHandler"),
registerAnonymousEventHandler("sysDataSendRequest", "map.eventHandler"),
registerAnonymousEventHandler("onMoveFail", "map.eventHandler"),
registerAnonymousEventHandler("onVisionFail", "map.eventHandler"),
registerAnonymousEventHandler("onRandomMove", "map.eventHandler"),
registerAnonymousEventHandler("onForcedMove", "map.eventHandler"),
registerAnonymousEventHandler("onNewRoom", "map.eventHandler"),
registerAnonymousEventHandler("onNewLine", "map.eventHandler"),
registerAnonymousEventHandler("mapOpenEvent", "map.eventHandler"),
registerAnonymousEventHandler("mapStop", "map.eventHandler"),
registerAnonymousEventHandler("onPrompt", "map.eventHandler"),
registerAnonymousEventHandler("sysManualLocationSetEvent", "map.eventHandler"),
registerAnonymousEventHandler("sysUninstallPackage", "map.eventHandler")
}


function map.echon(what)
  moveCursorEnd("main") if getCurrentLine() ~= "" then echo"\n" end
  decho("<112,229,0>(<73,149,0>mapper<112,229,0>): <255,255,255>")
  cecho(tostring(what))
end

function map.roomexists(num)
  if not num then return false end
  if roomExists then return roomExists(num) end

  local s,m = pcall(getRoomArea, tonumber(num))
  return (s and true or false)
end

-- translates n to north and so forth
-- should incorporate generic_mappers exit_map, stub_map
local tempDir = {
    n = "north",
    e = "east",
    s = "south",
    w = "west",
    ne = "northeast",
    se = "southeast",
    sw = "southwest",
    nw = "northwest",
    u = "up",
    d = "down",
    i = "in",
    o = "out",
    ["in"] = "in"
}
local anytolongmap = {}
for s, l in pairs(tempDir) do anytolongmap[l] = l; anytolongmap[s] = l end

function map.anytolong(exit)

  return anytolongmap[exit]
end

function map.anytoshort(exit)
  local t = {
    n = "north",
    e = "east",
    s = "south",
    w = "west",
    ne = "northeast",
    se = "southeast",
    sw = "southwest",
    nw = "northwest",
    u = "up",
    d = "down",
    ["in"] = "in",
    out = "out"
  }
  local rt = {}
  for s,l in pairs(t) do
    rt[l] = s; rt[s] = s
  end

  return rt[exit]
end


function map.ranytolong(exit)
  local t = {
    n = "south",
    north = "south",
    e = "west",
    east = "west",
    s = "north",
    south = "north",
    w = "east",
    west = "east",
    ne = "southwest",
    northeast = "southwest",
    se = "northwest",
    southeast = "northwest",
    sw = "northeast",
    southwest = "northeast",
    nw = "southeast",
    northwest = "southeast",
    u = "down",
    up = "down",
    d = "up",
    down = "up",
    i = "out",
    ["in"] = "out",
    o = "in",
    out = "in"
  }

  return t[exit]
end

-- returns nil or the room number relative to this one
function map.relativeroom(from, dir)
  if not map.roomexists(from) then return end

  local exits = getRoomExits(tonumber(from))
  return exits[map.anytolong(dir)]
end

function map.roomFind(query, lines)
  if query:ends('.') then
    query = query:sub(1, -2)
  end
  local defaultLine = 30 -- this could this to a setting instead of a static number
  local result = map.searchRoom(query)
  if lines == 'all' then
    lines = table.size(result)
  end
  lines = (lines ~= '') and tonumber(lines) or defaultLine

  --create a new table (roomsTable) with keys and add areas to the table
  local roomsTable = {}
  for k, v in pairs(result) do
    local a = getRoomArea(k) or "unknown"
    roomsTable[#roomsTable + 1] = {num = k, area = a, name = v}
  end
  --sort roomsTable by area name
  table.sort(
    roomsTable,
    function(a, b)
      return a.area < b.area
    end
  )
  --start displaying info
  if type(result) == "string" or not next(result) then
    cecho("<grey>You have no recollection of any room with that name.")
    return
  end
  cecho("<DarkSlateGrey>You know the following relevant rooms:\n")

  local i = 1
  if not tonumber(select(2, next(result))) then
    cecho(string.format("<white> %-10s%-40s%s\n", "ROOM ID", "ROOM NAME", "ROOM AREA"))
    for _, v in ipairs(roomsTable) do
      if i > lines then
        break
      end
      roomid = tonumber(v.num)
      roomname = v.name
      roomarea = v.area
      cechoLink(
        string.format("<cyan> %-10s", roomid),
        'gotoRoom(' .. roomid .. ')',
        string.format("Go to %s (%s)", roomid, tostring(roomname)),
        true
      )
      cecho(string.format("<LightSlateGray>%-40s", string.sub(tostring(roomname), 1, 39)))
      cechoLink(
        string.format(
          "<DarkSlateGrey>%s<DarkSlateGrey>\n", getRoomAreaName(getRoomArea(roomid))
        ),
        [[map.echoPath(map.currentRoom, ]] .. roomid .. [[)]],
        "Display directions from here to " .. roomname,
        true
      )
      resetFormat()
      i = i + 1
    end
  else
    -- new style
    --- not sure what this new area code is but it doesn't seem to fire
    for roomname, roomid in pairs(result) do
      roomid = tonumber(roomid)
      cecho(string.format("  <LightSlateGray>%s<DarkSlateGrey> (", tostring(roomname)))
      cechoLink(
        "<cyan>" .. roomid,
        'gotoRoom(' .. roomid .. ')',
        string.format("Go to %s (%s)", roomid, tostring(roomname)),
        true
      )
      cecho(
        string.format(
          "<DarkSlateGrey>) in <LightSlateGray>%s<DarkSlateGrey>.", getRoomAreaName(getRoomArea(roomid))
        )
      )
      fg("DarkSlateGrey")
      echoLink(
        " > Show path\n",
        [[map.echoPath(map.currentRoom, ]] .. roomid .. [[)]],
        "Display directions from here to " .. roomname,
        true
      )
      resetFormat()
    end
  end
  if table.size(result) <= lines then
    cecho(string.format("<DarkSlateGrey>%d rooms found.\n", table.size(result)))
  else
    lastRoomQuery = query
    cechoLink(
      string.format(
        "<DarkSlateGrey>%d of %d rooms shown. Click to see all rooms.\n", lines, table.size(result)
      ),
      'map.roomFind(lastRoomQuery, "all")',
      string.format("Show all %d rooms.", table.size(result)),
      true
    )
  end
end

function map.searchRoom(what)
  local result = searchRoom(what)
  local realResult = {}
  for key, value in pairs(type(result) == "table" and result or {}) do
      -- both ways, because searchRoom can return either id-room name or the reverse
      if type(key) == "string" then
        realResult[key:ends(" (road)") and key:sub(1, -8) or key] = value
      else
        realResult[key] = value:ends(" (road)") and value:sub(1, -8) or value
      end
  end
  result = realResult
  return result
end


-- Lock Area

map.locked = map.locked or {}
map.lastLockSearch = map.lastLockSearch or nil

function map.doLockArea(search)
	local areaList
	if search ~= nil then
		local r = rex.new(string.lower(search))
		map.lastLockSearch = search
		for name, id in pairs(getAreaTable()) do
			if r:match(string.lower(name)) then
				areaList = areaList or {}
				areaList[name] = id
			end
		end
		if areaList == nil then
			map.echo("'" .. search .. "' did not match any known areas!")
			return
		end
	else
		map.lastLockSearch = nil
		areaList = getAreaTable()
	end

	for name, id in pairs(areaList) do
    map.echon(string.format("%-40s %s", name, " "))
--		map.echon(name .. string.rep(" ", 40 - string.len(name)))
		if not map.locked[id] then
			setFgColor(0, 200, 0)
			setUnderline(true)
			echoLink("Lock!", [[map.lockArea( ']] .. name:gsub("'", [[\']]) .. [[', true )]], "Click to lock area '" .. name .. "'", true)
		else
			setFgColor(200, 0, 0)
			setUnderline(true)
			echoLink("Unlock!", [[map.lockArea( ']] .. name:gsub("'", [[\']]) .. [[', false )]], "Click to unlock area '" .. name .. "'", true)
		end
	end

	if not search then
		echo"\n\n" map.echo("Use <green>arealock <area><white> to filter areas.")
	end
end

function map.lockArea(name, lock, dontreshow)
	local areas = getAreaTable()
	local rooms = getAreaRooms(areas[name]) or {}
    local lockRoom = lockRoom
    local count = 0
	for _, room in pairs(rooms) do
		lockRoom(room, lock)
        count = count + 1
	end

	map.locked[areas[name]] = lock and true or nil
	map.echo(string.format("Area '%s' %slocked! All %s room%s within it.", name, (lock and '' or 'un'), count, (count == 1 and '' or 's')))

	if not dontreshow then map.doLockArea(map.lastLockSearch) end
end


function map.roomLook(input)
  -- we can do a report with a number

  local function handle_number(num)
    -- compile all available data
    if not map.roomexists(num) then
      map.echo(num .. " doesn't seem to exist.")
      return
    end
    local s, areanum = pcall(getRoomArea, num)
    if not s then
      map.echo(areanum);
      return ;
    end
    local exits = getRoomExits(num)
    local name = getRoomName(num)
    local islocked = roomLocked(num)
    local weight = (getRoomWeight(num) and getRoomWeight(num) or "?")
    -- getRoomWeight is buggy in one of the versions, is actually linked to setRoomWeight and thus returns nil
    local exitweights = (getExitWeights and getExitWeights(num) or {})
    local coords = {getRoomCoordinates(num)}
    local specexits = getSpecialExits(num)
    local env = getRoomEnv(num)
    -- generic_mapper doesn't have support for environments like IRE_mapper
    local envname = (map.envidsr and map.envidsr[env]) or "?"
    -- generate a report
    map.echo(
      string.format(
        "Room: %s #: %d area: %s (%d)", name, num, getRoomAreaName(areanum), areanum
      )
    )
    map.echo(
      string.format(
        "Coordinates: x:%d, y:%d, z:%d, locked: %s, weight: %s",
        coords[1],
        coords[2],
        coords[3],
        (islocked and "yes" or "no"),
        tostring(weight)
      )
    )
    map.echo(
      string.format(
        "Environment: %s (%d)%s",
        tostring(envname),
        env,
        (getRoomUserData(num, "indoors") ~= '' and ", indoors" or '')
      )
    )
    local description = getRoomUserData(num, "description")
    if description and description ~= "" then
      map.echo("Description:")
      for line in description:gmatch("[^\n]+") do
        echo("  " .. line .. "\n")
      end
    end
    map.echo(string.format("Exits (%d):", table.size(exits)))
    for exit, leadsto in pairs(exits) do
      echo(
        string.format(
          "  %s -> %s (%d)%s%s\n",
          exit,
          getRoomName(leadsto),
          leadsto,
          (
            (getRoomArea(leadsto) or "?") == areanum and
            "" or
            " (in " ..
            (getRoomAreaName(getRoomArea(leadsto)) or "?") ..
            ")"
          ),
          (
            (not exitweights[map.anytoshort(exit)] or exitweights[map.anytoshort(exit)] == 0) and
            "" or
            " (weight: " ..
            exitweights[map.anytoshort(exit)] ..
            ")"
          )
        )
      )
    end
    -- display special exits if we got any
    if next(specexits) then
      map.echo(string.format("Special exits (%d):", table.size(specexits)))
      for leadsto, command in pairs(specexits) do
        if type(command) == "string" then
          echo(string.format("  %s -> %s (%d)\n", command, getRoomName(leadsto), leadsto))
        else
          -- new format - exit name, command
          for cmd, locked in pairs(command) do
            if locked == '1' then
              cecho(
                string.format(
                  "<DarkSlateGrey>  %s -> %s (%d) (locked)\n", cmd, getRoomName(leadsto), leadsto
                )
              )
            else
              echo(string.format("  %s -> %s (%d)\n", cmd, getRoomName(leadsto), leadsto))
            end
          end
        end
      end
    end
    local message = "This room has the feature '%s'."
    for _, mapFeature in pairs(map.getRoomMapFeatures(num)) do
      map.echo(string.format(message, mapFeature))
    end
    -- actions we can do. This will be a short menu of sorts for actions
    map.echo("Stuff you can do:")
    echo("  ")
    echo("Clear all labels ")
    setUnderline(true)
    echoLink("(in area)", 'map.clearLabels(' .. areanum .. ')', '', true)
    setUnderline(false)
    echo(" ")
    setUnderline(true)
    echoLink(
      "(whole map)",
      [[
    if not map.clearinglabels then
      map.echo("Are you sure you want to clear all of your labels on this map? If yes, click the link again.")
      map.clearinglabels = true
    else
      map.clearLabels("map")
      map.clearinglabels = nil
    end
    ]],
      '',
      true
    )
    setUnderline(false)
    echo("\n")
  end

  -- see if we can do anything with the name

  local function handle_name(name)
    local result = map.searchRoom(name)
    if type(result) == "string" then
      cecho("<grey>You have no recollection of any room with that name.")
      return
    end
    -- if we got one result, then act on it
    if table.size(result) == 1 then
      if type(next(result)) == "number" then
        handle_number(next(result))
      else
        handle_number(select(2, next(result)))
      end
      return
    end
    -- if not, then ask the user to clarify which one would they want
    map.echo("Which room specifically would you like to look up?")
    if not select(2, next(result)) or not tonumber(select(2, next(result))) then
      for roomid, roomname in pairs(result) do
        roomid = tonumber(roomid)
        cecho(string.format("  <LightSlateGray>%s<DarkSlateGrey> (", tostring(roomname)))
        cechoLink(
          "<cyan>" .. roomid,
          'map.roomLook(' .. roomid .. ')',
          string.format("View room details for %s (%s)", roomid, tostring(roomname)),
          true
        )
        cecho(
          string.format(
            "<DarkSlateGrey>) in the <LightSlateGray>%s<DarkSlateGrey>.\n",
            getRoomAreaName(getRoomArea(roomid))
          )
        )
      end
    else
      for roomname, roomid in pairs(result) do
        roomid = tonumber(roomid)
        cecho(string.format("  <LightSlateGray>%s<DarkSlateGrey> (", tostring(roomname)))
        cechoLink(
          "<cyan>" .. roomid,
          'map.roomLook(' .. roomid .. ')',
          string.format("View room details for %s (%s)", roomid, tostring(roomname)),
          true
        )
        cecho(
          string.format(
            "<DarkSlateGrey>) in the <LightSlateGray>%s<DarkSlateGrey>.\n",
            getRoomAreaName(getRoomArea(roomid))
          )
        )
      end
    end
  end

  if not input then
    if not map.roomexists(map.currentRoom) then
      map.echo(map.currentRoom .. " doesn't seem to be mapped yet.")
      echo("\n")
      map.echo(string.format("version %s.", tostring(map.version)))
      return
    else
      input = map.currentRoom
    end
  end
  if tonumber(input) then
    handle_number(tonumber(input))
  else
    handle_name(input)
  end
  map.echo(string.format("version %s.", tostring(map.version)))
end


local function loadMapFeatures()
  local mapFeaturesString = getMapUserData("mapFeatures")
  local mapFeatures
  if mapFeaturesString and mapFeaturesString ~= "" then
    mapFeatures = yajl.to_value(mapFeaturesString)
  else
    mapFeatures = {}
  end
  return mapFeatures
end

local function saveMapFeatures(mapFeaturesToSave)
  local mapFeaturesString = yajl.to_string(mapFeaturesToSave)
  setMapUserData("mapFeatures", mapFeaturesString)
end

function map.createMapFeature(featureName, roomCharacter)
  if not featureName or featureName == "" then
    map.echo("Can't create an empty map feature.")
    return
  end
  if featureName:find("%d") then
    map.echo("Map feature names must not contain numbers.")
    return
  end
  roomCharacter = roomCharacter or ""
  if type(roomCharacter) ~= "string" then
    map.echo(
      "The new room character must be either a string or nil. " ..
      type(roomCharacter) ..
      " is not allowed."
    )
    return
  end
  local lowerFeatureName = featureName:lower()
  local mapFeatures = loadMapFeatures()
  if not mapFeatures[lowerFeatureName] then
    mapFeatures[lowerFeatureName] = roomCharacter
    saveMapFeatures(mapFeatures)
    map.echo(
      "Created map feature '" ..
      featureName ..
      "' with the room character '" ..
      roomCharacter ..
      "'."
    )
  else
    map.echo("A map feature with the name '" .. featureName .. "' already exists.")
    return
  end
  return true
end

function map.listMapFeatures()
  local mapFeatures = loadMapFeatures()
  map.echo("This map has the following features:")
  echo(string.format("    %-25s | %s\n", "feature name", "room character"))
  echo(string.format("    ---------------------------------------------\n"))
--  echo(string.format("    %s\n", string.rep("-", 45)))
  for featureName, roomCharacter in pairs(mapFeatures) do
    echo(string.format("    %-25s | %s\n", featureName, roomCharacter))
  end
  return true
end

function map.roomCreateMapFeature(featureName, roomId)
  -- checks for the feature name
  if not featureName then
    map.echo("Which feature would you like to create?")
    return
  end
  local lowerFeatureName = featureName:lower()
  local mapFeatures = loadMapFeatures()
  if not mapFeatures[lowerFeatureName] then
    map.echo(
      "A feature with name '" ..
      featureName ..
      "' does not exist. You need to use 'feature create' first."
    )
    return
  end
  -- checks for the room ID
  if not roomId then
    if not map.currentRoom then
      map.echo("Don't know where we are at the moment.")
      return
    end
    roomId = map.currentRoom
  else
    if type(roomId) ~= "number" then
      map.echo("Need a room ID as number for creating a map feature on a room.")
      return
    end
  end
  if not getRoomName(roomId) then
    map.echo("Room number '" .. roomId .. "' does not exist.")
    return
  end
  -- check if feature already exists
  if table.contains(map.getRoomMapFeatures(roomId), lowerFeatureName) then
    map.echo("Room '" .. roomId .. "' has already map feature '" .. featureName .. "'.")
    return
  end
  -- create map feature in room
  setRoomUserData(roomId, "feature-" .. lowerFeatureName, "true")
  map.echo(string.format("Map feature '%s' created in room number '%d'.", featureName, roomId))
  local featureRoomChar = mapFeatures[lowerFeatureName]
  if featureRoomChar ~= "" then
    setRoomChar(roomId, featureRoomChar)
    map.echo("The room now carries the room char '" .. featureRoomChar .. "'.")
  end
  return true
end

function map.roomDeleteMapFeature(featureName, roomId)
  -- checks for the feature name
  if not featureName then
    map.echo("Which feature would you like to delete?")
    return
  end
  local lowerFeatureName = featureName:lower()
  -- checks for the room ID
  if not roomId then
    if not map.currentRoom then
      map.echo("Don't know where we are at the moment.")
      return
    end
    roomId = map.currentroom
  else
    if type(roomId) ~= "number" then
      map.echo("Need a room ID as number for deleting a map feature from a room.")
      return
    end
  end
  if not getRoomName(roomId) then
    map.echo("Room number '" .. roomId .. "' does not exist.")
    return
  end
  -- check if feature exists
  local roomMapFeatures = map.getRoomMapFeatures(roomId)
  if not table.contains(roomMapFeatures, lowerFeatureName) then
    map.echo("Room '" .. roomId .. "' doesn't have map feature '" .. featureName .. "'.")
    return
  end
  -- delete map feature from room
  setRoomUserData(roomId, "feature-" .. lowerFeatureName, "")
  map.echo(string.format("Map feature '%s' deleted from room number '%d'.", featureName, roomId))
  -- now update room char if needed.
  -- first update current map features of this room
  roomMapFeatures = map.getRoomMapFeatures(roomId)
  local mapFeatures = loadMapFeatures()
  -- find out if we need to set a new room character
  if getRoomChar(roomId) == mapFeatures[lowerFeatureName] and getRoomChar(roomId) ~= "" then
    local index, otherRoomMapFeature
    -- find another usable room character
    repeat
      index, otherRoomMapFeature = next(roomMapFeatures, index)
    until not otherRoomMapFeature or mapFeatures[otherRoomMapFeature] ~= ""
    if otherRoomMapFeature then
      -- we found a usable room character, now set it
      local newRoomChar = mapFeatures[otherRoomMapFeature]
      setRoomChar(roomId, newRoomChar)
      map.echo("Using '" .. newRoomChar .. "' as new room character.")
    else
      -- we didn't find a usable room character, delete it.
      setRoomChar(roomId, "")
      map.echo("Deleted the current room character.")
    end
  end
  return true
end

function map.getRoomMapFeatures(roomId)
  -- checks for the room ID
  if not roomId then
    if not map.currentRoom then
      map.echo("Don't know where we are at the moment.")
      return
    end
    roomId = map.currentRoom
  else
    if type(roomId) ~= "number" then
      map.echo("Need a room ID as number for getting all map features of a room.")
      return
    end
  end
  if not getRoomName(roomId) then
    map.echo("Room number '" .. roomId .. "' does not exist.")
    return
  end
  local result = {}
  local mapFeatures = loadMapFeatures()
  for mapFeature in pairs(mapFeatures) do
    if getRoomUserData(roomId, "feature-" .. mapFeature) == "true" then
      result[#result + 1] = mapFeature
    end
  end
  return result
end

function map.deleteMapFeature(featureName)
  if not featureName or featureName == "" then
    map.echo("Which map feature would you like to delete?")
    return
  end
  local lowerFeatureName = featureName:lower()
  local mapFeatures = loadMapFeatures()
  if not mapFeatures[lowerFeatureName] then
    map.echo("Map feature '" .. featureName .. "' does not exist.")
    return
  end
  local roomsWithFeature = searchRoomUserData("feature-" .. lowerFeatureName, "true")
  for _, roomId in pairs(roomsWithFeature) do
    local deletionResult = map.roomDeleteMapFeature(lowerFeatureName, roomId)
    if not deletionResult then
      map.echo(
        "Something went wrong deleting the map feature '" ..
        featureName ..
        "' from all rooms. Deletion incomplete."
      )
      return
    end
  end
  mapFeatures[lowerFeatureName] = nil
  saveMapFeatures(mapFeatures)
  map.echo("Deleted map feature '" .. featureName .. "' from map.")
  return true
end

function map.getMapFeatures()
  return loadMapFeatures()
end


function map.echoPath(from, to)
  assert(tonumber(from) and tonumber(to), "map.echoPath: both from and to have to be room IDs")
  if getPath(from, to) then
    map.echo(
      "<white>Directions from <yellow>" ..
      string.upper(searchRoom(from)) ..
      " <white>to <yellow>" ..
      string.upper(searchRoom(to)) ..
      "<white>:"
    )
    map.echo(table.concat(speedWalkDir, ", "))
    return map.speedWalkDir
  else
    map.echo(
      "<white>I can't find a way from <yellow>" ..
      string.upper(searchRoom(from)) ..
      " <white>to <yellow>" ..
      string.upper(searchRoom(to)) ..
      "<white>"
    )
  end
end


function map.listSpecialExits(filter)
  local c = 0
  map.echo("Listing special exits...")
  for area, areaname in pairs(getAreaTableSwap()) do
    local rooms = getAreaRooms(area) or {}
    for i = 0, #rooms do
      local exits = getSpecialExits(rooms[i] or 0)
      if exits and next(exits) then
        for exit, cmd in pairs(exits) do
          if type(cmd) == "table" then
            cmd = next(cmd)
          end
          if cmd:match("^%d") then
            cmd = cmd:sub(2)
          end
          if not filter or cmd:lower():find(filter, 1, true) then
            if getRoomArea(exit) ~= area then
              cecho(
                string.format(
                  "<dark_slate_grey>%s <LightSlateGray>(%d, in %s)<dark_slate_grey> <MediumSlateBlue>-> <coral>%s -<MediumSlateBlue>><dark_slate_grey> %s <LightSlateGray>(%d, in %s)\n",
                  getRoomName(rooms[i]),
                  rooms[i],
                  areaname,
                  cmd,
                  getRoomName(exit),
                  exit,
                  getRoomAreaName(getRoomArea(exit)) or '?'
                )
              )
            else
              cecho(
                string.format(
                  "<dark_slate_grey>%s <LightSlateGray>(%d)<dark_slate_grey> <MediumSlateBlue>-> <coral>%s <MediumSlateBlue>-><dark_slate_grey> %s <LightSlateGray>(%d)<dark_slate_grey> in %s\n",
                  getRoomName(rooms[i]),
                  rooms[i],
                  cmd,
                  getRoomName(exit),
                  exit,
                  areaname
                )
              )
            end
            c = c + 1
          end
        end
      end
    end
  end
  map.echo(
    string.format(
      "%d exits listed%s.", c, (not filter and '' or ", with for the filter '" .. filter .. "'")
    )
  )
end

function map.delSpecialExits(filter)
  local c = 0
  for area, areaname in pairs(getAreaTableSwap()) do
    local rooms = getAreaRooms(area) or {}
    for i = 0, #rooms do
      local exits = getSpecialExits(rooms[i] or 0)
      if exits and next(exits) then
        for exit, cmd in pairs(exits) do
          if type(cmd) == "table" then
            cmd = next(cmd)
          end
          if cmd:match("^%d") then
            cmd = cmd:sub(2)
          end
          if not filter or cmd:lower():find(filter, 1, true) then
            local rid, action
            local originalExits = {}
            local e = getSpecialExits(rooms[i])
            for t, n in pairs(e) do
              rid = tonumber(t)
              for a, l in pairs(n) do
                action = tostring(a)
              end
              if not action:find(filter, 1, true) then
                originalExits[rid] = action
              end
            end
            clearSpecialExits(rooms[i])
            for rid, act in pairs(originalExits) do
              addSpecialExit(rooms[i], tonumber(rid), tostring(act))
            end
            c = c + 1
          end
        end
      end
    end
  end
  map.echo(
    string.format(
      "%d exits deleted%s.", c, (not filter and '' or ", with for the filter '" .. filter .. "'")
    )
  )
end


do
local oldsetExit = setExit

local exitmap = {
  n = 1,
  north = 1,
  ne = 2,
  northeast = 2,
  nw = 3,
  northwest = 3,
  e = 4,
  east = 4,
  w = 5,
  west = 5,
  s = 6,
  south = 6,
  se = 7,
  southeast = 7,
  sw = 8,
  southwest = 8,
  u = 9,
  up = 9,
  d = 10,
  down = 10,
  ["in"] = 11,
  out = 12
}

function map.setExit(from, to, direction)
  if type(direction) == "string" and not exitmap[direction] then return false end

  return oldsetExit(from, to, type(direction) == "string" and exitmap[direction] or direction)
end
end


function map.deleteArea(name, exact)
  local id, fname, ma = map.findAreaID(name, exact)
  if id then
    map.doareadelete(id)
  elseif next(ma) then
    map.echo("Which one of these specifically would you like to delete?")
    fg("DimGrey")
    for _, name in ipairs(ma) do
      echo("  ")
      setUnderline(true)
      echoLink(name, [[map.deleteArea("]] .. name .. [[", true)]], "Delete " .. name, true)
      setUnderline(false)
      echo("\n")
    end
    resetFormat()
  else
    map.echo("Don't know of that area.")
  end
end

-- the function actually doing area deletion

function map.doareadelete(areaid)
  map.deletingarea = {}
  local t = map.deletingarea
  local rooms = getAreaRooms(areaid)
  t.roomcount = table.size(rooms)
  t.roombatches = {}
  t.currentbatch = 1
  t.areaid = areaid
  t.areaname = getAreaTableSwap()[areaid]
  -- delete the area right away if there's nothing in it
  if t.roomcount == 0 then
    deleteArea(t.areaid)
    map.echo("All done! The area was already gone/empty.")
  end
  local rooms_per_batch = 100
  -- split up rooms into tables of tables, to be deleted in batches so
  -- that our print statements in between get a chance to be processed
  for batch = 1, t.roomcount, 100 do
    t.roombatches[#t.roombatches + 1] = {}
    local onebatch = t.roombatches[#t.roombatches]
    for inbatch = 1, 100 do
      onebatch[#onebatch + 1] = rooms[batch + inbatch]
    end
  end

  function map.deletenextbatch()
    local t = map.deletingarea
    if not t then
      return
    end
    local currentbatch = t.roombatches[t.currentbatchi]
    if currentbatch == nil then
      deleteArea(t.areaid)
      map.echo("All done! Deleted the '" .. t.areaname .. "' area.")
      map.deletingarea = nil
      centerview(map.currentRoom)
      return
    end
    local deleteRoom = deleteRoom
    for i = 1, #currentbatch do
      deleteRoom(currentbatch[i])
    end
    map.echo(
      string.format(
        "Deleted %d batch%s so far, %d left to go - %.2f%% done out of %d needed",
        t.currentbatchi,
        (t.currentbatchi == 1 and '' or 'es'),
        #t.roombatches - t.currentbatchi,
        (100 / #t.roombatches) * t.currentbatchi,
        #t.roombatches
      )
    )
    t.currentbatchi = t.currentbatchi + 1
    tempTimer(0.010, map.deletenextbatch)
  end

  t.currentbatchi = 1
  map.echo("Prepped room batches, starting deletion...")
  tempTimer(0.010, map.deletenextbatch)
end

function map.renameArea(name, exact)
  if not (map.currentroom or getRoomArea(map.currentRoom)) then
    map.echo("Don't know what area are we in at the moment, to rename it.")
  else
    map.echo(
      string.format(
        "Renamed %s to %s (%d).",
        getRoomAreaName(getRoomArea(map.currentRoom)),
        name,
        getRoomArea(map.currentRoom)
      )
    )
    setAreaName(getRoomArea(map.currentRoom), name)			
    centerview(map.currentRoom)
  end
end

function map.roomArea(otherroom, name, exact)
  local id, fname, ma
  if tonumber(name) then
    id = tonumber(name);
    fname = getAreaTableSwap()[id]
  else
    id, fname, ma = map.findAreaID(name, exact)
  end
  if fname == nil then
    map.echo("Area unknown, can't move room.")
    return
  end
  if otherroom ~= "" and not map.roomexists(otherroom) then
    map.echo("Room id " .. otherroom .. " doesn't seem to exist.")
    return
  elseif otherroom == "" and not map.roomexists(map.currentRoom) then
    map.echo("Don't know where we are at the moment.")
    return
  end
  otherroom = otherroom ~= "" and otherroom or map.currentRoom
  if id then
    setRoomArea(otherroom, id)
    map.echo(
      string.format(
        "Moved %s to %s (%d).",
        (getRoomName(otherroom) ~= "" and getRoomName(otherroom) or "''"),
        fname,
        id
      )
    )
    centerview(otherroom)
  elseif next(ma) then
    map.echo("Into which area exactly would you like to move the room?")
    fg("DimGrey")
    for _, name in ipairs(ma) do
      echo("  ")
      setUnderline(true)
      echoLink(
        name, [[map.roomArea('', "]] .. name .. [[", true)]], "Move the room to " .. name, true
      )
      setUnderline(false)
      echo("\n")
    end
    resetFormat()
  else
    map.echo("Don't know of that area.")
  end
end


function map.clearLabels(areaid)
  local function clearlabels(areaid)
    local t = getMapLabels(areaid)
    if type(t) ~= "table" then
      return
    end
    for labelid, _ in pairs(t) do
      deleteMapLabel(areaid, labelid)
    end
  end

  if areaid == "map" then
    for areaid in pairs(getAreaTableSwap()) do
      clearlabels(areaid)
    end
    map.echo("Cleared labels in all of the map.")
    return
  end
  clearlabels(areaid)
  map.echo(string.format("Cleared all labels in '%s'.", map.getAreaTableSwap()[areaid]))
end

function map.roomLabel(input)
  if not createMapLabel then
    map.echo(
      "Your Mudlet doesn't support createMapLabel() yet - please update to 2.0-test3 or better."
    )
    return
  end
  local tk = input:split(" ")
  local room, fg, bg, message = map.currentRoom, "yellow", "red", "Some room label"
  -- input always have to be something, so tk[1] at least always exists
  if tonumber(tk[1]) then
    room = tonumber(table.remove(tk, 1))
    -- remove the number, so we're left with the colors or msg
  end
  -- next: is this a foreground color?
  if tk[1] and color_table[tk[1]] then
    fg = table.remove(tk, 1)
  end
  -- next: is this a background color?
  if tk[1] and color_table[tk[1]] then
    bg = table.remove(tk, 1)
  end
  -- the rest would be our message
  if tk[1] then
    message = table.concat(tk, " ")
  end
  -- if we haven't provided a room ID and we don't know where we are yet, we can't make a label
  if not room then
    map.echo("We don't know where we are to make a label here.")
    return
  end
  local x, y, z = getRoomCoordinates(room)
  local f1, f2, f3 = unpack(color_table[fg])
  local b1, b2, b3 = unpack(color_table[bg])
  -- finally: do it :)
  local lid = createMapLabel(getRoomArea(room), message, x, y, z, f1, f2, f3, b1, b2, b3)
  map.echo(
    string.format(
      "Created new label #%d '%s' in %s.", lid, message, getRoomAreaName(getRoomArea(room))
    )
  )
end

function map.areaLabels(where, exact)
  if not getMapLabels then
    map.echo(
      "Your Mudlet doesn't support getMapLabels() yet - please update to 2.0-test3 or better."
    )
    return
  end
  if (not where or not type(where) == "string") and not map.currentRoom then
    map.echo("For which area would you like to view labels?")
    return
  end
  if not where then
    exact = true
    where = getRoomAreaName(getRoomArea(map.currentRoom))
  end
  local areaid, msg, multiples = map.findAreaID(where, exact)
  if areaid then
    local t = getMapLabels(areaid)
    if type(t) ~= "table" or not next(t) then
      map.echo(string.format("'%s' doesn't seem to have any labels.", getRoomAreaName(areaid)))
      return
    end
    map.echo(string.format("Area labels for '%s'", getRoomAreaName(areaid)))
    for labelid, labeltext in pairs(t) do
      fg("DimGrey")
      echo(string.format("  %d) %s (", labelid, labeltext))
      fg("orange_red")
      setUnderline(true)
      echoLink(
        'delete',
        string.format(
          'deleteMapLabel(%d, %d); map.echo("Deleted label #' .. labelid .. '")', areaid, labelid
        ),
        "Delete label #" .. labelid .. " from " .. getRoomAreaName(areaid)
      )
      setUnderline(false)
      echo(")\n")
    end
    resetFormat()
  elseif not areaid and #multiples > 0 then
    map.echo("Which area would you like to view exactly?")
    fg("DimGrey")
    for _, areaname in ipairs(multiples) do
      echo("  ");
      setUnderline(true)
      echoLink(
        areaname,
        'map.areaLabels("' .. areaname .. '", true)',
        "Click to view labels in " .. areaname,
        true
      )
      setUnderline(false)
      echo("\n")
    end
    resetFormat()
    return
  else
    map.echo(string.format("Don't know of any area named '%s'.", where))
    return
  end
end

