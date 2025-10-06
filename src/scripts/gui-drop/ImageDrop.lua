function GUIDropManager.ImageDrop(event, fname, suffix, posx, posy, consoleName)
    Adjustable.Container:saveAll()
    local acceptable_suffix = {"png", "jpg", "bmp", "jpeg"}
    
    if not table.contains(acceptable_suffix, suffix) then
        return
    end
    local main_width, main_height = getMainWindowSize()
    local image_width, image_height = getImageSize(fname)
    
    if not image_width then 
        return 
    end
    local image_ratio = image_height / image_width
    if image_width > main_width-50 or image_height > main_height-50 then
        image_height = main_height-50
        image_width = (main_height-50) / image_ratio
    end
    
    posx = math.max(0, posx - (image_width/10))
    posy = math.max(0, posy - (image_height/10))
    local imgName = fname:match("([^%/]+)%..+$")
    
    if not (io.exists(getMudletHomeDir() .. "/GUIDropImages/")) then
        lfs.mkdir(getMudletHomeDir() .. "/GUIDropImages/")
    end
    
    --copy file to my profile location
    local imgLocation = getMudletHomeDir() .. "/GUIDropImages/".. imgName.. ".".. suffix
    local infile = io.open(fname, "rb")
    if not (io.exists(imgLocation)) then 
        local instr = infile:read("*ab")
        infile:close()
        local outfile = io.open(imgLocation, "wb")
        outfile:write(instr)
        outfile:close()
    end
    
    local acontainer
    if consoleName == "main" then
        acontainer = Geyser
    else
        acontainer = Geyser.windowList[consoleName.."Container"].windowList[consoleName]
    end
    --convert filename to be a feasible variablename
    local containername = string.gsub(imgName,"[^_%w]","")
    --if filename is only composed of number convert it
    if not containername:match("%D+") then
        containername = "defaultName"
    end
    
    --Check if image exists already and create new containername by adding +1 to the name
    if GUIDropImages[containername] or _G[containername] then 
        while GUIDropImages[containername] or _G[containername] do
            counter = containername:match("%d+$")
            if counter ~= nil then     
                containername = containername:sub(1,-(string.len(counter)+1))
            end
            counter = counter or 0
            counter = counter + 1
            containername = containername..counter
        end
    end
    
    containername = containername
    local labelname = containername.."Label"
    
    GUIDropImages[containername] = Adjustable.Container:new({name="GUIDropImages."..containername, lockStyle = "full", padding = 0, noLimit = true, autoLoad = false, autoSave = false} , acontainer)
    GUIDropImages[containername]:move(posx, posy)
    GUIDropImages[containername]:resize(image_width, image_height)
    GUIDropImages[containername]:setPercent(true, true)
    GUIDropImages[labelname] = Geyser.Label:new({name = "GUIDropImages."..labelname, x=0, y=0, width="100%", height="100%", clickthrough = true}, GUIDropImages[containername])
    
    GUIDropImages[labelname].fname = [["..getMudletHomeDir().."/GUIDropImages/]].. imgName .. ".".. suffix
    GUIDropImages[labelname].imgName = imgName .. ".".. suffix
    GUIDropManager.createDropScript()
end
registerAnonymousEventHandler("sysDropEvent", "GUIDropManager.ImageDrop")