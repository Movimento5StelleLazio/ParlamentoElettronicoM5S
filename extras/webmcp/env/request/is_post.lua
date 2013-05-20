--[[--
bool =             -- true, if the current request is a POST request
request.is_post()

This function can be used to check, if the current request is a POST request.

--]]--

function request.is_post()
  if request._forward_processed then
    return false
  else
    return cgi.method == "POST"
  end
end
