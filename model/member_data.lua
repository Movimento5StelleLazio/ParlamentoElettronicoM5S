MemberData = mondelefant.new_class()
MemberData.table = 'member_data'

function MemberData:by_id(id)
    local selector = self:new_selector()
    selector:add_where { '"id" = ?', id }
    selector:optional_object_mode()
    return selector:exec()
end

function MemberData:get_db_conn()
    return secure_db
end
