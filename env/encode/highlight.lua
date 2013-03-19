function encode.highlight(text)
  local text = encode.html(text)
  text = text:gsub("\027", "")
  text = text:gsub("\\\\", "\027b")
  text = text:gsub("\\%*", "\027a")
  text = text:gsub("%*([^%*]*)%*", '<span class="highlighted">%1</span>')
  text = text:gsub("\027a", "*")
  text = text:gsub("\027b", "\\")
  return text
end