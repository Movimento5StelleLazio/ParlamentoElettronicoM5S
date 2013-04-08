if config.motd_intern then
  local help_text = config.motd_intern
  ui.container{
    attr = { class = "wiki" },
    content = function()
      slot.put(format.wiki_text(help_text))
    end
  }
end
