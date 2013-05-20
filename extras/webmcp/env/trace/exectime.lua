--[[--
trace.exectime{
  real = real,   -- physical time in seconds
  cpu  = cpu     -- CPU time in seconds
}

This function is called automatically to log the execution time of the handling of a request.

--]]--

function trace.exectime(args)
  if not trace._disabled then
    local real = args.real
    local cpu  = args.cpu
    if type(real) ~= "number" then
      error("Called trace.exectime{...} without numeric 'real' argument.")
    end
    if type(cpu) ~= "number" then
      error("Called trace.exectime{...} without numeric 'cpu' argument.")
    end
    trace._new_entry{ type = "exectime", real = args.real, cpu = args.cpu }
  end
end
