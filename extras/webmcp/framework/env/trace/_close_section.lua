function trace._close_section()
  local pos = #trace._stack
  local closed_section = trace._stack[pos]
  if not closed_section then
    error("All trace sections have been closed already.")
  end
  --trace.debug("END " .. extos.monotonic_hires_time() .. " / " .. os.clock())
  trace._stack[pos] = nil
  return closed_section
end
