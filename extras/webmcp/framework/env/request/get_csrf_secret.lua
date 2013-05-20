--[[--
secret =                   -- secret string, previously set with request.set_csrf_secret(...)
request.get_csrf_secret()

Returns the secret string being previously set with request.set_csrf_secret(...) for inclusion in web forms (nil if none is set). This function is automatically used by the ui.form{...} helper.

--]]--

function request.get_csrf_secret(secret)
  return request._csrf_secret
end
