--[[--
ui.add_partial_param_names(
  name_list
)

This function adds names of GET/POST parameters to the list of parameters
which are to be copied when calling ui._partial_load_js{...} or
ui.link{..., partial = {...}} or ui.form{..., partial = {...}}.

--]]--

function ui.add_partial_param_names(name_list)
  if ui._partial_state then
    for idx, param_name in ipairs(name_list) do
      ui._partial_state.param_name_hash[param_name] = true
    end
  end
end
