--[[--
claimed_identifier,                        -- identifier owned by the user
errmsg,                                    -- error message in case of failure
errcode =                                  -- error code in case of failure (TODO: not implemented yet)
auth.openid.verify(
  force_https              = force_https,  -- only allow https
  curl_options             = curl_options  -- options passed to "curl" binary, when performing discovery
)

--]]--

function auth.openid.verify(args)
  local args = args or {}
  if cgi.params["openid.ns"] ~= "http://specs.openid.net/auth/2.0" then
    return nil, "No indirect OpenID 2.0 message received."
  end
  local mode = cgi.params["openid.mode"]
  if mode == "id_res" then
    local return_to_url = cgi.params["openid.return_to"]
    if not return_to_url then
      return nil, "No return_to URL received in answer."
    end
    if return_to_url ~= encode.url{
      base   = request.get_absolute_baseurl(),
      module = request.get_module(),
      view   = request.get_view()
    } then
      return nil, "return_to URL not matching."
    end
    local discovery_args = table.new(args)
    local claimed_identifier = cgi.params["openid.claimed_id"]
    if not claimed_identifier then
      return nil, "No claimed identifier received."
    end
    local cropped_identifier = string.match(claimed_identifier, "[^#]*")
    local normalized_identifier = auth.openid._normalize_url(
      cropped_identifier
    )
    if not normalized_identifier then
      return nil, "Claimed identifier could not be normalized."
    end
    if normalized_identifier ~= cropped_identifier then
      return nil, "Claimed identifier was not normalized."
    end
    discovery_args.user_supplied_identifier = cropped_identifier
    local dd, errmsg, errcode = auth.openid.discover(discovery_args)
    if not dd then
      return nil, errmsg, errcode
    end
    if not dd.claimed_identifier then
      return nil, "Identifier is an OpenID Provider."
    end
    if dd.claimed_identifier ~= cropped_identifier then
      return nil, "Claimed identifier does not match."
    end
    local nonce = cgi.params["openid.response_nonce"]
    if not nonce then
      return nil, "Did not receive a response nonce."
    end 
    local year, month, day, hour, minute, second = string.match(
      nonce,
      "^([0-9][0-9][0-9][0-9])%-([0-9][0-9])%-([0-9][0-9])T([0-9][0-9]):([0-9][0-9]):([0-9][0-9])Z"
    )
    if not year then
      return nil, "Response nonce did not contain a parsable date/time."
    end
    local ts = atom.timestamp{
      year   = tonumber(year),
      month  = tonumber(month),
      day    = tonumber(day),
      hour   = tonumber(hour),
      minute = tonumber(minute),
      second = tonumber(second)
    }
    -- NOTE: 50 hours margin allows us to ignore time zone issues here:
    if math.abs(ts - atom.timestamp:get_current()) > 3600 * 50 then
      return nil, "Response nonce contains wrong time or local time is wrong."
    end
    local params = {}
    for key, value in pairs(cgi.params) do
      local trimmed_key = string.match(key, "^openid%.(.+)")
      if trimmed_key then
        params[key] = value
      end
    end
    params["openid.mode"] = "check_authentication"
    local options = table.new(args.curl_options)
    for key, value in pairs(params) do
      options[#options+1] = "--data-urlencode"
      options[#options+1] = key .. "=" .. value
    end
    local status, headers, body = auth.openid._curl(dd.op_endpoint, options)
    if status ~= 200 then
      return nil, "Authorization could not be verified."
    end
    local result = {}
    for key, value in string.gmatch(body, "([^\n:]+):([^\n]*)") do
      result[key] = value
    end
    if result.ns ~= "http://specs.openid.net/auth/2.0" then
      return nil, "No OpenID 2.0 message replied."
    end
    if result.is_valid == "true" then
      return claimed_identifier
    else
      return nil, "Signature invalid."
    end
  elseif mode == "cancel" then
    return nil, "Authorization failed according to OpenID provider."
  else
    return nil, "Unexpected OpenID mode."
  end
end
