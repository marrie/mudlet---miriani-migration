local s = matches[2]

s = string.gsub(s, "%$", "\n")
hfeedTriggers("\n" .. s .. "\n")
echo("\n")