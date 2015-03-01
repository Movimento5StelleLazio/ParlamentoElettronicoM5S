local draft = param.get("draft", "table")
local source = param.get("source", atom.boolean)

ui.container {
    attr = { class = "draft_content wiki initiative_list_box" },
    content = function()
        if source then
            ui.tag {
                tag = "pre",
                content = draft.content
            }
        else
            slot.put(draft:get_content("html"))
        end
    end
}
