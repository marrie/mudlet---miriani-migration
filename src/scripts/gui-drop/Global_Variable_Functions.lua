function GUIDropManager.getKeyFrom(value, exclude, depth, table, iteration)
    exclude = exclude or false
    depth = depth or 3
    table = table or _G
    local tempTable = {}
    iteration = iteration or 1
    if iteration > depth then
        return nil, "key not found"
    end
    for k,v in pairs(table) do
        if type(v) == "table" and k ~= "_G" then
            for k1,v1 in pairs(v) do
                tempTable[k.."."..k1] = v1
            end
        end
        if v == value and not string.find(k, exclude) then
            return k
        end
    end
    return GUIDropManager.getKeyFrom(value, exclude, depth, tempTable, iteration + 1)    
end