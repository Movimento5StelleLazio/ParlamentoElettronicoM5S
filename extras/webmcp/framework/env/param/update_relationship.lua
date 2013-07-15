--[[--
param.update_relationship{
  param_name        = param_name,        -- name of request GET/POST request parameters containing primary keys for model B
  id                = id,                -- value of the primary key for model A
  connecting_model  = connecting_model,  -- model used for creating/deleting entries referencing both model A and B
  own_reference     = own_reference,     -- field name for foreign key in the connecting model referencing model A 
  foreign_reference = foreign_reference  -- field name for foreign key in the connecting model referencing model B
}

This function updates a many-to-many relationship using a specified 'connecting_model' referencing both models.

--]]--

function param.update_relationship(args)
  local param_name        = args.param_name
  local id                = args.id
  local connecting_model  = args.connecting_model
  local own_reference     = args.own_reference
  local foreign_reference = args.foreign_reference
  local selected_ids = param.get_list(param_name, atom.integer)  -- TODO: support other types than integer too
  local db    = connecting_model:get_db_conn()
  local table = connecting_model:get_qualified_table()
  if #selected_ids == 0 then
    db:query{
      'DELETE FROM ' .. table .. ' WHERE "' .. own_reference .. '" = ?',
      args.id
    }
  else
    local selected_ids_sql = { sep = ", " }
    for idx, value in ipairs(selected_ids) do
      selected_ids_sql[idx] = {"?::int8", value}
    end
    db:query{
      'DELETE FROM ' .. table ..
      ' WHERE "' .. own_reference .. '" = ?' ..
      ' AND NOT "' .. foreign_reference .. '" IN ($)',
      args.id,
      selected_ids_sql
    }
    -- TODO: use VALUES SQL command, instead of this dirty array trick
    db:query{
      'INSERT INTO ' .. table ..
      ' ("' .. own_reference .. '", "' .. foreign_reference .. '")' ..
      ' SELECT ?, "subquery"."foreign" FROM (' ..
        'SELECT (ARRAY[$])[i] AS "foreign"' ..
        ' FROM generate_series(1, ?) AS "dummy"("i")' ..
        ' EXCEPT SELECT "' .. foreign_reference .. '" AS "foreign"' ..
        ' FROM ' .. table ..
        ' WHERE "' .. own_reference .. '" = ?' ..
      ') AS "subquery"',
      args.id,
      selected_ids_sql,
      #selected_ids,
      args.id
    }
  end
end
