-- USE PATTERNS FOR STRING.GSUB
if matches[2] then
  map.make_prompt_pattern(matches[2])
else
  display(map.save.prompt_pattern)
end