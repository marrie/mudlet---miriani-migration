-- USE PATTERNS FOR STRING.GSUB
if matches[2] then
  map.make_ignore_pattern(matches[2])
else
  display(map.save.ignore_patterns)
end