local issue = param.get("issue", "table")

local policy = issue.policy
ui.form{
  record = issue,
  readonly = true,
  attr = { class = "vertical" },
  content = function()
    ui.field.text{       label = _"Population",            name = "population" }
    ui.field.timestamp{  label = _"Created at",            name = "created" }
    if policy.polling then
      ui.field.text{       label = _"Admission time",        value = _"Implicitly admitted" }
    else
      ui.field.text{       label = _"Admission time",        value = format.interval_text(issue.admission_time_text) }
      ui.field.text{
        label = _"Issue quorum",
        value = format.percentage(policy.issue_quorum_num / policy.issue_quorum_den)
      }
      if issue.population then
        ui.field.text{
          label = _"Currently required",
          value = math.ceil(issue.population * policy.issue_quorum_num / policy.issue_quorum_den)
        }
      end
    end
    if issue.accepted then
      ui.field.timestamp{  label = _"Accepted at",           name = "accepted" }
    end
    ui.field.text{       label = _"Discussion time",       value = format.interval_text(issue.discussion_time_text) }
    if issue.half_frozen then
      ui.field.timestamp{  label = _"Half frozen at",        name = "half_frozen" }
    end
    ui.field.text{       label = _"Verification time",     value = format.interval_text(issue.verification_time_text) }
    ui.field.text{
      label   = _"Initiative quorum",
      value = format.percentage(policy.initiative_quorum_num / policy.initiative_quorum_den)
    }
    if issue.population then
      ui.field.text{
        label   = _"Currently required",
        value = math.ceil(issue.population * (issue.policy.initiative_quorum_num / issue.policy.initiative_quorum_den)),
      }
    end
    if issue.fully_frozen then
      ui.field.timestamp{  label = _"Fully frozen at",       name = "fully_frozen" }
    end
    ui.field.text{       label = _"Voting time",           value = format.interval_text(issue.voting_time_text) }
    if issue.closed then
      ui.field.timestamp{  label = _"Closed",                name = "closed" }
    end
  end
}
ui.form{
  record = issue.policy,
  readonly = true,
  content = function()
  end
}
