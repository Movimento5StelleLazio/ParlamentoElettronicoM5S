Supporter = mondelefant.new_class()
Supporter.table = 'supporter'
Supporter.primary_key = { "initiative_id", "member_id" }

Supporter:add_reference{
  mode          = 'm1',
  to            = "Initiative",
  this_key      = 'initiative_id',
  that_key      = 'id',
  ref           = 'initiative',
}

Supporter:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

function Supporter:by_pk(initiative_id, member_id)
  return self:new_selector()
    :add_where{ "initiative_id = ?", initiative_id }
    :add_where{ "member_id = ?", member_id }
    :optional_object_mode()
    :exec()
end

function Supporter.object:has_critical_opinion()
  return Opinion:new_selector()
    :add_where{ "initiative_id = ?", self.initiative_id }
    :add_where{ "member_id = ?", self.member_id }
    :add_where("(degree = -2 AND fulfilled) OR (degree = 2 AND NOT fulfilled)")
    :limit(1)
    :exec()[1] and true or false
end