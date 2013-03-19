function ui.field.image(args)
  ui.form_element(args, {}, function(args)
    local value_string = atom.dump(args.value)
    local attr = table.new(args.attr)
    attr.name  = args.field_name
    attr.type  = "file"
    attr.value = value_string
    ui.tag{ tag  = "input", attr = attr }
    local attr = table.new(args.attr)
    attr.name  = args.field_name .. '_' .. 'delete'
    attr.type  = "checkbox"
    attr.value = '1'
    ui.tag{ tag  = "input", attr = attr }
    slot.put(_'delete<br /><br />')
  end)
end
