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

--info box

 
 
local event_max_id = param.get_all_cgi()["event_max_id"]
local event_selector = Event:new_selector()
  :add_order_by("event.id DESC")
  :limit(25)
  :join("issue", nil, "issue.id = event.issue_id")
  :add_field("now()::date - event.occurrence::date", "time_ago")
  
if event_max_id then
  event_selector:add_where{ "event.id < ?", event_max_id }
end
  
 
 
local last_event_id
local events = event_selector: add_where{ "event.member_id = ?", app.session.member.id }:exec()

local direct_voter

 
 ui.container{ attr = { class = "containerIssueDiv" },
     content = function()
        
--issueDIv
 ui.paginate{
    
    per_page = tonumber(param.get("per_page") or 25),
    selector = issues_selector,
    content = function()
      local highlight_string = param.get("highlight_string", "string")
      local issues = issues_selector:exec()
      issues:load_everything_for_member_id(member and member.id or nil)

--contenitore issue
      ui.container{ attr = { class = "issues" }, content = function()
        
         local _issue={}
         local _events={}
         
         trace.debug("#events="..#events)
         for j,event in ipairs(events) do
                            
              if  event.member_id  ==    app.session.member.id then
                 _events[j]=event
                 trace.debug(" event.member_id == app.session.member.id :: "..event.member_id.."=="..app.session.member.id)
              end
              
         end
        
        trace.debug("#_events="..#_events)
        
        local issue_rendered=0
        for i, issue in ipairs(issues) do
--singola issue
                    if app.session.member_id then
                        direct_voter = issue.member_info.direct_voted
                    end 
                    if not direct_voter then
                    
                            if  #events>0   then
                                    
                                    for t,_e in ipairs(_events)  do
                                    
                                        if _e.issue_id==issue.id then
                                        _issue=issue
                                        end
                                    end
                                    
                                    if #_issue>0 then
                                      execute.view{ module = "issue", view = "_show_ext", params = {
                                        issue = _issue, for_listing = true, for_member = for_member , events=_events, event_id_show=i
                                      } }
                                      
                                      issue_rendered=issue_rendered+1
                                      _issue={}
                                    end
                            end  
                  end
                  
           
--spazio div         
          ui.container
          {
          attr={class="spazioIssue"},
          content=function()
          end
          }
          
        end --fine for
   --label "nessuna issue presente"    
          trace.debug("issue_rendered="..issue_rendered)  
          if  issue_rendered==0 then     
            ui.tag{tag="pre",
                    attr={style="font-style: italic;color:grey;margin-left:150px;"},
                    content=_"No initiatives suggested"
                    }
          end          
                
      end }
    end
  }
  
  end --fine containerIssue
  }
