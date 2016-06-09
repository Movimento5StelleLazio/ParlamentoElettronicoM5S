CheckedEvent = mondelefant.new_class()
CheckedEvent.table = 'checked_event'
CheckedEvent.primary_key = { "event_id", "member_id" }

CheckedEvent:add_reference {
    mode = 'm1',
    to = "Member",
    this_key = 'member_id',
    that_key = 'id',
    ref = 'member',
    back_ref = 'checked_event'
}

CheckedEvent:add_reference {
    mode = 'm1',
    to = "Event",
    this_key = 'event_id',
    that_key = 'id',
    ref = 'event',
    back_ref = 'checked_event'
}

function CheckedEvent:by_pk(event_id, member_id)
    return self:new_selector():add_where { "event_id = ? AND member_id = ?", event_id, member_id }:optional_object_mode():exec()
end
