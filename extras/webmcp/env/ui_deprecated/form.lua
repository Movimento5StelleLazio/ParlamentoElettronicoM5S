--
-- Creates a formular
--
-- record          (record)   Take field values from this object (optional)
-- class           (string)   Style class (optional)
-- method          (string)   Submit method ['post', 'get'] (optional)
-- module          (string)   The module to submit to
-- action          (string)   The action to submit to
-- params          (table)    The GET parameter to be send with
-- content         (function) Function for the content of the form
--
-- Example:
--
--  ui_deprecated.form({
--    object = client,
--    class  = 'form_class',
--    method = 'post',
--    module = 'client',
--    action = 'update',
--    params = {
--      id = client.id
--    }, 
--    redirect_to = {
--      ok = {
--        module = 'client', 
--        view = 'list'
--        },
--      error = {
--        module = 'client', 
--        view = 'edit', 
--        params = { 
--          id = client.id
--        }
--      }
--    },
--  })

function ui_deprecated.form(args)
  local slot_state = slot.get_state_table()
  if slot_state.form_opened then
    error("Cannot open a form inside a form.")
  end
  slot_state.form_opened = true
  local old_record = slot_state.form_record
  slot_state.form_record = args.record or {}  -- TODO: decide what really should happen when no record is specified

  local params = {}
  if args.params then
    for key, value in pairs(args.params) do
      params[key] = value
    end
  end
  ui_deprecated._prepare_redirect_params(params, args.redirect_to)

  local attr_action = args.url or encode.url{
    module = args.module,
    view   = args.view,
    action = args.action,
    id     = args.id,
    params = params
  }

  local base = request.get_relative_baseurl()
  local attr_class = table.concat({ 'ui_form', args.class }, ' ')
  local attr_method = args.method or 'POST'  -- TODO: uppercase/sanatize method

  slot.put(
    '<form',
    ' action="', attr_action, '"',
    ' class="',  attr_class,  '"',
    ' method="', attr_method, '"',
    '>\n'
  )

  if type(args.content) == 'function' then
    args.content()
  else
    error('No content function')
  end

  slot.put('</form>')
  slot_state.form_record = old_record
  slot_state.form_opened = false

end
