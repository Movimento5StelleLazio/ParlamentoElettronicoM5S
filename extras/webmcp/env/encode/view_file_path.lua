--[[--
path =                  -- string containing a path to a view
encode.view_file_path{
  module = module,      -- module name
  view   = view         -- view name
}

This function returns the file path of a view with a given module name and view name. Both module name and view name are mandatory arguments.

--]]--

function encode.view_file_path(args)
  return (encode.file_path(
    request.get_app_basepath(),
    'app', request.get_app_name(), args.module, args.view .. '.lua'
  ))
end
