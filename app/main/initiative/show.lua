local initiative = Initiative:by_id(param.get("initiative_id", atom.integer))
if not initiative then
    initiative = Initiative:by_id(param.get_id())
end

execute.view {
    module = "initiative",
    view = "_show_bs",
    params = {
        initiative = initiative
    }
}
