if saveMap(getMudletHomeDir() .. "/map.dat") then
  map.echo("Map saved.\n")
else
  map.echo("Error.  Map NOT saved.\n")
end
				