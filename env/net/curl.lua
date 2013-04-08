function net.curl(url)
  local stdout, errmsg, status = extos.pfilter(nil, "curl", url)
  if not stdout then
    error("Error while executing curl: " .. errmsg)
  end
  if status ~= 0 then
    return nil
  end
  return stdout
end