--[[--
param.restore()

Calling this function reverts the changes of param.exchange(...). It should not be called explicitly, but is used implicitly, if you pass an 'id' or 'params' option to execute.view{...} or execute.action{...}.

--]]--

function param.restore()
  local saved = param._saved
  local previous = saved[#saved]
  saved[#saved] = nil
  if previous == nil then
    error("Tried to restore id and params without having exchanged it before.")
  end
  param._exchanged = previous
end
