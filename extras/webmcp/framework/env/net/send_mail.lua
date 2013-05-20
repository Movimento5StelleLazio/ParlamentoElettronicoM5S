--[[--
success =                          -- true, if mail has been sent successfully, otherwise false
net.send_mail{
  envelope_from = envelope_from,   -- envelope from address, not part of mail headers
  from          = from,            -- From     header address or table with 'name' and 'address' fields
  sender        = sender,          -- Sender   header address or table with 'name' and 'address' fields
  reply_to      = reply_to,        -- Reply-To header address or table with 'name' and 'address' fields
  to            = to,              -- To       header address or table with 'name' and 'address' fields
  cc            = cc,              -- Cc       header address or table with 'name' and 'address' fields
  bcc           = bcc,             -- Bcc      header address or table with 'name' and 'address' fields
  subject       = subject,         -- subject of e-mail
  multipart     = multipart_type,  -- "alternative", "mixed", "related", or nil
  content_type  = content_type,    -- only for multipart == nil, defaults to "text/plain"
  binary        = binary,          -- allow full 8-bit content
  content       = content or {     -- content as lua-string, or table in case of multipart
    {
      multipart = multipart_type,
      ...,
      content   = content or {
        {...}, ...
      }
    }, {
      ...
    },
    ...
  }
}

This function sends a mail using the /usr/sbin/sendmail command. It returns true on success, otherwise false.

--]]--

function net.send_mail(args)
  local mail
  if type(args) == "string" then
    mail = args
  else
    mail = encode.mime.mail(args)
  end
  local envelope_from = args.envelope_from
  local command = {"/usr/sbin/sendmail", "-t", "-i"}
  if
    envelope_from and
    string.find(envelope_from, "^[0-9A-Za-z%.-_@0-9A-Za-z%.-_]+$")
  then
    command[#command+1] = "-f"
    command[#command+1] = envelope_from
  end
  local stdout, errmsg, status = extos.pfilter(mail, table.unpack(command))
  if not status then
    error("Error while calling sendmail: " .. errmsg)
  end
  if status == 0 then
    return true
  else
    return false
  end
end
