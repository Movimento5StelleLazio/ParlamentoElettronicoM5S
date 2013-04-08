local opinions_selector = param.get("opinions_selector", "table")

ui.list{
  records = opinions_selector:exec(),
  columns = {
    {
      label = _"Member name",
      content = function(arg) return Member.object.ui_field_text(arg.member) end
    },
    {
      label = _"Degree",
      content = function(record)
        if record.degree == -2 then
          slot.put(_"must not")
        elseif record.degree == -1 then
          slot.put(_"should not")
        elseif record.degree == 1 then
          slot.put(_"should")
        elseif record.degree == 2 then
          slot.put(_"must")
        end
      end
    },
    {
      label = _"Suggestion currently implemented",
      content = function(record)
        if record.fulfilled then
          slot.put(_"Yes")
        else
          slot.put(_"No")
        end
      end
    },
  }
}