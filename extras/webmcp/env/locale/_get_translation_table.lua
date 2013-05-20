function locale._get_translation_table()
  local language_code = locale.get("lang")
  if language_code then
    if type(language_code) ~= "string" then
      error('locale.get("lang") does not return a string.')
    end
    local translation_table = locale._translation_tables[language_code]
    if translation_table then 
      return translation_table
    end
    local filename = encode.file_path(request.get_app_basepath(), "locale", "translations." .. language_code .. ".lua")
    local func
    if _ENV then
      func = assert(loadfile(filename), nil, {})
    else
      func = assert(loadfile(filename))
      setfenv(func, {})
    end
    translation_table = func()
    if type(translation_table) ~= "table" then
      error("Translation file did not return a table.")
    end
    locale._translation_tables[language_code] = translation_table
    return translation_table
  else
    return locale._empty_translation_table
  end
end
