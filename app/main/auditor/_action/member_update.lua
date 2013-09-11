local id = param.get_id()

local member = Member:by_id(id)
if not member then
  member = Member:new()
  member.creator_id = app.session.member_id
end
local member_data = MemberData:by_id(id) 
if not member_data then
  member_data = MemberData:new()
  member.certifier_id = app.session.member_id
  member.certified = atom.timestamp:get_current()
end


local locked = param.get("locked", atom.boolean)
if locked ~= nil then
  member.locked = locked
end
local deactivate = param.get("deactivate", atom.boolean)
if deactivate then
  member.active = false
end
local firstname = param.get("firstname")
if firstname then
  if #firstname >=2 then
    member.firstname = firstname
  else
    slot.put_into("error", _"Firstname is too short!")
    return false
  end
end
local lastname = param.get("lastname")
if lastname then
  member.lastname = lastname
end
if firstname and lastname then
  member.realname = firstname.." "..lastname
  member.name = firstname
end

local nin = param.get("nin")
if nin then
  if #nin  ~= 16 then
    slot.put_into("error", _"This National Insurance Number is invalid!")
    return false
  end
  member.nin = string.upper(nin)
end

local municipality_id = atom.integer:load(param.get("municipality_id"))
if municipality_id then
  member.municipality_id = municipality_id
end

local merr = member:try_save()

if merr then
  slot.put_into("error", (_("Error while updating member, database reported:<br /><br /> (#{errormessage})"):gsub("#{errormessage}", tostring(merr.message))))
  return false
end

--[[
  Sensitive data 
--]]

member_data.id = member.id
local token_serial = param.get("token_serial")
if token_serial then
  member_data.token_serial = token_serial
end

local birthplace = param.get("birthplace")
if birthplace then
  member_data.birthplace = birthplace
end

local birthdate = atom.date:new{year=param.get("birthyear",atom.integer), month=param.get("birthmonth",atom.integer), day=param.get("birthday",atom.integer)}
if birthdate then
  member_data.birthdate = birthdate
end

local idcard = param.get("idcard")
if idcard then
  member_data.idcard = idcard
end

local email = param.get("email")
if email then
  member_data.email = email
end

local residence_address = param.get("residence_address")
if residence_address then
  member_data.residence_address = residence_address
end
local residence_city = param.get("residence_city")
if residence_city then
  member_data.residence_city = residence_city
end
local residence_province = param.get("residence_province")
if residence_province then
  member_data.residence_province = residence_province
end
local residence_postcode = param.get("residence_postcode")
if residence_postcode then
  member_data.residence_postcode = residence_postcode
end

local domicile_address = param.get("domicile_address")
if domicile_address then
  member_data.domicile_address = domicile_address
end
local domicile_city = param.get("domicile_city")
if domicile_city then
  member_data.domicile_city = domicile_city
end
local domicile_province = param.get("domicile_province")
if domicile_province then
  member_data.domicile_province = domicile_province
end
local domicile_postcode = param.get("domicile_postcode")
if domicile_postcode then
  member_data.domicile_postcode = domicile_postcode
end

local mderr = member_data:try_save()
if mderr then
  slot.put_into("error", (_("Error while updating member sensitive data, database reported:<br /><br /> (#{errormessage})"):gsub("#{errormessage}", tostring(mderr.message))))
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
