--[[--
action_name =
request.get_action()

Returns the name of the currently requested action, or nil in case of a view.

--]]--

function request.get_action()
  if request._forward_processed then
    return nil
  else
    return request._action
  end
end
