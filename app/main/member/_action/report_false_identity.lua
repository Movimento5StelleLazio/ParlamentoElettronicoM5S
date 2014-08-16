local member = Member:by_id(param.get("member_id", atom.integer))
local auditor = Member:by_id(member.creator_id)

subject = config.mail_subject_prefix .. _ " - False Identity Report"
content = slot.use_temporary(function()
    slot.put(_("The user #{sender_realname}(id: #{sender_id}) is reporting a false identity for the user #{member_realname}(id: #{member_id}).\n" ..
            "#{member_realname} has been certified by the auditor #{auditor_realname}(id: #{auditor_id}).\n\n" ..
            "Please check that all the identities are correct and corrisponds to the truth.", { sender_realname = (app.session.member.realname and app.session.member.realname or app.session.member.login), sender_id = app.session.member.id, member_realname = (member.realname and member.realname or member.login), member_id = member.id, auditor_realname = (auditor.realname and auditor.realname or auditor.login), auditor_id = auditor.id }))
end)

trace.debug("subject: " .. subject)
trace.debug("message: " .. content)

local units = app.session.member:get_reference_selector("units"):add_where("unit.active = TRUE"):exec()
local admins = units:get_reference_selector("members"):reset_fields():add_field("member.id"):add_field("member.notify_email"):add_where("member.admin = TRUE"):add_group_by("member.id"):exec()

local to = ""
for i, k in ipairs(admins) do
    to = to .. k.notify_email
    if i < #admins then
        to = to .. ", "
    end
    local success = net.send_mail {
        envelope_from = config.mail_envelope_from,
        from = config.mail_from,
        reply_to = config.mail_reply_to,
        to = k.notify_email,
        subject = subject,
        content_type = "text/plain; charset=UTF-8",
        content = content
    }
    if not success then
        slot.put_into("error", "Error reporting the false identity. Please retry.")
        return false
    end
end

trace.debug("admins for this user: " .. to)

slot.put_into("notice", "False identity reported to admins.")
return true
