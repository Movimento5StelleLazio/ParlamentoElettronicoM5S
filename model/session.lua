Session = mondelefant.new_class()
Session.table = 'session'
Session.primary_key = { 'ident' } 

Session:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

local function random_string()
  return multirand.string(
    32,
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  )
end

function Session:new()
  local session = self.prototype.new(self)  -- super call
  session.ident             = random_string()
  session.additional_secret = random_string()
  session:save() 
  return session
end

function Session:by_ident(ident)
  local selector = self:new_selector()
  selector:add_where{ 'ident = ?', ident }
  selector:optional_object_mode()
  return selector:exec()
end

function Session.object:has_access(level)
  if level == "member" then
    if app.session.member_id then
      return true
    else
      return false
    end
  
  elseif level == "everything" then
    if self:has_access("member") or config.public_access == "everything" then
      return true
    else
      return false
    end

  elseif level == "all_pseudonymous" then
    if self:has_access("everything") or config.public_access == "all_pseudonymous" then
      return true
    else
      return false
    end

  elseif level == "authors_pseudonymous" then
    if self:has_access("all_pseudonymous") or config.public_access == "authors_pseudonymous" then
      return true
    else
      return false
    end

  elseif level == "anonymous" then
    if self:has_access("authors_pseudonymous") or config.public_access == "anonymous" then
      return true
    else
      return false
    end
    
  end
  
  error("invalid access level")
end
