local categories, indices, messages, selected_category, modes, keybinds = {}, {}, {}, 0, {}, {}
channel_history = channel_history or {}
channel_history.show_timestamps = channel_history.show_timestamps or true
function channel_history.delete_category()
    -- deletes the category that currently has focus as well as all of its messages
    if #categories == 0 then
        return channel_history.say("No categories")
    end
    if selected_category == 0 then
        return channel_history.say("No category selected")
    end -- if
    messages[categories[selected_category]] = nil
    indices[categories[selected_category]] = nil
    table.remove(categories, selected_category)
    if selected_category > #categories then
        selected_category = 1
    end
    if #categories > 0 then
        channel_history.say(categories[category])
    else
        channel_history.say("no more categories")
        categories = {}
        selected_category = 0
    end
end -- func

function channel_history.add(category, message)
    if messages[category] == nil then
        messages[category] = {}
        indices[category] = 0
        table.insert(categories, category)
    end
    table.insert(messages[category], { ["message"] = message, ["time"] = os.clock() })
    if #messages[category] > 5000 then
        table.remove(messages[category], 1)
        if indices[category] > 1 then
            indices[category] = 1
        end
    end
end

function channel_history.get(which)
    local str = ""
    if selected_category == 0 and #categories == 0 then
        channel_history.say("No categories")
        return
    elseif selected_category == 0 and #categories > 0 then
        for i, result in ipairs(categories) do
            if categories[i] == "all" then
                selected_category = i
            end
        end
        if selected_category > 0 then
            str = str .. "switching to all."
        else
            str = str .. "switching to " .. categories[1] .. ". Use alt left and right arrows to change."
            selected_category = 1
        end
    end
    local item = tonumber(which)
    if #messages[categories[selected_category]] < item then
        channel_history.say("no message")
        return
    end

    -- now that all that's out of the way, we can start our real code which should always succeed.
    local timeout = 0.5 -- in seconds
    if modes[item] == nil then
        modes[item] = { os.clock(), 1 }
    elseif os.clock() - modes[item][1] >= timeout then
        modes[item][1] = os.clock()
        modes[item][2] = 1
    else
        modes[item][1] = os.clock()
        modes[item][2] = modes[item][2] + 1
    end
    if modes[item][2] > 3 then
        modes[item][2] = 3
    end
    local real_item = #messages[categories[selected_category]] + 1 - item
    if modes[item][2] == 1 then
        channel_history.sayMsg(str, messages[categories[selected_category]][real_item])
    elseif modes[item][2] == 2 then
        setClipboardText(messages[categories[selected_category]][real_item]["message"])
        channel_history.say("copied")
    end
end -- func

function channel_history.sayMsg(str, m)
    saythis = str .. " " .. m["message"]
    if channel_history.show_timestamps == true then
        local lastchar = string.byte(m["message"]:sub(-1))
        if (lastchar >= 49 and lastchar <= 57) or (lastchar >= 65 and lastchar <= 91) or (lastchar >= 97 and
            lastchar <= 123) then
            saythis = saythis .. "."
        end
        saythis = saythis .. " " .. calculateRelativeTime(os.clock() - m["time"])
    end
    channel_history.say(saythis)
end -- func

function calculateRelativeTime(t)
    if t < 1 then
        return "just now"
    end
    if t >= 1 and t < 60 then
        return math.ceil(t) .. " seconds ago"
    end
    if t >= 60 and t < 3600 then
        local min = math.floor(t / 60)
        local sec = math.ceil(math.fmod(t, 60))
        return min .. " minutes " .. sec .. " seconds ago"
    end
    if t >= 3600 and t < 86400 then -- amount of seconds in a day.
        local hr = math.floor(t / 3600)
        local min = math.floor((t % 3600) / 60)
        return hr .. " hours " .. min .. " minutes ago"
    end
    if t > 86400 then
        local days = math.floor(t / 86400)
        local hr = math.floor((t - (86400 * days)) / 3600)
        local min = math.floor(((t - ((86400 * days) + (3600 * hr))) / 60))
        return days .. " days, " .. hr .. " hours, and " .. min .. " minutes ago"
    end

    return ""
    --return os.clock()-t
end

function channel_history.next_category()
    if #categories == 0 then
        channel_history.say("no categories")
        return
    end
    selected_category = selected_category + 1
    if selected_category > #categories then
        selected_category = 1
    end
    if indices[categories[selected_category]] == 0 then indices[categories[selected_category]] = 1 end
    channel_history.say(categories[selected_category] ..
        ": " .. indices[categories[selected_category]] .. " of " .. #messages[categories[selected_category]])
end

function channel_history.previous_category()
    if #categories == 0 then
        channel_history.say("no categories")
        return
    end
    selected_category = selected_category - 1
    if selected_category < 1 then
        selected_category = #categories
    end
    if indices[categories[selected_category]] == 0 then indices[categories[selected_category]] = 1 end
    channel_history.say(categories[selected_category] ..
        ": " .. indices[categories[selected_category]] .. " of " .. #messages[categories[selected_category]])
end -- func

function channel_history.next_message(item)
    local skip = item or 1
    local str = ""
    if #categories == 0 then
        channel_history.say("no categories")
        return
    end
    if selected_category == 0 then
        channel_history.say("No category selected.")
        return
    end
    if indices[categories[selected_category]] == 0 then
        indices[categories[selected_category]] = #messages[categories[selected_category]]
    end
    if indices[categories[selected_category]] + skip > #messages[categories[selected_category]] then
        indices[categories[selected_category]] = #messages[categories[selected_category]]
        str = str .. "Bottom: "
    else
        indices[categories[selected_category]] = indices[categories[selected_category]] + skip
    end
    channel_history.sayMsg(str, messages[categories[selected_category]][ indices[categories[selected_category]] ])
end -- func

function channel_history.previous_message(item)
    local skip = item or 1
    local str = ""
    if #categories == 0 then
        channel_history.say("no categories")
        return
    end
    if selected_category == 0 then
        channel_history.say("No category selected.")
        return
    end
    if indices[categories[selected_category]] == 0 then
        indices[categories[selected_category]] = #messages[categories[selected_category]]
    end
    if indices[categories[selected_category]] - skip < 1 then
        indices[categories[selected_category]] = 1
        str = str .. "Top: "
    else
        indices[categories[selected_category]] = indices[categories[selected_category]] - skip
    end
    channel_history.sayMsg(str, messages[categories[selected_category]][ indices[categories[selected_category]] ])
end -- func

function channel_history.say(text)
    -- speaks the specified text through the system voice for Mac OSX and Linux, and announce() for Windows
    if getOS() == "windows" then
        announce(text)
    else
        ttsQueue(text)
    end -- if
end -- func

function channel_history.toggle_timestamps()
    channel_history.show_timestamps = not channel_history.show_timestamps
    local sts = channel_history.show_timestamps and "on" or "off"
    channel_history.say("announce timestamps with messages now " .. sts)
end -- func

-- set up our keys
local keys = { mudlet.key["1"], mudlet.key["2"], mudlet.key["3"], mudlet.key["4"], mudlet.key["5"], mudlet.key["6"],
    mudlet.key["7"], mudlet.key["8"], mudlet.key["9"], mudlet.key["0"] }
for index, code in ipairs(keys) do
    table.insert(keybinds, tempKey(mudlet.keymodifier.Alt, code, function() channel_history.get(index) end))
end
