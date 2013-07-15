--[[--
path =                    -- string containing a (file) path
encode.encode_file_path(
  base_path,
  element1,               -- next part of the path
  element2,               -- next part of the path
  ...
)

This function does the same as encode.concat_file_path, except that all arguments but the first are encoded using the encode.file_path_element function.

--]]--

function encode.file_path(base, ...)  -- base argument is not encoded
  local raw_elements = {...}
  local encoded_elements = {}
  for i = 1, #raw_elements do
    encoded_elements[i] = encode.file_path_element(raw_elements[i])
  end
  return encode.concat_file_path(base, table.unpack(encoded_elements))
end
