--[[--
charset.set(
  charset_ident  -- identifier of a charset, i.e. "UTF-8"
)

Changes the currently used charset. Only "UTF-8" is supported, which is already set as a default, so calling this function is not really useful yet.

--]]--

function charset.set(charset_ident)
  charset._current = charset_ident
end
