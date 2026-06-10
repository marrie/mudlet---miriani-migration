local function deleteImage(s) 
    GUIDropImages[string.gsub(s.name,"GUIDropImages%.","")] = nil  
    GUIDropImages[string.gsub(s.name.."Label", "GUIDropImages%.","")] = nil
    table.remove(Adjustable.Container.all_windows, table.index_of(Adjustable.Container.all_windows, s.name))
    Adjustable.Container.all[s.name] = nil
    if io.exists(getMudletHomeDir().."/AdjustableContainer/"..s.name..".lua") then
        os.remove(getMudletHomeDir().."/AdjustableContainer/"..s.name..".lua")
    end    
    s:hide()
end

local function convertToLabel(s)
    local labelscript = [[%s = %s or Geyser.Label:new({name = "%s", x="%s", y="%s", width="%s", height="%s"}%s)
    %s:setStyleSheet("border-image: url(%s);")
    ]]
    local container = GUIDropImages[string.gsub(s.name,"GUIDropImages%.","")]
    local labelname = string.gsub(s.name.."Label", "GUIDropImages%.","")
    GUIDropImages[labelname]:changeContainer(container.container)
    GUIDropImages[labelname]:move(container.x, container.y)
    GUIDropImages[labelname]:resize(container.width, container.height)
    
    if exists("GUIDropManager", "script") == 0 then
        permGroup("GUIDropManager", "script")
    end
    
    if exists("GUIDropLabels", "script") == 0 then
        permScript("GUIDropLabels", "GUIDropManager","--GUIDropLabels Script")
        enableScript("GUIDropLabels")
        echo("LabelScript created!")
    end
    
    if container.containervar then
        container.containervar = ","..container.containervar
    else
        container.containervar = ""
    end
    
    local label = GUIDropImages[string.gsub(s.name.."Label", "GUIDropImages%.","")]
    labelname = labelname:sub(1,-6)
    labelscript = string.format(labelscript, labelname, labelname, labelname, label.x, label.y, label.width, label.height, container.containervar, labelname, [["..getMudletHomeDir().."/GUIDropImages/]].. label.imgName)
    
    appendScript("GUIDropLabels", labelscript)
    
    GUIDropImages[string.gsub(s.name,"GUIDropImages%.","")]:hide()
    GUIDropImages[string.gsub(s.name,"GUIDropImages%.","")] = nil
    GUIDropImages[string.gsub(s.name.."Label", "GUIDropImages%.","")] = nil
    table.remove(Adjustable.Container.all_windows, table.index_of(Adjustable.Container.all_windows, s.name))
    Adjustable.Container.all[s.name] = nil
    if io.exists(getMudletHomeDir().."/AdjustableContainer/"..s.name..".lua") then
        os.remove(getMudletHomeDir().."/AdjdustableContainer/"..s.name..".lua")
    end  
end


function Adjustable.Container:setDropImg()
    if self.dropImg then
        return
    end
    
    self.dropImg = true
    self.adjLabelstyle =[[
    QLabel::hover{ background-color: rgba(0,0,0,0%); border: 1px solid grey;}
    QLabel::!hover{ background-color: rgba(0,0,0,0%);}]]
    if not self.locked then
        self.adjLabel:setStyleSheet(self.adjLabelstyle)
    else
        self.adjLabel:setStyleSheet([[border:0;]])
    end
    self:setTitle(" ")
    self.minimizeLabel:raise()
    self.exitLabel:raise()
    
    self:newCustomItem("setAbsolute", function(s) s:setAbsolute(true, true) self:save() end)
    self:newCustomItem("setPercent",  function(s) s:setPercent(true, true)  self:save() end)
    self:newCustomItem("deleteImage", function(s) deleteImage(s) GUIDropManager.createDropManager() Adjustable.Container:saveAll() end)
    self:newCustomItem("convertToLabel",  function(s) convertToLabel(s) GUIDropManager.createDropManager() Adjustable.Container:saveAll() end)
    self:newCustomItem("saveAll",  function(s) Adjustable.Container:saveAll() end)
    self:newCustomItem("loadAll",  function(s) Adjustable.Container:saveAll() end)
    self:newCustomItem("updateScript",  function(s) Adjustable.Container:saveAll() GUIDropManager.createDropManager() end)
end