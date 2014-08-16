local issues_selector = Issue:new_selector()

execute.view {
    module = "issue_private",
    view = "_list",
    params = { issues_selector = issues_selector }
}
