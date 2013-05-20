--[[--
request.set_csrf_secret(
  secret                 -- secret random string
)

Sets a secret string to be used as protection against cross-site request forgery attempts. This string will be transmitted to each action via a hidden form field named "_webmcp_csrf_secret". If this function is called during an action, and there is no CGI GET/POST parameter "_webmcp_csrf_secret" already being set to the given secret, then an error will be thrown to prohibit execution of the action.

--]]--

function request.set_csrf_secret(secret)
  if
    request.get_action() and
    cgi.params._webmcp_csrf_secret ~= secret
  then
    error("Cross-Site Request Forgery attempt detected");
  end
  request._csrf_secret = secret
end
