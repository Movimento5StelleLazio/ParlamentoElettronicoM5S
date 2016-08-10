function ui.field.popover(args)
    ui.container {
        attr = args.attr.div_attr or nil,
        content = function()
            attr = table.new()
            attr["datatoggle"] = "popover"

            if args.attr.datacontent then
                attr["data-content"] = args.attr.datacontent
            end

            if args.attr.dataplacement then
                attr["data-placement"] = args.attr.dataplacement
            end

            if args.attr.class then
                attr["class"] = args.attr.class
            else
                attr["class"] = "btn btn-primary"
            end

            if args.attr.dataanimation then
                attr["data-animation"] = args.attr.dataanimation
            end

            if args.attr.datatrigger then
                attr["data-trigger"] = args.attr.datatrigger
            else
                attr["data-trigger"] = "click"
            end

            if args.attr.datacontainer then
                attr["data-container"] = args.attr.datacontainer
            end

            if args.attr.datatitle then
                attr["title data-original-title"] = args.attr.datatitle
            end

            if args.attr.datahtml then
                attr["data-html"] = args.attr.datahtml
            end

            attr["id"] = ui.create_unique_id()

            if type(args.content) == "function" then
                ui.tag {
                    tag = "a",
                    href = "#",
                    attr = attr,
                    content = function() args.content() end
                }
            else
                ui.tag {
                    tag = "a",
                    href = "#",
                    attr = attr,
                    content = args.content
                }
            end

            ui.script {
                type = "text/javascript",
                script = "$('document').ready(function(){$('#" .. tostring(attr["id"]) .. "').popover();});"
            }
        end
    }
end
