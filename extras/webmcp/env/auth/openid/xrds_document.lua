--[[--
auth.openid.xrds_document{
  return_to_module = return_to_module,
  return_to_view   = return_to_view
}

This function returns an XRDS document with Content-Type
application/xrds+xml. For more information see documentation on
auth.openid.xrds_document{...}.

--]]--

function auth.openid.xrds_document(args)
  slot.set_layout(nil, "application/xrds+xml")
  slot.put_into("data",
    '<?xml version="1.0" encoding="UTF-8"?>\n',
    '<xrds:XRDS xmlns:xrds="xri://$xrds" xmlns="xri://$xrd*($v*2.0)">\n',
    '  <XRD>\n',
    '    <Service>\n',                                                   
    '      <Type>http://specs.openid.net/auth/2.0/return_to</Type>\n',
    '      <URI>',
    encode.url{
      base   = request.get_absolute_baseurl(),
      module = args.return_to_module,
      view   = args.return_to_view
    },
    '</URI>\n',
    '    </Service>\n',
    '  </XRD>\n',
    '</xrds:XRDS>\n'
  )
end
