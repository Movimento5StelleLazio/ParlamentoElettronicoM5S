local id = param.get_id()

local member = Member:by_id(id) or Member:new()

param.update(member, "notify_email")

local locked = param.get("locked", atom.boolean)
if locked ~= nil then
  member.locked = locked
end
local deactivate = param.get("deactivate", atom.boolean)
if deactivate then
  member.active = false
end
local name = param.get("name")
if name then
  member.name = name
end
local surname = param.get("surname")
if surname then
  member.surname = surname
end
local nin = param.get("nin")
if nin then
  if #nin  ~= 16 then
    slot.put_into("error", _"This National Insurance Number is invalid!")
     request.redirect{
      mode   = "redirect",
      module = "auditor",
      view   = "member_edit",
      id = member.id
     }
    return false
  end
  member.nin = string.upper(nin)
end

local err = member:try_save()

if err then
  slot.put_into("error", (_("Error while updating member, database reported:<br /><br /> (#{errormessage})"):gsub("#{errormessage}", tostring(err.message))))
  return false
end

if not member.activated and param.get("invite_member", atom.boolean) then
  member:send_invitation()
end

if id then
  slot.put_into("notice", _"Member successfully updated")
else
  slot.put_into("notice", _"Member successfully registered")
end
