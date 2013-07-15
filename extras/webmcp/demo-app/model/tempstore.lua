Tempstore = mondelefant.new_class()
Tempstore.table = 'tempstore'

function Tempstore:by_key(key)
  local selector = self:new_selector()
  selector:add_where{ 'key = ?', key }
  selector:optional_object_mode()
  return selector:exec()
end

function Tempstore:data_by_key(key)
  local tempstore = Tempstore:by_key(key)
  if tempstore then
    tempstore:destroy()
    return tempstore.data
  end
end

function Tempstore:create(data)
  tempstore = Tempstore:new()
  tempstore.key = multirand.string(22, '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')
  tempstore.data = data
  tempstore:save()
  return tempstore.key
end
