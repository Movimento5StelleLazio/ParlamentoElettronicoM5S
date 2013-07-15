Genre = mondelefant.new_class()
Genre.table = 'genre'

Genre:add_reference{
  mode          = '1m',               -- one (1) Genre is used for many (m) Classifications
  to            = "Classification",   -- name of referenced model (using a string instead of reference avoids auto-loading here)
  this_key      = 'id',               -- own key in genre table
  that_key      = 'genre_id',         -- other key in classification table
  ref           = 'classifications',  -- name of reference
  back_ref      = 'genre',            -- each autoloaded Classification automatically refers back to the Genre
  default_order = '"media_id"'        -- order Classifications by SQL expression "media_id"
}

Genre:add_reference{
  mode                  = 'mm',              -- many (m) Genres belong to many (m) Medium entries
  to                    = "Medium",          -- name of referenced model (quoting avoids auto-loading here)
  this_key              = 'id',              -- (primary) key of genre table
  that_key              = 'id',              -- (primary) key of medium talbe
  connected_by_table    = 'classification',  -- table connecting genres with media
  connected_by_this_key = 'genre_id',        -- key in connection table referencing genres
  connected_by_that_key = 'medium_id',       -- key in connection table referencing media
  ref                   = 'media',           -- name of reference
  back_ref              = nil,               -- not used for mm relation!
  default_order         = '"medium"."name", "medium"."id"'  -- mm references need qualified names in SQL order expression!
}
