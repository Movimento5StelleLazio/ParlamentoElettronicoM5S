slot.set_layout("m5s_bs")

ui.container{ attr={class="row-fluid"}, content=function()
  ui.container{ attr={class="span4 alert alert-simple"}, content=function()
    ui.tag{tag="p",content="Test"}
  end }

  ui.container{ attr={class="span4 offset4 alert alert-simple"}, content=function()
    ui.link{ 
      attr={class="btn btn-primary btn-small"},
      module="index",
      view="index",
      content=function()
        ui.heading{ level=5, content="Press me"}
      end
    }

  end }
end }


