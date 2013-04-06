if not app.session.member.admin then
  error('access denied')
end

execute.inner()
