--[[--
status_code =             -- status code returned by the executed lua file (a string)
execute.file_path{
  file_path = file_path,  -- path to a lua source or byte-code file
  id        = id,         -- id to be returned by param.get_id(...) during execution
  params    = params      -- parameters to be returned by param.get(...) during execution
}

This function loads and executes a lua file specified by a given path. If an "id" or "params" are provided, the param.get_id(...) and/or param.get(...) functions will return the provided values during execution. The lua routine must return true, false, nil or a string. In case of true or nil, this function returns the string "ok", in case of false, this function returns "error", otherwise the string returned by the lua routine will be returned by this function as well.

--]]--

function execute.file_path(args)
  local file_path = args.file_path
  local id        = args.id
  local params    = args.params
  local func, load_errmsg = loadfile(file_path)
  if not func then
    error('Could not load file "' .. file_path .. '": ' .. load_errmsg)
  end
  if id or params then
    param.exchange(id, params)
  end
  local result = func()
  if result == nil or result == true then
    result = 'ok'
  elseif result == false then
    result = 'error'
  elseif type(result) ~= "string" then
    error("Unexpected type of result: " .. type(result))
  end
  if id or params then
    param.restore()
  end
  return result
end
