event_names = {
  issue_created                 = _"New issue",
  issue_canceled                = _"Issue canceled",
  issue_accepted                = _"Issue accepted",
  issue_half_frozen             = _"Issue frozen",
  issue_finished_without_voting = _"Issue finished without voting",
  issue_voting_started          = _"Voting started",
  issue_finished_after_voting   = _"Issue finished",
  initiative_created            = _"New initiative",
  initiative_revoked            = _"Initiative revoked",
  draft_created                 = _"New draft",
  suggestion_created            = _"New suggestion"
}

filter_names = {
  contact = _"Saved as contact",
  interested = _"Interested",
  supporter = _"Supported",
  potential_supporter = _"Potential supported",
  initiator = _"Initiated",
  membership = _"Member of area"
}

option_names = {}
for key, val in pairs(event_names) do
  option_names[key] = val
end
for key, val in pairs(filter_names) do
  option_names[key] = val
end

