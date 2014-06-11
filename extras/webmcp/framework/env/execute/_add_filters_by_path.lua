function execute._add_filters_by_path(filter_list, ...)
  local full_path     = encode.file_path(request.get_app_basepath(), "app", ...)
  local relative_path = encode.file_path("", ...)
  local filter_names = extos.listdir(full_path)
  if filter_names then
    table.sort(filter_names)  -- not really neccessary, due to sorting afterwards
    for i, filter_name in ipairs(filter_names) do
      if string.find(filter_name, "%.lua$") then
        if filter_list[filter_name] then
          error('More than one filter is named "' .. filter_name .. '".')
        end
        table.insert(filter_list, filter_name)
        filter_list[filter_name] = function()
          trace.enter_filter{
            path = encode.file_path(relative_path, filter_name)
          }
          execute.file_path{
            file_path = encode.file_path(full_path, filter_name)
          }
          trace.execution_return()
        end
      end
    end
  end
end
