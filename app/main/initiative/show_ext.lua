local initiative = Initiative:by_id(param.get_id())

execute.view{
  module = "initiative", view = "_show", params = {
    initiative = initiative
  }
}
