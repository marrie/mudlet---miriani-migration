function GUIDropManager.createDropScript()
    if exists("GUIDropManager", "script") == 0 then
        permGroup("GUIDropManager", "script")
    end
    if exists("GUIDropManager", "script") < 2 then
        permScript("GUIDropManager", "GUIDropManager","--GUIDropManager Script")
        enableScript("GUIDropManager")
        echo("DropScript created!")
    end
    GUIDropManager.createDropManager()
end