local policy = Policy:by_id(param.get_id()) or Policy:new()

ui.title(_"Create / edit policy")

ui.form{
  attr = { class = "vertical" },
  record = policy,
  module = "admin",
  action = "policy_update",
  routing = {
    default = {
      mode = "redirect",
      module = "admin",
      view = "policy_list"
    }
  },
  id = policy.id,
  content = function()

    ui.field.text{ label = _"Index",        name = "index" }

    ui.field.text{ label = _"Name",        name = "name" }
    ui.field.text{ label = _"Description", name = "description", multiline = true }
    ui.field.text{ label = _"Hint",        readonly = true, 
                    value = _"Interval format:" .. " 3 mons 2 weeks 1 day 10:30:15" }

    ui.field.text{ label = _"Admission time",     name = "admission_time" }
    ui.field.text{ label = _"Discussion time",    name = "discussion_time" }
    ui.field.text{ label = _"Verification time",  name = "verification_time" }
    ui.field.text{ label = _"Voting time",        name = "voting_time" }

    ui.field.text{ label = _"Issue quorum numerator",   name = "issue_quorum_num" }
    ui.field.text{ label = _"Issue quorum denumerator", name = "issue_quorum_den" }

    ui.field.text{ label = _"Initiative quorum numerator",   name = "initiative_quorum_num" }
    ui.field.text{ label = _"Initiative quorum denumerator", name = "initiative_quorum_den" }

    ui.field.text{ label = _"Direct majority numerator",   name = "direct_majority_num" }
    ui.field.text{ label = _"Direct majority denumerator", name = "direct_majority_den" }
    ui.field.boolean{ label = _"Strict direct majority", name = "direct_majority_strict" }
    ui.field.text{ label = _"Direct majority positive",   name = "direct_majority_positive" }
    ui.field.text{ label = _"Direct majority non negative", name = "direct_majority_non_negative" }

    ui.field.text{ label = _"Indirect majority numerator",   name = "indirect_majority_num" }
    ui.field.text{ label = _"Indirect majority denumerator", name = "indirect_majority_den" }
    ui.field.boolean{ label = _"Strict indirect majority", name = "indirect_majority_strict" }
    ui.field.text{ label = _"Indirect majority positive",   name = "indirect_majority_positive" }
    ui.field.text{ label = _"Indirect majority non negative", name = "indirect_majority_non_negative" }

    ui.field.boolean{ label = _"No reverse beat path", name = "no_reverse_beat_path" }
    ui.field.boolean{ label = _"No multistage majority", name = "no_multistage_majority" }
    ui.field.boolean{ label = _"Polling mode", name = "polling" }


    ui.field.boolean{ label = _"Active?", name = "active" }

    ui.submit{ text = _"Save" }
  end
}
