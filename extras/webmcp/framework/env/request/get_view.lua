--[[--
view_name =
request.get_view()

Returns the name of the currently requested view, or nil in case of an action.

--]]--

function request.get_view()
  if request._forward_processed then
    return request._forward.view or 'index'
  else
    if request._view then
      local suffix = request._suffix or "html"
      if suffix == "html" then
        return request._view
      else
        return request._view .. "." .. suffix
      end
    elseif not request._action then
      return 'index'
    else
      return nil
    end
  end
end
