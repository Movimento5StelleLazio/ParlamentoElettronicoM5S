local areas = param.get("areas", "table")

if #areas > 0 then
  ui.container{
    attr = { style = "font-weight: bold;" },
    content = _"Current votings in areas you are member of and issues you are interested in:"
  }
  
  ui.list{
    records = areas,
    columns = {
      {
        name = "name"
      },
      {
        content = function(record)
          if record.is_member and record.issues_to_vote_count > 0 then
            ui.link{
              content = function()
                if record.issues_to_vote_count > 1 then
                  slot.put(_("#{issues_to_vote_count} issue(s)", { issues_to_vote_count = record.issues_to_vote_count }))
                else
                  slot.put(_("One issue"))
                end
              end,
              module = "area",
              view = "show",
              id = record.id,
              params = { 
                tab = "open",
                filter = "frozen",
                filter_interest = "any",
                filter_voting = "not_voted"
              }
            }
          else
            slot.put(_"Not a member")
          end
        end
      },
      {
        content = function(record)
          if record.interested_issues_to_vote_count > 0 then
            ui.link{
              content = function()
                if record.interested_issues_to_vote_count > 1 then
                  slot.put(_("#{interested_issues_to_vote_count} issue(s) you are interested in", { interested_issues_to_vote_count = record.interested_issues_to_vote_count }))
                else
                  slot.put(_"One issue you are interested in")
                end
              end,
              module = "area",
              view = "show",
              id = record.id,
              params = { 
                tab = "open",
                filter = "frozen",
                filter_interest = "issue",
                filter_voting = "not_voted"
              }
            }
          end
        end
      },
    }
  }
end
