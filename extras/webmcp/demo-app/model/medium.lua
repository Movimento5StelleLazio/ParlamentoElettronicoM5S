Medium = mondelefant.new_class()
Medium.table = 'medium'

Medium:add_reference{
  mode          = 'm1',             -- many (m) Medium entries can refer to one (1) MediaType
  to            = "MediaType",      -- name of referenced model (quoting avoids auto-loading here)
  this_key      = 'media_type_id',  -- own key in medium table
  that_key      =  'id',            -- other key in media_type table
  ref           = 'media_type',     -- name of reference
  back_ref      = nil,              -- not used for m1 relation!
  default_order = nil               -- not used for m1 relation!
}

Medium:add_reference{
  mode          = '1m',               -- one (1) Medium has many (m) Classifications
  to            = "Classification",   -- name of referenced model (quoting avoids auto-loading here)
  this_key      = 'id',               -- own key in medium table
  that_key      = 'medium_id',        -- other key in classification table
  ref           = 'classifications',  -- name of reference
  back_ref      = 'medium',           -- each autoloaded classification automatically refers back to the Medium
  default_order = '"genre_id"'        -- order classifications by SQL expression "genre_id"
}

Medium:add_reference{
  mode                  = 'mm',              -- many (m) Media belong to many (m) Genres
  to                    = "Genre",           -- name of referenced model (quoting avoids auto-loading here)
  this_key              = 'id',              -- (primary) key of medium table
  that_key              = 'id',              -- (primary) key of genre talbe
  connected_by_table    = 'classification',  -- table connecting media with genres
  connected_by_this_key = 'medium_id',       -- key in classification table referencing media
  connected_by_that_key = 'genre_id',        -- key in classification table referencing genres
  ref                   = 'genres',          -- name of reference
  back_ref              = nil,               -- not used for mm relation!
  default_order         = '"genre"."name", "genre"."id"'  -- mm references need qualified names in SQL order expression!
}

Medium:add_reference{
  mode          = '1m',         -- one (1) Medium has many (m) Tracks
  to            = "Track",      -- name of referenced model (quoting avoids auto-loading here)
  this_key      = 'id',         -- own key in medium table
  that_key      = 'medium_id',  -- other key in track table
  ref           = 'tracks',     -- name of reference
  back_ref      = 'medium',     -- each autoloaded classification automatically refers back to the Medium
  default_order = '"position"'  -- order tracks by SQL expression "position"
}
