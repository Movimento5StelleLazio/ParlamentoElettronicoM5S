Policy = mondelefant.new_class()
Policy.table = 'policy'

Policy:add_reference{
  mode          = '1m',
  to            = "Issue",
  this_key      = 'id',
  that_key      = 'policy_id',
  ref           = 'issues',
  back_ref      = 'policy'
}

local new_selector = Policy.new_selector

function Policy:new_selector()
  local selector = new_selector(self)
  selector:add_field("justify_interval(admission_time)::text", "admission_time_text")
  selector:add_field("justify_interval(discussion_time)::text", "discussion_time_text")
  selector:add_field("justify_interval(verification_time)::text", "verification_time_text")
  selector:add_field("justify_interval(voting_time)::text", "voting_time_text")
  return selector
end


function Policy:build_selector(args)
  local selector = self:new_selector()
  if args.active ~= nil then
    selector:add_where{ "active = ?", args.active }
  end
  selector:add_order_by("index")
  return selector
end

function Policy.object_get:free_timeable()
  if self.discussion_time == nil and self.verification_time == nil and self.voting_time == nil then
    return true
  end
  return false
end