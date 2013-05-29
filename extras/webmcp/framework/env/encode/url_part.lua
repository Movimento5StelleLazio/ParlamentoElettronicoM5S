--[[--
url_encoded_string =  -- URL-encoded string
encode.url_part(
  obj                 -- any native datatype or atom
)

This function encodes any native datatype or atom in a way that it can be placed inside an URL. It is first dumped with atom.dump(...) and then url-encoded.

--]]--

function encode.url_part(obj)
  return (
    string.gsub(
      atom.dump(obj),
      "[^0-9A-Za-z_%.~-]",
      function (char)
        return string.format("%%%02x", string.byte(char))
      end
    )
  )
end
