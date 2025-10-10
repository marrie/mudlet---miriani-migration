local s = matches[2]

s = string.gsub(s, "%$", "\n")
cfeedTriggers("\n" .. s .. "\n")
echo("\n")