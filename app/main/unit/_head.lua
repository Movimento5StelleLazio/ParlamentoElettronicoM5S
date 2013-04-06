local unit = param.get("unit", "table")
local member = param.get("member", "table")

local show_content = param.get("show_content", atom.boolean)

if app.session.member_id then
  unit:load_delegation_info_once_for_member_id(app.session.member_id)
end

ui.container{ attr = { class = "unit_head" }, content = function()

  execute.view{ module = "delegation", view = "_info", params = { unit = unit, member = member } }

  ui.container{ attr = { class = "title" }, content = function()
    if not config.single_unit_id then
      ui.link{ 
        module = "unit", view = "show", id = unit.id,
        attr = { class = "unit_name" }, content = unit.name
      }
    else
      ui.link{ 
        module = "unit", view = "show", id = unit.id,
        attr = { class = "unit_name" }, content = _"LiquidFeedback" .. " &middot; " .. config.instance_name
      }
    end
  end }

  if show_content then
    ui.container{ attr = { class = "content" }, content = function()

      if member and member:has_voting_right_for_unit_id(unit.id) then
        if app.session.member_id == member.id then
          ui.tag{ content = _"You have voting privileges for this unit" }
          slot.put(" &middot; ")
          if unit.delegation_info.first_trustee_id == nil then
            ui.link{ text = _"Delegate unit", module = "delegation", view = "show", params = { unit_id = unit.id } }
          else
            ui.link{ text = _"Change unit delegation", module = "delegation", view = "show", params = { unit_id = unit.id } }
          end
        else
          ui.tag{ content = _"Member has voting privileges for this unit" }
        end
      end
    end }
  else
    slot.put("<br />")
  end
    
end }
