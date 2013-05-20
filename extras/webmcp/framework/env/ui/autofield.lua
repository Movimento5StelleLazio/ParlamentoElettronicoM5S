--[[--
ui.autofield{
  name           = name,               -- field name (also used by default as HTML name)
  html_name      = html_name,          -- explicit HTML name to be used instead of 'name'
  value          = nihil.lift(value),  -- initial value, nil causes automatic lookup of value, use nihil.lift(nil) for nil
  container_attr = container_attr,     -- extra HTML attributes for the container (div) enclosing field and label
  attr           = attr,               -- extra HTML attributes for the field
  label          = label,              -- text to be used as label for the input field
  label_attr     = label_attr,         -- extra HTML attributes for the label
  readonly       = readonly_flag       -- set to true, to force read-only mode
  record         = record,             -- record to be used, defaults to record given to ui.form{...}
  ...                                  -- extra arguments for applicable ui.field.* helpers
}

This function automatically selects a ui.field.* helper to be used for a field of a record.

--]]--

function ui.autofield(args)
  local args = table.new(args)
  assert(args.name, "ui.autofield{...} needs a field 'name'.")
  if not args.record then
    local slot_state = slot.get_state_table()
    if not slot_state then
      error("ui.autofield{...} was called without an explicit record to be used, and is also not called inside a form.")
    elseif not slot_state.form_record then
      error("ui.autofield{...} was called without an explicit record to be used, and the form does not have a record assigned either.")
    else
      args.record = slot_state.form_record
    end
  end
  local class = args.record._class
  assert(class, "Used ui.autofield{...} on a record with no class information stored in the '_class' attribute.")
  local fields, field_info, ui_field_type, ui_field_options
  fields = class.fields
  if fields then
    field_info = fields[args.name]
  end
  if field_info then
    ui_field_type    = field_info.ui_field_type
    ui_field_options = table.new(field_info.ui_field_options)
  end
  if not ui_field_type then
    ui_field_type = "text"
  end
  if not ui_field_options then
    ui_field_options = {}
  end
  local ui_field_func = ui.field[ui_field_type]
  if not ui_field_func then
    error(string.format("Did not find ui.field helper of type %q.", ui_field_type))
  end
  for key, value in pairs(ui_field_options) do
    if args[key] == nil then
      args[key] = value
    end
  end
  return ui_field_func(args)
end
