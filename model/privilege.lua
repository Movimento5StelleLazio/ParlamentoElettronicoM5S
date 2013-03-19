Privilege = mondelefant.new_class()
Privilege.table = 'privilege'
Privilege.primary_key = { "member_id", "unit_id" }

Privilege:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

Privilege:add_reference{
  mode          = 'm1',
  to            = "Unit",
  this_key      = 'unit_id',
  that_key      = 'id',
  ref           = 'unit',
}

function Privilege:by_pk(unit_id, member_id)
  return self:new_selector()
    :add_where{ "unit_id = ? AND member_id = ?", unit_id, member_id }
    :optional_object_mode()
    :exec()
end