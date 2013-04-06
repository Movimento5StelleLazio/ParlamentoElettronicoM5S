local issues_selector = param.get("issues_selector", "table")
local member = param.get("for_member", "table") or app.session.member
local for_member = param.get("for_member", "table")
local for_state = param.get("for_state")
local for_unit = param.get("for_unit", atom.boolean)
local for_area = param.get("for_area", atom.boolean)


if for_state == "open" then
  issues_selector:add_where("issue.closed ISNULL")
elseif for_state == "closed" then
  issues_selector:add_where("issue.closed NOTNULL")
end

---------------info box

 
 
local event_max_id = param.get_all_cgi()["event_max_id"]
local event_selector = Event:new_selector()
  :add_order_by("event.id DESC")
  :limit(25)
  :join("issue", nil, "issue.id = event.issue_id")
  :add_field("now()::date - event.occurrence::date", "time_ago")
  
if event_max_id then
  event_selector:add_where{ "event.id < ?", event_max_id }
end
  
if for_member then
  event_selector:add_where{ "event.member_id = ?", for_member.id }
elseif for_unit then
  event_selector:join("area", nil, "area.id = issue.area_id")
  event_selector:add_where{ "area.unit_id = ?", for_unit.id }
 
--elseif not global then
--  event_selector:join("event_seen_by_member", nil, { "event_seen_by_member.id = event.id AND event_seen_by_member.seen_by_member_id = ?", app.session.member_id })
end
local last_event_id

  local events = event_selector:exec()

 

 
 ui.container{ attr = { class = "containerIssueDiv" },
     content = function()
        
-------issueDIv
 ui.paginate{
    
    per_page = tonumber(param.get("per_page") or 25),
    selector = issues_selector,
    content = function()
      local highlight_string = param.get("highlight_string", "string")
      local issues = issues_selector:exec()
      issues:load_everything_for_member_id(member and member.id or nil)

------contenitore issue
      ui.container{ attr = { class = "issues" }, content = function()

        for i, issue in ipairs(issues) do
------singola issue
          execute.view{ module = "issue", view = "_show_ext", params = {
            issue = issue, for_listing = true, for_member = for_member , events=events,event_id_show=i
          } }
          
----spazio div         
          ui.container
          {
          attr={class="spazioIssue"},
          content=function()
          end
          }
          
        end
      end }
    end
  }
  
  end --fine containerIssue
  }
