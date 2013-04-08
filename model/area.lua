Area = mondelefant.new_class()
Area.table = 'area'

Area:add_reference{
  mode          = 'm1',
  to            = "Unit",
  this_key      = 'unit_id',
  that_key      = 'id',
  ref           = 'unit',
}

Area:add_reference{
  mode          = '1m',
  to            = "Issue",
  this_key      = 'id',
  that_key      = 'area_id',
  ref           = 'issues',
  back_ref      = 'area'
}

Area:add_reference{
  mode          = '1m',
  to            = "Membership",
  this_key      = 'id',
  that_key      = 'area_id',
  ref           = 'memberships',
  back_ref      = 'area'
}

Area:add_reference{
  mode          = '1m',
  to            = "Delegation",
  this_key      = 'id',
  that_key      = 'area_id',
  ref           = 'delegations',
  back_ref      = 'area'
}

Area:add_reference{
  mode                  = 'mm',
  to                    = "Member",
  this_key              = 'id',
  that_key              = 'id',
  connected_by_table    = 'membership',
  connected_by_this_key = 'area_id',
  connected_by_that_key = 'member_id',
  ref                   = 'members'
}

Area:add_reference{
  mode                  = 'mm',
  to                    = "Policy",
  this_key              = 'id',
  that_key              = 'id',
  connected_by_table    = 'allowed_policy',
  connected_by_this_key = 'area_id',
  connected_by_that_key = 'policy_id',
  ref                   = 'allowed_policies'
}

Area:add_reference{
  mode               = "11",
  to                 = mondelefant.class_prototype,
  this_key           = "id",
  that_key           = "area_id",
  ref                = "delegation_info",
  back_ref           = "area",
  selector_generator = function(list, options)
    assert(options.member_id, "member_id mandatory for delegation_info")
    local ids = { sep = ", " }
    for i, object in ipairs(list) do
      local id = object.id
      if id ~= nil then
        ids[#ids+1] = {"?", id}
      end
    end
    local sub_selector = Area:get_db_conn():new_selector()
    if #ids == 0 then
      return sub_selector:empty_list_mode()
    end
    sub_selector:from("area")
    sub_selector:add_field("area.id", "area_id")
    sub_selector:add_field{ '(delegation_info(?, null, area.id, null, ?)).*', options.member_id, options.trustee_id }
    sub_selector:add_where{ 'area.id IN ($)', ids }

    local selector = Area:get_db_conn():new_selector()
    selector:add_from(sub_selector, "delegation_info")
    selector:left_join("member", "first_trustee", "first_trustee.id = delegation_info.first_trustee_id")
    selector:left_join("member", "other_trustee", "other_trustee.id = delegation_info.other_trustee_id")
    selector:add_field("delegation_info.*")
    selector:add_field("first_trustee.name", "first_trustee_name")
    selector:add_field("other_trustee.name", "other_trustee_name")
    return selector
  end
}

function Area.list:load_delegation_info_once_for_member_id(member_id, trustee_id)
  if self._delegation_info_loaded_for_member_id ~= member_id then
    self:load("delegation_info", { member_id = member_id, trustee_id = trustee_id })
    for i, area in ipairs(self) do
      area._delegation_info_loaded_for_member_id = member_id
    end
    self._delegation_info_loaded_for_member_id = member_id
  end
end

function Area.object:load_delegation_info_once_for_member_id(member_id, trustee_id)
  if self._delegation_info_loaded_for_member_id ~= member_id then
    self:load("delegation_info", { member_id = member_id, trustee_id = trustee_id })
    self._delegation_info_loaded_for_member_id = member_id
  end
end

function Area.object_get:default_policy()
  return Policy:new_selector()
    :join("allowed_policy", nil, "allowed_policy.policy_id = policy.id")
    :add_where{ "allowed_policy.area_id = ? AND allowed_policy.default_policy", self.id }
    :optional_object_mode()
    :exec()
end

function Area:build_selector(args)
  local selector = Area:new_selector()
  if args.active ~= nil then
    selector:add_where{ "area.active = ?", args.active }
  end
  if args.unit_id ~= nil then
    selector:add_where{ "area.unit_id = ?", args.unit_id }
  end
  return selector
end

function Area.object_get:name_with_unit_name()
  if not config.single_unit_id then
    return self.unit.name .. ", " .. self.name
  else
    return self.name
  end
end