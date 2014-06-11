--[[--
return_value =            -- return value of executed chunk
execute.chunk{
  file_path = file_path,  -- path to a lua source or byte-code file
  app       = app,        -- app name to use or the current will be used
  module    = module,     -- module where chunk is located
  chunk     = chunk       -- name of chunk (filename without .lua extension)
  id        = id,         -- id to be returned by param.get_id(...) during execution
  params    = params      -- parameters to be returned by param.get(...) during execution
}

This function loads and executes a lua file specified by a given path or constructs 
a path to load from the module and chunk name. A chunk name should always begin with an underscore. All return values of the loaded and executed chunk are returned by this function as well.

--]]--

function execute.chunk(args)
  local file_path = args.file_path
  local app       = args.app
  local module    = args.module
  local chunk     = args.chunk
  local id        = args.id
  local params    = args.params

  app = app or request.get_app_name()

  file_path = file_path or encode.file_path(
    request.get_app_basepath(),
    'app', app, module, chunk .. '.lua'
  )

  local func, load_errmsg = loadfile(file_path)
  if not func then
    error('Could not load file "' .. file_path .. '": ' .. load_errmsg)
  end

  if id or params then
    param.exchange(id, params)
  end

  local result = {func()}

  if id or params then
    param.restore()
  end

  return table.unpack(result)
end
