AllowedPolicy = mondelefant.new_class()
AllowedPolicy.table = 'allowed_policy'
AllowedPolicy.primary_key = { "area_id", "policy_id" }



function AllowedPolicy:by_pk(area_id, policy_id)
 
 return self:new_selector()
    :add_where{ "area_id = ?", area_id }
    :add_where{ "policy_id = ?", policy_id }
    :optional_object_mode()
    :exec()
end


function AllowedPolicy:get_policy_by_area_id(area_id)
  --  local selector=Policy:new_selector()
  --  :join("allowed_policy", nil, "allowed_policy.policy_id = policy.id")
  --  :add_where{ "allowed_policy.area_id = ?", self.id }
    
    
    local _sel=AllowedPolicy:new_selector()
    :add_where{ "area_id = ?",area_id }
    :add_where{ "default_policy=?",true}
    :optional_object_mode()
    :exec()
    trace.debug("_sel="..#_sel)
    
    
    local _selector=Policy:new_selector()
    :add_where{"id=?",_sel.policy_id}
    :exec()
     trace.debug("_selector="..#_selector)
    return _selector
end
 