Unit = mondelefant.new_class()
Unit.table = 'unit'

Unit:add_reference{
  mode          = '1m',
  to            = "Area",
  this_key      = 'id',
  that_key      = 'unit_id',
  ref           = 'areas',
  back_ref      = 'unit'
}

Unit:add_reference{
  mode                  = 'mm',
  to                    = "Member",
  this_key              = 'id',
  that_key              = 'id',
  connected_by_table    = 'privilege',
  connected_by_this_key = 'unit_id',
  connected_by_that_key = 'member_id',
  ref                   = 'members'
}

Unit:add_reference{
  mode               = "11",
  to                 = mondelefant.class_prototype,
  this_key           = "id",
  that_key           = "unit_id",
  ref                = "delegation_info",
  back_ref           = "unit",
  selector_generator = function(list, options)
    assert(options.member_id, "member_id mandatory for delegation_info")
    local ids = { sep = ", " }
    for i, object in ipairs(list) do
      local id = object.id
      if id ~= nil then
        ids[#ids+1] = {"?", id}
      end
    end
    local sub_selector = Unit:get_db_conn():new_selector()
    if #ids == 0 then
      return sub_selector:empty_list_mode()
    end
    sub_selector:from("unit")
    sub_selector:add_field("unit.id", "unit_id")
    sub_selector:add_field{ '(delegation_info(?, unit.id, null, null, ?)).*', options.member_id, options.trustee_id }
    sub_selector:add_where{ 'unit.id IN ($)', ids }

    local selector = Unit:get_db_conn():new_selector()
    selector:add_from(sub_selector, "delegation_info")
    selector:left_join("member", "first_trustee", "first_trustee.id = delegation_info.first_trustee_id")
    selector:left_join("member", "other_trustee", "other_trustee.id = delegation_info.other_trustee_id")
    selector:add_field("delegation_info.*")
    selector:add_field("first_trustee.name", "first_trustee_name")
    selector:add_field("other_trustee.name", "other_trustee_name")
    return selector
  end
}

function Unit.list:load_delegation_info_once_for_member_id(member_id, trustee_id)
  if self._delegation_info_loaded_for_member_id ~= member_id then
    self:load("delegation_info", { member_id = member_id, trustee_id = trustee_id })
    for i, unit in ipairs(self) do
      unit._delegation_info_loaded_for_member_id = member_id
    end
    self._delegation_info_loaded_for_member_id = member_id
  end
end

function Unit.object:load_delegation_info_once_for_member_id(member_id, trustee_id)
  if self._delegation_info_loaded_for_member_id ~= member_id then
    self:load("delegation_info", { member_id = member_id })
    self._delegation_info_loaded_for_member_id = member_id
  end
end



function recursive_add_child_units(units, parent_unit)
  parent_unit.childs = {}
  for i, unit in ipairs(units) do
    if unit.parent_id == parent_unit.id then
      parent_unit.childs[#(parent_unit.childs)+1] = unit
      recursive_add_child_units(units, unit)
    end
  end
end  

function recursive_get_child_units(units, parent_unit, depth)
  for i, unit in ipairs(parent_unit.childs) do
    unit.depth = depth
    units[#units+1] = unit
    recursive_get_child_units(units, unit, depth + 1)
  end
end

function Unit:get_flattened_tree(args)
  local units_selector = Unit:new_selector()
    :add_order_by("name")
  if not args or not args.include_inactive then
    units_selector:add_where("active")
  end
  local units = units_selector:exec()
  local unit_tree = {}
  for i, unit in ipairs(units) do
    if not unit.parent_id then
      unit_tree[#unit_tree+1] = unit
      recursive_add_child_units(units, unit)
    end
  end
  local depth = 1
  local units = {}
  for i, unit in ipairs(unit_tree) do
    unit.depth = depth
    units[#units+1] = unit
    recursive_get_child_units(units, unit, depth + 1)
  end
  return units
end
