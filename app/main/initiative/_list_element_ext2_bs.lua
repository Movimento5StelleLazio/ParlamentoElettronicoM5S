local initiative = param.get("initiative", "table")
local selected = param.get("selected", atom.boolean)
local for_member = param.get("for_member", "table") or app.session.member
local for_details = param.get("for_details", "boolean") or false

local class =""
if for_details then
  class = " alert alert-simple initiative_box paper"
end

ui.container{ attr = { class = "row-fluid" }, content = function()
  ui.container{ attr = { class = "span12"..class }, content = function()
    ui.container{ attr = { class = "row-fluid" }, content = function()
      --[[
      ui.container{ attr = { class = "span1" }, content = function()
        if initiative.issue.fully_frozen and initiative.issue.closed or initiative.admitted == false then 
          ui.field.rank{ attr = { class = "rank" }, value = initiative.rank, eligible = initiative.eligible }
        elseif not initiative.issue.closed then
          ui.image{ attr = { class = "spaceline" }, static = "icons/16/script.png" }
        else
          ui.image{ attr = { class = "spaceline" }, static = "icons/16/cross.png" }
        end
      end }
      --]]
      local span=2
      if for_details then
        ui.container{ attr = { class = "span2 text-center" }, content = function()
          ui.link{
            attr = { class="btn btn-primary btn_read_initiative"  },
            module = "initiative",
            id = initiative.id,
            view = "show",
            content = function()


              ui.container{ attr = { class = "event_star_out_box" }, content = function()
                ui.container{ attr = { class = "event_star_in_box" }, content = function()

                  local t=math.random(4)
                  if t == 1 then
 
                  ui.container{ attr = { class = "event_star_txt_box" }, content = function()
                    ui.tag{ tag="span", attr={class="event_star_txt"}, content="3 Eventi"}
                  end }
                  ui.image{ attr={class="event_star"}, static="svg/event_star_red.svg" }
                    
                  elseif t == 2 then

                  ui.container{ attr = { class = "event_star_txt_box" }, content = function()
                    ui.tag{ tag="span", attr={class="event_star_txt"}, content="Nuovo"}
                  end }
                  ui.image{ attr={class="event_star"}, static="svg/event_star_green.svg" }

                  end
                  
                end }
              end }


              ui.heading{level=5,attr={class=""},content=function()
                slot.put(_"Read".." p"..initiative.id)
              end }
            end
          }
      end }
      else
        span=4
      end

      ui.container{ attr = { class = "span"..span.." spaceline" }, content = function()
        ui.container{ attr = { class = "row-fluid" }, content = function()
          ui.container{ attr = { class = "span12" }, content = function()
            if initiative.issue.fully_frozen and initiative.issue.closed then
              if initiative.negative_votes and initiative.positive_votes then
                local max_value = initiative.issue.voter_count
        
                local a=initiative.positive_votes
                local b=(max_value - initiative.negative_votes - initiative.positive_votes)
                local c=initiative.negative_votes
    
                local ap,bp,cp
                if a>0 then ap=a * 100 / max_value else ap = 0 end
                if b>0 then bp=b * 100 / max_value else bp = 0 end
                if c>0 then cp=c * 100 / max_value else cp = 0 end
    
                ui.container{ attr = { class = "progress progress-striped active" }, content=function()
                  ui.container{ attr = {class = "progress_bar_txt"}, content=function()
                    ui.container{ attr = {class = "text-center"}, content=( (initiative.positive_votes)/max_value or "<0.1").."%" }
                  end }
                  ui.container{ attr = {class = "bar bar-success text-center", style = "width:"..ap.."%"}, content=""}
                  ui.container{ attr = {class = "bar bar-neutral text-center", style = "width:"..bp.."%"}, content=""}
                  ui.container{ attr = {class = "bar bar-danger text-center", style = "width:"..cp.."%"}, content=""}
                  --ui.tag{tag="span", content=a.." ("..ap.."%) / "..b.." ("..bp.."%) / "..c.." ("..cp.."%)" }
                  --ui.tag{tag="span", content=a.." / "..b.." / "..c }
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
              local c= max_value - (initiative.supporter_count or 0)
    
              local ap,bp,cp
              if a>0 then ap=a * 100 / max_value else ap = 0 end
              if b>0 then bp=b * 100 / max_value else bp = 0 end
              if c>0 then cp=c * 100 / max_value else cp = 0 end
    
              ui.container{ attr = { class = "progress progress-striped active" }, content=function()
                ui.container{ attr = {class = "progress_bar_txt"}, content=function()
                  ui.container{ attr = {class = "text-center"}, content=( (initiative.supporter_count+initiative.satisfied_supporter_count)/max_value or "<0.1").."%" }
                end }
                ui.container{ attr = {class = "bar bar-success", style = "width:"..ap.."%"}, content=""}
                ui.container{ attr = {class = "bar bar-neutral", style = "width:"..bp.."%"}, content=""}
                ui.container{ attr = {class = "bar bar-white", style = "width:"..cp.."%"}, content=""}
                --ui.tag{tag="span", content=a.." ("..ap.."%) / "..b.." ("..bp.."%) / "..c.." ("..cp.."%)" }
                --ui.tag{tag="span", content=a.." / "..b.." / "..c }
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
          ui.container{ attr = { class = "span12 text-center" }, content = function()
            ui.heading{level=6, content="("..initiative.supporter_count..")"}
          end }
        end }
      end }

      ui.container{ attr = { class = "span8" }, content = function()
      ui.link{
        content = function()
          local name
          if initiative.name_highlighted then
            name = encode.highlight(initiative.name_highlighted)
          else
            name = encode.html(initiative.shortened_name)
          end
          ui.heading{ level=6, content =function()
            if for_details then
              ui.tag{tag="strong",content= name }
            else
              ui.tag{tag="strong",content= "p" .. initiative.id .. ": "..name }
            end
          end }
        end,
        module  = "initiative",
        view    = "show",
        id      = initiative.id
      }
      --if request.get_view() == "show_ext_bs" then
      if for_details then
        ui.tag{ tag="p", content= initiative.brief_description}
      end
      end }
    end }

  end }
end }
