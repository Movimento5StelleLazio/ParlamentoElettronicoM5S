local unchecked_events = param.get("unchecked_events", "table")
local member_id = param.get("member_id", atom.integer)

for i, event in ipairs(unchecked_events) do
    if event.id then
        local checked_event = CheckedEvent:new()
        checked_event.member_id = member_id
        checked_event.event_id = event.id
        checked_event:save()
    end
end
