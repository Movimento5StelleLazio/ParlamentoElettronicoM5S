Session = mondelefant.new_class()
Session.table = 'session'
Session.primary_key = { "ident" }

Session:add_reference{
  mode          = 'm1',       -- many (m) sessions refer to one (1) user
  to            = "User",     -- name of referenced model (quoting avoids auto-loading here)
  this_key      = 'user_id',  -- own key in session table
  that_key      = 'id',       -- other key in user table
  ref           = 'user',     -- name of reference
  back_ref      = nil,        -- not used for m1 relation!
  default_order = nil         -- not used for m1 relation!
}

local function random_string()
  return multirand.string(
    32,
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  )
end

function Session:new()
  local session = self.prototype.new(self)  -- super call
  session.ident       = random_string()
  session.csrf_secret = random_string()
  session:save() 
  return session
end

function Session:by_ident(ident)
  local selector = self:new_selector()
  selector:add_where{ 'ident = ?', ident }
  selector:optional_object_mode()
  return selector:exec()
end
