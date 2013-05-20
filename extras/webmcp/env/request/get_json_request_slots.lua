--[[--
slot_idents =                    -- list of names of slots to be returned as JSON data
request.get_json_request_slots()

If the current request is no JSON request, this function returns nil, otherwise a list of names of all slots to be returned in JSON format. This function also throws an error, if JSON data was requested, but request.set_allowed_json_request_slots(...) has not been called.

--]]--

function request.get_json_request_slots(slot_idents)
  if not cgi then return end
  local slot_idents = cgi.params["_webmcp_json_slots[]"]
  if slot_idents and not request._json_requests_allowed then
    error("JSON requests have not been allowed using request.set_allowed_json_request_slots(...).")
  end
  return slot_idents
end
