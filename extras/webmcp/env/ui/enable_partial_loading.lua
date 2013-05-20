--[[--
ui.enable_partial_loading()

This function tells subsequent calls of ui.link{...} and ui.form{...} that
partial loading should be enabled when requested by passing "partial"
arguments to ui.link or ui.form.

NOTE: To use partial loading, the slots being requested need to be
white-listed by calling request.set_allowed_json_request_slots({...})
in the application configuration file. TODO: By now, at least the slot
names "default", "trace" and "system_error" need to be white-listed, as
these slots are currently hardwired in ui._partial_load_js(...).

--]]--

function ui.enable_partial_loading()
  ui._partial_loading_enabled = true
  request.force_absolute_baseurl()
end
