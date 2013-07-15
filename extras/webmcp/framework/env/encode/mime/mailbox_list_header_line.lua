function encode.mime.mailbox_list_header_line(key, mailboxes)
  local mailboxes = mailboxes
  if not mailboxes then
    mailboxes = {}
  elseif
    type(mailboxes) == "string" or
    mailboxes.address or mailboxes.name
  then
    mailboxes = { mailboxes }
  end
  local indentation = ""
  for i = 1, #key + #(": ") do
    indentation = indentation .. " "
  end
  local parts = { key, ": " }
  local first = true
  for idx, mailbox in ipairs(mailboxes) do
    local name, address
    if type(mailbox) == "string" then
      name, address = nil, mailbox
    else
      name, address = mailbox.name, mailbox.address
    end
    if address and not string.find(
      address,
      "^[0-9A-Za-z!#%$%%&'%*%+%-/=%?%^_`{|}~%.]+" ..
      "@[0-9A-Za-z!#%$%%&'%*%+%-/=%?%^_`{|}~%.]+$"
    )
    then
      if name then
        name, address = name .. " <" .. address .. ">", nil
      else
        name, address = address, nil
      end
    end
    if name or address then
      if not first then
        parts[#parts+1] = ",\r\n"
        parts[#parts+1] = indentation
      end
      if name then
        parts[#parts+1] = encode.mime.atom_token(name)
        parts[#parts+1] = " <"
        if address then
          parts[#parts+1] = address
        end
        parts[#parts+1] = ">"
      else
        parts[#parts+1] = address
      end
      first = false
    end
  end
  if first then
    return ""
  end
  parts[#parts+1] = "\r\n"
  return table.concat(parts)
end
