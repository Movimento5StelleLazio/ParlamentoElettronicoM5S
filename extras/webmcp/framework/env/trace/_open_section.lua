function trace._open_section(node)
  local node = trace._new_entry(node)
  node.section = true
  table.insert(trace._stack, node)
  --trace.debug("START " .. extos.monotonic_hires_time() .. " / " .. os.clock())
  return node
end
