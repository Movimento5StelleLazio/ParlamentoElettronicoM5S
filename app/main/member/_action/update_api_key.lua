
local api_key

if param.get_id() and param.get("delete", atom.boolean) then

  local member_application = MemberApplication:by_id(param.get_id())
  
  if member_application then
    member_application:destroy()
  end

  slot.put_into("notice", _"API key has been deleted")
else

  local member_application = MemberApplication:new()
  member_application.member_id = app.session.member_id
  member_application.key = multirand.string(
    20,
    '23456789BCDFGHJKLMNPQRSTVWXYZbcdfghjkmnpqrstvwxyz'
  )
  member_application.name = 'member'
  member_application.comment = ''
  member_application.access_level = 'member'

  member_application:save()
  slot.put_into("notice", _"API key has been created")
end
