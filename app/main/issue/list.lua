local issues_selector = Issue:new_selector()

execute.view{
  module = "issue",
  view = "_list",
  params = { issues_selector = issues_selector }
}