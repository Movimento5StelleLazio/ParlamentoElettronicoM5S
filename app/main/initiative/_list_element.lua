local initiative = param.get("initiative", "table")
local selected = param.get("selected", atom.boolean)
local for_member = param.get("for_member", "table") or app.session.member

local class = "initiative"

if selected then
  class = class .. " selected"
end

if initiative.polling then
  class = class .. " polling"
end

ui.container{ attr = { class = class }, content = function()

  ui.container{ attr = { class = "rank" }, content = function()
    if initiative.issue.fully_frozen and initiative.issue.closed
      or initiative.admitted == false
    then 
      ui.field.rank{ attr = { class = "rank" }, value = initiative.rank, eligible = initiative.eligible }
    elseif not initiative.issue.closed then
      ui.image{ static = "icons/16/script.png" }
    else
      ui.image{ static = "icons/16/cross.png" }
    end
  end }

  ui.container{ attr = { class = "bar" }, content = function()
    if initiative.issue.fully_frozen and initiative.issue.closed then
      if initiative.negative_votes and initiative.positive_votes then
        local max_value = initiative.issue.voter_count
        ui.bargraph{
          max_value = max_value,
          width = 100,
          bars = {
            { color = "#0a5", value = initiative.positive_votes },
            { color = "#aaa", value = max_value - initiative.negative_votes - initiative.positive_votes },
            { color = "#a00", value = initiative.negative_votes },
          }
        }
      else
         slot.put("&nbsp;")
      end
    else
      local max_value = initiative.issue.population or 0
      local quorum
      if initiative.issue.accepted then
        quorum = initiative.issue.policy.initiative_quorum_num / initiative.issue.policy.initiative_quorum_den
      else
        quorum = initiative.issue.policy.issue_quorum_num / initiative.issue.policy.issue_quorum_den
      end
      ui.bargraph{
        max_value = max_value,
        width = 100,
        quorum = max_value * quorum,
        quorum_color = "#00F",
        bars = {
          { color = "#0a5", value = (initiative.satisfied_supporter_count or 0) },
          { color = "#aaa", value = (initiative.supporter_count or 0) - (initiative.satisfied_supporter_count or 0) },
          { color = "#fff", value = max_value - (initiative.supporter_count or 0) },
        }
      }
    end
  end }

  if app.session.member_id then
    ui.container{ attr = { class = "interest" }, content = function()
      if initiative.member_info.initiated then
        local label 
        if for_member and for_member.id ~= app.session.member_id then
          label = _"This member is initiator of this initiative"
        else
          label = _"You are initiator of this initiative"
        end
        ui.image{
          attr = { alt = label, title = label },
          static = "icons/16/user_edit.png"
        }
      elseif initiative.member_info.directly_supported then
        if initiative.member_info.satisfied then
          if for_member and for_member.id ~= app.session.member_id then
            label = _"This member is supporter of this initiative"
          else
            local label = _"You are supporter of this initiative"
          end
          ui.image{
            attr = { alt = label, title = label },
            static = "icons/16/thumb_up_green.png"
          }
        else
          if for_member and for_member.id ~= app.session.member_id then
            label = _"This member is potential supporter of this initiative"
          else
            local label = _"You are potential supporter of this initiative"
          end
          ui.image{
            attr = { alt = label, title = label },
            static = "icons/16/thumb_up.png"
          }
        end
      elseif initiative.member_info.supported then
        if initiative.member_info.satisfied then
          if for_member and for_member.id ~= app.session.member_id then
            label = _"This member is supporter of this initiative via delegation"
          else
            local label = _"You are supporter of this initiative via delegation"
          end
          ui.image{
            attr = { alt = label, title = label },
            static = "icons/16/thumb_up_green_arrow.png"
          }
        else
          if for_member and for_member.id ~= app.session.member_id then
            label = _"This member is potential supporter of this initiative via delegation"
          else
            local label = _"You are potential supporter of this initiative via delegation"
          end
          ui.image{
            attr = { alt = label, title = label },
            static = "icons/16/thumb_up_arrow.png"
          }
        end
      end
    end }
  end
    
  ui.container{ attr = { class = "name" }, content = function()
    local link_class = "initiative_link"
    if initiative.revoked then
      link_class = "revoked"
    end
    ui.link{
      attr = { class = link_class },
      content = function()
        local name
        if initiative.name_highlighted then
          name = encode.highlight(initiative.name_highlighted)
        else
          name = encode.html(initiative.shortened_name)
        end
        ui.tag{ content = "i" .. initiative.id .. ": " }
        slot.put(name)
      end,
      module  = "initiative",
      view    = "show",
      id      = initiative.id
    }
        
  end }

end }
