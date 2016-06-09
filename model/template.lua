Template = mondelefant.new_class()
Template.table = 'template'

function Template:build_selector(args)
    local selector = self:new_selector()
    return selector
end


function Template:get_all_templates()
    return self:new_selector():exec()
end

function Template:get_templates_by_name(name)
    return self:new_selector():add_where { "name = ?", name }:exec()
end