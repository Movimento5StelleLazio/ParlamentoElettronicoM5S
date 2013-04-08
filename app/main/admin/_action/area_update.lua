local area = Area:by_id(param.get_id()) or Area:new()

param.update(area, "unit_id", "name", "description", "active")

area:save()

param.update_relationship{
  param_name        = "allowed_policies",
  id                = area.id,
  connecting_model  = AllowedPolicy,
  own_reference     = "area_id",
  foreign_reference = "policy_id"
}

-- we have to update the default flag because update_relationship can't handle it
old_default = AllowedPolicy:new_selector()
:add_where{ "allowed_policy.area_id = ? AND allowed_policy.default_policy = 't'", area.id }
:optional_object_mode()
:exec()

if old_default then
  old_default.default_policy = false;
  old_default:save()
end

default_policy_id = param.get("default_policy", atom.integer)

if default_policy_id and default_policy_id ~= -1 then
  pol = AllowedPolicy:new_selector()
  :add_where{ "allowed_policy.area_id = ? AND allowed_policy.policy_id = ?", area.id, default_policy_id }
  :optional_object_mode()
  :exec()
  if pol then
    pol.default_policy = true;
    pol:save()
  end
end
