--[[--
param.update(
  record,               -- database record to be updated
  key_and_field_name1,  -- name of CGI parameter and record field
  key_and_field_name2,  -- another name of a CGI parameter and record field
  {
    key3,               -- name of CGI parameter
    field_name3         -- name of record field
  }
)

This function can update several fields of a database record using GET/POST request parameters (or internal/exchanged parameters). The type of each parameter is automatically determined by the class of the record (_class:get_colums()[field].type).
--]]--

function param.update(record, mapping_info, ...)
  if not mapping_info then
    return
  end
  assert(record, "No record given for param.update(...).")
  assert(record._class, "Record passed to param.update(...) has no _class attribute.")
  local key, field_name
  if type(mapping_info) == "string" then
    key        = mapping_info
    field_name = mapping_info
  else
    key        = mapping_info[1]
    field_name = mapping_info[2]
  end
  assert(key, "No key given in parameter of param.update(...).")
  assert(field_name, "No field name given in parameter of param.update(...).")
  local column_info = record._class:get_columns()[field_name]
  if not column_info then
    error('Type of column "' .. field_name .. '" is unknown.')
  end
  local new_value = param.get(key, column_info.type)
  if new_value ~= record[field_name] then
    record[field_name] = new_value
  end
  return param.update(record, ...)  -- recursivly process following arguments
end
