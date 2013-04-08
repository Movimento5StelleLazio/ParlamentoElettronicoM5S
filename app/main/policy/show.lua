local policy = Policy:by_id(param.get_id())

slot.put_into("title", encode.html(_("Policy '#{name}'", { name = policy.name })))

ui.form{
  attr = { class = "vertical" },
  record = policy,
  content = function()
    if policy.polling then
      ui.field.text{ label = _"New" .. ":", value = _"without" }
    else
      ui.field.text{ label = _"New" .. ":", value = "≤ " .. policy.admission_time }
    end
    ui.field.text{ label = _"Discussion" .. ":", value = policy.discussion_time or _"variable" }
    ui.field.text{ label = _"Frozen" .. ":", value = policy.verification_time or _"variable" }
    ui.field.text{ label = _"Voting" .. ":", value = policy.voting_time or _"variable" }
    
    if policy.polling then
      ui.field.text{ label = _"Issue quorum" .. ":", value = _"without" }
    else
      ui.field.text{
        label = _"Issue quorum",
        value = "≥ " .. tostring(policy.issue_quorum_num) .. "/" .. tostring(policy.issue_quorum_den)
      }
    end
    ui.field.text{
      label = _"Initiative quorum",
      value = "≥ " .. tostring(policy.initiative_quorum_num) .. "/" .. tostring(policy.initiative_quorum_den)
    }
    ui.field.text{
      label = _"Direct majority",
      value = 
        (policy.direct_majority_strict and ">" or "≥" ) .. " "
        .. tostring(policy.direct_majority_num) .. "/"
        .. tostring(policy.direct_majority_den) 
        .. (policy.direct_majority_positive > 1 and ", " .. _("at least #{count} approvals", { count = policy.direct_majority_positive }) or "")
        .. (policy.direct_majority_non_negative > 1 and ", " .. _("at least #{count} approvals or abstentions", { count = policy.direct_majority_non_negative }) or "")
    }

    ui.field.text{
      label = _"Indirect majority",
      value = 
        (policy.indirect_majority_strict and ">" or "≥" ) .. " "
        .. tostring(policy.indirect_majority_num) .. "/"
        .. tostring(policy.indirect_majority_den) 
        .. (policy.indirect_majority_positive > 1 and ", " .. _("at least #{count} approvals", { count = policy.indirect_majority_positive }) or "")
        .. (policy.indirect_majority_non_negative > 1 and ", " .. _("at least #{count} approvals or abstentions", { count = policy.indirect_majority_non_negative }) or "")
    }

    local texts = {}
    if policy.no_reverse_beat_path then
      texts[#texts+1] = _"no reverse beat path to status quo (including ties)"
    end
    if policy.no_multistage_majority then
      texts[#texts+1] = _"prohibit potentially instable results caused by multistage majorities"
    end
    ui.field.text{
      label = _"Options",
      value = table.concat(texts, ", ")
    }
    if policy.description and #policy.description > 0 then
      ui.container{
        attr = { class = "suggestion_content wiki" },
        content = function()
          ui.tag{
            tag = "p",
            content = policy.description
          }
        end
      }
    end

  end
}
