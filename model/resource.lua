Resource = mondelefant.new_class()
Resource.table = 'resource'
Resource.primary_key = { "id" }

Resource:add_reference {
    mode = 'm1',
    to = "Initiative",
    this_key = 'initiative_id',
    that_key = 'id',
    ref = 'initiative',
}

function Resource:by_initiative_id(initiative_id)
    return self:new_selector():add_where { "initiative_id = ?", initiative_id }:optional_object_mode():exec()
end

function Resource:all_resources(initiative_id)
    return self:new_selector():add_where { "initiative_id = ?", initiative_id }:optional_object_mode():exec()
end

function Resource:all_resources_by_type(initiative_id, resource_type)
    return self:new_selector():add_where { "initiative_id = ? AND type = ?", initiative_id, resource_type }:optional_object_mode():exec()
end
