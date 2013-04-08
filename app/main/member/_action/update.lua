local fields = {
  "organizational_unit",
  "internal_posts",
  "realname",
  "birthday",
  "address",
  "email",
  "xmpp_address",
  "website",
  "phone",
  "mobile_phone",
  "profession",
  "external_memberships",
  "external_posts"
}

local update_args = { app.session.member }

for i, field in ipairs(fields) do
  if not config.locked_profile_fields[field] then
    param.update(app.session.member, field)
  end
end

if not config.locked_profile_fields.statement then
  local formatting_engine = param.get("formatting_engine")

  local formatting_engine_valid = false
  for fe, dummy in pairs(config.formatting_engine_executeables) do
    if formatting_engine == fe then
      formatting_engine_valid = true
    end
  end
  if not formatting_engine_valid then
    error("invalid formatting engine!")
  end


  local statement = param.get("statement")

  if statement ~= app.session.member.statement or 
     formatting_engine ~= app.session.member.formatting_engine then
    app.session.member.formatting_engine = formatting_engine
    app.session.member.statement = statement
    app.session.member:render_content(true)
  end

end

if not config.locked_profile_fields.birthday then
  if tostring(app.session.member.birthday) == "invalid_date" then
    app.session.member.birthday = nil
    slot.put_into("error", _"Date format is not valid. Please use following format: YYYY-MM-DD")
    return false
  end
end

app.session.member:save()


slot.put_into("notice", _"Your page has been updated")
