local suggestion = param.get("suggestion", "table")
       ui.container { attr = { class = "row-fluid" }, content = function()
              ui.container { attr = { class = "span12 well" }, content = function()
ui.form{
  attr = { class = "text-center" },
  record = suggestion,
  readonly = true,
  content = function()       
  ui.container { attr = { class = "row-fluid" }, content = function()
    ui.container { attr = { class = "span10 offset1 label label-warning" }, content = function()
      ui.container{
      attr = { class = "span6" },
      content = function()
    if suggestion.author then 
      suggestion.author:ui_field_text{label=_"Author"} 
    end
        end
} 
    ui.container{
      attr = { class = "span6" },
      content = function()
    ui.field.text{ label = _"Title", name = "name" }
    end
}  
    end
} 
    end
}    
   ui.container { attr = { class = "row-fluid spaceline spaceline-bottom text-left" }, content = function()
    ui.container{
      attr = { class = "span12 well-inside paper" },
      content = function()
        slot.put(suggestion:get_content("html"))
      end
    }
  end
}
  end
}
execute.view{
  module = "suggestion",
  view = "_list_element",
  params = {
    suggestions_selector = Suggestion:new_selector():add_where{ "id = ?", suggestion.id },
    initiative = suggestion.initiative,
    show_name = false,
    show_filter = false
  }
}  
end
}
end
}
