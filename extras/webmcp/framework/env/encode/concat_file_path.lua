--[[--
path =                    -- string containing a (file) path
encode.concat_file_path(
  element1,               -- first part of the path
  element2,               -- second part of the path
  ...                     -- more parts of the path
)

This function takes a variable amount of strings as arguments and returns a concatenation with slashes as seperators. Multiple slashes following each other directly are transformed into a single slash.

--]]--

function encode.concat_file_path(...)
  return (
    string.gsub(
      table.concat({...}, "/"), "/+", "/"
    )
  )
end
