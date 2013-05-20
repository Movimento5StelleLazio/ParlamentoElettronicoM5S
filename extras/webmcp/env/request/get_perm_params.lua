--[[--
perm_params =              -- table containing permanent parameters
request.get_perm_params()

This function returns a table containing all permanent paremeters set with request.set_perm_param(...). Modifications of the returned table have no side effects.

--]]--

function request.get_perm_params()
  -- NOTICE: it's important to return a copy here
  return table.new(request._perm_params)
end
