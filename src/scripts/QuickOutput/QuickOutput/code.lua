quick_output = {}
quick_output.timeout = 0.3 -- seconds
quick_output.clock = os.clock()
quick_output.keybinds = {}
quick_output.do_action = 0
quick_output.old_line = ""
function quick_output.get_line(number)
    -- work with the first 10 lines of output
    -- if number is 1, we just do getCurrentLine()
    -- else, we subtract 1 from number and move the cursor to the start of that line
    -- then do getCurrentLine()
    local line = ""
    if number == 1 then
        moveCursorEnd()
        line = getCurrentLine()
        if line == "" then
            moveCursorUp()
            line = getCurrentLine()
        end -- if
        moveCursorEnd()
    elseif number < 11 then
        if moveCursor(0, getLastLineNumber() - number) then
            line = getCurrentLine()
        else
            line = "error getting line"
        end -- if
    end -- if
    if line == "" then line = "blank" end
    if line == quick_output.old_line then quick_output.do_action = quick_output.do_action + 1 end
    if os.clock() - quick_output.clock > quick_output.timeout then
        quick_output.do_action = 0
    end -- if
    if quick_output.do_action >= 1 then
        if setClipboardText(line) then quick_output.say("copied") end
        quick_output.do_action = 0
        return
    end -- if
    quick_output.say(line)
    quick_output.old_line = line
    quick_output.clock = os.clock()
end -- func

function quick_output.say(text)
    -- we will use announce() on windows and tts on other systems
    if type(text) ~= "string" then
        error("Expected string")
    end -- if
    if getOS() == "windows" then
        announce(text)
    else
        ttsQueue(text)
    end -- if
end -- func

function quick_output.remove(event, package)
    if package ~= "QuickOutput" then return true end
    -- First, kill off all the keybinds
    for _, id in ipairs(quick_output.keybinds) do
        killKey(id)
    end
    -- Everything else is contained within the quick_output table so just make it nil
    quick_output = nil
end -- func

-- set up our keys
local keys = { mudlet.key["1"], mudlet.key["2"], mudlet.key["3"], mudlet.key["4"], mudlet.key["5"], mudlet.key["6"],
    mudlet.key["7"], mudlet.key["8"], mudlet.key["9"], mudlet.key["0"] }
for index, code in ipairs(keys) do
    table.insert(quick_output.keybinds,
        tempKey(mudlet.keymodifier.Control, code, function() quick_output.get_line(index) end))
end

-- register our event handler for when the package is removed

registerAnonymousEventHandler("sysUninstall", quick_output.remove, true)
