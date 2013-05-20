function auth.openid._curl(url, curl_options)
  -- NOTE: Don't accept URLs starting with file:// or other nasty protocols
  if not string.find(url, "^[Hh][Tt][Tt][Pp][Ss]?://") then
    return nil
  end
  local options = table.new(curl_options)
  options[#options+1] = "-i"
  options[#options+1] = url
  local stdout, errmsg, status = extos.pfilter(nil, "curl", table.unpack(options))
  if not stdout then
    error("Error while executing curl: " .. errmsg)
  end
  if status ~= 0 then
    return nil
  end
  local status  = tonumber(string.match(stdout, "^[^ ]+ *([0-9]*)"))
  local headers = string.match(stdout, "(\r?\n.-\r?\n)\r?\n")
  local body    = string.match(stdout, "\r?\n\r?\n(.*)")
  return status, headers, body
end
