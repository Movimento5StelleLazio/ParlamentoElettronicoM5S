local id = param.get_id(atom.string)

if not id then
  id = "index"
else
  -- sanity check. Only allow letters, digits and _-
  id = string.match(id, "[%a%d_-]*")
end

if not app.html_title.title then
  app.html_title.title = _("Help #{id}", { id = id })
end

local basepath = request.get_app_basepath() 
local found_help = false
-- we try to load any help file that fits best
for x,lang in ipairs{locale.get("lang"), "en"} do
  local file_name = basepath .. "/locale/help/" .. id .. "." .. lang .. ".txt.html"
  local file = io.open(file_name)
  if file ~= nil then
    local help_text = file:read("*a")
    if #help_text > 0 then
      found_help = true
      ui.container{
        attr = { class = "wiki" },
        content = function()
          slot.put(help_text)
        end
      }
      break
    end
  end
end

if not found_help then
  ui.field.text{ value = _("Missing help text: #{id}.#{lang}.txt", { id = id, lang = locale.get("lang") }) }
end
