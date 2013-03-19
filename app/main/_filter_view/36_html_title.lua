
app.html_title = {}

  execute.inner()

-- add ":" to prefix
if app.html_title.prefix then
  app.html_title.prefix = app.html_title.prefix .. ": " 
  app.html_title.prefix = encode.html( app.html_title.prefix )
end

-- add "-" to title 
if app.html_title.title then
  app.html_title.title = app.html_title.title .. " - " 
  app.html_title.title = encode.html( app.html_title.title )

end

-- add "-" to subtitle
if app.html_title.subtitle then
  app.html_title.subtitle = app.html_title.subtitle .. " - " 
  app.html_title.subtitle = encode.html( app.html_title.subtitle )
end


slot.put_into("html_title", 
  ( app.html_title.prefix or "" )
  ..
  ( app.html_title.title  or "" )
  ..
  ( app.html_title.subtitle or "" )
  ..
  _"LiquidFeedback" .. " - " .. config.instance_name
)

