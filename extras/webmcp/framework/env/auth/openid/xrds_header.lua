--[[--
auth.openid.xrds_header{
  ...                     -- arguments as used for encode.url{...}, pointing to an XRDS document as explained below
}

According to the OpenID specification, providers should verify, that
return_to URLs are an OpenID relying party endpoint. To use OpenID
providers following this recommendation, the relying parties can send a
X-XRDS-Location header by calling this function. Its arguments must refer
to an URL returning a document as follows:

<?xml version="1.0" encoding="UTF-8"?>
<xrds:XRDS xmlns:xrds="xri://$xrds" xmlns="xri://$xrd*($v*2.0)">
  <XRD>                                                         
    <Service>                                                   
      <Type>http://specs.openid.net/auth/2.0/return_to</Type>   
      <URI>RETURN_TO_URL</URI>                                  
    </Service>                                                  
  </XRD>                                                        
</xrds:XRDS>

The placeholder RETURN_TO_URL has to be replaced by the absolute URL of the
given return_to_module and return_to_view.


Example application-wide filter, assuming the document above is saved in
"static/openid.xrds":

auth.openid.xrds_header{ static = "openid.xrds" }
execute.inner()


Example applications-wide filter, assuming
- the return_to_module is "openid"
- the return_to_view is "return"
- the module for returning the xrds document is "openid"
- the view for returning the xrds document is "xrds"

auth.openid.xrds_header{ module = "openid", view = "xrds" }
execute.inner()


In the last example the "xrds" view in module "openid" has to make the
following call:

auth.openid.xrds_document{
  return_to_module = "openid",
  return_to_view   = "return"
}

--]]--
function auth.openid.xrds_header(args)
  cgi.add_header("X-XRDS-Location: " .. encode.url(args))
end
