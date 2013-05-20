--[[--
value =        -- value of the id casted to the chosen param_type
param.get_id(
  param_type   -- desired type of the returned value
)

Same as param.get(...), but operates on a special id parameter. An id is set via a __webmcp_id GET or POST parameter or an 'id' option to execute.view{...} or execute.action{...}. In a normal setup a beauty URL of the form http://www.example.com/example-application/example-module/example-view/<id>.html will cause the id to be set.

--]]--

function param.get_id(param_type)
  local param_type = param_type or atom.integer
  if param._exchanged then
    local value = param._exchanged.id
    if value ~= nil and not atom.has_type(value, param_type) then
      error("Parameter has unexpected type.")
    end
    return value
  else
    local str = request.get_id_string()
    if str then
      return param._get_parser(nil, param_type)(str)
    else
      return nil
    end
  end
end
