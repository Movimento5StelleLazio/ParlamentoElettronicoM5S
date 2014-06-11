--[[--
trace.sql{
  command        = command,        -- executed SQL command as string
  error_position = error_position  -- optional position in bytes where an error occurred
}

This command can be used to log SQL command execution. It is currently not invoked automatically.

--]]--

-- TODO: automatic use of this function?

function trace.sql(args)
  if not trace._disabled then
    local command = args.command
    local error_position = args.error_position
    if type(command) ~= "string" then
      error("No command string passed to trace.sql{...}.")
    end
    if error_position and type(error_position) ~= "number" then
      error("error_position must be a number.")
    end
    trace._new_entry{
      type = "sql",
      command = command,
      error_position = error_position
    }
  end
end
