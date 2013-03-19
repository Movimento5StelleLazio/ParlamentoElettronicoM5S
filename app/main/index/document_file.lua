if not config.document_dir then
  error("feature not enabled")
end

local filename = param.get("filename")

local file = assert(io.open(encode.file_path(config.document_dir, filename)), "file not found")

if param.get("inline") then
  print('Content-disposition: inline; filename=' .. filename)
else
  print('Content-disposition: attachment; filename=' .. filename)
end
print('')

io.stdout:write(file:read("*a"))

exit()
