slot.put_into("title", _ "Admin menu")

ui.container{ 
		attr = {class = "row-fluid well"},
		content = function()
			ui.container {
          attr = { class = "span3" },
          content = function()
              ui.link {
                  attr = { class = "btn btn-primary btn-large large_btn fixclick" },
                  module = "index",
                  view = "index",
                  content = function()
                      ui.heading {
                          level = 3,
                          content = function()
                              ui.image { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" }
                              slot.put(_ "Back to previous page")
                          end
                      }
                  end
              }
          end
      }
  end
}
		     
ui.tag {
    tag = "ul",
    content = function()
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Policies",
                    module = "admin",
                    view = "policy_list",
                }
            end
        }
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Units",
                    module = "admin",
                    view = "unit_list",
                }
            end
        }
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Members",
                    module = "admin",
                    view = "member_list",
                }
            end
        }
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Configuration",
                    module = "admin",
                    view = "configuration",
                }
            end
        }
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Database Dumps",
                    module = "admin",
                    view = "download",
                }
            end
        }
    end
}
