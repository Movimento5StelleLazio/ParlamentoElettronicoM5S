local initiative = Initiative:by_id(param.get_id())

execute.view {
    module = "initiative",
    view = "_show_bs",
    params = {
        initiative = initiative
    }
}
