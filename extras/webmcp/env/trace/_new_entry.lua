function trace._new_entry(node)
  local node = node or {}
  table.insert(trace._stack[#trace._stack], node)
  return node
end
