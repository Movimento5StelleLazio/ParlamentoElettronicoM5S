IgnoredInitiative = mondelefant.new_class()
IgnoredInitiative.table = 'ignored_initiative'
IgnoredInitiative.primary_key = { "member_id", "initiative_id" }

IgnoredInitiative:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

IgnoredInitiative:add_reference{
  mode          = 'm1',
  to            = "Inititive",
  this_key      = 'initiative_id',
  that_key      = 'id',
  ref           = 'initiative',
}


function IgnoredInitiative:by_pk(member_id, initiative_id)
  return self:new_selector()
    :add_where{ "member_id = ?", member_id }
    :add_where{ "initiative_id = ?", initiative_id }
    :optional_object_mode()
    :exec()
end

