local voting_right_unit_id
local current_trustee_id
local current_trustee_name

local unit = Unit:by_id(param.get("unit_id", atom.integer))
if unit then
  unit:load_delegation_info_once_for_member_id(app.session.member_id)
  voting_right_unit_id = unit.id
  if unit.delegation_info.own_delegation_scope == 'unit' then
    current_trustee_id = unit.delegation_info.first_trustee_id
    current_trustee_name = unit.delegation_info.first_trustee_name
  end
  ui.title(config.single_unit_id and _"Set global delegation" or _"Set unit delegation")
  util.help("delegation.new.unit")
end

local area = Area:by_id(param.get("area_id", atom.integer))
if area then
  area:load_delegation_info_once_for_member_id(app.session.member_id)
  voting_right_unit_id = area.unit_id
  if area.delegation_info.own_delegation_scope == 'area' then
    current_trustee_id = area.delegation_info.first_trustee_id
    current_trustee_name = area.delegation_info.first_trustee_name
  end
  ui.title(_"Set delegation for Area '#{name}'":gsub("#{name}", area.name))
  util.help("delegation.new.area")
end

local issue = Issue:by_id(param.get("issue_id", atom.integer))
if issue then
  issue:load("member_info", { member_id = app.session.member_id })
  voting_right_unit_id = issue.area.unit_id
  if issue.member_info.own_delegation_scope == 'issue' then
    current_trustee_id = issue.member_info.first_trustee_id
    current_trustee_name = issue.member_info.first_trustee_name
  end
  ui.title(_"Set delegation for Issue ##{number} in Area '#{area_name}'":gsub("#{number}", issue.id):gsub("#{area_name}", issue.area.name))
  util.help("delegation.new.issue")
end


local delegation
local unit_id
local area_id
local issue_id
local initiative_id
local initiative

local scope = "unit"

unit_id = param.get("unit_id", atom.integer)

local inline = param.get("inline", atom.boolean)

if param.get("initiative_id", atom.integer) then
  initiative_id = param.get("initiative_id", atom.integer)
  initiative = Initiative:by_id(initiative_id)
  issue_id = initiative.issue_id
  scope = "issue"
end

if param.get("issue_id", atom.integer) then
  issue_id = param.get("issue_id", atom.integer)
  scope = "issue"
end

if param.get("area_id", atom.integer) then
  area_id = param.get("area_id", atom.integer)
  scope = "area"
end



local delegation
local issue

if issue_id then
  issue = Issue:by_id(issue_id)
  delegation = Delegation:by_pk(app.session.member.id, nil, nil, issue_id)
  if not delegation then
    delegation = Delegation:by_pk(app.session.member.id, nil, issue.area_id)
  end
  if not delegation then
    delegation = Delegation:by_pk(app.session.member.id, issue.area.unit_id)
  end
elseif area_id then
  delegation = Delegation:by_pk(app.session.member.id, nil, area_id)
  if not delegation then
    local area = Area:by_id(area_id)
    delegation = Delegation:by_pk(app.session.member.id, area.unit_id)
  end
end

if not delegation then
  delegation = Delegation:by_pk(app.session.member.id, unit_id)
end

local contact_members = Member:build_selector{
  is_contact_of_member_id = app.session.member_id,
  voting_right_for_unit_id = voting_right_unit_id,
  active = true,
  order = "name"
}:exec()

local preview_trustee_id = param.get("preview_trustee_id", atom.integer)

ui.script{ static = "js/update_delegation_info.js" }

ui.actions(function()
  if issue then
    ui.link{
      module = "issue",
      view = "show",
      id = issue.id,
      content = function()
          ui.image{ static = "icons/16/cancel.png" }
          slot.put(_"Cancel")
      end,
    }
  elseif area then
    ui.link{
      module = "area",
      view = "show",
      id = area.id,
      content = function()
          ui.image{ static = "icons/16/cancel.png" }
          slot.put(_"Cancel")
      end,
    }
  else
    ui.link{
      module = "index",
      view = "index",
      content = function()
          ui.image{ static = "icons/16/cancel.png" }
          slot.put(_"Cancel")
      end,
    }
  end
end)


ui.form{
  attr = { class = "vertical", id = "delegationForm" },
  module = "delegation",
  action = "update",
  params = {
    unit_id = unit and unit.id or nil,
    area_id = area and area.id or nil,
    issue_id = issue and issue.id or nil,
    initiative_id = initiative_id
  },
  routing = {
    default = {
      mode = "redirect",
      module = area and "area" or initiative and "initiative" or issue and "issue" or "unit",
      view = "show",
      id = area and area.id or initiative and initiative.id or issue and issue.id or unit.id,
    }
  },
  content = function()
    local records

    if issue then
      local delegate_name = ""
      local scope = "no delegation set"
      local area_delegation = Delegation:by_pk(app.session.member_id, nil, issue.area_id)
      if area_delegation then
        delegate_name = area_delegation.trustee and area_delegation.trustee.name or _"abandoned"
        scope = _"area"
      else
        local unit_delegation = Delegation:by_pk(app.session.member_id, issue.area.unit_id)
        if unit_delegation then
          delegate_name = unit_delegation.trustee.name
          scope = config.single_unit_id and _"global" or _"unit"
        end
      end
      local text_apply
      local text_abandon
      if config.single_unit_id then
        text_apply = _("Apply global or area delegation for this issue (Currently: #{delegate_name} [#{scope}])", { delegate_name = delegate_name, scope = scope })
        text_abandon = _"Abandon unit and area delegations for this issue"
      else
        text_apply = _("Apply unit or area delegation for this issue (Currently: #{delegate_name} [#{scope}])", { delegate_name = delegate_name, scope = scope })
        text_abandon = _"Abandon unit and area delegations for this issue"
      end
      records = {
        { id = -1, name = text_apply },
        { id = 0,  name = text_abandon }
      }
    elseif area then
      local delegate_name = ""
      local scope = "no delegation set"
      local unit_delegation = Delegation:by_pk(app.session.member_id, area.unit_id)
      if unit_delegation then
        delegate_name = unit_delegation.trustee.name
        scope = config.single_unit_id and _"global" or _"unit"
      end
      local text_apply
      local text_abandon
      if config.single_unit_id then
        text_apply = _("Apply global delegation for this area (Currently: #{delegate_name} [#{scope}])", { delegate_name = delegate_name, scope = scope })
        text_abandon = _"Abandon global delegation for this area"
      else
        text_apply = _("Apply unit delegation for this area (Currently: #{delegate_name} [#{scope}])", { delegate_name = delegate_name, scope = scope })
        text_abandon = _"Abandon unit delegation for this area"
      end
      records = {
        {
          id = -1,
          name = text_apply
        },
        {
          id = 0,
          name = text_abandon
        }
      }

    else
      records = {
        {
          id = -1,
          name = _"No delegation"
        }
      }

    end
    -- add current trustee
    if current_trustee_id then
      records[#records+1] = {id="_", name= "--- " .. _"Current trustee" .. " ---"}
      records[#records+1] = { id = current_trustee_id, name = current_trustee_name }
    end
    -- add initiative authors
    if initiative then
      records[#records+1] = {id="_", name= "--- " .. _"Initiators" .. " ---"}
      for i,record in ipairs(initiative.initiators) do
        records[#records+1] = record.member
      end
    end
    -- add saved members
    if #contact_members > 0 then
      records[#records+1] = {id="_", name= "--- " .. _"Saved contacts" .. " ---"}
      for i, record in ipairs(contact_members) do
        records[#records+1] = record
      end
    end

    disabled_records = {}
    disabled_records["_"] = true
    disabled_records[app.session.member_id] = true

    local value = current_trustee_id
    if preview_trustee_id then
      value = preview_trustee_id
    end
    if preview_trustee_id == nil and delegation and not delegation.trustee_id then
      value = 0
    end
    
    ui.field.select{
      attr = { onchange = "updateDelegationInfo();" },
      label = _"Trustee",
      name = "trustee_id",
      foreign_records = records,
      foreign_id = "id",
      foreign_name = "name",
      disabled_records = disabled_records,
      value = value
    }

    ui.field.hidden{ name = "preview" }
    
    ui.submit{ text = _"Save" }
    
  end
}


-- ------------------------

local preview_inherit = false
local tmp_preview_trustee_id = preview_trustee_id
if preview_trustee_id == -1 then
  preview_inherit = true
  tmp_preview_trustee_id = nil
end
local delegation_chain = Member:new_selector()
  :add_field("delegation_chain.*")
  :join({ "delegation_chain(?,?,?,?,?,?)", app.session.member.id, unit_id, area_id, issue_id, tmp_preview_trustee_id, preview_inherit }, "delegation_chain", "member.id = delegation_chain.member_id")
  :add_order_by("index")
  :exec()

for i, record in ipairs(delegation_chain) do
  local style
  local overridden = (not issue or issue.state ~= 'voting') and record.overridden
  if record.scope_in then
    if not overridden then
      ui.image{
        attr = { class = "delegation_arrow" },
        static = "delegation_arrow_24_vertical.png"
      }
    else
      ui.image{
        attr = { class = "delegation_arrow delegation_arrow_overridden" },
        static = "delegation_arrow_24_vertical.png"
      }
    end
    ui.tag{
      attr = { class = "delegation_scope" .. (overridden and " delegation_scope_overridden" or "") },
      content = function()
        if record.scope_in == "unit" then
          slot.put(config.single_object_mode and _"Global delegation" or _"Unit delegation")
        elseif record.scope_in == "area" then
          slot.put(_"Area delegation")
        elseif record.scope_in == "issue" then
          slot.put(_"Issue delegation")
        end
      end
    }
  end
  ui.container{
    attr = { class = overridden and "delegation_overridden" or "" },
    content = function()
      execute.view{
        module = "member",
        view = "_show_thumb",
        params = { member = record }
      }
    end
  }
  if (not issue or issue.state ~= 'voting') and record.participation and not record.overridden then
    ui.container{
      attr = { class = "delegation_participation" },
      content = function()
        slot.put(_"This member is participating, the rest of delegation chain is suspended while discussing")
      end
    }
  end
  slot.put("<br style='clear: left'/>")
end

if preview_trustee_id == 0 or not preview_trustee_id == null and delegation and not delegation.trustee_id then
  ui.image{
    static = "icons/16/table_go_crossed.png"
  }
  if issue_id then
    slot.put(_"Delegation turned off for issue")
  elseif area_id then
    slot.put(_"Delegation turned off for area")
  end
end

