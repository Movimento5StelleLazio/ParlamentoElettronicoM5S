local initiative = param.get("initiative", "table")
local selected = param.get("selected", atom.boolean)
local for_member = param.get("for_member", "table") or app.session.member

ui.container{ attr = { class = "row-fluid" }, content = function()
  ui.container{ attr = { class = "span12 initiative_list_box" }, content = function()
    ui.container{ attr = { class = "row-fluid" }, content = function()
      ui.container{ attr = { class = "span1" }, content = function()
        if initiative.issue.fully_frozen and initiative.issue.closed or initiative.admitted == false then 
          ui.field.rank{ attr = { class = "rank" }, value = initiative.rank, eligible = initiative.eligible }
        elseif not initiative.issue.closed then
          ui.image{ static = "icons/16/script.png" }
        else
          ui.image{ static = "icons/16/cross.png" }
        end
      end }
      ui.container{ attr = { class = "span11" }, content = function()
        if initiative.issue.fully_frozen and initiative.issue.closed then
          if initiative.negative_votes and initiative.positive_votes then
            local max_value = initiative.issue.voter_count
    
            local a=initiative.positive_votes
            local b=max_value - initiative.negative_votes - initiative.positive_votes
            local c=initiative.negative_votes
            ui.container{ attr = { class = "progress progress-striped active" }, content=function()
              ui.container{ attr = {class = "bar bar-success", style = "width:"..a.."%"}, content=''}
              ui.container{ attr = {class = "bar bar-warning", style = "width:"..b.."%"}, content=''}
              ui.container{ attr = {class = "bar bar-important", style = "width:"..c.."%"}, content=''}
            end }
            --[[
            ui.bargraph{
              max_value = max_value,
              width = 100,
              bars = {
                { color = "#0a5", value = initiative.positive_votes },
                { color = "#aaa", value = max_value - initiative.negative_votes - initiative.positive_votes },
                { color = "#a00", value = initiative.negative_votes },
              }
            }
            --]]
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
          local a=(initiative.satisfied_supporter_count or 0)
          local b=(initiative.supporter_count or 0) - (initiative.satisfied_supporter_count or 0)
          ui.container{ attr = { class = "progress progress-striped active" }, content=function()
            ui.container{ attr = {class = "bar bar-success", style = "width:"..a.."%"}, content=''}
            ui.container{ attr = {class = "bar bar-warning", style = "width:"..b.."%"}, content=''}
          end }

          --[[
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
          --]]
        end
      end }
    end }
    ui.container{ attr = { class = "row-fluid" }, content = function()
      ui.container{ attr = { class = "span12" }, content = function()
      ui.link{
        content = function()
          local name
          if initiative.name_highlighted then
            name = encode.highlight(initiative.name_highlighted)
          else
            name = encode.html(initiative.shortened_name)
          end
          ui.heading{ level=6, content = "i" .. initiative.id .. ": "..name }
        end,
        module  = "initiative",
        view    = "show",
        id      = initiative.id
      }
      if request.get_view() == "show_ext_bs" then
        ui.tag{ tag="p", content= initiative.brief_description}
      end
      end }
    end }

  end }
end }
