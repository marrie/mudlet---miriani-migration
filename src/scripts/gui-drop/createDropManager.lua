GUIDropManager = GUIDropManager or {}
GUIDropImages = GUIDropImages or {}
function GUIDropManager.createDropManager()
    GUIDropManager.script = "--GUIDropManager\n"
    
    local labelscript = [[%s = %s or Geyser.Label:new({name = "%s", x="%s", y="%s", width="%s", height="%s"%s}, %s)
    %s:setStyleSheet("border-image: url(%s);")
    %s.imgName = "%s"
    %s:setDropImg()
    
    ]]
    local containerscript = [[%s = %s or Adjustable.Container:new({name = "%s", x = "%s", y = "%s", width = "%s", height = "%s", lockStyle = "full", padding = 0, noLimit = true%s%s}%s)
    
    ]]
    local function createFname(imgName)
        return [["..getMudletHomeDir().."/GUIDropImages/]].. imgName
    end
    for k,v in pairs(GUIDropImages) do
        
        if v.type == "adjustablecontainer" then
            local container = ""
            local containervar = ""
            local locked = ""
            if v.windowname ~= "main" then
                container = v.containervar or getKeyFrom(v.container, ".container")
                if not container then
                    container = "Geyser.windowList."..v.windowname.."Container.windowList."..v.windowname
                end
                containervar = [[, containervar = "]]..container..[["]]
                v.containervar = container
                container = ", "..container
            end
            if v.locked then
                locked = ", locked = true"
            end
            GUIDropManager.script = GUIDropManager.script..string.format(containerscript, v.name, v.name, v.name, v.x, v.y, v.width, v.height, locked, containervar, container)
        end
        
    end
    
    
    for k,v in pairs(GUIDropImages) do    
        if v.type == "label" then
            v.fname = v.fname or createFname(v.imgName)
            local clickthrough = ""
            if v.clickthrough then
                clickthrough = ", clickthrough = true"
            end
            GUIDropManager.script = GUIDropManager.script..string.format(labelscript, v.name, v.name, v.name, v.x, v.y, v.width, v.height, clickthrough, v.container.container.name, v.name, v.fname, v.name, v.imgName, v.container.container.name)
        end    
    end
    
    if not setScript("GUIDropManager", GUIDropManager.script, 2) then
        display(setScript("GUIDropManager", GUIDropManager.script, 2))
    end
    
end