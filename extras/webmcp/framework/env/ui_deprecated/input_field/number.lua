function ui_deprecated.input_field.number(args)
	name = args.name or ''
	value = args.value or 0
	return '<input class="ui_input_field_number" type="text" name="' .. name .. '" value="' .. convert.to_human(value, "number") .. '" />'
end