-- Once Geyser.add2 is in this is not needed anymore
local addwrapper = Adjustable.Container.add
function Adjustable.Container:add(window, cons)
  addwrapper(self, window, cons)
  if self.hidden then
    tempTimer(0, function() self:hide() end)
  end
  if self.auto_hidden then
    tempTimer(0, function() self:hide(true) end)
  end
end