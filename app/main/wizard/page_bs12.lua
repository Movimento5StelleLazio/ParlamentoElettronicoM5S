slot.set_layout("custom")

local area_id=param.get("area_id", atom.integer)
local unit_id=param.get("unit_id", atom.integer)
local area_name=param.get("area_name", atom.string)
local unit_name= param.get("unit_name", atom.string)
local policy_id = param.get("policy_id", atom.integer) or 0
local issue_title = param.get("issue_title", atom.string) or ""
local issue_brief_description = param.get("issue_brief_description", atom.string) or ""
local issue_keywords = param.get("issue_keywords", atom.string) or ""
local problem_description = param.get("problem_description", atom.string) or ""
local aim_description = param.get("aim_description", atom.string) or ""
local initiative_title = param.get("initiative_title", atom.string) or ""
local initiative_brief_description = param.get("initiative_brief_description", atom.string) or ""
local draft = param.get("draft", atom.string) or ""
local technical_areas = param.get("technical_areas", atom.string) or tostring(area_id)
local proposer1 = param.get("proposer1", atom.boolean) or true
local proposer2 = param.get("proposer2", atom.boolean) or true
local proposer3 = param.get("proposer3", atom.boolean) or true

-- trace di controllo sui valori dei parametri
trace.debug( "area_id: "..tostring(area_id) )
trace.debug( "area_name: "..area_name )
trace.debug( "unit_id: "..tostring(unit_id) )
trace.debug( "unit_name: "..tostring(unit_name) )
trace.debug( "policy_id: "..tostring(policy_id) )
trace.debug( "issue_title: "..issue_title )
trace.debug( "issue_brief_description: "..issue_brief_description )
trace.debug( "issue_keywords: "..issue_keywords )
trace.debug( "problem_description: "..problem_description )
trace.debug( "aim_description: "..aim_description )
trace.debug( "initiative_title: "..initiative_title )
trace.debug( "initiative_brief_description: "..initiative_brief_description )
trace.debug( "draft: "..draft )
trace.debug( "technical_areas: "..tostring(technical_areas) )
trace.debug( "proposer1: "..tostring(proposer1) )
trace.debug( "proposer2: "..tostring(proposer2) )
trace.debug( "proposer3: "..tostring(proposer3) )

ui.form {
	method = "post",
	attr = { id = "page_bs12", class = "" },
	module = 'wizard',
	action = 'create',
	params={
		area_id = area_id,
		unit_id = unit_id,
		policy_id = policy_id,
		issue_title = issue_title,
		issue_brief_description = issue_brief_description,
		issue_keywords = issue_keywords,
		problem_description = problem_description,
		aim_description = aim_description,
		initiative_title = initiative_title,
		initiative_brief_description = initiative_brief_description,
		draft = draft,
		technical_areas = technical_areas,
		proposer1 = proposer1,
		proposer2 = proposer2,
		proposer3 = proposer3,
		formatting_engine = "rocketwiki"
	},
	routing = {
		ok = {
			mode   = 'forward',
			module = 'index',
			view = 'homepage_bs'
		},
		error = {
			mode   = 'forward',
			module = 'index',
			view = 'index'
		} 
	}, 
	content=function()
	
	ui.container{attr={class="row-fluid"},content=function()
		ui.container{attr={class="span12 text-center"},content=function()
			ui.container{attr={ class  = "row-fluid" } , content = function()
				ui.container{attr={ class  = "well span12" }, content = function()
					ui.container{attr={ class  = "row-fluid" } , content = function()
						ui.container{attr={ class  = "span12" }, content = function()
							ui.heading{level=1, content = _"WIZARD HEADER END" }
						end }
					end }
					ui.container{ attr = { class  = "row-fluid spaceline3" } , content = function()
						ui.container{ attr = { class  = "span3" }, content = function()
							-- implementare "indietro"
							ui.tag {
								tag = "a",
								attr = { class="btn btn-primary btn-large table-cell fixclick"},
								content = function()
									ui.heading{level=3,attr={class="fittext_back_btn"},content=function()
										ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
										slot.put(_"Back to previous page")
								end }
							end }				
						end }
						ui.container{ attr = { class  = "span9" }, content = function()
							ui.heading{level=3, content = _"WIZARD END"}
						end }
					end }
				end }
			end }
			ui.container{attr={class="row-fluid"},content=function()
				ui.container{attr={class="span12 text-center"},content=function()
					ui.heading{level=2,attr={class="spaceline"}, content= function()
						slot.put(_"Unit"..": ".."<strong>"..unit_name.."</strong>" )
					end }
					ui.heading{level=2,content= function()
						slot.put( _"Area"..": ".."<strong>"..area_name.."</strong>" )
					end }
				end }
			end }	  
		end }
	end }

	ui.container{attr={class="row-fluid spaceline3"},content=function()
		ui.container{attr={class="span12 text-center"},content=function()
			--Selezione policy
			ui.container{ attr={class="formSelect",style=""},content=function()
					local area_policies = AllowedPolicy:get_policy_by_area_id(area_id)
					local policies = {}

					for i,k in ipairs(area_policies) do
						policies[#policies+1] = { id = k.policy_id, name = Policy:by_id(k.policy_id).name }
					end

					ui.container{attr={class="formSelect", style=""},content=function()
						ui.container{attr={class="row-fluid spaceline3"},content=function()
							ui.container{attr={class="span12 text-center"},content=function()
								ui.container{attr={class="inline-block"},content=function()
									ui.container{attr={class="text-left"},content=function()
										ui.container {attr={class="row-fluid text-center"},content=function()
										--policy selezionata cambiata
											ui.field.hidden {
												html_name = "policy_id",
												attr = { id = "policy_id" },
												value = param.get("policy_id", atom.integer) or 0
											}
											ui.field.parelon_group_radio {
												id = "policy_id",
												out_id = "policy_id",
												elements = policies,
												selected = policy_id,
												attr = {
													label_attr={ class="inline" },
													container_attr={class="span12 inline-block" }
												}
											}								
										end }
									end }
								end }                                                      
							end }
						end }
					end }
				end }
				-- Box questione
				ui.container{attr={class="row-fluid spaceline3"},content=function()
					ui.container{attr={class="span12 text-center alert alert-simple issue_box paper", style="padding-bottom:30px"},content=function()
						--Titolo box questione
						ui.container{attr={class="row-fluid spaceline3"},content=function()
							ui.container{attr={class="span4 offset1"},content=function()      
								ui.heading{ level=5, attr = { class = "alert head-orange uppercase text-center" }, content = _"QUESTIONE" }
							end }
						end }
						--Titolo questione
						ui.container{attr={class="row-fluid spaceline3"},content=function()
							ui.container{attr={class="span4 offset1 text-right"},content=function() 
								ui.tag{tag="label", content=_"Problem Title"}
						end }
						ui.container{attr={class="span6"},content=function() 
								ui.tag{tag="input",attr={id="issue_title", name="issue_title", value=issue_title, style="width:100%;"}, content=""}
							end }
						end }
						-- Descrizione breve questione
						ui.container{attr={class="row-fluid spaceline4"},content=function()
							ui.container{attr={class="span4 offset1 text-right issue_brief_span"},content=function()
								ui.tag{tag="p",content=  _"Description to the problem you want to solve"}
--									ui.tag{tag="em",content=  _"Description note"}
							end }
							ui.container{attr={class="span6 issue_brief_span"},content=function()
								ui.tag{
									tag="textarea",
									attr={id="issue_brief_description",name="issue_brief_description", style="width:100%;height:100%;resize:none;"},
									content=issue_brief_description
								}
							end }
						end }
						-- Keywords
						ui.container{attr={class="row-fluid spaceline4"},content=function()
							ui.container{attr={class="span4 offset1 text-right"},content=function()
								ui.tag{tag="p",content=  _"Keywords"}
--                     ui.tag{tag="em",content=  _"Keywords note"}
								end }
								ui.container{attr={class="span6 collapse",style="height:auto;"},content=function()
									ui.tag{
										tag="textarea",
										attr={id="issue_keywords",name="issue_keywords",class="tagsinput",style="resize:none;"},
										content=issue_keywords
									}
							end }
						end }
						-- Descrizione del problema
						ui.container{attr={class="row-fluid spaceline4"},content=function()
							ui.container{attr={class="span4 offset1 text-right issue_desc"},content=function()
								ui.tag{tag="p",content=  _"Problem description"}
--                      ui.tag{tag="em",content=  _"Problem note"}
							end }
							ui.container{attr={class="span6 issue_desc"},content=function()
								ui.tag{
									tag="textarea",
									attr={id="problem_description",name="problem_description",style="height:100%;width:100%;resize:none;"},
									content=problem_description
								}
							end }
						end }
					end }
				end }

				-- Box proposta
				ui.container{attr={class="row-fluid spaceline3"},content=function()
					ui.container{attr={class="span12 text-center alert alert-simple issue_box paper", style="padding-bottom:30px"},content=function()
						-- Titolo box proposta			  
						ui.container{attr={class="row-fluid spaceline3"},content=function()
							ui.container{attr={class="span4 offset1"},content=function()      
								ui.heading{ level=5, attr = { class = "alert head-chocolate uppercase text-center" }, content = _"PROPOSTA" }
							end }
						end }
						-- Titolo proposta
						ui.container{attr={class="row-fluid spaceline3"},content=function()
							ui.container{attr={class="span4 offset1 text-right"},content=function() 
								ui.tag{tag="label", content=_"Initiative Title"}
							end }
							ui.container{attr={class="span6"},content=function() 
								ui.tag{tag="input",attr={id="initiative_title", name="initiative_title", value=initiative_title, style="width:100%;"}, content=""}
							end }
						end }
						-- Descrizione breve proposta
						ui.container{attr={class="row-fluid spaceline3"},content=function()
							ui.container{attr={class="span4 offset1 text-right init_brief"},content=function()
								ui.tag{tag="p",content=  _"Initiative short description"}
--                      ui.tag{tag="em",content=  _"Initiative short note"}
							end }
							ui.container{attr={class="span6 init_brief"},content=function()
								ui.tag{
									tag="textarea",
									attr={id="initiative_brief_description",name="initiative_brief_description",style="height:100%;width:100%;resize:none;"},
									content=initiative_brief_description
								}
							end }
						end }
						-- Descrizione dell'obiettivo
						ui.container{attr={class="row-fluid spaceline3"},content=function()
							ui.container{attr={class="span4 offset1 text-right aim_desc"},content=function()
								ui.tag{tag="p",content=  _"Target description"}
--                      ui.tag{tag="em",content=  _"Target note"}
							end }
							ui.container{attr={class="span6 aim_desc"},content=function()
								ui.tag{
									tag="textarea",
									attr={id="aim_description",name="aim_description",style="height:100%;width:100%;resize:none;"},
									content=aim_description
								}
							end }
						end }
						-- Testo della proposta
						ui.container{attr={class="row-fluid spaceline3"},content=function()
							ui.container{attr={class="span4 offset1 text-right draft"},content=function()
								ui.tag{tag="p",content=  _"Draft text"}
--                      ui.tag{tag="em",content=  _"Draft note"}
							end }
							ui.container{attr={class="span6 draft"},content=function()
								ui.tag{
									tag="textarea",
									attr={id="draft",name="draft",style="height:100%;width:100%;resize:none;"},
									content=draft
								}
							end }
						end }
						-- Keywords competenze tecniche
						ui.container{attr={class="row-fluid spaceline4"},content=function()
							ui.container{attr={class="span4 offset1 text-right"},content=function()
								ui.tag{tag="p",content=  _"Keywords"}
--                     ui.tag{tag="em",content=  _"Keywords note"}
								end }
								ui.container{attr={class="span6 collapse",style="height:auto;"},content=function()
									ui.tag{
										tag="textarea",
										attr={id="technical_areas",name="technical_areas",class="tagsinput",style="resize:none;"},
										content=technical_areas
									}
							end }
						end }
					end }
				end }
			end }
		end }
		-- Pulsanti
		ui.container{attr={class="row-fluid"},content=function()
			ui.container{attr={class="span3 text-center",style="width: 100%;"},content=function()
				ui.container{attr={id="pulsanti" , style="position: relative;"},content=function()               
					ui.container{attr={class="row-fluid"},content=function()
						ui.container{attr={class="row-fluid"},content=function()						
							ui.container{attr={class="span3 text-center",style="margin-left: 7em;" },content=function()
								--pulsante anteprima
								ui.container{attr={id="btnAnteprima",class="btn btn-primary btn-large table-cell eq_btn fixclick",disabled="true",style="opacity:0.5;float:left;height: 103px;"},
									module = "wizard",
									view = "anteprima",
									content=function()
										ui.heading{level=4, attr = {class = "fittext_btn_wiz" },content=function()
											ui.container{attr={class="row-fluid"},content=function()
												ui.container{attr={class="span12"},content=function()
													slot.put(_"Show preview"  )
												end }
											end }
										end }
								end }
							end }
							--pulsante "Save preview"
							ui.container{attr={class="span3 text-center"},content=function()
								ui.container{
									attr={id="btnSalvaPreview",class="btn btn-primary btn-large table-cell eq_btn fixclick",disabled="true",style="opacity:0.5;float:left;height: 103px;"},
									module = "wizard",
									view = "_save_preview",
									content=function()
										ui.heading { level=4, attr = {class = "fittext_btn_wiz" }, content=function()
											ui.container { attr={class="row-fluid"}, content=function()
												ui.container { attr={class="span12"}, content=function()
													slot.put(_"Save preview"  )
												end }
											end }
										end }
								end }
							end }
							--pulsante Save
							ui.container{attr={class="span3 text-center"},content=function()
								ui.tag{
									tag="a",
										attr={id="btnSaveIssue",class="btn btn-primary btn-large table-cell eq_btn fixclick",style="float:left;cursor:pointer;height: 103px;"},
										content=function()													
										ui.heading { level=4, attr = {class = "fittext_btn_wiz" }, content=function()
											ui.container { attr={class="row-fluid"}, content=function()
												ui.container { attr={class="span12"}, content=function()
													slot.put(_"Save issue"  )
												end }
											end }																			
										end }
								end	}
							end }										 
						end	}
					end }
				end }        
		  end }
		end } 
end }	

ui.script{static="js/jquery.tagsinput.js"}
ui.script{script="$('#issue_keywords').tagsInput({'height':'96%','width':'96%','defaultText':'".._"Add a keyword".."','maxChars' : 20});"}
ui.script{script="$('#technical_areas').tagsInput({'height':'96%','width':'96%','defaultText':'".._"Add a keyword".."','maxChars' : 20});"}
