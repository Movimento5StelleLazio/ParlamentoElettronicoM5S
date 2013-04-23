local issues_selector = param.get("issues_selector", "table")
local member = param.get("for_member", "table") or app.session.member
local for_state = param.get("for_state")
local for_unit = param.get("for_unit", atom.boolean)


 
 
local event_max_id = param.get_all_cgi()["event_max_id"]
local event_selector = Event:new_selector()
  :add_order_by("event.id DESC")
  :limit(25)
  :join("issue", nil, "issue.id = event.issue_id")
  :add_field("now()::date - event.occurrence::date", "time_ago")
  
if event_max_id then
  event_selector:add_where{ "event.id < ?", event_max_id }
end
  
event_selector:add_where{ "event.member_id = ?",  app.session.member.id}
 

local events = event_selector:exec()

local view=param.get("view")
local direct_voter
local issue_rendered=0
 
ui.container{ attr = { class = "containerIssueDiv" },
content = function()
        
--issueDiv
 ui.paginate{
    
    per_page = tonumber(param.get("per_page") or 25),
    selector = issues_selector,
    content = function()
      local highlight_string = param.get("highlight_string", "string")
      local issues = issues_selector:exec()
      issues:load_everything_for_member_id(member and member.id or nil)

--contenitore issue
      ui.container{ attr = { class = "issues" }, content = function()

        for i, issue in ipairs(issues) do
--singola issue
                  
                  if app.session.member_id then
                        direct_voter = issue.member_info.direct_voted
                    end             
                  if direct_voter then  
                          execute.view{ module = "issue", view = "_show_ext", params = {
                            issue = issue, for_listing = true,  events=events,event_id_show=i
                          } }
                          
                          issue_rendered=issue_rendered+1
                   end
              
--spazio div         
          ui.container
          {
          attr={class="spazioIssue"},
          content=function()
          end
          }
          
        end --fine for
        
        
         if  issue_rendered==0 then     
            ui.tag{tag="pre",
                    attr={style="font-style: italic;color:grey;margin-left:135px;"},
                    content=_"No issue voted"
                    }
          end     
        
        
      end }
    end
  }
  
  end --fine containerIssue
  }
