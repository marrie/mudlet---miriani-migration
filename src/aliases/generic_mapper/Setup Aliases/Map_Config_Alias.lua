-- adjust pattern to allow no argument, if no argument show general help about configs
if not matches[2] then
	cecho(map.help.config)
else
  local startStr, endStr = string.match(matches[2],"(.*) ([%w%.]+)")
  local vals = {'on', 'off', 'true', 'false'}
  local modes = {'lazy','simple','normal','complex'}
  if (table.contains(vals, endStr) or tonumber(endStr)) or (startStr == "mode" and table.contains(modes, endStr)) then
  	map.setConfigs(startStr, endStr)
  else
  	map.setConfigs(matches[2])
  end
end