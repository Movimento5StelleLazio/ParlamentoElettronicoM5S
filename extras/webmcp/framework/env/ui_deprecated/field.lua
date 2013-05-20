--
-- Creates an output field
--
-- label      (string) The label of the field
-- value      (atom)   The value to put out
-- field_type (string) The type of the field (default: 'string')
--
-- Example:
--
--  ui_deprecated.field({
--    label = _'Id',
--    value = myobject.id, 
--    field_type = 'integer'
--  })
--

function ui_deprecated.field(args)
  local value_type = args.value_type or atom.string
  slot.put(
    '<div class="ui_field ui_field_', value_type.name, '">',
      '<div class="label">',
        encode.html(args.label or ''), 
      '</div>',
      '<div class="value">')
  if args.value then
    slot.put(encode.html(convert.to_human(args.value, value_type)))
  elseif args.link then
    ui_deprecated.link(args.link)
  end
  slot.put(
      '</div>',
    '</div>\n'
  )
end
