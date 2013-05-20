--[[--
execute.inner()

It is MANDATORY to call this function once in each filter of a WebMCP application. Calling execute.inner() calls the next filter in the filter chain, or the view or action, if there are no more filters following. Code executed BEFORE calling this function is executed BEFORE the view or action, while code executed AFTER calling this function is executed AFTER the view of action.

--]]--

function execute.inner()
  local stack = execute._wrap_stack
  local pos = #stack
  if pos == 0 then
    error("Unexpected call of execute.inner().")
  end
  local inner_func = stack[pos]
  if not inner_func then
    error("Repeated call of execute.inner().")
  end
  stack[pos] = false
  inner_func()
end
