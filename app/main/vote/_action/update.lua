local cancel = param.get("cancel") and true or false
if cancel then return end

local issue = Issue:new_selector():add_where{ "id = ?", param.get("issue_id", atom.integer) }:for_share():single_object_mode():exec()

local preview = param.get("preview") and true or false

if not app.session.member:has_voting_right_for_unit_id(issue.area.unit_id) then
  error("access denied")
end

local update_comment = param.get("update_comment") == "1" and true or false

if issue.state ~= "voting" and not issue.closed then
  slot.put_into("error", _"Voting has not started yet.")
  return false
end

if issue.phase_finished or issue.closed and not update_comment then
  slot.put_into("error", _"This issue is already closed.")
  return false
end

local direct_voter = DirectVoter:by_pk(issue.id, app.session.member_id)

if param.get("discard", atom.boolean) then
  if direct_voter then
    direct_voter:destroy()
  end
  slot.put_into("notice", _"Your vote has been discarded. Delegation rules apply if set.")
  return
end

local move_up 
local move_down

local tempvoting_string = param.get("scoring")

local tempvotings = {}
if not update_comment then
  for match in tempvoting_string:gmatch("([^;]+)") do
    for initiative_id, grade in match:gmatch("([^:;]+):([^:;]+)") do
      tempvotings[tonumber(initiative_id)] = tonumber(grade)
      if param.get("move_up_" .. initiative_id .. ".x", atom.integer) then
        move_up = tonumber(initiative_id)
      elseif param.get("move_down_" .. initiative_id .. ".x", atom.integer) then
        move_down = tonumber(initiative_id)
      end
    end
  end
end

if not move_down and not move_up then
  if not preview then
    if not direct_voter then
      if issue.closed then
        slot.put_into("error", _"This issue is already closed.")
        return false
      else 
        direct_voter = DirectVoter:new()
        direct_voter.issue_id = issue.id
        direct_voter.member_id = app.session.member_id
        direct_voter:save()

        direct_voter = DirectVoter:by_pk(issue.id, app.session.member_id)
      end
    end
    
    local formatting_engine = param.get("formatting_engine")
    local comment = param.get("comment")

    if comment ~= direct_voter.comment then
      if #comment > 0 then
        direct_voter.formatting_engine = formatting_engine
        direct_voter.comment = comment
        if issue.closed then
          direct_voter.comment_changed = 'now'
        end
        direct_voter:render_content(true)
      else
        direct_voter.formatting_engine = null
        direct_voter.comment = null
        if issue.closed then
          direct_voter.comment_changed = 'now'
        end
      end
    end
    direct_voter:save()
    
  end

  if not update_comment then
    local scoring = param.get("scoring")

    for initiative_id, grade in scoring:gmatch("([^:;]+):([^:;]+)") do
      local initiative_id = tonumber(initiative_id)
      local grade = tonumber(grade)
      local initiative = Initiative:by_id(initiative_id)
      if initiative.issue.id ~= issue.id then
        error("initiative from wrong issue")
      end
      if not preview and not issue.closed then
        local vote = Vote:by_pk(initiative_id, app.session.member.id)
        if not vote then
          vote = Vote:new()
          vote.issue_id = issue.id
          vote.initiative_id = initiative.id
          vote.member_id = app.session.member.id
        end
        vote.grade = grade
        vote:save()
      end
    end
  end

  if not preview and not cancel then
    request.redirect{
      module = "issue",
      view = "show",
      id = issue.id
    }
  end

else

  local current_initiative_id = move_up or move_down

  local current_grade = tempvotings[current_initiative_id] or 0
  local is_alone = true
  if current_grade == 0 then
    is_alone = false
  else
    for initiative_id, grade in pairs(tempvotings) do
      if current_initiative_id ~= initiative_id and grade == current_grade then
        is_alone = false
        break
      end
    end
  end

  if     move_up   and current_grade >= 0 and     is_alone then
    for initiative_id, grade in pairs(tempvotings) do
      if grade > current_grade then
        tempvotings[initiative_id] = grade - 1
      end
    end

  elseif move_up   and current_grade >= 0 and not is_alone then
    for initiative_id, grade in pairs(tempvotings) do
      if grade > current_grade then
        tempvotings[initiative_id] = grade + 1
      end
    end
    tempvotings[current_initiative_id] = current_grade + 1

  elseif move_up   and current_grade  < 0 and     is_alone then
    tempvotings[current_initiative_id] = current_grade + 1
    for initiative_id, grade in pairs(tempvotings) do
      if grade < current_grade then
        tempvotings[initiative_id] = grade + 1
      end
    end

  elseif move_up   and current_grade  < 0 and not is_alone then
    for initiative_id, grade in pairs(tempvotings) do
      if grade <= current_grade then
        tempvotings[initiative_id] = grade - 1
      end
    end
    tempvotings[current_initiative_id] = current_grade

  elseif move_down and current_grade <= 0 and     is_alone then
    for initiative_id, grade in pairs(tempvotings) do
      if grade < current_grade then
        tempvotings[initiative_id] = grade + 1
      end
    end

  elseif move_down and current_grade <= 0 and not is_alone then
    for initiative_id, grade in pairs(tempvotings) do
      if grade < current_grade then
        tempvotings[initiative_id] = grade - 1
      end
    end
    tempvotings[current_initiative_id] = current_grade - 1

  elseif move_down and current_grade  > 0 and     is_alone then
    tempvotings[current_initiative_id] = current_grade - 1
    for initiative_id, grade in pairs(tempvotings) do
      if grade > current_grade then
        tempvotings[initiative_id] = grade - 1
      end
    end

  elseif move_down and current_grade  > 0 and not is_alone then
    for initiative_id, grade in pairs(tempvotings) do
      if grade >= current_grade then
        tempvotings[initiative_id] = grade + 1
      end
    end
    tempvotings[current_initiative_id] = current_grade

  end

  local tempvotings_list = {}
  for key, val in pairs(tempvotings) do
    tempvotings_list[#tempvotings_list+1] = tostring(key) .. ":" .. tostring(val)
  end

  tempvoting_string = table.concat(tempvotings_list, ";")

  request.redirect{
    module = "vote",
    view = "list",
    params = {
      issue_id = issue.id,
      scoring = tempvoting_string
    }
  }

end
