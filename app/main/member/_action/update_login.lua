if config.locked_profile_fields.login then
  error("access denied")
end

local login = param.get("login")

login = util.trim(login)

if #login < 3 then 
  slot.put_into(_error, _"This login is too short!")
end

app.session.member.login = login

local db_error = app.session.member:try_save()

if db_error then
  if db_error:is_kind_of("IntegrityConstraintViolation.UniqueViolation") then
    slot.put_into("error", _"This login is already taken, please choose another one!")
  return false
  end
  db_error:escalate()
end

slot.put_into("notice", _("Your login has been changed to '#{login}'", { login = login }))
