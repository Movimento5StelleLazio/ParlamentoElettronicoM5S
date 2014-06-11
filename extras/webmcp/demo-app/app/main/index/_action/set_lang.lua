app.session.user.lang = param.get("lang")
app.session.user:save()

locale.set{ lang = app.session.user.lang }

slot.put_into("notice", _"Language changed")