--[[--
text_with_br_tags =                -- text with <br/> tags
encode.html_newlines(
  text_with_lf_control_characters  -- text with LF control characters
)

This function transforms LF control characters (\n) into <br/> tags.

--]]--

function encode.html_newlines(text)
  return (string.gsub(text, '\n', '<br/>'))
end
