Classification = mondelefant.new_class()
Classification.table = 'classification'

Classification:add_reference{
  mode          = 'm1',         -- many (m) Classifications can refer to one (1) Medium
  to            = "Medium",     -- name of referenced model (quoting avoids auto-loading of model here)
  this_key      = 'medium_id',  -- our key in the classification table
  that_key      = 'id',         -- other key in the medium table
  ref           = 'medium',     -- name of reference
  back_ref      = nil,          -- not used for m1 relation!
  default_order = nil           -- not used for m1 relation!
}

Classification:add_reference{
  mode          = 'm1',        -- many (m) Classifications can refer to one (1) Medium
  to            = "Genre",     -- name of referenced model (quoting avoids auto-loading of model here)
  this_key      = 'genre_id',  -- our key in the classification table
  that_key      = 'id',        -- other key in the genre table
  ref           = 'genre',     -- name of reference
  back_ref      = nil,         -- not used for m1 relation!
  default_order = nil          -- not used for m1 relation!
}
