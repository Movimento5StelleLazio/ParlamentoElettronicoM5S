-- Generating CSV data
local members_selector = Member:new_selector()
members_selector:add_where { "certifier_id = ?", app.session.member_id }
members_selector:add_order_by { "id" }
members = members_selector:exec()
local ids = ""
local data = ""
if #members >= 1 then
    for i, member in ipairs(members) do
        if i > 1 then
            ids = ids .. ", "
        end
        ids = ids .. member.id
    end
    members_data_selector = MemberData:new_selector()
    members_data_selector:add_where { "id IN (" .. ids .. ")" }
    members_data_selector:add_order_by { "id" }
    members_data = members_data_selector:exec()
    for i, member in ipairs(members) do
        local sensitive_data = ""
        for i, member_data in ipairs(members_data) do
            if member_data.id == member.id then
                sensitive_data = "," .. (member_data.birthplace or "") .. "," .. (format.date(member_data.birthdate) or "") .. "," .. (member_data.idcard or "")
            end
        end
        data = data .. member.id .. "," .. (member.firstname or "") .. "," .. (member.lastname or "") .. "," .. (member.nin or "") .. sensitive_data .. '\n'
    end
end

local date = atom.date:get_current()

print('Cache-Control: no-cache');
print('Content-disposition: attachment; filename=users_' .. date.year .. date.month .. date.day .. '.csv');
slot.set_layout(nil, "text/plain; charset=UTF-8")
slot.put_into("data", "ID,Nome,Cognome,CF,Luogo di nascita,Data di nascita,Numero documento" .. '\n')
slot.put_into("data", data)
