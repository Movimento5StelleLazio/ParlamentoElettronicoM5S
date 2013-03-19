function model.has_rendered_content(class, rendered_class, content_field_name)

  local content_field_name = content_field_name or 'content'
  
  -- render content to html, save it as rendered_class and return it
  function class.object:render_content(force_rendering)
    -- local draft for update

    local selector = class:new_selector()

    if type(class.primary_key) == "table" then
      for i, key in ipairs(class.primary_key) do
        selector:add_where{ "$ = ?", { key }, self[key] }
      end
    else
      selector:add_where{ "id = ?", self.id }
    end
    
    local lock = selector:single_object_mode():for_update():exec()
      
    -- check if there is already a rendered content
    local selector = rendered_class:new_selector()
      if type(class.primary_key) == "table" then
        for i, key in ipairs(class.primary_key) do
          selector:add_where{ "$.$ = ?", { rendered_class.table }, { key }, self[key] }
        end
      else
        selector:add_where{ "$." .. class.table .. "_id = ?", { rendered_class.table }, self.id }
      end
      local rendered = selector:add_where{ "format = 'html'" }
      :optional_object_mode()
      :exec()
    if rendered then
      if force_rendering then
        rendered:destroy()
      else
        return rendered
      end
    end
    -- create rendered_class record
    local rendered = rendered_class:new()
    if type(class.primary_key) == "table" then
      for i, key in ipairs(class.primary_key) do
        rendered[key] = self[key]
      end
    else
      rendered[class.table .. "_id"] = self.id
    end
    rendered.format = "html"
    rendered.content = format.wiki_text(self[content_field_name], self.formatting_engine)
    rendered:save()
    -- and return it
    return rendered
  end

  -- returns rendered version for specific format
  function class.object:get_content(format)
    -- Fetch rendered_class record for specified format
    local selector = rendered_class:new_selector()
    if type(class.primary_key) == "table" then
      for i, key in ipairs(class.primary_key) do
        selector:add_where{ "$.$ = ?", { rendered_class.table }, { key }, self.id }
      end
    else
      selector:add_where{ class.table .. "_id = ?", self.id }
    end
    local rendered = selector:add_where{ "format = ?", format }
      :optional_object_mode()
      :exec()
    -- If this format isn't rendered yet, render it
    if not rendered then
      rendered = self:render_content()
    end
    -- return rendered content
    return rendered.content
  end

end