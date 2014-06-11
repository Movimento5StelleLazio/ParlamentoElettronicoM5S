--[[--
path =                    -- string containing a path to an action
encode.action_file_path{
  module = module,        -- module name
  action = action         -- action name
}

This function returns the file path of an action with a given module name and action name. Both module name and action name are mandatory arguments.

--]]--

function encode.action_file_path(args)
  return (encode.file_path(
    request.get_app_basepath(),
    'app',
    request.get_app_name(),
    args.module,
    '_action',
    args.action .. '.lua'
  ))
end
