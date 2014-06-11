local un  = encode.mime.unstructured_header_line
local mbl = encode.mime.mailbox_list_header_line

local function encode_container(parts, container)
  if container.multipart then
    local boundary
    boundary = "BOUNDARY--" .. multirand.string(
      24,
      "123456789BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz"
    )
    parts[#parts+1] = "Content-Type: "
    parts[#parts+1] = "multipart/"
    parts[#parts+1] = container.multipart
    parts[#parts+1] = "; boundary="
    parts[#parts+1] = boundary
    parts[#parts+1] = "\r\n\r\nMIME multipart\r\n"  -- last \r\n optional
    for idx, sub_container in ipairs(container) do
      parts[#parts+1] = "\r\n--"
      parts[#parts+1] = boundary
      parts[#parts+1] = "\r\n"
      encode_container(parts, sub_container)
    end
    parts[#parts+1] = "\r\n--"
    parts[#parts+1] = boundary
    parts[#parts+1] = "--\r\n"
  else
    parts[#parts+1] = "Content-Type: "
    parts[#parts+1] = container.content_type or "text/plain"
    parts[#parts+1] = "\r\n"
    if container.content_id then
      parts[#parts+1] = "Content-ID: <"
      parts[#parts+1] = container.content_id
      parts[#parts+1] = ">\r\n"
    end
    if container.attachment_filename then
      parts[#parts+1] = "Content-Disposition: attachment; filename="
      parts[#parts+1] = encode.mime.atom_token(
        container.attachment_filename
      )
      parts[#parts+1] = "\r\n"
    end
    if container.binary then
      parts[#parts+1] = "Content-Transfer-Encoding: base64\r\n\r\n"
      parts[#parts+1] = encode.mime.base64(container.content)
    else
      parts[#parts+1] =
        "Content-Transfer-Encoding: quoted-printable\r\n\r\n"
      parts[#parts+1] =
        encode.mime.quoted_printable_text_content(container.content)
    end
  end
end

function encode.mime.mail(args)
  local parts = {}
  parts[#parts+1] = mbl("From",     args.from)
  parts[#parts+1] = mbl("Sender",   args.sender)
  parts[#parts+1] = mbl("Reply-To", args.reply_to)
  parts[#parts+1] = mbl("To",       args.to)
  parts[#parts+1] = mbl("Cc",       args.cc)
  parts[#parts+1] = mbl("Bcc",      args.bcc)
  parts[#parts+1] = un("Subject", args.subject)
  parts[#parts+1] = "MIME-Version: 1.0\r\n"
  encode_container(parts, args)
  return table.concat(parts)
end
