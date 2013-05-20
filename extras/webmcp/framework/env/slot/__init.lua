slot._data_metatable = {}
function slot._data_metatable:__index(key)
  self[key] = { string_fragments = {}, state_table = {} }
  return self[key]
end
slot._active_slot = 'default'
slot._current_layout = 'default'
slot._content_type = nil

slot.reset_all()
