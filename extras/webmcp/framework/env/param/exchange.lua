--[[--
param.exchange(
  id,
  params
)

This function exchanges the id and/or parameters which are returned by param.get_id(...), param.get(...), etc. It should not be called explicitly, but is used implicitly, if you pass an 'id' or 'params' option to execute.view{...} or execute.action{...}. The function param.restore() is used to revert the exchange.

--]]--

function param.exchange(id, params)
  table.insert(param._saved, param._exchanged)
  param._exchanged = { id = id, params = params }
end
