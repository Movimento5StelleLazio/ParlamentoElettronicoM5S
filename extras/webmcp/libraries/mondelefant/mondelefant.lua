#!/usr/bin/env lua


---------------------------
-- module initialization --
---------------------------

local _G              = _G
local _VERSION        = _VERSION
local assert          = assert
local error           = error
local getmetatable    = getmetatable
local ipairs          = ipairs
local next            = next
local pairs           = pairs
local print           = print
local rawequal        = rawequal
local rawget          = rawget
local rawlen          = rawlen
local rawset          = rawset
local select          = select
local setmetatable    = setmetatable
local tonumber        = tonumber
local tostring        = tostring
local type            = type

local math            = math
local string          = string
local table           = table

local add             = table.insert

local _M = require("mondelefant_native")
if _ENV then
  _ENV = _M
else
  _G[...] = _M
  setfenv(1, _M)
end



---------------
-- selectors --
---------------

selector_metatable = {}
selector_prototype = {}
selector_metatable.__index = selector_prototype

local function init_selector(self, db_conn)
  self._db_conn = db_conn
  self._mode = "list"
  self._with = { sep = ", " }
  self._fields = { sep = ", " }
  self._distinct = false
  self._distinct_on = {sep = ", ", expression}
  self._from = { sep = " " }
  self._where = { sep = ") AND (" }
  self._group_by = { sep = ", " }
  self._having = { sep = ") AND (" }
  self._combine = { sep = " " }
  self._order_by = { sep = ", " }
  self._limit = nil
  self._offset = nil
  self._read_lock = { sep = ", " }
  self._write_lock = { sep = ", " }
  self._class = nil
  self._attach = nil
  return self
end

--[[--
selector =                  -- new selector
<db_handle>:new_selector()

Creates a new selector to operate on the given database handle.
--]]--
function connection_prototype:new_selector()
  return init_selector(setmetatable({}, selector_metatable), self)
end
--//--

--[[--
db_handle =                  -- handle of database connection
<db_selector>:get_db_conn()

Returns the database connection handle used by a selector.

--]]--
function selector_prototype:get_db_conn()
  return self._db_conn
end
--//--

-- TODO: selector clone?

--[[--
db_selector =                       -- same selector returned
<db_selector>:single_object_mode()

Sets selector to single object mode (mode "object" passed to "query" method of database handle). The selector is modified and returned.

--]]--
function selector_prototype:single_object_mode()
  self._mode = "object"
  return self
end
--//--

--[[--
db_selector =                         -- same selector returned
<db_selector>:optional_object_mode()

Sets selector to single object mode (mode "opt_object" passed to "query" method of database handle). The selector is modified and returned.

--]]--
function selector_prototype:optional_object_mode()
  self._mode = "opt_object"
  return self
end
--//--

--[[--
db_selector =                    -- same selector returned
<db_selector>:empty_list_mode()

Sets selector to empty list mode. The selector is modified and returned. When using the selector, no SQL query will be issued, but instead an empty database result list is returned.

--]]--
function selector_prototype:empty_list_mode()
  self._mode = "empty_list"
  return self
end
--//--

--[[--
db_selector =
<db_selector>:add_with(
  expression = expression,
  selector   = selector
)

Adds an WITH RECURSIVE expression to the selector. The selector is modified and returned.
--]]--
function selector_prototype:add_with(expression, selector)
  add(self._with, {"$ AS ($)", {expression}, {selector}})
  return self
end
--//--

--[[--
db_selector =                   -- same selector returned
<db_selector>:add_distinct_on(
  expression                    -- expression as passed to "assemble_command"
)

Adds an DISTINCT ON expression to the selector. The selector is modified and returned.

--]]--
function selector_prototype:add_distinct_on(expression)
  if self._distinct then
    error("Can not combine DISTINCT with DISTINCT ON.")
  end
  add(self._distinct_on, expression)
  return self
end
--//--

--[[--
db_selector =                -- same selector returned
<db_selector>:set_distinct()

Sets selector to perform a SELECT DISTINCT instead of SELECT (ALL). The selector is modified and returned. This mode can not be combined with DISTINCT ON.

--]]--
function selector_prototype:set_distinct()
  if #self._distinct_on > 0 then
    error("Can not combine DISTINCT with DISTINCT ON.")
  end
  self._distinct = true
  return self
end
--//--

--[[--
db_selector =             -- same selector returned
<db_selector>:add_from(
  expression,             -- expression as passed to "assemble_command"
  alias,                  -- optional alias expression as passed to "assemble_command"
  condition               -- optional condition expression as passed to "assemble_command"
)

Adds expressions for FROM clause to the selector. The selector is modified and returned. If an additional condition is given, an INNER JOIN will be used, otherwise a CROSS JOIN.

This method is identical to "join".

--]]--
function selector_prototype:add_from(expression, alias, condition)
  local first = (#self._from == 0)
  if not first then
    if condition then
      add(self._from, "INNER JOIN")
    else
      add(self._from, "CROSS JOIN")
    end
  end
  if getmetatable(expression) == selector_metatable then
    if alias then
      add(self._from, {'($) AS "$"', {expression}, {alias}})
    else
      add(self._from, {'($) AS "subquery"', {expression}})
    end
  else
    if alias then
      add(self._from, {'$ AS "$"', {expression}, {alias}})
    else
      add(self._from, expression)
    end
  end
  if condition then
    if first then
      self:add_where(condition)
    else
      add(self._from, "ON")
      add(self._from, condition)
    end
  end
  return self
end
--//--

--[[--
db_selector =             -- same selector returned
<db_selector>:add_where(
  expression              -- expression as passed to "assemble_command"
)

Adds expressions for WHERE clause to the selector. The selector is modified and returned. Multiple calls cause expressions to be AND-combined.

--]]--
function selector_prototype:add_where(expression)
  add(self._where, expression)
  return self
end
--//--

--[[--
db_selector =                -- same selector returned
<db_selector>:add_group_by(
  expression                 -- expression as passed to "assemble_command"
)

Adds expressions for GROUP BY clause to the selector. The selector is modified and returned.

--]]--
function selector_prototype:add_group_by(expression)
  add(self._group_by, expression)
  return self
end
--//--

--[[--
db_selector =              -- same selector returned
<db_selector>:add_having(
  expression               -- expression as passed to "assemble_command"
)

Adds expressions for HAVING clause to the selector. The selector is modified and returned. Multiple calls cause expressions to be AND-combined.

--]]--
function selector_prototype:add_having(expression)
  add(self._having, expression)
  return self
end
--//--

--[[--
db_selector =               -- same selector returned
<db_selector>:add_combine(
  expression                -- expression as passed to "assemble_command"
)

This function is used for UNION/INTERSECT/EXCEPT clauses. It does not need to be called directly. Use "union", "union_all", "intersect", "intersect_all", "except" and "except_all" instead.

--]]--
function selector_prototype:add_combine(expression)
  add(self._combine, expression)
  return self
end
--//--

--[[--
db_selector =                -- same selector returned
<db_selector>:add_order_by(
  expression                 -- expression as passed to "assemble_command"
)

Adds expressions for ORDER BY clause to the selector. The selector is modified and returned.

--]]--
function selector_prototype:add_order_by(expression)
  add(self._order_by, expression)
  return self
end
--//--

--[[--
db_selector =         -- same selector returned
<db_selector>:limit(
  count               -- integer used as LIMIT
)

Limits the number of rows to a given number, by using LIMIT. The selector is modified and returned.

--]]--
function selector_prototype:limit(count)
  if type(count) ~= "number" or count % 1 ~= 0 then
    error("LIMIT must be an integer.")
  end
  self._limit = count
  return self
end
--//--

--[[--
db_selector =          -- same selector returned
<db_selector>:offset(
  count                -- integer used as OFFSET
)

Skips a given number of rows, by using OFFSET. The selector is modified and returned.

--]]--
function selector_prototype:offset(count)
  if type(count) ~= "number" or count % 1 ~= 0 then
    error("OFFSET must be an integer.")
  end
  self._offset = count
  return self
end
--//--

--[[--
db_selector =              -- same selector returned
<db_selector>:for_share()

Adds FOR SHARE to the statement, to share-lock all rows read. The selector is modified and returned.

--]]--
function selector_prototype:for_share()
  self._read_lock.all = true
  return self
end
--//--

--[[--
db_selector =                -- same selector returned
<db_selector>:for_share_of(
  expression                 -- expression as passed to "assemble_command"
)

Adds FOR SHARE OF to the statement, to share-lock all rows read by the named table(s). The selector is modified and returned.

--]]--
function selector_prototype:for_share_of(expression)
  add(self._read_lock, expression)
  return self
end
--//--

--[[--
db_selector =               -- same selector returned
<db_selector>:for_update()

Adds FOR UPDATE to the statement, to exclusivly lock all rows read. The selector is modified and returned.

--]]--
function selector_prototype:for_update()
  self._write_lock.all = true
  return self
end
--//--

--[[--
db_selector =                 -- same selector returned
<db_selector>:for_update_of(
  expression                  -- expression as passed to "assemble_command"
)

Adds FOR SHARE OF to the statement, to exclusivly lock all rows read by the named table(s). The selector is modified and returned.

--]]--
function selector_prototype:for_update_of(expression)
  add(self._write_lock, expression)
  return self
end
--//--

--[[--
db_selector =                 -- same selector returned
<db_selector>:reset_fields()

This method removes all fields added by method "add_field". The selector is modified and returned.

--]]--
function selector_prototype:reset_fields()
  for idx in ipairs(self._fields) do
    self._fields[idx] = nil
  end
  return self
end
--//--

--[[--
db_selector =             -- same selector returned
<db_selector>:add_field(
  expression,             -- expression as passed to "assemble_command"
  alias,                  -- optional alias expression as passed to "assemble_command"
  option_list             -- optional list of options (may contain strings "distinct" or "grouped")
)

Adds fields to the selector. The selector is modified and returned. The third argument can be a list of options. If option "distinct" is given, then "add_distinct_on" will be executed for the given field or alias. If option "grouped" is given, then "add_group_by" will be executed for the given field or alias.

--]]--
function selector_prototype:add_field(expression, alias, options)
  if alias then
    add(self._fields, {'$ AS "$"', {expression}, {alias}})
  else
    add(self._fields, expression)
  end
  if options then
    for i, option in ipairs(options) do
      if option == "distinct" then
        if alias then
          self:add_distinct_on('"' .. alias .. '"')
        else
          self:add_distinct_on(expression)
        end
      elseif option == "grouped" then
        if alias then
          self:add_group_by('"' .. alias .. '"')
        else
          self:add_group_by(expression)
        end
      else
        error("Unknown option '" .. option .. "' to add_field method.")
      end
    end
  end
  return self
end
--//--

--[[--
db_selector =        -- same selector returned
<db_selector>:join(
  expression,        -- expression as passed to "assemble_command"
  alias,             -- optional alias expression as passed to "assemble_command"
  condition          -- optional condition expression as passed to "assemble_command"
)

Adds expressions for FROM clause to the selector. The selector is modified and returned. If an additional condition is given, an INNER JOIN will be used, otherwise a CROSS JOIN.

This method is identical to "add_from".

--]]--
function selector_prototype:join(...)  -- NOTE: alias for add_from
  return self:add_from(...)
end
--//--

--[[--
db_selector =        -- same selector returned
<db_selector>:from(
  expression,        -- expression as passed to "assemble_command"
  alias,             -- optional alias expression as passed to "assemble_command"
  condition          -- optional condition expression as passed to "assemble_command"
)

Adds the first expression for FROM clause to the selector. The selector is modified and returned. If an additional condition is given, an INNER JOIN will be used, otherwise a CROSS JOIN.

This method is identical to "add_from" or "join", except that an error is thrown, if there is already any FROM expression existent.

--]]--
function selector_prototype:from(expression, alias, condition)
  if #self._from > 0 then
    error("From-clause already existing (hint: try join).")
  end
  return self:join(expression, alias, condition)
end
--//--

--[[--
db_selector =             -- same selector returned
<db_selector>:left_join(
  expression,             -- expression as passed to "assemble_command"
  alias,                  -- optional alias expression as passed to "assemble_command"
  condition               -- optional condition expression as passed to "assemble_command"
)

Adds expressions for FROM clause to the selector using a LEFT OUTER JOIN. The selector is modified and returned.

--]]--
function selector_prototype:left_join(expression, alias, condition)
  local first = (#self._from == 0)
  if not first then
    add(self._from, "LEFT OUTER JOIN")
  end
  if alias then
    add(self._from, {'$ AS "$"', {expression}, {alias}})
  else
    add(self._from, expression)
  end
  if condition then
    if first then
      self:add_where(condition)
    else
      add(self._from, "ON")
      add(self._from, condition)
    end
  end
  return self
end
--//--

--[[--
db_selector =         -- same selector returned
<db_selector>:union(
  expression          -- expression or selector without ORDER BY, LIMIT, FOR UPDATE or FOR SHARE
)

This method adds an UNION clause to the given selector. The selector is modified and returned. The selector (or expression) passed as argument to this function shall not contain any ORDER BY, LIMIT, FOR UPDATE or FOR SHARE clauses.

--]]--
function selector_prototype:union(expression)
  self:add_combine{"UNION $", {expression}}
  return self
end
--//--

--[[--
db_selector =             -- same selector returned
<db_selector>:union_all(
  expression              -- expression or selector without ORDER BY, LIMIT, FOR UPDATE or FOR SHARE
)

This method adds an UNION ALL clause to the given selector. The selector is modified and returned. The selector (or expression) passed as argument to this function shall not contain any ORDER BY, LIMIT, FOR UPDATE or FOR SHARE clauses.

--]]--
function selector_prototype:union_all(expression)
  self:add_combine{"UNION ALL $", {expression}}
  return self
end
--//--

--[[--
db_selector =             -- same selector returned
<db_selector>:intersect(
  expression              -- expression or selector without ORDER BY, LIMIT, FOR UPDATE or FOR SHARE
)

This method adds an INTERSECT clause to the given selector. The selector is modified and returned. The selector (or expression) passed as argument to this function shall not contain any ORDER BY, LIMIT, FOR UPDATE or FOR SHARE clauses.

--]]--
function selector_prototype:intersect(expression)
  self:add_combine{"INTERSECT $", {expression}}
  return self
end
--//--

--[[--
db_selector =                 -- same selector returned
<db_selector>:intersect_all(
  expression                  -- expression or selector without ORDER BY, LIMIT, FOR UPDATE or FOR SHARE
)

This method adds an INTERSECT ALL clause to the given selector. The selector is modified and returned. The selector (or expression) passed as argument to this function shall not contain any ORDER BY, LIMIT, FOR UPDATE or FOR SHARE clauses.

--]]--
function selector_prototype:intersect_all(expression)
  self:add_combine{"INTERSECT ALL $", {expression}}
  return self
end
--//--

--[[--
db_selector =          -- same selector returned
<db_selector>:except(
  expression           -- expression or selector without ORDER BY, LIMIT, FOR UPDATE or FOR SHARE
)

This method adds an EXCEPT clause to the given selector. The selector is modified and returned. The selector (or expression) passed as argument to this function shall not contain any ORDER BY, LIMIT, FOR UPDATE or FOR SHARE clauses.

--]]--
function selector_prototype:except(expression)
  self:add_combine{"EXCEPT $", {expression}}
  return self
end
--//--

--[[--
db_selector =              -- same selector returned
<db_selector>:except_all(
  expression               -- expression or selector without ORDER BY, LIMIT, FOR UPDATE or FOR SHARE
)

This method adds an EXCEPT ALL clause to the given selector. The selector is modified and returned. The selector (or expression) passed as argument to this function shall not contain any ORDER BY, LIMIT, FOR UPDATE or FOR SHARE clauses.

--]]--
function selector_prototype:except_all(expression)
  self:add_combine{"EXCEPT ALL $", {expression}}
  return self
end
--//--

--[[--
db_selector =             -- same selector returned
<db_selector>:set_class(
  class                   -- database class (model)
)

This method makes the selector to return database result lists or objects of the given database class (model). The selector is modified and returned.

--]]--
function selector_prototype:set_class(class)
  self._class = class
  return self
end
--//--

--[[--
db_selector =          -- same selector returned
<db_selector>:attach(
  mode,                -- attachment type: "11" one to one, "1m" one to many, "m1" many to one
  data2,               -- other database result list or object, the results of this selector shall be attached with
  field1,              -- field name(s) in result list or object of this selector used for attaching
  field2,              -- field name(s) in "data2" used for attaching
  ref1,                -- name of reference field in the results of this selector after attaching
  ref2                 -- name of reference field in "data2" after attaching
)

This method causes database result lists or objects of this selector to be attached with other database result lists after execution. This method does not need to be called directly.

--]]--
function selector_prototype:attach(mode, data2, field1, field2, ref1, ref2)
  self._attach = {
    mode = mode,
    data2 = data2,
    field1 = field1,
    field2 = field2,
    ref1 = ref1,
    ref2 = ref2
  }
  return self
end
--//--

function selector_metatable:__tostring()
  local parts = {sep = " "}
  if #self._with > 0 then
    add(parts, {"WITH RECURSIVE $", self._with})
  end
  add(parts, "SELECT")
  if self._distinct then
    add(parts, "DISTINCT")
  elseif #self._distinct_on > 0 then
    add(parts, {"DISTINCT ON ($)", self._distinct_on})
  end
  add(parts, {"$", self._fields})
  if #self._from > 0 then
    add(parts, {"FROM $", self._from})
  end
  if #self._mode == "empty_list" then
    add(parts, "WHERE FALSE")
  elseif #self._where > 0 then
    add(parts, {"WHERE ($)", self._where})
  end
  if #self._group_by > 0 then
    add(parts, {"GROUP BY $", self._group_by})
  end
  if #self._having > 0 then
    add(parts, {"HAVING ($)", self._having})
  end
  for i, v in ipairs(self._combine) do
    add(parts, v)
  end
  if #self._order_by > 0 then
    add(parts, {"ORDER BY $", self._order_by})
  end
  if self._mode == "empty_list" then
    add(parts, "LIMIT 0")
  elseif self._mode ~= "list" then
    add(parts, "LIMIT 1")
  elseif self._limit then
    add(parts, "LIMIT " .. self._limit)
  end
  if self._offset then
    add(parts, "OFFSET " .. self._offset)
  end
  if self._write_lock.all then
    add(parts, "FOR UPDATE")
  else
    if self._read_lock.all then
      add(parts, "FOR SHARE")
    elseif #self._read_lock > 0 then
      add(parts, {"FOR SHARE OF $", self._read_lock})
    end
    if #self._write_lock > 0 then
      add(parts, {"FOR UPDATE OF $", self._write_lock})
    end
  end
  return self._db_conn:assemble_command{"$", parts}
end

--[[--
db_error,                 -- database error object, or nil in case of success
result =                  -- database result list or object
<db_selector>:try_exec()

This method executes the selector on its database. First return value is an error object or nil in case of success. Second return value is the result list or object.

--]]--
function selector_prototype:try_exec()
  if self._mode == "empty_list" then
    if self._class then
      return nil, self._class:create_list()
    else
       return nil, self._db_conn:create_list()
    end
  end
  local db_error, db_result = self._db_conn:try_query(self, self._mode)
  if db_error then
    return db_error
  elseif db_result then
    if self._class then set_class(db_result, self._class) end
    if self._attach then
      attach(
        self._attach.mode,
        db_result,
        self._attach.data2,
        self._attach.field1,
        self._attach.field2,
        self._attach.ref1,
        self._attach.ref2
      )
    end
    return nil, db_result
  else
    return nil
  end
end
--//--

--[[--
result =              -- database result list or object
<db_selector>:exec()

This method executes the selector on its database. The result list or object is returned on success, otherwise an error is thrown.

--]]--
function selector_prototype:exec()
  local db_error, result = self:try_exec()
  if db_error then
    db_error:escalate()
  else
    return result
  end
end
--//--

--[[--
count =                -- number of rows returned
<db_selector>:count()

This function wraps the given selector inside a subquery to count the number of rows returned by the database. NOTE: The result is cached inside the selector, thus the selector should NOT be modified afterwards.

--]]--
function selector_prototype:count()
  if not self._count then
    local count_selector = self:get_db_conn():new_selector()
    count_selector:add_field('count(1)')
    count_selector:add_from(self)
    count_selector:single_object_mode()
    self._count = count_selector:exec().count
  end
  return self._count
end
--//--



-----------------
-- attachments --
-----------------

local function attach_key(row, fields)
  local t = type(fields)
  if t == "string" then
    return tostring(row[fields])
  elseif t == "table" then
    local r = {}
    for idx, field in ipairs(fields) do
      r[idx] = string.format("%q", row[field])
    end
    return table.concat(r)
  else
    error("Field information for 'mondelefant.attach' is neither a string nor a table.")
  end
end

--[[--
mondelefant.attach(
  mode,              -- attachment type: "11" one to one, "1m" one to many, "m1" many to one
  data1,             -- first database result list or object
  data2,             -- second database result list or object
  key1,              -- field name(s) in first result list or object used for attaching
  key2,              -- field name(s) in second result list or object used for attaching
  ref1,              -- name of reference field to be set in first database result list or object
  ref2               -- name of reference field to be set in second database result list or object
)

This function attaches database result lists/objects with each other. It does not need to be called directly.

--]]--
function attach(mode, data1, data2, key1, key2, ref1, ref2)
  local many1, many2
  if mode == "11" then
    many1 = false
    many2 = false
  elseif mode == "1m" then
    many1 = false
    many2 = true
  elseif mode == "m1" then
    many1 = true
    many2 = false
  elseif mode == "mm" then
    many1 = true
    many2 = true
  else
    error("Unknown mode specified for 'mondelefant.attach'.")
  end
  local list1, list2
  if data1._type == "object" then
    list1 = { data1 }
  elseif data1._type == "list" then
    list1 = data1
  else
    error("First result data given to 'mondelefant.attach' is invalid.")
  end
  if data2._type == "object" then
    list2 = { data2 }
  elseif data2._type == "list" then
    list2 = data2
  else
    error("Second result data given to 'mondelefant.attach' is invalid.")
  end
  local hash1 = {}
  local hash2 = {}
  if ref2 then
    for i, row in ipairs(list1) do
      local key = attach_key(row, key1)
      local list = hash1[key]
      if not list then list = {}; hash1[key] = list end
      list[#list + 1] = row
    end
  end
  if ref1 then
    for i, row in ipairs(list2) do
      local key = attach_key(row, key2)
      local list = hash2[key]
      if not list then list = {}; hash2[key] = list end
      list[#list + 1] = row
    end
    for i, row in ipairs(list1) do
      local key = attach_key(row, key1)
      local matching_rows = hash2[key]
      if many2 then
        local list = data2._connection:create_list(matching_rows)
        list._class = data2._class
        row._ref[ref1] = list
      elseif matching_rows and #matching_rows == 1 then
        row._ref[ref1] = matching_rows[1]
      else
        row._ref[ref1] = false
      end
    end
  end
  if ref2 then
    for i, row in ipairs(list2) do
      local key = attach_key(row, key2)
      local matching_rows = hash1[key]
      if many1 then
        local list = data1._connection:create_list(matching_rows)
        list._class = data1._class
        row._ref[ref2] = list
      elseif matching_rows and #matching_rows == 1 then
        row._ref[ref2] = matching_rows[1]
      else
        row._ref[ref2] = false
      end
    end
  end
end
--//--



------------------
-- model system --
------------------

--[[--
<db_class>.primary_key

Primary key of a database class (model). Defaults to "id".

--]]--
class_prototype.primary_key = "id"
--//--

--[[--
db_handle =               -- database connection handle used by this class
<db_class>:get_db_conn()

By implementing this method for a particular model or overwriting it in the default prototype "mondelefant.class_prototype", classes are connected with a particular database. This method needs to return a database connection handle. If it is not overwritten, an error is thrown, when invoking this method.

--]]--
function class_prototype:get_db_conn()
  error(
    "Method mondelefant class(_prototype):get_db_conn() " ..
    "has to be implemented."
  )
end
--//--

--[[--
string =                          -- string of form '"schemaname"."tablename"' or '"tablename"'
<db_class>:get_qualified_table()

This method returns a string with the (double quoted) qualified table name used to store objects of this class.

--]]--
function class_prototype:get_qualified_table()
  if not self.table then error "Table unknown." end
  if self.schema then
    return '"' .. self.schema .. '"."' .. self.table .. '"'
  else
    return '"' .. self.table .. '"'
  end
end
--]]--

--[[--
string =                                  -- single quoted string of form "'schemaname.tablename'" or "'tablename'"
<db_class>:get_qualified_table_literal()

This method returns a string with an SQL literal representing the given table. It causes ambiguities when the table name contains a dot (".") character.

--]]--
function class_prototype:get_qualified_table_literal()
  if not self.table then error "Table unknown." end
  if self.schema then
    return self.schema .. '.' .. self.table
  else
    return self.table
  end
end
--//--

--[[--
list =                             -- list of column names of primary key
<db_class>:get_primary_key_list()

This method returns a list of column names of the primary key.

--]]--
function class_prototype:get_primary_key_list()
  local primary_key = self.primary_key
  if type(primary_key) == "string" then
    return {primary_key}
  else
    return primary_key
  end
end
--//--

--[[--
columns =                 -- list of columns
<db_class>:get_columns()

This method returns a list of column names of the table used for the class.

--]]--
function class_prototype:get_columns()
  if self._columns then
    return self._columns
  end
  local selector = self:get_db_conn():new_selector()
  selector:set_class(self)
  selector:from(self:get_qualified_table())
  selector:add_field("*")
  selector:add_where("FALSE")
  local db_result = selector:exec()
  local connection = db_result._connection
  local columns = {}
  for idx, info in ipairs(db_result._column_info) do
    local key   = info.field_name
    local value = {
      name = key,
      type = connection.type_mappings[info.type]
    }
    columns[key] = value
    table.insert(columns, value)
  end
  self._columns = columns
  return columns
end
--//--

--[[--
selector =                -- new selector for selecting objects of this class
<db_class>:new_selector(
  db_conn                 -- optional(!) database connection handle, defaults to result of :get_db_conn()
)

This method creates a new selector for selecting objects of the class.

--]]--
function class_prototype:new_selector(db_conn)
  local selector = (db_conn or self:get_db_conn()):new_selector()
  selector:set_class(self)
  selector:from(self:get_qualified_table())
  selector:add_field(self:get_qualified_table() .. ".*")
  return selector
end
--//--

--[[--
db_list =                 -- database result being an empty list
<db_class>:create_list()

Creates an empty database result representing a list of objects of the given class.

--]]--
function class_prototype:create_list()
  local list = self:get_db_conn():create_list()
  list._class = self
  return list
end
--//--

--[[--
db_object =       -- database object (instance of model)
<db_class>:new()

Creates a new object of the given class.

--]]--
function class_prototype:new()
  local object = self:get_db_conn():create_object()
  object._class = self
  object._new = true
  return object
end
--//--

--[[--
db_error =              -- database error object, or nil in case of success
<db_object>:try_save()

This method saves changes to an object in the database. Returns nil on success, otherwise an error object is returned.

--]]--
function class_prototype.object:try_save()
  if not self._class then
    error("Cannot save object: No class information available.")
  end
  local primary_key = self._class:get_primary_key_list()
  local primary_key_sql = { sep = ", " }
  for idx, value in ipairs(primary_key) do
    primary_key_sql[idx] = '"' .. value .. '"'
  end
  if self._new then
    local fields = {sep = ", "}
    local values = {sep = ", "}
    for key, dummy in pairs(self._dirty or {}) do
      add(fields, {'"$"', {key}})
      add(values, {'?', self[key]})
    end
    if compat_returning then  -- compatibility for PostgreSQL 8.1
      local db_error, db_result1, db_result2 = self._connection:try_query(
        {
          'INSERT INTO $ ($) VALUES ($)',
          {self._class:get_qualified_table()},
          fields,
          values,
          primary_key_sql
        },
        "list",
        {
          'SELECT currval(?)',
          self._class.table .. '_id_seq'
        },
        "object"
      )
      if db_error then
        return db_error
      end
      self.id = db_result2.id
    else
      local db_error, db_result
      if #fields == 0 then
        db_error, db_result = self._connection:try_query(
          {
            'INSERT INTO $ DEFAULT VALUES RETURNING ($)',
            {self._class:get_qualified_table()},
            primary_key_sql
          },
          "object"
        )
      else
        db_error, db_result = self._connection:try_query(
          {
            'INSERT INTO $ ($) VALUES ($) RETURNING ($)',
            {self._class:get_qualified_table()},
            fields,
            values,
            primary_key_sql
          },
          "object"
        )
      end
      if db_error then
        return db_error
      end
      for idx, value in ipairs(primary_key) do
        self[value] = db_result[value]
      end
    end
    self._new = false
  else
    local command_sets = {sep = ", "}
    for key, dummy in pairs(self._dirty or {}) do
      add(command_sets, {'"$" = ?', {key}, self[key]})
    end
    if #command_sets >= 1 then
      local primary_key_compare = {sep = " AND "}
      for idx, value in ipairs(primary_key) do
        primary_key_compare[idx] = {
          "$ = ?",
          {'"' .. value .. '"'},
          self[value]
        }
      end
      local db_error = self._connection:try_query{
        'UPDATE $ SET $ WHERE $',
        {self._class:get_qualified_table()},
        command_sets,
        primary_key_compare
      }
      if db_error then
        return db_error
      end
    end
  end
  return nil
end
--//--

--[[--
<db_object>:save()

This method saves changes to an object in the database. Throws error, unless successful.

--]]--
function class_prototype.object:save()
  local db_error = self:try_save()
  if db_error then
    db_error:escalate()
  end
  return self
end
--//--

--[[--
db_error =                 -- database error object, or nil in case of success
<db_object>:try_destroy()

This method deletes an object in the database. Returns nil on success, otherwise an error object is returned.

--]]--
function class_prototype.object:try_destroy()
  if not self._class then
    error("Cannot destroy object: No class information available.")
  end
  local primary_key = self._class:get_primary_key_list()
  local primary_key_compare = {sep = " AND "}
  for idx, value in ipairs(primary_key) do
    primary_key_compare[idx] = {
      "$ = ?",
      {'"' .. value .. '"'},
      self[value]
    }
  end
  return self._connection:try_query{
    'DELETE FROM $ WHERE $',
    {self._class:get_qualified_table()},
    primary_key_compare
  }
end
--//--

--[[--
<db_object>:destroy()

This method deletes an object in the database. Throws error, unless successful.

--]]--
function class_prototype.object:destroy()
  local db_error = self:try_destroy()
  if db_error then
    db_error:escalate()
  end
  return self
end
--//--

--[[--
db_selector =
<db_list>:get_reference_selector(
  ref_name,                        -- name of reference (e.g. "children")
  options,                         -- table options passed to the reference loader (e.g. { order = ... })
  ref_alias,                       -- optional alias for the reference (e.g. "ordered_children")
  back_ref_alias                   -- back reference name (e.g. "parent")
)

This method returns a special selector for selecting referenced objects. It is prepared in a way, that on execution of the selector, all returned objects are attached with the objects of the existent list. The "ref" and "back_ref" arguments passed to "add_reference" are used for the attachment, unless aliases are given with "ref_alias" and "back_ref_alias". If "options" are set, these options are passed to the reference loader. The default reference loader supports only one option named "order". If "order" is set to nil, the default order is used, if "order" is set to false, no ORDER BY statment is included in the selector, otherwise the given expression is used for ordering.

This method is not only available for database result lists but also for database result objects.

--]]--
function class_prototype.list:get_reference_selector(
  ref_name, options, ref_alias, back_ref_alias
)
  local ref_info = self._class.references[ref_name]
  if not ref_info then
    error('Reference with name "' .. ref_name .. '" not found.')
  end
  local selector = ref_info.selector_generator(self, options or {})
  local mode = ref_info.mode
  if mode == "mm" or mode == "1m" then
    mode = "m1"
  elseif mode == "m1" then
    mode = "1m"
  end
  local ref_alias = ref_alias
  if ref_alias == false then
    ref_alias = nil
  elseif ref_alias == nil then
    ref_alias = ref_name
  end
  local back_ref_alias
  if back_ref_alias == false then
    back_ref_alias = nil
  elseif back_ref_alias == nil then
    back_ref_alias = ref_info.back_ref
  end
  selector:attach(
    mode,
    self,
    ref_info.that_key,                   ref_info.this_key,
    back_ref_alias or ref_info.back_ref, ref_alias or ref_name
  )
  return selector
end
--//--

--[[--
db_list_or_object =
<db_list>:load(
  ref_name,          -- name of reference (e.g. "children")
  options,           -- table options passed to the reference loader (e.g. { order = ... })
  ref_alias,         -- optional alias for the reference (e.g. "ordered_children")
  back_ref_alias     -- back reference name (e.g. "parent")
)

This method loads referenced objects and attaches them with the objects of the existent list. The "ref" and "back_ref" arguments passed to "add_reference" are used for the attachment, unless aliases are given with "ref_alias" and "back_ref_alias". If "options" are set, these options are passed to the reference loader. The default reference loader supports only one option named "order". If "order" is set to nil, the default order is used, if "order" is set to false, no ORDER BY statment is included in the selector, otherwise the given expression is used for ordering.

This method is not only available for database result lists but also for database result objects.

--]]--
function class_prototype.list.load(...)
  return class_prototype.list.get_reference_selector(...):exec()
end
--//--

--[[--
db_object =
<db_object>:get_reference_selector(
  ref_name,                          -- name of reference (e.g. "children")
  options,                           -- table options passed to the reference loader (e.g. { order = ... })
  ref_alias,                         -- optional alias for the reference (e.g. "ordered_children")
  back_ref_alias                     -- back reference name (e.g. "parent")
)

This method returns a special selector for selecting referenced objects. It is prepared in a way, that on execution of the selector, all returned objects are attached with the objects of the existent list. The "ref" and "back_ref" arguments passed to "add_reference" are used for the attachment, unless aliases are given with "ref_alias" and "back_ref_alias". If "options" are set, these options are passed to the reference loader. The default reference loader supports only one option named "order". If "order" is set to nil, the default order is used, if "order" is set to false, no ORDER BY statment is included in the selector, otherwise the given expression is used for ordering.

This method is not only available for database result objects but also for database result lists.

--]]--
function class_prototype.object:get_reference_selector(...)
  local list = self._class:create_list()
  list[1] = self
  return list:get_reference_selector(...)
end
--//--

--[[--
db_list_or_object =
<db_object>:load(
  ref_name,          -- name of reference (e.g. "children")
  options,           -- table options passed to the reference loader (e.g. { order = ... })
  ref_alias,         -- optional alias for the reference (e.g. "ordered_children")
  back_ref_alias     -- back reference name (e.g. "parent")
)

This method loads referenced objects and attaches them with the objects of the existent list. The "ref" and "back_ref" arguments passed to "add_reference" are used for the attachment, unless aliases are given with "ref_alias" and "back_ref_alias". If "options" are set, these options are passed to the reference loader. The default reference loader supports only one option named "order". If "order" is set to nil, the default order is used, if "order" is set to false, no ORDER BY statment is included in the selector, otherwise the given expression is used for ordering.

This method is not only available for database result objects but also for database result lists. Calling this method for objects is unneccessary, unless additional options and/or an alias is used.

--]]--
function class_prototype.object.load(...)
  return class_prototype.object.get_reference_selector(...):exec()
end
--//--

--[[--
db_class =                                        -- same class returned
<db_class>:add_reference{
  mode                  = mode,                   -- "11", "1m", "m1", or "mm" (one/many to one/many)
  to                    = to,                     -- referenced class (model), optionally as string or function returning the value (avoids autoload)
  this_key              = this_key,               -- name of key in this class (model)
  that_key              = that_key,               -- name of key in the other class (model) ("to" argument)
  ref                   = ref,                    -- name of reference in this class, referring to the other class
  back_ref              = back_ref,               -- name of reference in other class, referring to this class
  default_order         = default_order,          -- expression as passed to "assemble_command" used for sorting
  selector_generator    = selector_generator,     -- alternative function used as selector generator (use only, when you know what you are doing)
  connected_by_table    = connected_by_table,     -- connecting table used for many to many relations
  connected_by_this_key = connected_by_this_key,  -- key in connecting table referring to "this_key" of this class (model)
  connected_by_that_key = connected_by_that_key   -- key in connecting table referring to "that_key" in other class (model) ("to" argument)
}

Denotes a reference from one database class to another database class (model to model relation). There are 4 possible types of references: one-to-one (mode = "11"), one-to-many (mode = "1m"), many-to-one ("m1"), and many-to-many ("mm"). References usually should be defined in both models, which are related to each other, with mirrored mode (i.e. "1m" in one model, and "m1" in the other). One-to-one and one-to-many references may have a "back_ref" setting, which causes that loaded objects of the referenced class, refer back to the originating object. One-to-many and many-to-many references may have a "default_order" setting, which selects the default order for selected objects. When adding a many-to-many reference, the argument "connected_by_table", "connected_by_this_key" and "connected_by_that_key" must be set additionally.

--]]--
function class_prototype:add_reference(args)
  local selector_generator    = args.selector_generator
  local mode                  = args.mode
  local to                    = args.to
  local this_key              = args.this_key
  local that_key              = args.that_key
  local connected_by_table    = args.connected_by_table  -- TODO: split to table and schema
  local connected_by_this_key = args.connected_by_this_key
  local connected_by_that_key = args.connected_by_that_key
  local ref                   = args.ref
  local back_ref              = args.back_ref
  local default_order         = args.default_order
  local model
  local function get_model()
    if not model then
      if type(to) == "string" then
        model = _G
        for path_element in string.gmatch(to, "[^.]+") do
          model = model[path_element]
        end
      elseif type(to) == "function" then
        model = to()
      else
        model = to
      end
    end
    if not model or model == _G then
      error("Could not get model for reference.")
    end
    return model
  end
  self.references[ref] = {
    mode     = mode,
    this_key = this_key,
    that_key = connected_by_table and "mm_ref_" or that_key,
    ref      = ref,
    back_ref = back_ref,
    selector_generator = selector_generator or function(list, options)
      -- TODO: support tuple keys
      local options = options or {}
      local model = get_model()
      -- TODO: too many records cause PostgreSQL command stack overflow
      local ids = { sep = ", " }
      for i, object in ipairs(list) do
        local id = object[this_key]
        if id ~= nil then
          ids[#ids+1] = {"?", id}
        end
      end
      if #ids == 0 then
        return model:new_selector():empty_list_mode()
      end
      local selector = model:new_selector()
      if connected_by_table then
        selector:join(
          connected_by_table,
          nil,
          {
            '$."$" = $."$"',
            {connected_by_table},
            {connected_by_that_key},
            {model:get_qualified_table()},
            {that_key}
          }
        )
        selector:add_field(
          {
            '$."$"',
            {connected_by_table},
            {connected_by_this_key}
          },
          'mm_ref_'
        )
        selector:add_where{
          '$."$" IN ($)',
          {connected_by_table},
          {connected_by_this_key},
          ids
        }
      else
        selector:add_where{'$."$" IN ($)', {model:get_qualified_table()}, {that_key}, ids}
      end
      if options.order == nil and default_order then
        selector:add_order_by(default_order)
      elseif options.order then
        selector:add_order_by(options.order)
      end
      return selector
    end
  }
  if mode == "m1" or mode == "11" then
    self.foreign_keys[this_key] = ref
  end
  return self
end
--//--

return _M

