--[[--
is_404 =          -- boolean
request.is_404()

Returns true, if this request results in a 404, else false.

--]]--

function request.is_404()
  return request._is_404
end
