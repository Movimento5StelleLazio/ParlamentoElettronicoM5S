local member = app.session.member
local other_member = Member:by_id(param.get_id())

local contact = Contact:by_pk(member.id, other_member.id)
contact:destroy()

--slot.put_into("notice", _"Member has been removed from your contacts")
