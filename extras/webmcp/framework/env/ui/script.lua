--[[--
ui.script{
  noscript_attr = noscript_attr,  -- HTML attributes for noscript tag
  noscript      = noscript,       -- string or function for noscript content
  attr          = attr,           -- extra HTML attributes for script tag
  type          = type,           -- type of script, defaults to "text/javascript"
  script        = script,         -- string or function for script content
}

This function is used to insert a script into the active slot.

WARNING: If the script contains two closing square brackets directly followed by a greater-than sign, it will be rejected to avoid ambiguity related to HTML vs. XML parsing. Additional space characters can be added within the program code to avoid occurrence of the character sequence. The function encode.json{...} encodes all string literals in a way that the sequence is not contained.

--]]--

function ui.script(args)
  local args = args or {}
  local noscript_attr = args.noscript_attr
  local noscript = args.noscript
  local attr = table.new(args.attr)
  attr.type = attr.type or args.type or "text/javascript"
  local script = args.script
  if args.external then
    attr.src = encode.url{ external = args.external }
  elseif args.static then
    attr.src = encode.url{ static = args.static }
  end
  if noscript then
    ui.tag{ tag = "noscript", attr = attr, content = noscript }
  end
  if attr.src then
    ui.tag{ tag = "script", attr = attr, content = "" }
  elseif script then
    local script_string
    if type(script) == "function" then
      script_string = slot.use_temporary(script)
    else
      script_string = script
    end
    if string.find(script_string, "]]>") then
      error('Script contains character sequence "]]>" and is thus rejected to avoid ambiguity. If this sequence occurs as part of program code, please add additional space characters. If this sequence occurs inside a string literal, please encode one of this characters using the \\uNNNN unicode escape sequence.')
    end
    ui.tag{
      tag  = "script",
      attr = attr,
      content = function()
        slot.put("/* <![CDATA[ */")
        slot.put(script_string)
        slot.put("/* ]]> */")
      end
    }
  end
end
