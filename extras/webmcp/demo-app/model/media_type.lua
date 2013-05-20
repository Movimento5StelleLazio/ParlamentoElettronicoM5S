MediaType = mondelefant.new_class()
MediaType.table = 'media_type'

MediaType:add_reference{
  mode          = '1m',             -- one (1) MediaType is set for many (m) media
  to            = "Medium",         -- name of referenced model (quoting avoids auto-loading here)
  this_key      = 'id',             -- own key in media_type table
  that_key      = 'media_type_id',  -- other key in medium table
  ref           = 'media',          -- name of reference
  back_ref      = 'media_type',     -- each autoloaded Medium automatically refers back to the MediaType
  default_order = '"name", "id"'    -- order media by SQL expression "name", "id"
}
