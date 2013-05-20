--[[--
execute.multi_wrapped(
  wrapper_funcs,   -- multiple wrapper functions (i.e. filters)
  inner_func       -- inner function (i.e. an action or view)
)

This function does the same as execute.wrapped(...), but with multiple wrapper functions, instead of just one wrapper function. It is used by execute.filtered_view{...} and execute.filtered_action{...} to wrap multiple filters around the view or action.

--]]--

function execute.multi_wrapped(wrapper_funcs, inner_func)
  local function wrapped_execution(pos)
    local wrapper_func = wrapper_funcs[pos]
    if wrapper_func then
      return execute.wrapped(
        wrapper_func,
        function()
          wrapped_execution(pos+1)
        end
      )
    else
      return inner_func()
    end
  end
  return wrapped_execution(1)
end
