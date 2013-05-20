function ui_deprecated.label(value)
  slot.put '<div class="ui_label">' 
  ui_deprecated.text( value )
  slot.put '</div>\n'
end