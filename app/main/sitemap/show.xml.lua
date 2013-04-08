slot.set_layout("xml", "text/xml")

slot.put_into("default", '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')

function url(args)
  return ui.tag{
    tag = "url",
    content = function()
      ui.tag{tag = "loc",
             content = encode.url{
                base = request.get_absolute_baseurl(),
                module = args.module,
                view = args.view,
                id = args.id
              }
             }
      if args.lastmod then
        ui.tag{tag = "lastmod",
               content = args.lastmod
               }
      end
      ui.tag{tag = "changefreq",
             content = args.changefreq or "daily",
             }
      if args.priority then
        ui.tag{tag = "priority",
               content = tostring(args.priority)
               }
      end

    end
  }
end

function max(...)
  trace.debug_table(arg)
  nargs = {}
  for i = 1,1,arg.n do
    if type(arg[i]) == "number" then
      nargs[#nargs] = arg[i]
    end
  end
  if #nargs > 0 then
    return math.max(unpack(nargs))
  end
  return nil
end


areas = Area:new_selector():add_where("active='y'")

for i,area in ipairs(areas:exec()) do
  url{ module = "area", view = "show", id = area.id, priority = 0.9 }
end

-- FIXME timezone should be added as ...HH24:MI:SS+TZ with NUMERIC like +09:00

issues = Issue:new_selector()
issues:add_field("to_char(GREATEST(issue.created, issue.accepted, issue.half_frozen, issue.fully_frozen, issue.closed, issue.cleaned), 'YYYY-MM-DD\"T\"HH24:MI:SS')", "lastmod")

for i,issue in ipairs(issues:exec()) do
  url{ module = "issue", view = "show", id = issue.id, priority = 0.8,
       lastmod = tostring(issue.lastmod)
       }
end

initiatives = Initiative:new_selector()
initiatives:add_field("to_char(GREATEST(initiative.created, initiative.revoked, (select draft.created from draft where draft.initiative_id = initiative.id ORDER BY draft.created DESC LIMIT 1)), 'YYYY-MM-DD\"T\"HH24:MI:SS')", "lastmod")

for i,initiative in ipairs(initiatives:exec()) do
  url{ module = "initiative", view = "show", id = initiative.id, priority = 0.5,
       lastmod = tostring(initiative.lastmod)
       }
end

--trace.render()

slot.put_into("default", '</urlset>')

return