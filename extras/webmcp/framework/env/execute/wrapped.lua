--[[--
execute.wrapped(
  wrapper_func,   -- function with an execute.inner() call inside
  inner_func      -- function which is executed when execute.inner() is called
)

This function takes two functions as argument. The first function is executed, and must contain one call of execute.inner() during its execution. When execute.inner() is called, the second function is executed. After the second function finished, program flow continues in the first function.

--]]--

function execute.wrapped(wrapper_func, inner_func)
  if
    type(wrapper_func) ~= "function" or
    type(inner_func) ~= "function"
  then
    error("Two functions need to be passed to execute.wrapped(...).")
  end
  local stack = execute._wrap_stack
  local pos = #stack + 1
  stack[pos] = inner_func
  wrapper_func()
  -- if stack[pos] then
  --   error("Wrapper function did not call execute.inner().")
  -- end
  stack[pos] = nil
end
