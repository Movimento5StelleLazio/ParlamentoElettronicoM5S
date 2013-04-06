ui.title(_"Broken delegations")

execute.view{
  module = "delegation",
  view = "_list",
  params = {
    delegations_selector = Delegation:selector_for_broken(app.session.member_id),
    outgoing = true
  }
}
