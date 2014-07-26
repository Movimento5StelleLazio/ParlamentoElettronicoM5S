function ui.field.parelon_group_radio(args)
	ui.container {
		content=function()							
			-- Loading of all checkboxes for all allowed policies
			for i, value in ipairs(args.elements) do
				if value.id == args.selected then
					--create a new checkbox with one pre-selected
					ui.field.parelon_radio {
						name = "parelon_radio"..args.id,
						id = value.id,
						label = tostring(value.name),
						label_attr={args.label_attr},
						container_attr=container_attr,
						value = true,
						attr = { onClick = "getElementById(\""..args.out_id.."\").label = "..tostring(value.id) }
					}
				else
					--create a new checkbox
					ui.field.parelon_radio {
						name = "parelon_radio"..args.id,
						id = value.id,
						label = tostring(value.name),
						label_attr={args.label_attr},
						container_attr=container_attr,
						attr = { onClick = "getElementById(\""..args.out_id.."\").value = "..tostring(value.id) }
					}
				end
			end
	end }
end
