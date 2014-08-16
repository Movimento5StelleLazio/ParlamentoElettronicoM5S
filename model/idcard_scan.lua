IdcardScan = mondelefant.new_class()
IdcardScan.table = "idcard_scan"
IdcardScan.primary_key = { "member_id", "scan_type" }

function IdcardScan:by_pk(member_id, scan_type)
    return self:new_selector():add_where { "member_id = ?", member_id }:add_where { "scan_type = ?", scan_type }:optional_object_mode():exec()
end

function IdcardScan:get_db_conn()
    return secure_db
end

