--[[--
request.set_status(
  str                -- string containing a HTTP status code, e.g. "404 Not Found"
)

Calling this function causes a HTTP status different from 200 OK (or in case of error different from 500 Internal Server Error) to be sent to the browser.

--]]--

function request.set_status(str)
  if str then
    local t = type(str)
    if type(str) == "number" then
      str = tostring(str)
    elseif type(str) ~= "string" then
      error("request.set_status(...) must be called with a string as parameter.")
    end
    request._status = str
  else
    request._status = nil
  end
end
