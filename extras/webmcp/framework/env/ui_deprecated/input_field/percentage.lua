function ui_deprecated.input_field.percentage(args)
	name = args.name or ''
	value = args.value or 0
	return '<input class="ui_input_field_percentage" type="text" name="' .. name .. '" value="' .. convert.to_human(value, "number") .. '" /> %'
end