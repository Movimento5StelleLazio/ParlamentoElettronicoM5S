-- THIS IS JUST A WORKAROUND --

local type_id = param.get_id()
local target_module = param.get("module")
local target_view = param.get("view")
local target_action = param.get("action") or nil
local target_wizard = param.get("wizard", atom.boolean) or false
local public_flag = param.get("public", atom.boolean)

config.gui_preset["custom"].public = public_flag
trace.debug(config.gui_preset["custom"].public)

if target_action ~= nil and not target_wizard then	
	execute.view{
		module = target_module,
		view = target_view,
		action = target_action,
		id = id
	}
elseif target_action == nil and not target_wizard then
	execute.view{
		module = target_module,
		view = target_view,
		id = id
	}
elseif target_action ~= nil and target_wizard then
	execute.view{
		module = target_module,
		view = target_view,
		action = target_action,
		id = id,
		params = { wizard = true }
	}
else --target_action == nil and target_wizard
	execute.view{
		module = target_module,
		view = target_view,
		id = id,
		params = { wizard = true }
	}
end
