--[[--
ui.container{
  auto_args = auto_args,
  attr          = attr,           -- HTML attributes for the surrounding div or fieldset
  label         = label,          -- text to be used as label
  label_for     = label_for,      -- DOM id of element to which the label should refer
  label_attr    = label_attr,     -- extra HTML attributes for a label tag
  legend        = legend,         -- text to be used as legend
  legend_attr   = legend_attr,    -- HTML attributes for a legend tag
  content_first = content_first,  -- set to true to place label or legend after the content
  content = function()
    ...
  end
}

This function encloses content in a div element (or a fieldset element, if 'legend' is given). An additional 'label' or 'legend' can be placed before the content or after the content. The argument 'auto_args' is set by other ui helper functions when calling ui.container automatically.

--]]--

function ui.container(args)
  local attr, label, label_attr, legend, legend_attr, content
  local auto_args = args.auto_args
  if auto_args then
    attr        = auto_args.container_attr
    label       = auto_args.label
    label_attr  = auto_args.label_attr
    legend      = auto_args.legend
    legend_attr = auto_args.legend_attr
    if label and auto_args.attr and auto_args.attr.id then
      label_attr = table.new(label_attr)
      label_attr["for"] = auto_args.attr.id
    end
  else
    attr        = args.attr
    label       = args.label
    label_attr  = args.label_attr or {}
    legend      = args.legend
    legend_attr = args.legend_attr
    content     = content
    if args.label_for then
      label_attr["for"] = args.label_for
    end
  end
  local content = args.content
  if label and not legend then
    return ui.tag {
      tag     = "div",
      attr    = attr,
      content = function()
        if not args.content_first then
          ui.tag{ tag = "label", attr = label_attr, content = label }
          slot.put(" ")
        end
        if type(content) == "function" then
          content()
        elseif content then
          slot.put(encode.html(content))
        end
        if args.content_first then
          slot.put(" ")
          ui.tag{ tag = "label", attr = label_attr, content = label }
        end
      end
    }
  elseif legend and not label then
    return ui.tag {
      tag     = "fieldset",
      attr    = attr,
      content = function()
        if not args.content_first then
          ui.tag{ tag = "legend", attr = legend_attr, content = legend }
          slot.put(" ")
        end
        if type(content) == "function" then
          content()
        elseif content then
          slot.put(encode.html(content))
        end
        if args.content_first then
          slot.put(" ")
          ui.tag{ tag = "legend", attr = legend_attr, content = legend }
        end
      end
    }
  elseif fieldset and label then
    error("ui.container{...} may either get a label or a legend.")
  else
    return ui.tag{ tag = "div", attr = attr, content = content }
  end
end
