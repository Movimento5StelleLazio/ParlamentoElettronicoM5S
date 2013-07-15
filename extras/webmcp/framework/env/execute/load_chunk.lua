--[[--
return_value =            -- return value of executed chunk
execute.load_chunk{
  file_path = file_path,  -- path to a lua source or byte-code file
  app       = app,        -- app name to use or the current will be used
  module    = module,     -- module where chunk is located
  chunk     = chunk       -- filename of lua file to load (including filename extension)
  id        = id,         -- id to be returned by param.get_id(...) during execution
  params    = params      -- parameters to be returned by param.get(...) during execution
}

NOTE: execute.load_chunk{...} is DEPRECATED and replaced by execute.chunk{...}. Both functions differ in interpretation of argument "chunk" regarding the filename extenstion '.lua'.
  
This function loads and executes a lua file specified by a given path or constructs 
a path to load from the module and chunk name.

--]]--

function execute.load_chunk(args)
  local chunk_name
  if args.chunk then
    chunk_name = string.match(args.chunk, "^(.*)%.lua$")
    if not chunk_name then
      error('"chunk_name" does not end with \'.lua\'')
    end
  end
  return execute.chunk{
    file_path = args.file_path,
    app       = args.app,
    module    = args.module,
    chunk     = chunk_name,
    id        = args.id,
    params    = args.params
  }
end
