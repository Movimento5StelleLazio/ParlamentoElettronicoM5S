--[[--
request.set_allowed_json_request_slots(
  slot_idents                            -- list of names of slots which can be requested in JSON format
)

This function enables JSON requests. The given list of names of slots selects, which slots may be requestd in JSON format (without layout).

--]]--

function request.set_allowed_json_request_slots(slot_idents)
  if cgi then  -- do nothing, when being in interactive mode
    local hash = {}
    for idx, slot_ident in ipairs(slot_idents) do
      hash[slot_ident] = true
    end
    if cgi.params["_webmcp_json_slots[]"] then
      for idx, slot_ident in ipairs(cgi.params["_webmcp_json_slots[]"]) do
        if not hash[slot_ident] then
          error('Requesting slot "' .. slot_ident .. '" is forbidden.')
        end
      end
    end
    request._json_requests_allowed = true
  end
end
