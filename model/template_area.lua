TemplateArea = mondelefant.new_class()
TemplateArea.table = 'template_area'

TemplateArea:add_reference {
    mode = '1m',
    to = "Policy",
    this_key = 'id',
    that_key = 'id',
    ref = 'policy'
}


-- Anche policy e' da modificare

function TemplateArea.object_get:default_policy()
    return Policy:new_selector():join("template_area_allowed_policy", nil, "template_area_allowed_policy.policy_id = policy.id"):add_where { "template_area_allowed_policy.area_id = ? AND template_area_allowed_policy.default_policy", self.id }:optional_object_mode():exec()
end

function TemplateArea:build_selector(args)
    local selector = TemplateArea:new_selector()
    if args.active ~= nil then
        selector:add_where { "template_area.active = ?", args.active }
    end
    if args.templateId ~= nil then
        selector:add_where { "template_area.template_id = ?", args.templateId }
    end
    return selector
end

 