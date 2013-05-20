--[[--
encoded_path_element =     -- string which can't contain evil stuff like "/"
encode.file_path_element(
  path_element             -- string to be encoded
)

This function is encoding a string in a way that it can be used as a file or directory name, without security risks. See the source for details.

--]]--

function encode.file_path_element(path_element)
  return (
    string.gsub(
      string.gsub(
        path_element, "[^0-9A-Za-z_%.-]",
        function(char)
          return string.format("%%%02x", string.byte(char))
        end
      ), "^%.", string.format("%%%%%02x", string.byte("."))
    )
  )
end
