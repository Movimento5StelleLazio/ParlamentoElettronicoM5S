InviteCode = mondelefant.new_class()
InviteCode.table = 'invite_code'
InviteCode.primary_key = "code"

function InviteCode:by_code(code)
  local selector = self:new_selector()
  selector:add_where{'"code" = ?', code }
  selector:optional_object_mode()
  return selector:exec()
end
