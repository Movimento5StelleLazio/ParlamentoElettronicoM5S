local issue = param.get("issue", "table")

execute.view{ module = "area", view = "_head", params = { area = issue.area } }
