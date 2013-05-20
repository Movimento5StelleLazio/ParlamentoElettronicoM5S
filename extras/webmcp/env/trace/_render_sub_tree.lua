local function open(class)
  slot.put('<li class="trace_' .. class .. '">')
end
local function open_head()
  slot.put('<div class="trace_head">')
end
local function close_head()
  slot.put('</div>')
end
local function close()
  slot.put('</li>')
end
function trace._render_sub_tree(node)
  local function render_children(tail)
    if #node > 0 then
      slot.put('<ul class="trace_list">')
      for idx, child in ipairs(node) do
        trace._render_sub_tree(child)
      end
      if tail then
        slot.put(tail)
      end
      slot.put("</ul>")
    end
  end
  local function close_with_children()
    close_head()
    render_children()
    close()
  end
  local node_type = node.type
  if node_type == "root" then
    render_children()
  elseif node_type == "debug" then
    open("debug")
    slot.put(encode.html(node.message))
    close()
  elseif node_type == "debug_table" then
    open("debug")
    slot.put("<table>")
    if type(node.message) == "table" then
      for k, v in pairs(node.message) do
        slot.put("<tr><td>", encode.html(tostring(k)), "</td><td>", encode.html(tostring(v)), "</td></tr>")
      end
      slot.put("</table>")
    else
      slot.put("debug_table: not of table type")
    end
    close()
  elseif node_type == "traceback" then
    open("debug")
    slot.put('<pre>')
    slot.put(encode.html(node.message))
    slot.put('</pre>')
    close()
  elseif node_type == "request" then
    open("request")
    open_head()
    slot.put("REQUESTED")
    if node.view then
      slot.put(" VIEW")
    elseif node.action then
      slot.put(" ACTION")
    end
    slot.put(
      ": ",
      encode.html(node.module),
      "/",
      encode.html(node.view or node.action)
    )
    close_with_children()
  elseif node_type == "config" then
    open("config")
    open_head()
    slot.put('Configuration "', encode.html(node.name), '"')
    close_with_children()
  elseif node_type == "filter" then
    open("filter")
    open_head()
    slot.put(encode.html(node.path))
    close_with_children()
  elseif node_type == "view" then
    open("view")
    open_head()
    slot.put(
      "EXECUTE VIEW: ",
      encode.html(node.module),
      "/",
      encode.html(node.view)
    )
    close_with_children()
  elseif node_type == "action" then
    if
      node.status and (
        node.status == "ok" or
        string.find(node.status, "^ok_")
      )
    then
      open("action_success")
    elseif
      node.status and (
        node.status == "error" or
        string.find(node.status, "^error_")
      )
    then
      open("action_softfail")
    else
      open("action_neutral")
    end
    open_head()
    slot.put(
      "EXECUTE ACTION: ",
      encode.html(node.module),
      "/",
      encode.html(node.action)
    )
    close_head()
    if node.status == "softfail" then
      render_children(
        '<li class="trace_action_status">Status code: "' ..
        encode.html(node.failure_code) ..
        '"</li>'
      )
    else
      render_children()
    end
    close()
  elseif node_type == "redirect" then
    open("redirect")
    open_head()
    slot.put("303 REDIRECT TO VIEW: ", encode.html(node.module), "/", encode.html(node.view))
    close_with_children()
  elseif node_type == "forward" then
    open("forward")
    open_head()
    slot.put("INTERNAL FORWARD TO VIEW: ", encode.html(node.module), "/", encode.html(node.view))
    close_with_children()
  elseif node_type == "exectime" then
    open("exectime")
    open_head()
    slot.put(
      "Finished after " ..
      string.format("%.1f", extos.monotonic_hires_time() * 1000) ..
      ' ms (' ..
      string.format("%.1f", os.clock() * 1000) ..
      ' ms CPU)'
    )
    close_with_children()
  elseif node_type == "sql" then
    open("sql")
    if node.error_position then
      -- error position starts counting with 1
      local part1 = string.sub(node.command, 1, node.error_position - 1)
      --local part2 = string.sub(node.command, node.error_position - 1, node.error_position + 1)
      local part2 = string.sub(node.command, node.error_position)
      slot.put(encode.html(part1))
      slot.put('<span class="trace_error_position">&rArr;</span>')
      slot.put(encode.html(part2))
      --slot.put('</span>')
      --slot.put(encode.html(part3))
    else
      slot.put(encode.html(node.command))
    end
    close();
  elseif node_type == "error" then
    open("error")
    open_head()
    slot.put("UNEXPECTED ERROR")
    close_head()
    close()
  end
end
