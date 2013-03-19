-- ========================================================================
-- DO NOT CHANGE ANYTHING IN THIS FILE
-- (except when you really know what you are doing!)
-- ========================================================================

config.app_version = "2.2.0"

if not config.password_hash_algorithm then
  config.password_hash_algorithm = "crypt_sha512"
end

if not config.password_hash_min_rounds then
 config.password_hash_min_rounds = 10000
end

if not config.password_hash_max_rounds then
  config.password_hash_max_rounds = 20000
end

if config.enabled_languages == nil then
  config.enabled_languages = { 'en', 'de', 'eo', 'el', 'hu', 'it', 'nl', 'zh-Hans', 'zh-TW' }
end

if config.default_lang == nil then
  config.default_lang = "en"
end

if config.mail_subject_prefix == nil then
  config.mail_subject_prefix = "[LiquidFeedback] "
end

if config.member_image_content_type == nil then
  config.member_image_content_type = "image/jpeg"
end

if config.member_image_convert_func == nil then
  config.member_image_convert_func = {
    avatar = function(data) return extos.pfilter(data, "convert", "jpeg:-", "-thumbnail",   "48x48", "jpeg:-") end,
    photo =  function(data) return extos.pfilter(data, "convert", "jpeg:-", "-thumbnail", "240x240", "jpeg:-") end
  }
end

if config.locked_profile_fields == nil then
  config.locked_profile_fields = {}
end

if not config.database then
  config.database = { engine='postgresql', dbname='liquid_feedback' }
end

if not config.enable_debug_trace then
  trace.disable()
else
  slot.put_into('trace_button', '<div id="trace_show" onclick="document.getElementById(\'trace_content\').style.display=\'block\';this.style.display=\'none\';">TRACE</div>')
end


request.set_404_route{ module = 'index', view = '404' }

-- open and set default database handle
db = assert(mondelefant.connect(config.database))
at_exit(function() 
  db:close()
end)
function mondelefant.class_prototype:get_db_conn() return db end

-- enable output of SQL commands in trace system
function db:sql_tracer(command)
  return function(error_info)
    local error_info = error_info or {}
    trace.sql{ command = command, error_position = error_info.position }
  end
end

request.set_absolute_baseurl(config.absolute_base_url)


-- TODO abstraction
-- get record by id
function mondelefant.class_prototype:by_id(id)
  local selector = self:new_selector()
  selector:add_where{ 'id = ?', id }
  selector:optional_object_mode()
  return selector:exec()
end

