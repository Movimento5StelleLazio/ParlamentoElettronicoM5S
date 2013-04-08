MemberImage = mondelefant.new_class()
MemberImage.table = "member_image"
MemberImage.primary_key = { "member_id", "image_type" }

function MemberImage:by_pk(member_id, image_type, scaled)
  return self:new_selector()
    :add_where{ "member_id = ?",  member_id }
    :add_where{ "image_type = ?", image_type }
    :add_where{ "scaled = ?", scaled }
    :optional_object_mode()
    :exec()
end
