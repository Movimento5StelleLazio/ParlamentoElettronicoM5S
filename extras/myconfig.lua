-- ========================================================================
-- MANDATORY (MUST BE CAREFULLY CHECKED AND PROPERLY SET!)
-- ========================================================================

-- Name of this instance, defaults to name of config file
-- ------------------------------------------------------------------------
config.instance_name = "Parlamento Elettronico Online"


-- Information about service provider (HTML)
-- ------------------------------------------------------------------------
config.app_service_provider = ""

config.gui_preset = {
  default = {
    name = "default",
    start_page = "_index_default"
  }, 
  custom = {
    name = "custom",
    start_page = "_welcome_bs",
    units = {
      eletti = {
        type_id = 1,
        unit_title = _"ELECTEDS THEMATIC AREAS",
        area_filter_title = _"CHOOSE THE ELECTEDS INITIATIVES YOU WANT TO READ:",
        assembly_title = _"#{realname}, you are now in the Regione Lazio Assembly",
        issues_desc_development =_"Electeds Initiatives In Discussion",
        issues_desc_closed = _"Electeds Initiatives Completed or Retired"
      },
      cittadini = {
        type_id = 0,
        unit_title = _"CITIZENS THEMATIC AREAS",
        area_filter_title = _"CHOOSE THE CITIZENS INITIATIVES YOU WANT TO READ:",
        assembly_title = _"#{realname}, you are now in the Regione Lazio Assembly",
        issues_desc_development =_"Citizens Initiatives In Discussion",
        issues_desc_closed = _"Citizens Initiatives Completed or Retired",
        issues_desc_admission =  _"Citizens Initiatives Looking For Supporters"
      },
      iscritti = {
        type_id = 0,
        unit_title = _"M5S MEMBERS THEMATIC AREAS",
        area_filter_title = _"CHOOSE THE MEMBERS INITIATIVES YOU WANT TO READ:",
        assembly_title = _"#{realname}, you are now in the Regione Lazio Internal Assembly",
        issues_desc_development =_"M5S Members Initiatives In Discussion",
        issues_desc_closed = _"M5S Members Initiatives Completed or Retired",
        issues_desc_admission =  _"M5S Members Initiatives Looking For Supporters"
      },
      altri_gruppi = {
        type_id = 2,
        unit_title = _"OTHER POLITICAL GROUPS THEMATIC AREAS",
        area_filter_title = _"CHOOSE THE OTHER GROUPS INITIATIVES YOU WANT TO READ:",
        assembly_title = _"#{realname}, you are now in the Regione Lazio Assembly",
        issues_desc_development =_"Other Groups Initiatives In Discussion",
        issues_desc_closed = _"Other Groups Initiatives Completed or Retired"
      }
    }
  }
}

-- A rocketwiki formatted text the user has to accept while registering
-- ------------------------------------------------------------------------
config.use_terms = "=== Terms of Use ==="


-- Checkbox(es) the user has to accept while registering
-- ------------------------------------------------------------------------
config.use_terms_checkboxes = {
  {
    name = "terms_of_use_v1",
    html = "I accept the terms of use.",
    not_accepted_error = "You have to accept the terms of use to be able to register."
  },
--  {
--    name = "extra_terms_of_use_v1",
--    html = "I accept the extra terms of use.",
--    not_accepted_error = "You have to accept the extra terms of use to be able to register."
--  }
}

  
-- Absolute base url of application
-- ------------------------------------------------------------------------
config.absolute_base_url = "https://test.parelon.com/lf"


-- Connection information for the LiquidFeedback database
-- ------------------------------------------------------------------------
config.secure_database = { 
  engine='postgresql', 
  dbname='parelon_cert', 
  host='localhost',
  port='5432',
  user='www-data'
}


-- Location of the rocketwiki binaries
-- ------------------------------------------------------------------------
config.formatting_engine_executeables = {
  rocketwiki= "/opt/rocketwiki-lqfb/rocketwiki-lqfb",
  compat = "/opt/rocketwiki-lqfb/rocketwiki-lqfb-compat"
}


-- Public access level
-- ------------------------------------------------------------------------
-- Available options:
-- "none" 
--     -> Closed user group, no public access at all
--        (except login/registration/password reset)
-- "anonymous"
--     -> Shows only initiative/suggestions texts and aggregated
--        supporter/voter counts
-- "authors_pseudonymous" 
--     -> Like anonymous, but shows screen names of authors
-- "all_pseudonymous" 
--     -> Show everything a member can see, except profile pages
-- "everything"
--     -> Show everything a member can see, including profile pages
-- ------------------------------------------------------------------------
config.public_access = "none"



-- ========================================================================
-- OPTIONAL
-- Remove leading -- to use a option
-- ========================================================================

-- List of enabled languages, defaults to available languages
-- ------------------------------------------------------------------------
-- config.enabled_languages = { 'en', 'de', 'eo', 'el', 'hu', 'it', 'nl', 'zh-Hans', 'zh-TW' }

-- Default language, defaults to "en"
-- ------------------------------------------------------------------------
config.default_lang = "it"

-- after how long is a user considered inactive and the trustee will see warning,
-- notation is according to postgresql intervals, default: no warning at all
-- ------------------------------------------------------------------------
-- config.delegation_warning_time = '6 months'

-- Prefix of all automatic mails, defaults to "[Liquid Feedback] "
-- ------------------------------------------------------------------------
config.mail_subject_prefix = "Parlamento Elettronico Online "

-- Sender of all automatic mails, defaults to system defaults
-- ------------------------------------------------------------------------
config.mail_envelope_from = "info@parelon.com"
config.mail_from = { name = "Parlamento Elettronico Online", address = "info@parelon.com" }
config.mail_reply_to = { name = "Support", address = "support@parelon.com" }

-- Configuration of password hashing algorithm (defaults to "crypt_sha512")
-- ------------------------------------------------------------------------
-- config.password_hash_algorithm = "crypt_sha512"
-- config.password_hash_algorithm = "crypt_sha256"
-- config.password_hash_algorithm = "crypt_md5"

-- Number of rounds for crypt_sha* algorithms, minimum and maximum
-- (defaults to minimum 10000 and maximum 20000)
-- ------------------------------------------------------------------------
-- config.password_hash_min_rounds = 10000
-- config.password_hash_max_rounds = 20000


-- Supply custom url for avatar/photo delivery
-- ------------------------------------------------------------------------
-- config.fastpath_url_func = nil

-- Local directory for database dumps offered for download
-- ------------------------------------------------------------------------
-- config.download_dir = nil

-- Special use terms for database dump download
-- ------------------------------------------------------------------------
-- config.download_use_terms = "=== Download use terms ===\n"

-- Use custom image conversion, defaults to ImageMagick's convert
-- ------------------------------------------------------------------------
--config.member_image_content_type = "image/jpeg"
--config.member_image_convert_func = {
--  avatar = function(data) return extos.pfilter(data, "convert", "jpeg:-", "-thumbnail",   "48x48", "jpeg:-") end,
--  photo =  function(data) return extos.pfilter(data, "convert", "jpeg:-", "-thumbnail", "240x240", "jpeg:-") end
--}

-- Display a public message of the day
-- ------------------------------------------------------------------------
-- config.motd_public = "===Message of the day===\nThe MOTD is formatted with rocket wiki"

-- Automatic issue related discussion URL
-- ------------------------------------------------------------------------
-- config.issue_discussion_url_func = function(issue)
--   return "http://example.com/discussion/issue_" .. tostring(issue.id)
-- end

-- Integration of Etherpad, disabled by default
-- ------------------------------------------------------------------------
--config.etherpad = {
--  base_url = "http://example.com:9001/",
--  api_base = "http://localhost:9001/",
--  api_key = "mysecretapikey",
--  group_id = "mygroupname",
--  cookie_path = "/"
--}

-- Free timings
-- ------------------------------------------------------------------------
-- This example expects a date string entered in the free timing field
-- by the user creating a poll, interpreting it as target date for then
-- poll and splits the remaining time at the ratio of 4:1:2
-- Please note, polling policies never have an admission phase
-- The available_func is optional, if not set any target date is allowed

config.free_timing = {
  calculate_func = function(policy, timing_string)
    function interval_by_seconds(secs)
      local secs_per_day = 60 * 60 * 24
      local days
      days = math.floor(secs / secs_per_day)
      secs = secs - days * secs_per_day
      return days .. " days " .. secs .. " seconds"
    end
    local target_date = parse.date(timing_string, atom.date)
    if not target_date then
      return false
    end
    local target_timestamp = target_date.midday
    local now = atom.timestamp:get_current()
    trace.debug(target_timestamp, now)
    local duration = target_timestamp - now
    if duration < 0 then
      return false
    end
    return {
      discussion = interval_by_seconds(duration / 7 * 4),
      verification = interval_by_seconds(duration / 7 * 1),
      voting = interval_by_seconds(duration / 7 * 2)
    }
  end,
  available_func = function(policy)
    return { 
      { name = "End of 2013", id = '2013-12-31' },
      { name = "End of 2014", id = '2014-12-31' },
      { name = "End of 2015", id = '2015-12-31' }
    }
  end
}

-- WebMCP accelerator
-- uncomment the following two lines to use C implementations of chosen
-- functions and to disable garbage collection during the request, to
-- increase speed:
-- ------------------------------------------------------------------------
-- require 'webmcp_accelerator'
-- if cgi then collectgarbage("stop") end

-- Trace debug
-- uncomment the following line to enable debug trace
config.enable_debug_trace = true

-- ========================================================================
-- Do main initialisation (DO NOT REMOVE FOLLOWING SECTION)
-- ========================================================================

execute.config("init")
