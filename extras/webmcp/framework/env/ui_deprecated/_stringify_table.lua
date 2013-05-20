function ui_deprecated._stringify_table(table)
  if not table then
    return ''
  end
  local string = ''
  for key, value in pairs(table) do
    string = string .. ' ' .. key .. '="' .. value ..'"'
  end
  return string
end

