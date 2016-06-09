AllowedPolicy = mondelefant.new_class()
AllowedPolicy.table = 'allowed_policy'
AllowedPolicy.primary_key = { "area_id", "policy_id" }



function AllowedPolicy:by_pk(area_id, policy_id)

    return self:new_selector():add_where { "area_id = ?", area_id }:add_where { "policy_id = ?", policy_id }:optional_object_mode():exec()
end


function AllowedPolicy:get_policy_by_area_id(area_id)
    local _sel = AllowedPolicy:new_selector():add_where { "area_id = ?", area_id }:exec()
    return _sel
end
 