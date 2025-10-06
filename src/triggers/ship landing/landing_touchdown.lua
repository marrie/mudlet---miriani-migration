-- number of lines matched by this trigger
local L = 2

-- move cursor up to the first matched line
-- (relative move: 0 columns, -(L-1) rows)
moveCursor(0, -(L - 1))

-- delete each matched line from top to bottom
for i = 1, L do
  selectCurrentLine()
  deleteLine()
end
