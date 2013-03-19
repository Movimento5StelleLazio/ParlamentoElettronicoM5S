function util.put_highlighted_string(string)
  local highlight_string = param.get("highlight_string")
  if highlight_string then
    local highlighted_string = slot.use_temporary(function()
      ui.tag{
        tag = "span",
        attr = { class = "highlighted" },
        content = highlight_string
      }
    end)
    string = string:gsub(highlight_string, highlighted_string)
  end
  slot.put(string)
end