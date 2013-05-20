--[[--
success,                                                -- boolean indicating success or failure
errmsg,                                                 -- error message in case of failure
errcode =                                               -- error code in case of failure (TODO: not implemented yet)
auth.openid.initiate{
  user_supplied_identifier = user_supplied_identifier,  -- string given by user
  https_as_default         = https_as_default,          -- default to https
  curl_options             = curl_options,              -- additional options passed to "curl" binary, when performing discovery
  return_to_module         = return_to_module,          -- module of the verifying view, the user shall return to after authentication
  return_to_view           = return_to_view,            -- verifying view, the user shall return to after authentication
  realm                    = realm                      -- URL the user should authenticate for, defaults to application base
}

In order to authenticate using OpenID the user should enter an identifier.
It is recommended that the form field element for this identifier is named
"openid_identifier", so that User-Agents can automatically determine the
given field should contain an OpenID identifier. The entered identifier is
then passed as "user_supplied_identifier" argument to this function. It
returns false on error and currently never returns on success. However in
future this function shall return true on success. After the user has
authenticated successfully, he/she is forwarded to the URL given by the
"return_to" argument. Under this URL the application has to verify the
result by calling auth.openid.verify{...}.

--]]--

function auth.openid.initiate(args)
  local dd, errmsg, errcode = auth.openid.discover(args)
  if not dd then
    return nil, errmsg, errcode
  end
  -- TODO: Use request.redirect once it supports external URLs
  cgi.set_status("303 See Other")
  cgi.add_header(
    "Location: " ..
    encode.url{
      external = dd.op_endpoint,
      params = {
        ["openid.ns"]         = "http://specs.openid.net/auth/2.0",
        ["openid.mode"]       = "checkid_setup",
        ["openid.claimed_id"] = dd.claimed_identifier or
                                "http://specs.openid.net/auth/2.0/identifier_select",
        ["openid.identity"]   = dd.op_local_identifier or dd.claimed_identifier or
                                "http://specs.openid.net/auth/2.0/identifier_select",
        ["openid.return_to"]  = encode.url{
                                  base   = request.get_absolute_baseurl(),
                                  module = args.return_to_module,
                                  view   = args.return_to_view
                                },
        ["openid.realm"]      = args.realm or request.get_absolute_baseurl()
      }
    }
  )
  cgi.send_data()
  exit()
end
