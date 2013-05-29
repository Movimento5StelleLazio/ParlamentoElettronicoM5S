function _(text, replacements)
  local text = locale._get_translation_table()[text] or text
  if replacements then
    return (
      string.gsub(
        text,
        "#{(.-)}",
        function (placeholder)
          return replacements[placeholder]
        end
      )
    )
  else
    return text
  end
end
