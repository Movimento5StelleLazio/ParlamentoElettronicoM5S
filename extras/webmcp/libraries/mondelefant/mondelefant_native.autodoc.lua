
--[[--
db_handle,                            -- database handle, or nil in case of error
errmsg,                               -- error message
errcode =                             -- error code
mondelefant.connect{
  engine          = "postgresql",     -- no other engine is supported
  conninfo        = conninfo,         -- string passed directly to PostgreSQL's libpq
  host            = host,             -- hostname or directory with leading slash where Unix-domain socket resides
  hostaddr        = hostaddr,         -- IPv4, or IPv6 address if supported
  port            = port,             -- TCP port or socket file name extension
  dbname          = dbname,           -- name of database to connect with
  user            = user,             -- login name
  password        = password,         -- password
  connect_timeout = connect_timeout,  -- seconds to wait for connection to be established. Zero or nil means infinite
  ...
}  

Opens a new database connection and returns a handle for that connection. You may chose to specify host, port, dbname, etc. as seperated arguments, or to use a "conninfo" string, which is directly passed to PostgreSQL's libpq.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_connect(lua_State *L)
--//--


--[[--
<db_handle>:close()

Closes the database connection. This method may be called multiple times and is called automatically when the database handle is garbage collected.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_close(lua_State *L)
--//--


--[[--
status =             -- true, if database connection has no malfunction
<db_handle>:is_ok()

Returns false, if the database connection has a malfunction, otherwise true.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_is_ok(lua_State *L)
--//--


--[[--
status =                              -- status string
<db_handle>:get_transaction_status()

Depending on the transaction status of the connection a string is returned:
- idle
- active
- intrans
- inerror
- unknown

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_get_transaction_status(lua_State *L)
--//--


--[[--
db_list =                  -- database result being an empty list
<db_handle>:create_list()

Creates an empty database result representing a list. The used meta-table is "result_metatable". The attribute "_connection" is set to the database handle, and the attribute "_type" is set to "list".

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_create_list(lua_State *L)
--//--


--[[--
db_object =                  -- database result being an empty object (row)
<db_handle>:create_object()

Creates an empty database result representing an object (row). The used meta-table is "result_metatable". The attribute "_connection" is set to the database handle, and the attribute "_type" is set to "object". Additionally the attributes "_data", "_dirty" and "_ref" are initialized with an empty table. TODO: Documentation of _data, _dirty and _ref.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_create_object(lua_State *L)
--//--


--[[--
quoted_encoded_string =    -- encoded and quoted string
<db_handle>:quote_string(
  unencoded_string         -- string to encode and quote
)

Prepares a string to be used safely within SQL queries. This function is database dependent (see "backslash_quote" server configuration option for PostgreSQL).

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_quote_string(lua_State *L)
--//--


--[[--
quoted_encoded_data =      -- encoded and quoted data (as Lua string)
<db_handle>:quote_string(
  raw_data                 -- data (as Lua string) to encode and quote
)

Prepares a binary string to be used safely within SQL queries (as "bytea" type). This function is database dependent.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_quote_binary(lua_State *L)
--//--


--[[--
sql_string =
<db_handle>:assemble_command{
  template,                    -- template string
  arg1,                        -- value to be inserted
  arg2,                        -- another value to be inserted
  key1 = named_arg3,           -- named value
  key2 = named_arg4,           -- another named value
  ...
}

This method returns a SQL command by inserting the given values into the template string. Placeholders are "?" or "$", optionally followed by alphanumeric characters (including underscores). Placeholder characters can be escaped by writing them twice. A question-mark ("?") denotes a single value to be inserted, a dollar-sign ("$") denotes a list of sub-structures to be inserted. If alphanumeric characters are following the placeholder character, then these characters form a key, which is used to lookup the value to be used, otherwise values of numeric indicies are used.

TODO: documentation of input-converters

List of sub-structures are tables with an optional "sep" value, which is used as seperator. Each (numerically indexed) entry  of this table is passed to a recursive call of "assemble_command" and concatenated with the given seperator, or ", ", if no seperator is given.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_assemble_command(lua_State *L)
--//--


--[[--
db_error,               -- error object, or nil in case of success
result1,                -- result of first command
result2,                -- result of second command
... =
<db_handle>:try_query(
  command1,             -- first command (to be processed by "assemble_command" method)
  mode1,                -- mode for first command: "list", "object" or "opt_object"
  command2,             -- second command (to be processed by "assemble_command" method)
  mode2,                -- mode for second command: "list", "object" or "opt_object"
  ..
)

This method executes one or multiple SQL commands and returns its results. Each command is pre-processed by the "assemble_command" method of the database handle. A mode can be selected for each command: "list" for normal queries, "object" for queries which have exactly one result row, or "opt_object" which have one or zero result rows. If an error occurs, an error object is returned as first result value.

The mode of the last command may be ommitted and default to "list".

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_try_query(lua_State *L)
--//--


--[[--
<db_error>:escalate()

Causes a Lua error to be thrown. If the database connection has "error_objects" set to true, then the object is thrown itself, otherwise a string is thrown.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_errorobject_escalate(lua_State *L)
--//--


--[[--
bool =                  -- true or false
<db_error>:is_kind_of(
  error_code            -- error code as used by this library
)

Checks, if a given error is of a given kind.

Example:
db_error:is_kind_of("IntegrityConstraintViolation")

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_errorobject_is_kind_of(lua_State *L)
--//--


--[[--
result1,            -- result of first command
result2,            -- result of second command
... =
<db_handle>:query(
  command1,         -- first command (to be processed by "assemble_command" method)
  mode1,            -- mode for first command: "list", "object" or "opt_object"
  command2,         -- second command (to be processed by "assemble_command" method)
  mode2,            -- mode for second command: "list", "object" or "opt_object"
  ..
)

Same as "try_query" but raises error, when occurring.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_conn_query(lua_State *L)
--//--


--[[--
db_list_or_object =     -- first argument is returned
mondelefant.set_class(
  db_list_or_object,    -- database result list or object
  db_class              -- database class (model)
)

This function sets a class for a given database result list or object. If a result list is given as first argument, the class is also set for all elements of the list.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_set_class(lua_State *L)
--//--


--[[--
db_class =               -- new database class (model)
mondelefant.new_class()

This function creates a new class (model) used for database result lists or objects.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_new_class(lua_State *L) 
--//--


--[[--
reference_data =           -- table with reference information
<db_class>:get_reference(
  name                     -- reference name
)

This function performs a lookup for the given name in the "reference" table. Prototypes are used, when lookup was unsuccessful.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_class_get_reference(lua_State *L)
--//--


--[[--
reference_name =                            -- reference name
<db_class>:get_foreign_key_reference_name(
  foreign_key                               -- foreign key
)

This function performs a lookup for the given name in the "foreign_keys" table. Prototypes are used, when lookup was unsuccessful.

--]]--
-- implemented in mondelefant_native.c as
-- static int mondelefant_class_get_reference(lua_State *L)
--//--

