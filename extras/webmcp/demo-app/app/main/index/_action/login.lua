local user = User:by_ident_and_password(param.get('ident'), param.get('password'))

if user then
  app.session.user = user
  app.session:save()
  slot.put_into('notice', _'Login successful!')
  trace.debug('User authenticated')
else
  slot.put_into('error', _'Invalid username or password!')
  trace.debug('User NOT authenticated')
  return false
end
