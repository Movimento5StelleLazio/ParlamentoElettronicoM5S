TemplateAreaAllowedPolicy = mondelefant.new_class()
TemplateAreaAllowedPolicy.table = 'template_area_allowed_policy'
TemplateAreaAllowedPolicy.primary_key = { "template_area_id", "policy_id" }


function TemplateAreaAllowedPolicy:build_selector(args)
    local selector = self:new_selector()
    if args.area_id ~= nil then
        selector:add_where { "template_area_allowed_policy.template_area_id = ?", args.area_id }
    end
    return selector
end
