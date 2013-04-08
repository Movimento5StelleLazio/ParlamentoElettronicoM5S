Event = mondelefant.new_class()
Event.table = 'event'

Event:add_reference{
  mode          = 'm1',
  to            = "Issue",
  this_key      = 'issue_id',
  that_key      = 'id',
  ref           = 'issue',
}

Event:add_reference{
  mode          = 'm1',
  to            = "Initiative",
  this_key      = 'initiative_id',
  that_key      = 'id',
  ref           = 'initiative',
}

Event:add_reference{
  mode          = 'm1',
  to            = "Suggestion",
  this_key      = 'suggestion_id',
  that_key      = 'id',
  ref           = 'suggestion',
}

Event:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

function Event.object_get:event_name()
  return ({
    issue_state_changed = _"Issue reached next phase",
    initiative_created_in_new_issue = _"New issue",
    initiative_created_in_existing_issue = _"New initiative",
    initiative_revoked = _"Initiative revoked",
    new_draft_created = _"New initiative draft",
    suggestion_created = _"New suggestion"
  })[self.event]
end
  
function Event.object_get:state_name()
  return Issue:get_state_name_for_state(self.state)
end
  
function Event.object:send_notification()
  
  local members_to_notify = Member:new_selector()
    :join("event_seen_by_member", nil, { "event_seen_by_member.seen_by_member_id = member.id AND event_seen_by_member.notify_level <= member.notify_level AND event_seen_by_member.id = ?", self.id } )
    :add_where("member.activated NOTNULL AND member.notify_email NOTNULL")
    -- SAFETY FIRST, NEVER send notifications for events more then 3 days in past or future
    :add_where("now() - event_seen_by_member.occurrence BETWEEN '-3 days'::interval AND '3 days'::interval")
    -- do not notify a member about the events caused by the member
    :add_where("event_seen_by_member.member_id ISNULL OR event_seen_by_member.member_id != member.id")
    :exec()
    
  print (_("Event #{id} -> #{num} members", { id = self.id, num = #members_to_notify }))


  local url

  for i, member in ipairs(members_to_notify) do
    local subject
    local body = ""
    
    locale.do_with(
      { lang = member.lang or config.default_lang or 'en' },
      function()
        subject = config.mail_subject_prefix .. " " .. self.event_name
        body = body .. _("[event mail]      Unit: #{name}", { name = self.issue.area.unit.name }) .. "\n"
        body = body .. _("[event mail]      Area: #{name}", { name = self.issue.area.name }) .. "\n"
        body = body .. _("[event mail]     Issue: ##{id}", { id = self.issue_id }) .. "\n\n"
        body = body .. _("[event mail]    Policy: #{policy}", { policy = self.issue.policy.name }) .. "\n\n"
        body = body .. _("[event mail]     Event: #{event}", { event = self.event_name }) .. "\n\n"
        body = body .. _("[event mail]     Phase: #{phase}", { phase = self.state_name }) .. "\n\n"

        if self.initiative_id then
          url = request.get_absolute_baseurl() .. "initiative/show/" .. self.initiative_id .. ".html"
        elseif self.suggestion_id then
          url = request.get_absolute_baseurl() .. "suggestion/show/" .. self.suggestion_id .. ".html"
        else
          url = request.get_absolute_baseurl() .. "issue/show/" .. self.issue_id .. ".html"
        end
        
        body = body .. _("[event mail]       URL: #{url}", { url = url }) .. "\n\n"
        
        if self.initiative_id then
          local initiative = Initiative:by_id(self.initiative_id)
          body = body .. _("i#{id}: #{name}", { id = initiative.id, name = initiative.name }) .. "\n\n"
        else
          local initiative_count = Initiative:new_selector()
            :add_where{ "initiative.issue_id = ?", self.issue_id }
            :count()
          local initiatives = Initiative:new_selector()
            :add_where{ "initiative.issue_id = ?", self.issue_id }
            :add_order_by("initiative.supporter_count DESC")
            :limit(3)
            :exec()
          for i, initiative in ipairs(initiatives) do
            body = body .. _("i#{id}: #{name}", { id = initiative.id, name = initiative.name }) .. "\n"
          end
          if initiative_count - 3 > 0 then
            body = body .. _("and #{count} more initiatives", { count = initiative_count - 3 }) .. "\n"
          end
          body = body .. "\n"
        end
        
        if self.suggestion_id then
          local suggestion = Suggestion:by_id(self.suggestion_id)
          body = body .. _("#{name}\n\n", { name = suggestion.name })
        end
  
        local success = net.send_mail{
          envelope_from = config.mail_envelope_from,
          from          = config.mail_from,
          reply_to      = config.mail_reply_to,
          to            = member.notify_email,
          subject       = subject,
          content_type  = "text/plain; charset=UTF-8",
          content       = body
        }
    
      end
    )
  end
  
end

function Event:send_next_notification()
  
  local notification_sent = NotificationSent:new_selector()
    :optional_object_mode()
    :for_update()
    :exec()
    
  local last_event_id = 0
  if notification_sent then
    last_event_id = notification_sent.event_id
  end
  
  local event = Event:new_selector()
    :add_where{ "event.id > ?", last_event_id }
    :add_order_by("event.id")
    :limit(1)
    :optional_object_mode()
    :exec()

  if event then
    if last_event_id == 0 then
      db:query{ "INSERT INTO notification_sent (event_id) VALUES (?)", event.id }
    else
      db:query{ "UPDATE notification_sent SET event_id = ?", event.id }
    end
    
    event:send_notification()
    
    return true

  end

end

function Event:send_notifications_loop()

  while true do
    local did_work = Event:send_next_notification()
    if not did_work then
      print "Sleeping 1 second"
      os.execute("sleep 1")
    end
  end
  
end