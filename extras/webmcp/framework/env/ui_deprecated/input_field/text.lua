function ui_deprecated.input_field.text(args)
	name = args.name or ''
	value = args.value or ''
	return '<input type="text" name="' .. name .. '" value="' .. convert.to_human(value, "string") .. '" />'
end