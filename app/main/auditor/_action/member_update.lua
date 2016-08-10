local id = param.get_id()
local member = Member:by_id(id)
local res1, res2

if not member then
    member = Member:new()
    member.creator_id = app.session.member_id
    res1 = db:query("SELECT COUNT(*) from member WHERE nin = '" .. string.upper(param.get("nin")) .. "'")[1][1]
elseif member.certifier_id ~= app.session.member_id then
    slot.put_into("error", _ "You cannot modify an user not created by you!")
    return false
else
    res1 = db:query("SELECT COUNT(*) from member WHERE nin = '" .. string.upper(param.get("nin")) .. "' AND id !=" .. member.id)[1][1]
end

local member_data = MemberData:by_id(id)
if not member_data then
    member_data = MemberData:new()
    member.certifier_id = app.session.member_id
    member.certified = atom.timestamp:get_current()
    res2 = secure_db:query("SELECT COUNT(*) from member_data WHERE idcard = '" .. param.get("idcard") .. "'")[1][1]
    res3 = secure_db:query("SELECT COUNT(*) from member_data WHERE token_serial ='" .. param.get("token_serial") .. "'")[1][1]
else
    res2 = secure_db:query("SELECT COUNT(*) from member_data WHERE idcard = '" .. param.get("idcard") .. "' AND id !=" .. member_data.id)[1][1]
    res3 = secure_db:query("SELECT COUNT(*) from member_data WHERE token_serial ='" .. param.get("token_serial") .. "' AND id !=" .. member_data.id)[1][1]
end

if res1 > 0 then
    slot.put_into("error", _ "Duplicate NIN value found in the database. User already registered.")
    return false
end

if res2 > 0 then
    slot.put_into("error", _ "Duplicate Id Card Number value found in the database. User already registered.")
    return false
end

if res3 > 0 then
    slot.put_into("error", _ "Duplicate Token Serial value found in the database. User already registered.")
    return false
end

local locked = param.get("locked", atom.boolean)
if locked ~= nil then
    member.locked = locked
end
local deactivate = param.get("deactivate", atom.boolean)
if deactivate then
    member.active = false
end

-- Check user first name
local firstname = param.get("firstname")
if firstname then
    if #firstname >= 2 then
        member.firstname = firstname
    else
        slot.put_into("error", _ "User first name is too short!")
        return false
    end
else
    if not member.firstname then
        slot.put_into("error", _ "User first name cannot be empty!")
        return false
    end
end

-- Check user first name
local lastname = param.get("lastname")
if lastname then
    if #lastname >= 2 then
        member.lastname = lastname
    else
        slot.put_into("error", _ "User last name is too short!")
        return false
    end
else
    if not member.lastname then
        slot.put_into("error", _ "User last name cannot be empty!")
        return false
    end
end

-- Building name and realname field
if firstname and lastname then
    member.realname = firstname .. " " .. lastname
    member.name = firstname
end

-- Check user nin
local nin = param.get("nin")
if nin then
    if #nin ~= 16 then
        slot.put_into("error", _ "This National Insurance Number is invalid!")
        return false
    end
    member.nin = string.upper(nin)
else
    if not member.nin then
        slot.put_into("error", _ "User NIN cannot be empty!")
        return false
    end
end

-- Check user unit_group_id
local unit_group_id = param.get("unit_group_id", atom.integer)
if unit_group_id then
    member.unit_group_id = unit_group_id
else
    if not member.unit_group_id then
        slot.put_into("error", _ "User unit cannot be empty!")
        return false
    end
end

--[[
  Sensitive data 
--]]

-- Check user token serial number
local token_serial = param.get("token_serial")
if token_serial then
    if #token_serial >= 8 then
        member_data.token_serial = token_serial
    else
        slot.put_into("error", _ "User token serial number is too short!")
        return false
    end
else
    if not member_data.token_serial then
        slot.put_into("error", _ "User token serial number cannot be empty!")
        return false
    end
end

-- Check user birthplace
local birthplace = param.get("birthplace")
if birthplace then
    if #birthplace >= 2 then
        member_data.birthplace = birthplace
    else
        slot.put_into("error", _ "User birthplace is too short!")
        return false
    end
else
    if not member_data.birthplace then
        slot.put_into("error", _ "User birthplace cannot be empty!")
        return false
    end
end

local birthdate = atom.date:new { year = param.get("birthyear", atom.integer), month = param.get("birthmonth", atom.integer), day = param.get("birthday", atom.integer) }
if birthdate then
    member_data.birthdate = birthdate
end

-- Check user id card number
local idcard = param.get("idcard")
if idcard then
    if #idcard >= 4 then
        member_data.idcard = idcard
    else
        slot.put_into("error", _ "User id card number is too short!")
        return false
    end
else
    if not member_data.idcard then
        slot.put_into("error", _ "User id card number cannot be empty!")
        return false
    end
end

-- Check user e-mail address
local email = param.get("email")
if email then
    if #email >= 6 then
        member_data.email = email
    else
        slot.put_into("error", _ "User e-mail address is too short!")
        return false
    end
else
    if not member_data.email then
        slot.put_into("error", _ "User e-mail address cannot be empty!")
        return false
    end
end

-- Check user residence data
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

if #residence_address < 6 or #residence_city < 2 or #residence_province == 0 or #residence_postcode < 4 then
    slot.put_into("error", _ "User residence data missing or incomplete!")
    return false
end

-- Check user domicile data
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

if #domicile_address < 6 or #domicile_city < 2 or #domicile_province == 0 or #domicile_postcode < 4 then
    slot.put_into("error", _ "User domicile data missing or incomplete!")
    return false
end

-- Saving

local merr = member:try_save()
if merr then
    slot.put_into("error", (_("Error while updating member, database reported:<br /><br /> (#{errormessage})"):gsub("#{errormessage}", tostring(merr.message))))
    return false
end

member_data.id = member.id

local mderr = member_data:try_save()
if mderr then
    slot.put_into("error", (_("Error while updating member sensitive data, database reported:<br /><br /> (#{errormessage})"):gsub("#{errormessage}", tostring(mderr.message))))
    return false
end


if not member.activated and param.get("invite_member", atom.boolean) then
    member:send_invitation()
end

if id then
    slot.put_into("notice", _ "Member successfully updated")
else
    slot.put_into("notice", _ "Member successfully registered")
end
