slot.put_into("title", _"Member list")

util.help("member.list")

local members_selector = Member:new_selector()
  :add_where("activated NOTNULL")

execute.view{
  module = "member",
  view = "_list",
  params = { members_selector = members_selector }
}
