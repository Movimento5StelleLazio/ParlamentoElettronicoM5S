ui.heading{ level = 2, content = _"Notification level not set yet" }

slot.put("<br />")

ui.tag{
  tag = "div",
  content = _"You didn't set the level of notifications you like to receive"
}

slot.put("<br />")

ui.link{
  text = _"Configure notifications now",
  module = "member",
  view = "settings_notification",
}
slot.put("<br />")
slot.put("<br />")

