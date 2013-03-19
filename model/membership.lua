Membership = mondelefant.new_class()
Membership.table = 'membership'
Membership.primary_key = { "area_id", "member_id" }

Membership:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

Membership:add_reference{
  mode          = 'm1',
  to            = "Area",
  this_key      = 'area_id',
  that_key      = 'id',
  ref           = 'area',
}

function Membership:by_pk(area_id, member_id)
  return self:new_selector()
    :add_where{ "area_id = ? AND member_id = ?", area_id, member_id }
    :optional_object_mode()
    :exec()
end