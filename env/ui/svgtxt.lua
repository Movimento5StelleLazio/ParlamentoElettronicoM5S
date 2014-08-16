function ui.svgtxt(args)
    local args = args or {}
    local attr = table.new(args.attr)
    local svg_attr = table.new(args.svg_attr)
    local content = args.content or args.text
    svg_attr['xmlns'] = "http://www.w3.org/2000/svg"
    svg_attr['version'] = "1.1"
    svg_attr['width'] = "100%"
    svg_attr['height'] = "100%"
    svg_attr['text-anchor'] = "middle"
    attr['x'] = "50%"
    attr['y'] = "50%"
    ui.tag {
        tag = "svg",
        attr = svg_attr,
        content = function()
            ui.tag {
                tag = "text",
                attr = attr,
                content = content
            }
        end
    }
end
