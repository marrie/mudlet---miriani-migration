-- Get the captured message without quotes
local message = matches[2]:gsub('^"', ''):gsub('"$', '')

-- Gag the original line
selectCurrentLine()
deleteLine()

-- Output just the stripped message
cecho(message .. "\n")
