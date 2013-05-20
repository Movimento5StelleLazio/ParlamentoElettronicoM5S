function ui_deprecated.input_field.textarea(args)
	local value = args.value or ''
	local name = assert(args.name, 'No field name given')
	local style = ''
	if args.height then
	  style = 'style="height:' .. args.height .. '"'
	end
	return '<textarea name="' .. name .. '" ' .. style .. '>' .. encode.html(convert.to_human(value, "string")) .. '</textarea>'
end
