Track = mondelefant.new_class()
Track.table = 'track'

Track:add_reference{
  mode          = 'm1',         -- many (m) Tracks can refer to one (1) Medium
  to            = "Medium",     -- name of referenced model (quoting avoids auto-loading of model here)
  this_key      = 'medium_id',  -- our key in the track table
  that_key      = 'id',         -- other key in the medium table
  ref           = 'medium',     -- name of reference
  back_ref      = nil,          -- not used for m1 relation!
  default_order = nil           -- not used for m1 relation!
}
