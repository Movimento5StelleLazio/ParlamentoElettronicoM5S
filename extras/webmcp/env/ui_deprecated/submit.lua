--
-- Creates a submit buttom for a form
--
-- label      (string) The label of the box
--
-- Example:
--
--	ui_deprecated.submit({
--		label = 'Save'
--	})
--

function ui_deprecated.submit(args)
  local args = args or {}
  args.label = args.label or 'Submit'
  slot.put(
    '<div class="ui_field ui_submit">',
      '<div class="label">&nbsp;</div>',
      '<div class="value">',
        '<input type="submit" value="', encode.html(args.label), '" />',
      '</div>',
    '</div>'
  )
end
