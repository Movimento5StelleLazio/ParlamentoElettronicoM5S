function ui_deprecated.multiselect(args)
  local record = assert(slot.get_state_table(), "ui_deprecated.multiselect was not called within a form.").form_record
  local name = args.name
  local relationship = args.relationship

  local foreign_records = relationship.foreign_records
	
  local selector = relationship.connected_by_model:new_selector()
  selector:add_where{ relationship.connected_by_my_id .. ' = ?', record[relationship.my_id] }
  local connected_by_records = selector:exec()
	
  local connections = {}
  for i, connected_by_record in ipairs(connected_by_records) do
    connections[connected_by_record[relationship.connected_by_foreign_id]] = connected_by_record
  end

  local html = {}

  if args.type == "checkboxes" then
    for i, foreign_record in ipairs(foreign_records) do
      local selected = ''
      if connections[foreign_record[relationship.foreign_id]] then
        selected = ' checked="1"'
      end
      html[#html + 1] = '<input type="checkbox" name="' .. name .. '" value="' .. foreign_record[relationship.foreign_id] .. '"' .. selected .. '>&nbsp;' .. convert.to_human(foreign_record[relationship.foreign_name], "string") .. '<br />\n'
    end
 
  else
    html[#html + 1] = '<select name="' .. name .. '" multiple="1">'
    for i, foreign_record in ipairs(foreign_records) do
      local selected = ''
      if connections[foreign_record[relationship.foreign_id]] then
        selected = ' selected="1"'
      end
      html[#html + 1] = '<option value="' .. foreign_record[relationship.foreign_id] .. '"' .. selected .. '>' .. convert.to_human(foreign_record[relationship.foreign_name], "string") .. '</option>\n'
    end
    html[#html + 1] = '</select>'

  end
  	
  slot.put('<div class="ui_field ui_multiselect">\n')
  if args.label then
    slot.put('<div class="label">', encode.html(args.label), '</div>\n')
  end
  slot.put('<div class="value">',
        table.concat(html),
      '</div>\n',
    '</div>\n'
  )
end