User = mondelefant.new_class()
User.table = 'user'

User:add_reference{
  mode          = '1m',        -- one (1) user can have many (m) sessions
  to            = "Session",   -- referenced model (quoting avoids auto-loading here)
  this_key      = 'id',        -- own key in user table
  that_key      = 'user_id',   -- other key in session table
  ref           = 'sessions',  -- name of reference
  back_ref      = 'user',      -- each autoloaded Session automatically refers back to the User
  default_order = '"ident"'    -- order sessions by SQL expression "ident"
}

function User:by_ident_and_password(ident, password)
  local selector = self:new_selector()
  selector:add_where{ 'ident = ? AND password = ?', ident, password }
  selector:optional_object_mode()
  return selector:exec()
end

function User.object_get:name_with_login()
  return self.name .. ' (' .. self.login .. ')'
end

function User.object:require_privilege(privilege)
  if privilege == "admin" then
    assert(self.admin, "Administrator privilege required")
  elseif privilege == "write" then
    assert(self.write_priv, "Write privilege required")
  else
    error("Unknown privilege passed to require_privilege method of User")
  end
end
