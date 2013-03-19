if config.locked_profile_fields.name then
  error("access denied")
end

local name = param.get("name")

name = util.trim(name)

if #name < 3 then
  slot.put_into("error", _"This name is too short!")
  return false
end

app.session.member.name = name

local db_error = app.session.member:try_save()

if db_error then
  if db_error:is_kind_of("IntegrityConstraintViolation.UniqueViolation") then
    slot.put_into("error", _"This name is already taken, please choose another one!")
  return false
  end
  db_error:escalate()
end

slot.put_into("notice", _"Your name has been changed")
