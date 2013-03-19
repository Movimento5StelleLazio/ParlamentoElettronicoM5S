local issue = param.get("issue", "table")

ui.tag{ tag = "iframe", attr = { 
  width = "800",
  height = "500",
  src = issue.etherpad_url 
} }

