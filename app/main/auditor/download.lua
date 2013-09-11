if not app.session.member_id then
  slot.put_into("error",_"Unauthorized")
  return false
end

-- Generating CSV data
local members_selector = Member:new_selector()
members_selector:add_where{ "certifier_id = ?", app.session.member_id }
members_selector:add_order_by{ "id" }
members = members_selector:exec()
local ids = ""
local data = ""
if #members >=1 then
  for i,member in ipairs(members) do
    if i > 1 then
      ids=ids..", "
    end
    ids=ids..member.id
    data=data..member.id..","..(member.firstname or "")..","..(member.lastname or "")..","
  end
  members_data_selector = MemberData:new_selector()
  members_data_selector:add_where{ "id IN (?)",ids } 
  members_data_selector:add_order_by{ "id" }
  members_data = members_data_selector:exec()
end

print('Cache-Control: no-cache');
print('Content-disposition: attachment; filename=test.csv');

slot.set_layout(nil, "text/plain; charset=UTF-8")

if record then
  slot.put_into("data", "ciao")
end
print('test');
