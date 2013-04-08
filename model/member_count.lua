MemberCount = mondelefant.new_class()
MemberCount.table = 'member_count'

function MemberCount:get()
  if not MemberCount.total_count then
    MemberCount.total_count = self:new_selector():single_object_mode():exec().total_count
  end
  return MemberCount.total_count
end