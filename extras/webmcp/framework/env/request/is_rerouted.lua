--[[--

bool =                 -- true, if request.forard{...} or request.redirect{...} has been called before.
request_is_rerouted()

This function returns true, if request.forward{...} or request.redirect{...} has been called before. In a new request caused by a redirect the function returns false. After a forward has been processed, this function also returns false.

--]]--


function request.is_rerouted()
  if
    (request._forward and not request._forward_processed) or
    request._redirect
  then
    return true
  else
    return false
  end
end
