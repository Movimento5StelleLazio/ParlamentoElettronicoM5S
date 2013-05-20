#!/usr/bin/env lua

local func, errmsg = loadfile('webmcp.lua')

if func then
  local result
  result, errmsg = pcall(func)
  if result then
    errmsg = nil
  end
end

if errmsg and not (cgi and cgi.data_sent) then
  print('Status: 500 Internal Server Error')
  print('Content-type: text/plain')
  print()
  print('500 Internal Server Error')
  print()
  print(errmsg)
  print()
  print('(caught by webmcp-wrapper.lua)')
  os.exit(1)
end
