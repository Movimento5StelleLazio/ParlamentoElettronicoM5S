function ui.twitter(message)
  ui.link{
    attr = { target = "_blank" },
    content = function()
      ui.image{ static = "icons/16/user_comment.png" }
      slot.put(encode.html("tweet it"))
    end,
    external = "http://twitter.com/?status=" .. encode.url_part(message)
  }
end