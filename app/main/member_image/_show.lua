local member = param.get("member", "table")
local member_id = member and member.id or param.get("member_id", atom.integer)

local image_type = param.get("image_type")
local class = param.get("class")
local popup_text = param.get("popup_text")

if class then
  class = " " .. class
else
  class = ""
end


if config.fastpath_url_func then
  ui.image{
    attr = { title = popup_text, class = "member_image member_image_" .. image_type .. class },
    external = config.fastpath_url_func(member_id, image_type)
  }
else
  ui.image{
    attr = { title = popup_text, class = "member_image member_image_" .. image_type .. class },
    module = "member_image",
    view = "show",
    extension = "jpg",
    id = member_id,
    params = {
      image_type = image_type
    }
  }
end
