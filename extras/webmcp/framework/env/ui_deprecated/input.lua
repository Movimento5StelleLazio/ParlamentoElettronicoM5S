--
-- Creates an input field in a form
--
-- label      (string) The label of the input field
-- field      (string) The name of the record field
-- field_type (string) The type of the record field
--
-- Example:
--
--  ui_deprecated.input({
--    label = _'Comment',
--    field = 'comment', 
--    field_type = 'textarea'
--  })
--
local field_type_to_atom_class_map = {
  text       = atom.string,
  textarea   = atom.string,
  number     = atom.number,
  percentage = atom.number,
}

function ui_deprecated.input(args)
  local record = assert(slot.get_state_table(), "ui_deprecated.input was not called within a form.").form_record

  local field_type = args.field_type or "text"

  local field_func = assert(ui_deprecated.input_field[field_type], "no field helper for given type '" .. field_type .. "'")

  local html_name = args.name or args.field
  local field_html

  if args.field then
    local param_type = field_type_to_atom_class_map[field_type] or error('Unkown field type')
    field_html = field_func{
      name  = html_name, 
      value = param.get(html_name, param_type) 
              or record[args.field],
      height = args.height,
    }

  elseif args.value then
    field_html = field_func{
      name  = html_name, 
      value = args.value,
      height = args.height,
    }
  
  else
    field_html = field_func{
      name  = html_name, 
      value = '',
      height = args.height,
    }
    
  end
  
  slot.put('<div class="ui_field ui_input_', field_type, '">\n')
  if args.label then
    slot.put('<div class="label">', encode.html(args.label), '</div>\n')
  end
  slot.put('<div class="value">',
        field_html,
      '</div>\n',
    '</div>\n'
  )
end
