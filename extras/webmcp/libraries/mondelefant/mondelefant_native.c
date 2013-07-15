#include <lua.h>
#include <lauxlib.h>
#include <libpq-fe.h>
#include <postgres.h>
#include <catalog/pg_type.h>
#include <stdint.h>

// NOTE: Comments with format "// <number>" denote the Lua stack position

// prefix for all Lua registry entries of this library:
#define MONDELEFANT_REGKEY "e449ba8d9a53d353_mondelefant_"

// registry key of module "mondelefant_native":
#define MONDELEFANT_MODULE_REGKEY (MONDELEFANT_REGKEY "module")
// registry key of meta-table for database connections:
#define MONDELEFANT_CONN_MT_REGKEY (MONDELEFANT_REGKEY "connection")
// registry key of table storing connection specific data:
#define MONDELEFANT_CONN_DATA_REGKEY (MONDELEFANT_REGKEY "connection_data")
// registry key of meta-table for database result lists and objects:
#define MONDELEFANT_RESULT_MT_REGKEY (MONDELEFANT_REGKEY "result")
// registry key of meta-table for database error objects:
#define MONDELEFANT_ERROROBJECT_MT_REGKEY (MONDELEFANT_REGKEY "errorobject")
// registry key of meta-table for models (named classes here):
#define MONDELEFANT_CLASS_MT_REGKEY (MONDELEFANT_REGKEY "class")
// registry key of default prototype for models/classes:
#define MONDELEFANT_CLASS_PROTO_REGKEY (MONDELEFANT_REGKEY "class_proto")

// C-structure for database connection userdata:
typedef struct {
  PGconn *pgconn;
  int server_encoding;
} mondelefant_conn_t;
#define MONDELEFANT_SERVER_ENCODING_ASCII 0
#define MONDELEFANT_SERVER_ENCODING_UTF8  1

// transform codepoint-position to byte-position for a given UTF-8 string:
static size_t utf8_position_to_byte(const char *str, size_t utf8pos) {
  size_t bytepos;
  for (bytepos = 0; utf8pos > 0; bytepos++) {
    uint8_t c;
    c = ((const uint8_t *)str)[bytepos];
    if (!c) break;
    if (c <= 0x7f || c >= 0xc0) utf8pos--;
  }
  return bytepos;
}

// PostgreSQL's OID for binary data type (bytea):
#define MONDELEFANT_POSTGRESQL_BINARY_OID ((Oid)17)

// mapping a PostgreSQL type given by its OID to a string identifier:
static const char *mondelefant_oid_to_typestr(Oid oid) {
  switch (oid) {
    case 16: return "bool";
    case 17: return "bytea";
    case 18: return "char";
    case 19: return "name";
    case 20: return "int8";
    case 21: return "int2";
    case 23: return "int4";
    case 25: return "text";
    case 26: return "oid";
    case 27: return "tid";
    case 28: return "xid";
    case 29: return "cid";
    case 600: return "point";
    case 601: return "lseg";
    case 602: return "path";
    case 603: return "box";
    case 604: return "polygon";
    case 628: return "line";
    case 700: return "float4";
    case 701: return "float8";
    case 705: return "unknown";
    case 718: return "circle";
    case 790: return "money";
    case 829: return "macaddr";
    case 869: return "inet";
    case 650: return "cidr";
    case 1042: return "bpchar";
    case 1043: return "varchar";
    case 1082: return "date";
    case 1083: return "time";
    case 1114: return "timestamp";
    case 1184: return "timestamptz";
    case 1186: return "interval";
    case 1266: return "timetz";
    case 1560: return "bit";
    case 1562: return "varbit";
    case 1700: return "numeric";
    default: return NULL;
  }
}

// This library maps PostgreSQL's error codes to CamelCase string
// identifiers, which consist of CamelCase identifiers and are seperated
// by dots (".") (no leading or trailing dots).
// There are additional error identifiers which do not have a corresponding
// PostgreSQL error associated with it.

// matching start of local variable 'pgcode' against string 'incode',
// returning string 'outcode' on match:
#define mondelefant_errcode_item(incode, outcode) \
  if (!strncmp(pgcode, (incode), strlen(incode))) return outcode; else

// additional error identifiers without corresponding PostgreSQL error:
#define MONDELEFANT_ERRCODE_UNKNOWN "unknown"
#define MONDELEFANT_ERRCODE_CONNECTION "ConnectionException"
#define MONDELEFANT_ERRCODE_RESULTCOUNT_LOW "WrongResultSetCount.ResultSetMissing"
#define MONDELEFANT_ERRCODE_RESULTCOUNT_HIGH "WrongResultSetCount.TooManyResults"
#define MONDELEFANT_ERRCODE_QUERY1_NO_ROWS "NoData.OneRowExpected"
#define MONDELEFANT_ERRCODE_QUERY1_MULTIPLE_ROWS "CardinalityViolation.OneRowExpected"

// mapping PostgreSQL error code to error code as returned by this library:
static const char *mondelefant_translate_errcode(const char *pgcode) {
  if (!pgcode) abort();  // should not happen
  mondelefant_errcode_item("02", "NoData")
  mondelefant_errcode_item("03", "SqlStatementNotYetComplete")
  mondelefant_errcode_item("08", "ConnectionException")
  mondelefant_errcode_item("09", "TriggeredActionException")
  mondelefant_errcode_item("0A", "FeatureNotSupported")
  mondelefant_errcode_item("0B", "InvalidTransactionInitiation")
  mondelefant_errcode_item("0F", "LocatorException")
  mondelefant_errcode_item("0L", "InvalidGrantor")
  mondelefant_errcode_item("0P", "InvalidRoleSpecification")
  mondelefant_errcode_item("21", "CardinalityViolation")
  mondelefant_errcode_item("22", "DataException")
  mondelefant_errcode_item("23001", "IntegrityConstraintViolation.RestrictViolation")
  mondelefant_errcode_item("23502", "IntegrityConstraintViolation.NotNullViolation")
  mondelefant_errcode_item("23503", "IntegrityConstraintViolation.ForeignKeyViolation")
  mondelefant_errcode_item("23505", "IntegrityConstraintViolation.UniqueViolation")
  mondelefant_errcode_item("23514", "IntegrityConstraintViolation.CheckViolation")
  mondelefant_errcode_item("23",    "IntegrityConstraintViolation")
  mondelefant_errcode_item("24", "InvalidCursorState")
  mondelefant_errcode_item("25", "InvalidTransactionState")
  mondelefant_errcode_item("26", "InvalidSqlStatementName")
  mondelefant_errcode_item("27", "TriggeredDataChangeViolation")
  mondelefant_errcode_item("28", "InvalidAuthorizationSpecification")
  mondelefant_errcode_item("2B", "DependentPrivilegeDescriptorsStillExist")
  mondelefant_errcode_item("2D", "InvalidTransactionTermination")
  mondelefant_errcode_item("2F", "SqlRoutineException")
  mondelefant_errcode_item("34", "InvalidCursorName")
  mondelefant_errcode_item("38", "ExternalRoutineException")
  mondelefant_errcode_item("39", "ExternalRoutineInvocationException")
  mondelefant_errcode_item("3B", "SavepointException")
  mondelefant_errcode_item("3D", "InvalidCatalogName")
  mondelefant_errcode_item("3F", "InvalidSchemaName")
  mondelefant_errcode_item("40", "TransactionRollback")
  mondelefant_errcode_item("42", "SyntaxErrorOrAccessRuleViolation")
  mondelefant_errcode_item("44", "WithCheckOptionViolation")
  mondelefant_errcode_item("53", "InsufficientResources")
  mondelefant_errcode_item("54", "ProgramLimitExceeded")
  mondelefant_errcode_item("55", "ObjectNotInPrerequisiteState")
  mondelefant_errcode_item("57", "OperatorIntervention")
  mondelefant_errcode_item("58", "SystemError")
  mondelefant_errcode_item("F0", "ConfigurationFileError")
  mondelefant_errcode_item("P0", "PlpgsqlError")
  mondelefant_errcode_item("XX", "InternalError")
  return "unknown";
}

// C-function, checking if a given error code (as defined by this library)
// is belonging to a certain class of errors (strings are equal or error
// code begins with error class followed by a dot):
static int mondelefant_check_error_class(
  const char *errcode, const char *errclass
) {
  size_t i = 0;
  while (1) {
    if (errclass[i] == 0) {
      if (errcode[i] == 0 || errcode[i] == '.') return 1;
      else return 0;
    }
    if (errcode[i] != errclass[i]) return 0;
    i++;
  }
}

// pushing first line of a string on Lua's stack (without trailing CR/LF):
static void mondelefant_push_first_line(lua_State *L, const char *str) {
  char *str2;
  size_t i = 0;
  if (!str) abort();  // should not happen
  str2 = strdup(str);
  while (1) {
    char c = str2[i];
    if (c == '\n' || c == '\r' || c == 0) { str2[i] = 0; break; }
    i++;
  };
  lua_pushstring(L, str2);
  free(str2);
}

// "connect" function of library, which establishes a database connection
// and returns a database connection handle:
static int mondelefant_connect(lua_State *L) {
  luaL_Buffer buf;  // Lua string buffer to create 'conninfo' (see below)
  const char *conninfo;  // string for PQconnectdb function
  PGconn *pgconn;  // PGconn object as returned by PQconnectdb function
  mondelefant_conn_t *conn;  // C-structure for userdata
  // if engine is anything but "postgresql", then raise error:
  lua_settop(L, 1);
  lua_getfield(L, 1, "engine");  // 2
  if (!lua_toboolean(L, 2)) {
    return luaL_error(L, "No database engine selected.");
  }
  lua_pushliteral(L, "postgresql");  // 3
  if (!lua_rawequal(L, 2, 3)) {
    return luaL_error(L,
      "Only database engine 'postgresql' is supported."
    );
  }
  // copy conninfo string for PQconnectdb function from argument table to
  // stack position 2:
  lua_settop(L, 1);
  lua_getfield(L, 1, "conninfo");  // 2
  // if no conninfo string was found, then assemble one from the named
  // options except "engine" option:
  if (!lua_toboolean(L, 2)) {
    lua_settop(L, 1);
    lua_pushnil(L);  // slot for key at stack position 2
    lua_pushnil(L);  // slot for value at stack position 3
    luaL_buffinit(L, &buf);
    {
      int need_seperator = 0;
      while (lua_pushvalue(L, 2), lua_next(L, 1)) {
        lua_replace(L, 3);
        lua_replace(L, 2);
        // NOTE: numbers will be converted to strings automatically here,
        // but perhaps this will change in future versions of lua
        luaL_argcheck(L,
          lua_isstring(L, 2) && lua_isstring(L, 3), 1, "non-string contained"
        );
        lua_pushvalue(L, 2);
        lua_pushliteral(L, "engine");
        if (!lua_rawequal(L, -2, -1)) {
          const char *value;
          size_t value_len;
          size_t value_pos = 0;
          lua_pop(L, 1);
          if (need_seperator) luaL_addchar(&buf, ' ');
          luaL_addvalue(&buf);
          luaL_addchar(&buf, '=');
          luaL_addchar(&buf, '\'');
          value = lua_tolstring(L, 3, &value_len);
          do {
            char c;
            c = value[value_pos++];
            if (c == '\'') luaL_addchar(&buf, '\\');
            luaL_addchar(&buf, c);
          } while (value_pos < value_len);
          luaL_addchar(&buf, '\'');
          need_seperator = 1;
        } else {
          lua_pop(L, 1);
        }
      }
    }
    luaL_pushresult(&buf);
    lua_replace(L, 2);
    lua_settop(L, 2);
  }
  // use conninfo string on stack position 2:
  conninfo = lua_tostring(L, 2);
  // call PQconnectdb function of libpq:
  pgconn = PQconnectdb(conninfo);
  // throw errors, if neccessary:
  if (!pgconn) {
    return luaL_error(L,
      "Error in libpq while creating 'PGconn' structure."
    );
  }
  if (PQstatus(pgconn) != CONNECTION_OK) {
    const char *errmsg;
    lua_pushnil(L);
    errmsg = PQerrorMessage(pgconn);
    if (errmsg) {
      mondelefant_push_first_line(L, errmsg);
    } else {
      lua_pushliteral(L,
        "Error while connecting to database, but no error message given."
      );
    }
    lua_pushliteral(L, MONDELEFANT_ERRCODE_CONNECTION);
    PQfinish(pgconn);
    return 3;
  }
  // create userdata:
  lua_settop(L, 0);
  conn = lua_newuserdata(L, sizeof(*conn));  // 1
  // set 'pgconn' in C-struct of userdata:
  conn->pgconn = pgconn;
  // set 'server_encoding' in C-struct of userdata:
  {
    const char *charset;
    charset = PQparameterStatus(pgconn, "server_encoding");
    if (charset && !strcmp(charset, "UTF8")) {
      conn->server_encoding = MONDELEFANT_SERVER_ENCODING_UTF8;
    } else {
      conn->server_encoding = MONDELEFANT_SERVER_ENCODING_ASCII;
    }
  }
  // set meta-table of userdata:
  luaL_getmetatable(L, MONDELEFANT_CONN_MT_REGKEY);  // 2
  lua_setmetatable(L, 1);
  // create entry in table storing connection specific data and associate
  // created userdata with it:
  lua_getfield(L, LUA_REGISTRYINDEX, MONDELEFANT_CONN_DATA_REGKEY);  // 2
  lua_pushvalue(L, 1);  // 3
  lua_newtable(L);  // 4
  lua_settable(L, 2);
  lua_settop(L, 1);
  // store key "engine" with value "postgresql" as connection specific data:
  lua_pushliteral(L, "postgresql");
  lua_setfield(L, 1, "engine");
  // return userdata:
  return 1;
}

// returns pointer to libpq handle 'pgconn' of userdata at given index
// (or throws error, if database connection has been closed):
static mondelefant_conn_t *mondelefant_get_conn(lua_State *L, int index) {
  mondelefant_conn_t *conn;
  conn = luaL_checkudata(L, index, MONDELEFANT_CONN_MT_REGKEY);
  if (!conn->pgconn) {
    luaL_error(L, "PostgreSQL connection has been closed.");
    return NULL;
  }
  return conn;
}

// meta-method "__index" of database handles (userdata):
static int mondelefant_conn_index(lua_State *L) {
  // try table for connection specific data:
  lua_settop(L, 2);
  lua_getfield(L, LUA_REGISTRYINDEX, MONDELEFANT_CONN_DATA_REGKEY);  // 3
  lua_pushvalue(L, 1);  // 4
  lua_gettable(L, 3);  // 4
  lua_remove(L, 3);  // connection specific data-table at stack position 3
  lua_pushvalue(L, 2);  // 4
  lua_gettable(L, 3);  // 4
  if (!lua_isnil(L, 4)) return 1;
  // try to use prototype stored in connection specific data:
  lua_settop(L, 3);
  lua_getfield(L, 3, "prototype");  // 4
  if (lua_toboolean(L, 4)) {
    lua_pushvalue(L, 2);  // 5
    lua_gettable(L, 4);  // 5
    if (!lua_isnil(L, 5)) return 1;
  }
  // try to use "postgresql_connection_prototype" of library:
  lua_settop(L, 2);
  lua_getfield(L, LUA_REGISTRYINDEX, MONDELEFANT_MODULE_REGKEY);  // 3
  lua_getfield(L, 3, "postgresql_connection_prototype");  // 4
  if (lua_toboolean(L, 4)) {
    lua_pushvalue(L, 2);  // 5
    lua_gettable(L, 4);  // 5
    if (!lua_isnil(L, 5)) return 1;
  }
  // try to use "connection_prototype" of library:
  lua_settop(L, 3);
  lua_getfield(L, 3, "connection_prototype");  // 4
  if (lua_toboolean(L, 4)) {
    lua_pushvalue(L, 2);  // 5
    lua_gettable(L, 4);  // 5
    if (!lua_isnil(L, 5)) return 1;
  }
  // give up and return nothing:
  return 0;
}

// meta-method "__newindex" of database handles (userdata):
static int mondelefant_conn_newindex(lua_State *L) {
  // store key-value pair in table for connection specific data:
  lua_settop(L, 3);
  lua_getfield(L, LUA_REGISTRYINDEX, MONDELEFANT_CONN_DATA_REGKEY);  // 4
  lua_pushvalue(L, 1);  // 5
  lua_gettable(L, 4);  // 5
  lua_remove(L, 4);  // connection specific data-table at stack position 4
  lua_pushvalue(L, 2);
  lua_pushvalue(L, 3);
  lua_settable(L, 4);
  // return nothing:
  return 0;
}

// meta-method "__gc" of database handles:
static int mondelefant_conn_free(lua_State *L) {
  mondelefant_conn_t *conn;
  conn = luaL_checkudata(L, 1, MONDELEFANT_CONN_MT_REGKEY);
  if (conn->pgconn) PQfinish(conn->pgconn);
  conn->pgconn = NULL;
  return 0;
}

// method "close" of database handles:
static int mondelefant_conn_close(lua_State *L) {
  mondelefant_conn_t *conn;
  lua_settop(L, 1);
  conn = mondelefant_get_conn(L, 1);
  PQfinish(conn->pgconn);
  conn->pgconn = NULL;
  return 0;
}

// method "is_okay" of database handles:
static int mondelefant_conn_is_ok(lua_State *L) {
  mondelefant_conn_t *conn;
  lua_settop(L, 1);
  conn = mondelefant_get_conn(L, 1);
  lua_pushboolean(L, PQstatus(conn->pgconn) == CONNECTION_OK);
  return 1;
}

// method "get_transaction_status" of database handles:
static int mondelefant_conn_get_transaction_status(lua_State *L) {
  mondelefant_conn_t *conn;
  lua_settop(L, 1);
  conn = mondelefant_get_conn(L, 1);
  switch (PQtransactionStatus(conn->pgconn)) {
  case PQTRANS_IDLE:
    lua_pushliteral(L, "idle");
    break;
  case PQTRANS_ACTIVE:
    lua_pushliteral(L, "active");
    break;
  case PQTRANS_INTRANS:
    lua_pushliteral(L, "intrans");
    break;
  case PQTRANS_INERROR:
    lua_pushliteral(L, "inerror");
    break;
  default:
    lua_pushliteral(L, "unknown");
  }
  return 1;
}

// method "create_list" of database handles:
static int mondelefant_conn_create_list(lua_State *L) {
  // ensure that first argument is a database connection:
  lua_settop(L, 2);
  luaL_checkudata(L, 1, MONDELEFANT_CONN_MT_REGKEY);
  // if no second argument is given, use an empty table:
  if (!lua_toboolean(L, 2)) {
    lua_newtable(L);
    lua_replace(L, 2);  // new result at stack position 2
  }
  // set meta-table for database result lists/objects:
  lua_getfield(L, LUA_REGISTRYINDEX, MONDELEFANT_RESULT_MT_REGKEY);  // 3
  lua_setmetatable(L, 2);
  // set "_connection" attribute to self:
  lua_pushvalue(L, 1);  // 3
  lua_setfield(L, 2, "_connection");
  // set "_type" attribute to string "list":
  lua_pushliteral(L, "list");  // 3
  lua_setfield(L, 2, "_type");
  // return created database result list:
  return 1;
}

// method "create_object" of database handles:
static int mondelefant_conn_create_object(lua_State *L) {
  // ensure that first argument is a database connection:
  lua_settop(L, 2);
  luaL_checkudata(L, 1, MONDELEFANT_CONN_MT_REGKEY);
  // if no second argument is given, use an empty table:
  if (!lua_toboolean(L, 2)) {
    lua_newtable(L);
    lua_replace(L, 2);  // new result at stack position 2
  }
  //   set meta-table for database result lists/objects:
  lua_getfield(L, LUA_REGISTRYINDEX, MONDELEFANT_RESULT_MT_REGKEY);  // 3
  lua_setmetatable(L, 2);
  // set "_connection" attribute to self:
  lua_pushvalue(L, 1);  // 3
  lua_setfield(L, 2, "_connection");
  // set "_type" attribute to string "object":
  lua_pushliteral(L, "object");  // 3
  lua_setfield(L, 2, "_type");  // "object" or "list"
  // create empty tables for "_data", "_dirty" and "_ref" attributes:
  lua_newtable(L);  // 3
  lua_setfield(L, 2, "_data");
  lua_newtable(L);  // 3
  lua_setfield(L, 2, "_dirty");
  lua_newtable(L);  // 3
  lua_setfield(L, 2, "_ref");  // nil=no info, false=nil, else table
  // return created database result object:
  return 1;
}

// method "quote_string" of database handles:
static int mondelefant_conn_quote_string(lua_State *L) {
  mondelefant_conn_t *conn;
  const char *input;
  size_t input_len;
  char *output;
  size_t output_len;
  // get 'conn' attribute of C-struct of database connection:
  lua_settop(L, 2);
  conn = mondelefant_get_conn(L, 1);
  // get second argument, which must be a string:
  input = luaL_checklstring(L, 2, &input_len);
  // throw error, if string is too long:
  if (input_len > (SIZE_MAX / sizeof(char) - 3) / 2) {
    return luaL_error(L, "String to be escaped is too long.");
  }
  // allocate memory for quoted string:
  output = malloc((2 * input_len + 3) * sizeof(char));
  if (!output) {
    return luaL_error(L, "Could not allocate memory for string quoting.");
  }
  // do escaping by calling PQescapeStringConn and enclosing result with
  // single quotes:
  output[0] = '\'';
  output_len = PQescapeStringConn(
    conn->pgconn, output + 1, input, input_len, NULL
  );
  output[output_len + 1] = '\'';
  output[output_len + 2] = 0;
  // create Lua string:
  lua_pushlstring(L, output, output_len + 2);
  // free allocated memory:
  free(output);
  // return Lua string:
  return 1;
}

// method "quote_binary" of database handles:
static int mondelefant_conn_quote_binary(lua_State *L) {
  mondelefant_conn_t *conn;
  const char *input;
  size_t input_len;
  char *output;
  size_t output_len;
  luaL_Buffer buf;
  // get 'conn' attribute of C-struct of database connection:
  lua_settop(L, 2);
  conn = mondelefant_get_conn(L, 1);
  // get second argument, which must be a string:
  input = luaL_checklstring(L, 2, &input_len);
  // call PQescapeByteaConn, which allocates memory itself:
  output = (char *)PQescapeByteaConn(
    conn->pgconn, (const unsigned char *)input, input_len, &output_len
  );
  // if PQescapeByteaConn returned NULL, then throw error:
  if (!output) {
    return luaL_error(L, "Could not allocate memory for binary quoting.");
  }
  // create Lua string enclosed by single quotes:
  luaL_buffinit(L, &buf);
  luaL_addchar(&buf, '\'');
  luaL_addlstring(&buf, output, output_len - 1);
  luaL_addchar(&buf, '\'');
  luaL_pushresult(&buf);
  // free memory allocated by PQescapeByteaConn:
  PQfreemem(output);
  // return Lua string:
  return 1;
}

// method "assemble_command" of database handles:
static int mondelefant_conn_assemble_command(lua_State *L) {
  mondelefant_conn_t *conn;
  int paramidx = 2;
  const char *template;
  size_t template_pos = 0;
  luaL_Buffer buf;
  // get 'conn' attribute of C-struct of database connection:
  lua_settop(L, 2);
  conn = mondelefant_get_conn(L, 1);
  // if second argument is a string, return this string:
  if (lua_isstring(L, 2)) {
    lua_tostring(L, 2);
    return 1;
  }
  // if second argument has __tostring meta-method,
  // then use this method and return its result:
  if (luaL_callmeta(L, 2, "__tostring")) return 1;
  // otherwise, require that second argument is a table:
  luaL_checktype(L, 2, LUA_TTABLE);
  // get first element of table, which must be a string:
  lua_rawgeti(L, 2, 1);  // 3
  luaL_argcheck(L,
    lua_isstring(L, 3),
    2,
    "First entry of SQL command structure is not a string."
  );
  template = lua_tostring(L, 3);
  // get value of "input_converter" attribute of database connection:
  lua_pushliteral(L, "input_converter");  // 4
  lua_gettable(L, 1);  // input_converter at stack position 4
  // reserve space on Lua stack:
  lua_pushnil(L);  // free space at stack position 5
  lua_pushnil(L);  // free space at stack position 6
  // initialize Lua buffer for result string:
  luaL_buffinit(L, &buf);
  // fill buffer in loop:
  while (1) {
    // variable declaration:
    char c;
    // get next character:
    c = template[template_pos++];
    // break, when character is NULL byte:
    if (!c) break;
    // question-mark and dollar-sign are special characters:
    if (c == '?' || c == '$') {  // special character found
      // check, if same character follows:
      if (template[template_pos] == c) {  // special character is escaped
        // consume two characters of input and add one character to buffer:
        template_pos++;
        luaL_addchar(&buf, c);
      } else {  // special character is not escaped
        luaL_Buffer keybuf;
        int subcmd;
        // set 'subcmd' = true, if special character was a dollar-sign,
        // set 'subcmd' = false, if special character was a question-mark:
        subcmd = (c == '$');
        // read any number of alpha numeric chars or underscores
        // and store them on Lua stack:
        luaL_buffinit(L, &keybuf);
        while (1) {
          c = template[template_pos];
          if (
            (c < 'A' || c > 'Z') &&
            (c < 'a' || c > 'z') &&
            (c < '0' || c > '9') &&
            (c != '_')
          ) break;
          luaL_addchar(&keybuf, c);
          template_pos++;
        }
        luaL_pushresult(&keybuf);
        // check, if any characters matched:
#if LUA_VERSION_NUM >= 502
        if (lua_rawlen(L, -1)) {
#else
        if (lua_objlen(L, -1)) {
#endif
          // if any alpha numeric chars or underscores were found,
          // push them on stack as a Lua string and use them to lookup
          // value from second argument:
          lua_pushvalue(L, -1);           // save key on stack
          lua_gettable(L, 2);             // fetch value (raw-value)
        } else {
          // otherwise push nil and use numeric lookup based on 'paramidx':
          lua_pop(L, 1);
          lua_pushnil(L);                 // put nil on key position
          lua_rawgeti(L, 2, paramidx++);  // fetch value (raw-value)
        }
        // Lua stack contains: ..., <buffer>, key, raw-value
        // branch according to type of special character ("?" or "$"):
        if (subcmd) {  // dollar-sign
          size_t i;
          size_t count;
          // store fetched value (which is supposed to be sub-structure)
          // on Lua stack position 5 and drop key:
          lua_replace(L, 5);
          lua_pop(L, 1);
          // Lua stack contains: ..., <buffer>
          // check, if fetched value is really a sub-structure:
          luaL_argcheck(L,
            !lua_isnil(L, 5),
            2,
            "SQL sub-structure not found."
          );
          luaL_argcheck(L,
            lua_type(L, 5) == LUA_TTABLE,
            2,
            "SQL sub-structure must be a table."
          );
          // Lua stack contains: ..., <buffer>
          // get value of "sep" attribute of sub-structure,
          // and place it on Lua stack position 6:
          lua_getfield(L, 5, "sep");
          lua_replace(L, 6);
          // if seperator is nil, then use ", " as default,
          // if seperator is neither nil nor a string, then throw error:
          if (lua_isnil(L, 6)) {
            lua_pushstring(L, ", ");
            lua_replace(L, 6);
          } else {
            luaL_argcheck(L,
              lua_isstring(L, 6),
              2,
              "Seperator of SQL sub-structure has to be a string."
            );
          }
          // iterate over items of sub-structure:
#if LUA_VERSION_NUM >= 502
          count = lua_rawlen(L, 5);
#else
          count = lua_objlen(L, 5);
#endif
          for (i = 0; i < count; i++) {
            // add seperator, unless this is the first run:
            if (i) {
              lua_pushvalue(L, 6);
              luaL_addvalue(&buf);
            }
            // recursivly apply assemble function and add results to buffer:
            lua_pushcfunction(L, mondelefant_conn_assemble_command);
            lua_pushvalue(L, 1);
            lua_rawgeti(L, 5, i+1);
            lua_call(L, 2, 1);
            luaL_addvalue(&buf);
          }
        } else {  // question-mark
          if (lua_toboolean(L, 4)) {
            // call input_converter with connection handle, raw-value and
            // an info-table which contains a "field_name" entry with the
            // used key:
            lua_pushvalue(L, 4);
            lua_pushvalue(L, 1);
            lua_pushvalue(L, -3);
            lua_newtable(L);
            lua_pushvalue(L, -6);
            lua_setfield(L, -2, "field_name");
            lua_call(L, 3, 1);
            // Lua stack contains: ..., <buffer>, key, raw-value, final-value
            // remove key and raw-value:
            lua_remove(L, -2);
            lua_remove(L, -2);
            // Lua stack contains: ..., <buffer>, final-value
            // throw error, if final-value is not a string:
            if (!lua_isstring(L, -1)) {
              return luaL_error(L, "input_converter returned non-string.");
            }
          } else {
            // remove key from stack:
            lua_remove(L, -2);
            // Lua stack contains: ..., <buffer>, raw-value
            // branch according to type of value:
            if (lua_isnil(L, -1)) {  // value is nil
              // push string "NULL" to stack:
              lua_pushliteral(L, "NULL");
            } else if (lua_type(L, -1) == LUA_TBOOLEAN) {  // value is boolean
              // push strings "TRUE" or "FALSE" to stack:
              lua_pushstring(L, lua_toboolean(L, -1) ? "TRUE" : "FALSE");
            } else if (lua_isstring(L, -1)) {  // value is string or number
              // NOTE: In this version of lua a number will be converted
              // push output of "quote_string" method of database
              // connection to stack:
              lua_tostring(L, -1);
              lua_pushcfunction(L, mondelefant_conn_quote_string);
              lua_pushvalue(L, 1);
              lua_pushvalue(L, -3);
              lua_call(L, 2, 1);
            } else {  // value is of other type
              // throw error:
              return luaL_error(L,
                "Unable to convert SQL value due to unknown type "
                "or missing input_converter."
              );
            }
            // Lua stack contains: ..., <buffer>, raw-value, final-value
            // remove raw-value:
            lua_remove(L, -2);
            // Lua stack contains: ..., <buffer>, final-value
          }
          // append final-value to buffer:
          luaL_addvalue(&buf);
        }
      }
    } else {  // character is not special
      // just copy character:
      luaL_addchar(&buf, c);
    }
  }
  // return string in buffer:
  luaL_pushresult(&buf);
  return 1;
}

// max number of SQL statements executed by one "query" method call:
#define MONDELEFANT_MAX_COMMAND_COUNT 64
// max number of columns in a database result:
#define MONDELEFANT_MAX_COLUMN_COUNT 1024
// enum values for 'modes' array in C-function below:
#define MONDELEFANT_QUERY_MODE_LIST 1
#define MONDELEFANT_QUERY_MODE_OBJECT 2
#define MONDELEFANT_QUERY_MODE_OPT_OBJECT 3

// method "try_query" of database handles:
static int mondelefant_conn_try_query(lua_State *L) {
  mondelefant_conn_t *conn;
  int command_count;
  int command_idx;
  int modes[MONDELEFANT_MAX_COMMAND_COUNT];
  luaL_Buffer buf;
  int sent_success;
  PGresult *res;
  int rows, cols, row, col;
  // get 'conn' attribute of C-struct of database connection:
  conn = mondelefant_get_conn(L, 1);
  // calculate number of commands (2 arguments for one command):
  command_count = lua_gettop(L) / 2;
  // push nil on stack, which is needed, if last mode was ommitted:
  lua_pushnil(L);
  // throw error, if number of commands is too high:
  if (command_count > MONDELEFANT_MAX_COMMAND_COUNT) {
    return luaL_error(L, "Exceeded maximum command count in one query.");
  }
  // create SQL string, store query modes and push SQL string on stack:
  luaL_buffinit(L, &buf);
  for (command_idx = 0; command_idx < command_count; command_idx++) {
    int mode;
    int mode_idx;  // stack index of mode string
    if (command_idx) luaL_addchar(&buf, ' ');
    lua_pushcfunction(L, mondelefant_conn_assemble_command);
    lua_pushvalue(L, 1);
    lua_pushvalue(L, 2 + 2 * command_idx);
    lua_call(L, 2, 1);
    luaL_addvalue(&buf);
    luaL_addchar(&buf, ';');
    mode_idx = 3 + 2 * command_idx;
    if (lua_isnil(L, mode_idx)) {
      mode = MONDELEFANT_QUERY_MODE_LIST;
    } else {
      const char *modestr;
      modestr = luaL_checkstring(L, mode_idx);
      if (!strcmp(modestr, "list")) {
        mode = MONDELEFANT_QUERY_MODE_LIST;
      } else if (!strcmp(modestr, "object")) {
        mode = MONDELEFANT_QUERY_MODE_OBJECT;
      } else if (!strcmp(modestr, "opt_object")) {
        mode = MONDELEFANT_QUERY_MODE_OPT_OBJECT;
      } else {
        return luaL_error(L, "Unknown query mode specified.");
      }
    }
    modes[command_idx] = mode;
  }
  luaL_pushresult(&buf);  // stack position unknown
  lua_replace(L, 2);  // SQL command string to stack position 2
  // call sql_tracer, if set:
  lua_settop(L, 2);
  lua_getfield(L, 1, "sql_tracer");  // tracer at stack position 3
  if (lua_toboolean(L, 3)) {
    lua_pushvalue(L, 1);  // 4
    lua_pushvalue(L, 2);  // 5
    lua_call(L, 2, 1);  // trace callback at stack position 3
  }
  // NOTE: If no tracer was found, then nil or false is stored at stack
  // position 3.
  // call PQsendQuery function and store result in 'sent_success' variable:
  sent_success = PQsendQuery(conn->pgconn, lua_tostring(L, 2));
  // create preliminary result table:
  lua_newtable(L);  // results in table at stack position 4
  // iterate over results using function PQgetResult to fill result table:
  for (command_idx = 0; ; command_idx++) {
    int mode;
    char binary[MONDELEFANT_MAX_COLUMN_COUNT];
    ExecStatusType pgstatus;
    // fetch mode which was given for the command:
    mode = modes[command_idx];
    // if PQsendQuery call was successful, then fetch result data:
    if (sent_success) {
      // NOTE: PQgetResult called one extra time. Break only, if all
      // queries have been processed and PQgetResult returned NULL.
      res = PQgetResult(conn->pgconn);
      if (command_idx >= command_count && !res) break;
      if (res) {
        pgstatus = PQresultStatus(res);
        rows = PQntuples(res);
        cols = PQnfields(res);
      }
    }
    // handle errors:
    if (
      !sent_success || command_idx >= command_count || !res ||
      (pgstatus != PGRES_TUPLES_OK && pgstatus != PGRES_COMMAND_OK) ||
      (rows < 1 && mode == MONDELEFANT_QUERY_MODE_OBJECT) ||
      (rows > 1 && mode != MONDELEFANT_QUERY_MODE_LIST)
    ) {
      const char *command;
      command = lua_tostring(L, 2);
      lua_newtable(L);  // 5
      lua_getfield(L,
        LUA_REGISTRYINDEX,
        MONDELEFANT_ERROROBJECT_MT_REGKEY
      );
      lua_setmetatable(L, 5);
      lua_pushvalue(L, 1);
      lua_setfield(L, 5, "connection");
      lua_pushinteger(L, command_idx + 1);
      lua_setfield(L, 5, "command_number");
      lua_pushvalue(L, 2);
      lua_setfield(L, 5, "sql_command");
      if (!res) {
        lua_pushliteral(L, MONDELEFANT_ERRCODE_RESULTCOUNT_LOW);
        lua_setfield(L, 5, "code");
        lua_pushliteral(L, "Received too few database result sets.");
        lua_setfield(L, 5, "message");
      } else if (command_idx >= command_count) {
        lua_pushliteral(L, MONDELEFANT_ERRCODE_RESULTCOUNT_HIGH);
        lua_setfield(L, 5, "code");
        lua_pushliteral(L, "Received too many database result sets.");
        lua_setfield(L, 5, "message");
      } else if (
        pgstatus != PGRES_TUPLES_OK && pgstatus != PGRES_COMMAND_OK
      ) {
        const char *sqlstate;
        const char *errmsg;
        lua_pushstring(L, PQresultErrorField(res, PG_DIAG_SEVERITY));
        lua_setfield(L, 5, "pg_severity");
        sqlstate = PQresultErrorField(res, PG_DIAG_SQLSTATE);
        if (sqlstate) {
          lua_pushstring(L, sqlstate);
          lua_setfield(L, 5, "pg_sqlstate");
          lua_pushstring(L, mondelefant_translate_errcode(sqlstate));
          lua_setfield(L, 5, "code");
        } else {
          lua_pushliteral(L, MONDELEFANT_ERRCODE_UNKNOWN);
          lua_setfield(L, 5, "code");
        }
        errmsg = PQresultErrorField(res, PG_DIAG_MESSAGE_PRIMARY);
        if (errmsg) {
          mondelefant_push_first_line(L, errmsg);
          lua_setfield(L, 5, "message");
          lua_pushstring(L, errmsg);
          lua_setfield(L, 5, "pg_message_primary");
        } else {
          lua_pushliteral(L,
            "Error while fetching result, but no error message given."
          );
          lua_setfield(L, 5, "message");
        }
        lua_pushstring(L, PQresultErrorField(res, PG_DIAG_MESSAGE_DETAIL));
        lua_setfield(L, 5, "pg_message_detail");
        lua_pushstring(L, PQresultErrorField(res, PG_DIAG_MESSAGE_HINT));
        lua_setfield(L, 5, "pg_message_hint");
        // NOTE: "position" and "pg_internal_position" are recalculated to
        // byte offsets, as Lua 5.1 is not Unicode aware.
        {
          char *tmp;
          tmp = PQresultErrorField(res, PG_DIAG_STATEMENT_POSITION);
          if (tmp) {
            int pos;
            pos = atoi(tmp) - 1;
            if (conn->server_encoding == MONDELEFANT_SERVER_ENCODING_UTF8) {
              pos = utf8_position_to_byte(command, pos);
            }
            lua_pushinteger(L, pos + 1);
            lua_setfield(L, 5, "position");
          }
        }
        {
          const char *internal_query;
          internal_query = PQresultErrorField(res, PG_DIAG_INTERNAL_QUERY);
          lua_pushstring(L, internal_query);
          lua_setfield(L, 5, "pg_internal_query");
          char *tmp;
          tmp = PQresultErrorField(res, PG_DIAG_INTERNAL_POSITION);
          if (tmp) {
            int pos;
            pos = atoi(tmp) - 1;
            if (conn->server_encoding == MONDELEFANT_SERVER_ENCODING_UTF8) {
              pos = utf8_position_to_byte(internal_query, pos);
            }
            lua_pushinteger(L, pos + 1);
            lua_setfield(L, 5, "pg_internal_position");
          }
        }
        lua_pushstring(L, PQresultErrorField(res, PG_DIAG_CONTEXT));
        lua_setfield(L, 5, "pg_context");
        lua_pushstring(L, PQresultErrorField(res, PG_DIAG_SOURCE_FILE));
        lua_setfield(L, 5, "pg_source_file");
        lua_pushstring(L, PQresultErrorField(res, PG_DIAG_SOURCE_LINE));
        lua_setfield(L, 5, "pg_source_line");
        lua_pushstring(L, PQresultErrorField(res, PG_DIAG_SOURCE_FUNCTION));
        lua_setfield(L, 5, "pg_source_function");
      } else if (rows < 1 && mode == MONDELEFANT_QUERY_MODE_OBJECT) {
        lua_pushliteral(L, MONDELEFANT_ERRCODE_QUERY1_NO_ROWS);
        lua_setfield(L, 5, "code");
        lua_pushliteral(L, "Expected one row, but got empty set.");
        lua_setfield(L, 5, "message");
      } else if (rows > 1 && mode != MONDELEFANT_QUERY_MODE_LIST) {
        lua_pushliteral(L, MONDELEFANT_ERRCODE_QUERY1_MULTIPLE_ROWS);
        lua_setfield(L, 5, "code");
        lua_pushliteral(L, "Got more than one result row.");
        lua_setfield(L, 5, "message");
      } else {
        // should not happen
        abort();
      }
      if (res) {
        PQclear(res);
        while ((res = PQgetResult(conn->pgconn))) PQclear(res);
      }
      if (lua_toboolean(L, 3)) {
        lua_pushvalue(L, 3);
        lua_pushvalue(L, 5);
        lua_call(L, 1, 0);
      }
      return 1;
    }
    // call "create_list" or "create_object" method of database handle,
    // result will be at stack position 5:
    if (modes[command_idx] == MONDELEFANT_QUERY_MODE_LIST) {
      lua_pushcfunction(L, mondelefant_conn_create_list);  // 5
      lua_pushvalue(L, 1);  // 6
      lua_call(L, 1, 1);  // 5
    } else {
      lua_pushcfunction(L, mondelefant_conn_create_object);  // 5
      lua_pushvalue(L, 1);  // 6
      lua_call(L, 1, 1);  // 5
    }
    // set "_column_info":
    lua_newtable(L);  // 6
    for (col = 0; col < cols; col++) {
      lua_newtable(L);  // 7
      lua_pushstring(L, PQfname(res, col));
      lua_setfield(L, 7, "field_name");
      {
        Oid tmp;
        tmp = PQftable(res, col);
        if (tmp == InvalidOid) lua_pushnil(L);
        else lua_pushinteger(L, tmp);
        lua_setfield(L, 7, "table_oid");
      }
      {
        int tmp;
        tmp = PQftablecol(res, col);
        if (tmp == 0) lua_pushnil(L);
        else lua_pushinteger(L, tmp);
        lua_setfield(L, 7, "table_column_number");
      }
      {
        Oid tmp;
        tmp = PQftype(res, col);
        binary[col] = (tmp == MONDELEFANT_POSTGRESQL_BINARY_OID);
        lua_pushinteger(L, tmp);
        lua_setfield(L, 7, "type_oid");
        lua_pushstring(L, mondelefant_oid_to_typestr(tmp));
        lua_setfield(L, 7, "type");
      }
      {
        int tmp;
        tmp = PQfmod(res, col);
        if (tmp == -1) lua_pushnil(L);
        else lua_pushinteger(L, tmp);
        lua_setfield(L, 7, "type_modifier");
      }
      lua_rawseti(L, 6, col+1);
    }
    lua_setfield(L, 5, "_column_info");
    // set "_rows_affected":
    {
      char *tmp;
      tmp = PQcmdTuples(res);
      if (tmp[0]) {
        lua_pushinteger(L, atoi(tmp));
        lua_setfield(L, 5, "_rows_affected");
      }
    }
    // set "_oid":
    {
      Oid tmp;
      tmp = PQoidValue(res);
      if (tmp != InvalidOid) {
        lua_pushinteger(L, tmp);
        lua_setfield(L, 5, "_oid");
      }
    }
    // copy data as strings or nil, while performing binary unescaping
    // automatically:
    if (modes[command_idx] == MONDELEFANT_QUERY_MODE_LIST) {
      for (row = 0; row < rows; row++) {
        lua_pushcfunction(L, mondelefant_conn_create_object);  // 6
        lua_pushvalue(L, 1);  // 7
        lua_call(L, 1, 1);  // 6
        for (col = 0; col < cols; col++) {
          if (PQgetisnull(res, row, col)) {
            lua_pushnil(L);
          } else if (binary[col]) {
            size_t binlen;
            char *binval;
            binval = (char *)PQunescapeBytea(
              (unsigned char *)PQgetvalue(res, row, col), &binlen
            );
            if (!binval) {
              return luaL_error(L,
                "Could not allocate memory for binary unescaping."
              );
            }
            lua_pushlstring(L, binval, binlen);
            PQfreemem(binval);
          } else {
            lua_pushstring(L, PQgetvalue(res, row, col));
          }
          lua_rawseti(L, 6, col+1);
        }
        lua_rawseti(L, 5, row+1);
      }
    } else if (rows == 1) {
      for (col = 0; col < cols; col++) {
        if (PQgetisnull(res, 0, col)) {
          lua_pushnil(L);
        } else if (binary[col]) {
          size_t binlen;
          char *binval;
          binval = (char *)PQunescapeBytea(
            (unsigned char *)PQgetvalue(res, 0, col), &binlen
          );
          if (!binval) {
            return luaL_error(L,
              "Could not allocate memory for binary unescaping."
            );
          }
          lua_pushlstring(L, binval, binlen);
          PQfreemem(binval);
        } else {
          lua_pushstring(L, PQgetvalue(res, 0, col));
        }
        lua_rawseti(L, 5, col+1);
      }
    } else {
      // no row in optrow mode
      lua_pop(L, 1);
      lua_pushnil(L);
    }
    // save result in result list:
    lua_rawseti(L, 4, command_idx+1);
    // extra assertion:
    if (lua_gettop(L) != 4) abort();  // should not happen
    // free memory acquired by libpq:
    PQclear(res);
  }
  // trace callback at stack position 3
  // result at stack position 4 (top of stack)
  // if a trace callback is existent, then call:
  if (lua_toboolean(L, 3)) {
    lua_pushvalue(L, 3);
    lua_call(L, 0, 0);
  }
  // put result at stack position 3:
  lua_replace(L, 3);
  // get output converter to stack position 4:
  lua_getfield(L, 1, "output_converter");
  // apply output converters and fill "_data" table according to column names:
  for (command_idx = 0; command_idx < command_count; command_idx++) {
    int mode;
    mode = modes[command_idx];
    lua_rawgeti(L, 3, command_idx+1);  // raw result at stack position 5
    if (lua_toboolean(L, 5)) {
      lua_getfield(L, 5, "_column_info");  // column_info list at position 6
#if LUA_VERSION_NUM >= 502
      cols = lua_rawlen(L, 6);
#else
      cols = lua_objlen(L, 6);
#endif
      if (mode == MONDELEFANT_QUERY_MODE_LIST) {
#if LUA_VERSION_NUM >= 502
        rows = lua_rawlen(L, 5);
#else
        rows = lua_objlen(L, 5);
#endif
        for (row = 0; row < rows; row++) {
          lua_rawgeti(L, 5, row+1);  // row at stack position 7
          lua_getfield(L, 7, "_data");  // _data table at stack position 8
          for (col = 0; col < cols; col++) {
            lua_rawgeti(L, 6, col+1);  // this column info at position 9
            lua_getfield(L, 9, "field_name");  // 10
            if (lua_toboolean(L, 4)) {
              lua_pushvalue(L, 4);  // output-converter
              lua_pushvalue(L, 1);  // connection
              lua_rawgeti(L, 7, col+1);  // raw-value
              lua_pushvalue(L, 9);  // this column info
              lua_call(L, 3, 1);  // converted value at position 11
            } else {
              lua_rawgeti(L, 7, col+1);  // raw-value at position 11
            }
            lua_pushvalue(L, 11);  // 12
            lua_rawseti(L, 7, col+1);
            lua_rawset(L, 8);
            lua_settop(L, 8);
          }
          lua_settop(L, 6);
        }
      } else {
        lua_getfield(L, 5, "_data");  // _data table at stack position 7
        for (col = 0; col < cols; col++) {
          lua_rawgeti(L, 6, col+1);  // this column info at position 8
          lua_getfield(L, 8, "field_name");  // 9
          if (lua_toboolean(L, 4)) {
            lua_pushvalue(L, 4);  // output-converter
            lua_pushvalue(L, 1);  // connection
            lua_rawgeti(L, 5, col+1);  // raw-value
            lua_pushvalue(L, 8);  // this column info
            lua_call(L, 3, 1);  // converted value at position 10
          } else {
            lua_rawgeti(L, 5, col+1);  // raw-value at position 10
          }
          lua_pushvalue(L, 10);  // 11
          lua_rawseti(L, 5, col+1);
          lua_rawset(L, 7);
          lua_settop(L, 7);
        }
      }
    }
    lua_settop(L, 4);
  }
  // return nil as first result value, followed by result lists/objects:
  lua_settop(L, 3);
  lua_pushnil(L);
  for (command_idx = 0; command_idx < command_count; command_idx++) {
    lua_rawgeti(L, 3, command_idx+1);
  }
  return command_count+1;
}

// method "escalate" of error objects:
static int mondelefant_errorobject_escalate(lua_State *L) {
  // check, if we may throw an error object instead of an error string:
  lua_settop(L, 1);
  lua_getfield(L, 1, "connection");  // 2
  lua_getfield(L, 2, "error_objects");  // 3
  if (lua_toboolean(L, 3)) {
    // throw error object:
    lua_settop(L, 1);
    return lua_error(L);
  } else {
    // throw error string:
    lua_getfield(L, 1, "message");  // 4
    if (lua_isnil(L, 4)) {
      return luaL_error(L, "No error message given for escalation.");
    }
    return lua_error(L);
  }
}

// method "is_kind_of" of error objects:
static int mondelefant_errorobject_is_kind_of(lua_State *L) {
  lua_settop(L, 2);
  lua_getfield(L, 1, "code");  // 3
  if (lua_isstring(L, 3)) {
    lua_pushboolean(L,
      mondelefant_check_error_class(
        lua_tostring(L, 3), luaL_checkstring(L, 2)
      )
    );
  } else {
    // only happens for errors where code is not set
    lua_pushboolean(L, 0);
  }
  return 1;
}

// method "query" of database handles:
static int mondelefant_conn_query(lua_State *L) {
  int argc;
  // count number of arguments:
  argc = lua_gettop(L);
  // insert "try_query" function/method at stack position 1:
  lua_pushcfunction(L, mondelefant_conn_try_query);
  lua_insert(L, 1);
  // call "try_query" method:
  lua_call(L, argc, LUA_MULTRET);  // results (with error) starting at index 1
  // check, if error occurred:
  if (lua_toboolean(L, 1)) {
    // invoke escalate method of error object:
    lua_pushcfunction(L, mondelefant_errorobject_escalate);
    lua_pushvalue(L, 1);
    lua_call(L, 1, 0);  // will raise an error
    return 0;  // should not be executed
  } else {
    // return everything but nil error object:
    return lua_gettop(L) - 1;
  }
}

// library function "set_class":
static int mondelefant_set_class(lua_State *L) {
  // ensure that first argument is a database result list/object:
  lua_settop(L, 2);
  lua_getmetatable(L, 1);  // 3
  lua_getfield(L, LUA_REGISTRYINDEX, MONDELEFANT_RESULT_MT_REGKEY);  // 4
#if LUA_VERSION_NUM >= 502
  luaL_argcheck(L, lua_compare(L, 3, 4, LUA_OPEQ), 1, "not a database result");
#else
  luaL_argcheck(L, lua_equal(L, 3, 4), 1, "not a database result");
#endif
  // ensure that second argument is a database class (model):
  lua_settop(L, 2);
  lua_getmetatable(L, 2);  // 3
  lua_getfield(L, LUA_REGISTRYINDEX, MONDELEFANT_CLASS_MT_REGKEY);  // 4
#if LUA_VERSION_NUM >= 502
  luaL_argcheck(L, lua_compare(L, 3, 4, LUA_OPEQ), 2, "not a database class");
#else
  luaL_argcheck(L, lua_equal(L, 3, 4), 2, "not a database class");
#endif
  // set attribute "_class" of result list/object to given class:
  lua_settop(L, 2);
  lua_pushvalue(L, 2);  // 3
  lua_setfield(L, 1, "_class");
  // test, if database result is a list (and not a single object):
  lua_getfield(L, 1, "_type");  // 3
  lua_pushliteral(L, "list");  // 4
  if (lua_rawequal(L, 3, 4)) {
    int i;
    // set attribute "_class" of all elements to given class:
#if LUA_VERSION_NUM >= 502
    for (i=0; i < lua_rawlen(L, 1); i++) {
#else
    for (i=0; i < lua_objlen(L, 1); i++) {
#endif
      lua_settop(L, 2);
      lua_rawgeti(L, 1, i+1);  // 3
      lua_pushvalue(L, 2);  // 4
      lua_setfield(L, 3, "_class");
    }
  }
  // return first argument:
  lua_settop(L, 1);
  return 1;
}

// library function "new_class":
static int mondelefant_new_class(lua_State *L) {
  // use first argument as template or create new table:
  lua_settop(L, 1);
  if (!lua_toboolean(L, 1)) {
    lua_settop(L, 0);
    lua_newtable(L);  // 1
  }
  // set meta-table for database classes (models):
  lua_getfield(L, LUA_REGISTRYINDEX, MONDELEFANT_CLASS_MT_REGKEY);  // 2
  lua_setmetatable(L, 1);
  // check, if "prototype" attribute is not set:
  lua_pushliteral(L, "prototype");  // 2
  lua_rawget(L, 1);  // 2
  if (!lua_toboolean(L, 2)) {
    // set "prototype" attribute to default prototype:
    lua_pushliteral(L, "prototype");  // 3
    lua_getfield(L,
      LUA_REGISTRYINDEX,
      MONDELEFANT_CLASS_PROTO_REGKEY
    );  // 4
    lua_rawset(L, 1);
  }
  // set "object" attribute to empty table, unless it is already set:
  lua_settop(L, 1);
  lua_pushliteral(L, "object");  // 2
  lua_rawget(L, 1);  // 2
  if (!lua_toboolean(L, 2)) {
    lua_pushliteral(L, "object");  // 3
    lua_newtable(L);  // 4
    lua_rawset(L, 1);
  }
  // set "object_get" attribute to empty table, unless it is already set:
  lua_settop(L, 1);
  lua_pushliteral(L, "object_get");  // 2
  lua_rawget(L, 1);  // 2
  if (!lua_toboolean(L, 2)) {
    lua_pushliteral(L, "object_get");  // 3
    lua_newtable(L);  // 4
    lua_rawset(L, 1);
  }
  // set "object_set" attribute to empty table, unless it is already set:
  lua_settop(L, 1);
  lua_pushliteral(L, "object_set");  // 2
  lua_rawget(L, 1);  // 2
  if (!lua_toboolean(L, 2)) {
    lua_pushliteral(L, "object_set");  // 3
    lua_newtable(L);  // 4
    lua_rawset(L, 1);
  }
  // set "list" attribute to empty table, unless it is already set:
  lua_settop(L, 1);
  lua_pushliteral(L, "list");  // 2
  lua_rawget(L, 1);  // 2
  if (!lua_toboolean(L, 2)) {
    lua_pushliteral(L, "list");  // 3
    lua_newtable(L);  // 4
    lua_rawset(L, 1);
  }
  // set "references" attribute to empty table, unless it is already set:
  lua_settop(L, 1);
  lua_pushliteral(L, "references");  // 2
  lua_rawget(L, 1);  // 2
  if (!lua_toboolean(L, 2)) {
    lua_pushliteral(L, "references");  // 3
    lua_newtable(L);  // 4
    lua_rawset(L, 1);
  }
  // set "foreign_keys" attribute to empty table, unless it is already set:
  lua_settop(L, 1);
  lua_pushliteral(L, "foreign_keys");  // 2
  lua_rawget(L, 1);  // 2
  if (!lua_toboolean(L, 2)) {
    lua_pushliteral(L, "foreign_keys");  // 3
    lua_newtable(L);  // 4
    lua_rawset(L, 1);
  }
  // return table:
  lua_settop(L, 1);
  return 1;
}

// method "get_reference" of classes (models):
static int mondelefant_class_get_reference(lua_State *L) {
  lua_settop(L, 2);
  while (lua_toboolean(L, 1)) {
    // get "references" table:
    lua_getfield(L, 1, "references");  // 3
    // perform lookup:
    lua_pushvalue(L, 2);  // 4
    lua_gettable(L, 3);  // 4
    // return result, if lookup was successful:
    if (!lua_isnil(L, 4)) return 1;
    // replace current table by its prototype:
    lua_settop(L, 2);
    lua_pushliteral(L, "prototype");  // 3
    lua_rawget(L, 1);  // 3
    lua_replace(L, 1);
  }
  // return nothing:
  return 0;
}

// method "iterate_over_references" of classes (models):
static int mondelefant_class_iterate_over_references(lua_State *L) {
  return luaL_error(L, "Reference iterator not implemented yet.");  // TODO
}

// method "get_foreign_key_reference_name" of classes (models):
static int mondelefant_class_get_foreign_key_reference_name(lua_State *L) {
  lua_settop(L, 2);
  while (lua_toboolean(L, 1)) {
    // get "foreign_keys" table:
    lua_getfield(L, 1, "foreign_keys");  // 3
    // perform lookup:
    lua_pushvalue(L, 2);  // 4
    lua_gettable(L, 3);  // 4
    // return result, if lookup was successful:
    if (!lua_isnil(L, 4)) return 1;
    // replace current table by its prototype:
    lua_settop(L, 2);
    lua_pushliteral(L, "prototype");  // 3
    lua_rawget(L, 1);  // 3
    lua_replace(L, 1);
  }
  // return nothing:
  return 0;
}

// meta-method "__index" of database result lists and objects:
static int mondelefant_result_index(lua_State *L) {
  const char *result_type;
  // only lookup, when key is a string not beginning with an underscore:
  if (lua_type(L, 2) != LUA_TSTRING || lua_tostring(L, 2)[0] == '_') {
    return 0;
  }
  // get value of "_class" attribute, or default class, when unset:
  lua_settop(L, 2);
  lua_getfield(L, 1, "_class");  // 3
  if (!lua_toboolean(L, 3)) {
    lua_settop(L, 2);
    lua_getfield(L,
      LUA_REGISTRYINDEX,
      MONDELEFANT_CLASS_PROTO_REGKEY
    );  // 3
  }
  // get value of "_type" attribute:
  lua_getfield(L, 1, "_type");  // 4
  result_type = lua_tostring(L, 4);
  // different lookup for lists and objects:
  if (result_type && !strcmp(result_type, "object")) {  // object
    lua_settop(L, 3);
    // try inherited attributes, methods or getter functions:
    while (lua_toboolean(L, 3)) {
      lua_getfield(L, 3, "object");  // 4
      lua_pushvalue(L, 2);  // 5
      lua_gettable(L, 4);  // 5
      if (!lua_isnil(L, 5)) return 1;
      lua_settop(L, 3);
      lua_getfield(L, 3, "object_get");  // 4
      lua_pushvalue(L, 2);  // 5
      lua_gettable(L, 4);  // 5
      if (lua_toboolean(L, 5)) {
        lua_pushvalue(L, 1);  // 6
        lua_call(L, 1, 1);  // 5
        return 1;
      }
      lua_settop(L, 3);
      lua_pushliteral(L, "prototype");  // 4
      lua_rawget(L, 3);  // 4
      lua_replace(L, 3);
    }
    lua_settop(L, 2);
    // try primary keys of referenced objects:
    lua_pushcfunction(L,
      mondelefant_class_get_foreign_key_reference_name
    );  // 3
    lua_getfield(L, 1, "_class");  // 4
    lua_pushvalue(L, 2);  // 5
    lua_call(L, 2, 1);  // 3
    if (!lua_isnil(L, 3)) {
      // reference name at stack position 3
      lua_pushcfunction(L, mondelefant_class_get_reference);  // 4
      lua_getfield(L, 1, "_class");  // 5
      lua_pushvalue(L, 3);  // 6
      lua_call(L, 2, 1);  // reference info at stack position 4
      lua_getfield(L, 1, "_ref");  // 5
      lua_getfield(L, 4, "ref");  // 6
      lua_gettable(L, 5);  // 6
      if (!lua_isnil(L, 6)) {
        if (lua_toboolean(L, 6)) {
          lua_getfield(L, 4, "that_key");  // 7
          if (lua_isnil(L, 7)) {
            return luaL_error(L, "Missing 'that_key' entry in model reference.");
          }
          lua_gettable(L, 6);  // 7
        } else {
          lua_pushnil(L);
        }
        return 1;
      }
    }
    lua_settop(L, 2);
    // try normal data field info:
    lua_getfield(L, 1, "_data");  // 3
    lua_pushvalue(L, 2);  // 4
    lua_gettable(L, 3);  // 4
    if (!lua_isnil(L, 4)) return 1;
    lua_settop(L, 2);
    // try cached referenced object (or cached NULL reference):
    lua_getfield(L, 1, "_ref");  // 3
    lua_pushvalue(L, 2);  // 4
    lua_gettable(L, 3);  // 4
    if (lua_isboolean(L, 4) && !lua_toboolean(L, 4)) {
      lua_pushnil(L);
      return 1;
    } else if (!lua_isnil(L, 4)) {
      return 1;
    }
    lua_settop(L, 2);
    // try to load a referenced object:
    lua_pushcfunction(L, mondelefant_class_get_reference);  // 3
    lua_getfield(L, 1, "_class");  // 4
    lua_pushvalue(L, 2);  // 5
    lua_call(L, 2, 1);  // 3
    if (!lua_isnil(L, 3)) {
      lua_settop(L, 2);
      lua_getfield(L, 1, "load");  // 3
      lua_pushvalue(L, 1);  // 4 (self)
      lua_pushvalue(L, 2);  // 5
      lua_call(L, 2, 0);
      lua_settop(L, 2);
      lua_getfield(L, 1, "_ref");  // 3
      lua_pushvalue(L, 2);  // 4
      lua_gettable(L, 3);  // 4
      if (lua_isboolean(L, 4) && !lua_toboolean(L, 4)) lua_pushnil(L);  // TODO: use special object instead of false
      return 1;
    }
    return 0;
  } else if (result_type && !strcmp(result_type, "list")) {  // list
    lua_settop(L, 3);
    // try inherited list attributes or methods:
    while (lua_toboolean(L, 3)) {
      lua_getfield(L, 3, "list");  // 4
      lua_pushvalue(L, 2);  // 5
      lua_gettable(L, 4);  // 5
      if (!lua_isnil(L, 5)) return 1;
      lua_settop(L, 3);
      lua_pushliteral(L, "prototype");  // 4
      lua_rawget(L, 3);  // 4
      lua_replace(L, 3);
    }
  }
  // return nothing:
  return 0;
}

// meta-method "__newindex" of database result lists and objects:
static int mondelefant_result_newindex(lua_State *L) {
  const char *result_type;
  // perform rawset, unless key is a string not starting with underscore:
  lua_settop(L, 3);
  if (lua_type(L, 2) != LUA_TSTRING || lua_tostring(L, 2)[0] == '_') {
    lua_rawset(L, 1);
    return 1;
  }
  // get value of "_class" attribute, or default class, when unset:
  lua_getfield(L, 1, "_class");  // 4
  if (!lua_toboolean(L, 4)) {
    lua_settop(L, 3);
    lua_getfield(L,
      LUA_REGISTRYINDEX,
      MONDELEFANT_CLASS_PROTO_REGKEY
    );  // 4
  }
  // get value of "_type" attribute:
  lua_getfield(L, 1, "_type");  // 5
  result_type = lua_tostring(L, 5);
  // distinguish between lists and objects:
  if (result_type && !strcmp(result_type, "object")) {  // objects
    lua_settop(L, 4);
    // try object setter functions:
    while (lua_toboolean(L, 4)) {
      lua_getfield(L, 4, "object_set");  // 5
      lua_pushvalue(L, 2);  // 6
      lua_gettable(L, 5);  // 6
      if (lua_toboolean(L, 6)) {
        lua_pushvalue(L, 1);  // 7
        lua_pushvalue(L, 3);  // 8
        lua_call(L, 2, 0);
        return 0;
      }
      lua_settop(L, 4);
      lua_pushliteral(L, "prototype");  // 5
      lua_rawget(L, 4);  // 5
      lua_replace(L, 4);
    }
    lua_settop(L, 3);
    // check, if a object reference is changed:
    lua_pushcfunction(L, mondelefant_class_get_reference);  // 4
    lua_getfield(L, 1, "_class");  // 5
    lua_pushvalue(L, 2);  // 6
    lua_call(L, 2, 1);  // 4
    if (!lua_isnil(L, 4)) {
      // store object in _ref table (use false for nil):  // TODO: use special object instead of false
      lua_getfield(L, 1, "_ref");  // 5
      lua_pushvalue(L, 2);  // 6
      if (lua_isnil(L, 3)) lua_pushboolean(L, 0);  // 7
      else lua_pushvalue(L, 3);  // 7
      lua_settable(L, 5);
      lua_settop(L, 4);
      // delete referencing key from _data table:
      lua_getfield(L, 4, "this_key");  // 5
      if (lua_isnil(L, 5)) {
        return luaL_error(L, "Missing 'this_key' entry in model reference.");
      }
      lua_getfield(L, 1, "_data");  // 6
      lua_pushvalue(L, 5);  // 7
      lua_pushnil(L);  // 8
      lua_settable(L, 6);
      lua_settop(L, 5);
      lua_getfield(L, 1, "_dirty");  // 6
      lua_pushvalue(L, 5);  // 7
      lua_pushboolean(L, 1);  // 8
      lua_settable(L, 6);
      return 0;
    }
    lua_settop(L, 3);
    // store value in data field info:
    lua_getfield(L, 1, "_data");  // 4
    lua_pushvalue(L, 2);  // 5
    lua_pushvalue(L, 3);  // 6
    lua_settable(L, 4);
    lua_settop(L, 3);
    // mark field as dirty (needs to be UPDATEd on save):
    lua_getfield(L, 1, "_dirty");  // 4
    lua_pushvalue(L, 2);  // 5
    lua_pushboolean(L, 1);  // 6
    lua_settable(L, 4);
    lua_settop(L, 3);
    // reset reference cache, if neccessary:
    lua_pushcfunction(L,
      mondelefant_class_get_foreign_key_reference_name
    );  // 4
    lua_getfield(L, 1, "_class");  // 5
    lua_pushvalue(L, 2);  // 6
    lua_call(L, 2, 1);  // 4
    if (!lua_isnil(L, 4)) {
      lua_getfield(L, 1, "_ref");  // 5
      lua_pushvalue(L, 4);  // 6
      lua_pushnil(L);  // 7
      lua_settable(L, 5);
    }
    return 0;
  } else {  // non-objects (i.e. lists)
    // perform rawset:
    lua_settop(L, 3);
    lua_rawset(L, 1);
    return 0;
  }
}

// meta-method "__index" of classes (models):
static int mondelefant_class_index(lua_State *L) {
  // perform lookup in prototype:
  lua_settop(L, 2);
  lua_pushliteral(L, "prototype");  // 3
  lua_rawget(L, 1);  // 3
  lua_pushvalue(L, 2);  // 4
  lua_gettable(L, 3);  // 4
  return 1;
}

// registration information for functions of library:
static const struct luaL_Reg mondelefant_module_functions[] = {
  {"connect", mondelefant_connect},
  {"set_class", mondelefant_set_class},
  {"new_class", mondelefant_new_class},
  {NULL, NULL}
};

// registration information for meta-methods of database connections:
static const struct luaL_Reg mondelefant_conn_mt_functions[] = {
  {"__gc", mondelefant_conn_free},
  {"__index", mondelefant_conn_index},
  {"__newindex", mondelefant_conn_newindex},
  {NULL, NULL}
};

// registration information for methods of database connections:
static const struct luaL_Reg mondelefant_conn_methods[] = {
  {"close", mondelefant_conn_close},
  {"is_ok", mondelefant_conn_is_ok},
  {"get_transaction_status", mondelefant_conn_get_transaction_status},
  {"create_list", mondelefant_conn_create_list},
  {"create_object", mondelefant_conn_create_object},
  {"quote_string", mondelefant_conn_quote_string},
  {"quote_binary", mondelefant_conn_quote_binary},
  {"assemble_command", mondelefant_conn_assemble_command},
  {"try_query", mondelefant_conn_try_query},
  {"query", mondelefant_conn_query},
  {NULL, NULL}
};

// registration information for meta-methods of error objects:
static const struct luaL_Reg mondelefant_errorobject_mt_functions[] = {
  {NULL, NULL}
};

// registration information for methods of error objects:
static const struct luaL_Reg mondelefant_errorobject_methods[] = {
  {"escalate", mondelefant_errorobject_escalate},
  {"is_kind_of", mondelefant_errorobject_is_kind_of},
  {NULL, NULL}
};

// registration information for meta-methods of database result lists/objects:
static const struct luaL_Reg mondelefant_result_mt_functions[] = {
  {"__index", mondelefant_result_index},
  {"__newindex", mondelefant_result_newindex},
  {NULL, NULL}
};

// registration information for methods of database result lists/objects:
static const struct luaL_Reg mondelefant_class_mt_functions[] = {
  {"__index", mondelefant_class_index},
  {NULL, NULL}
};

// registration information for methods of classes (models):
static const struct luaL_Reg mondelefant_class_methods[] = {
  {"get_reference", mondelefant_class_get_reference},
  {"iterate_over_references", mondelefant_class_iterate_over_references},
  {"get_foreign_key_reference_name",
    mondelefant_class_get_foreign_key_reference_name},
  {NULL, NULL}
};

// registration information for methods of database result objects (not lists!):
static const struct luaL_Reg mondelefant_object_methods[] = {
  {NULL, NULL}
};

// registration information for methods of database result lists (not single objects!):
static const struct luaL_Reg mondelefant_list_methods[] = {
  {NULL, NULL}
};

// luaopen function to initialize/register library:
int luaopen_mondelefant_native(lua_State *L) {
  lua_settop(L, 0);
  lua_newtable(L);  // module at stack position 1
#if LUA_VERSION_NUM >= 502
  luaL_setfuncs(L, mondelefant_module_functions, 0);
#else
  luaL_register(L, NULL, mondelefant_module_functions);
#endif

  lua_pushvalue(L, 1);  // 2
  lua_setfield(L, LUA_REGISTRYINDEX, MONDELEFANT_MODULE_REGKEY);

  lua_newtable(L);  // 2
  // NOTE: only PostgreSQL is supported yet:
#if LUA_VERSION_NUM >= 502
  luaL_setfuncs(L, mondelefant_conn_methods, 0);
#else
  luaL_register(L, NULL, mondelefant_conn_methods);
#endif
  lua_setfield(L, 1, "postgresql_connection_prototype");
  lua_newtable(L);  // 2
  lua_setfield(L, 1, "connection_prototype");

  luaL_newmetatable(L, MONDELEFANT_CONN_MT_REGKEY);  // 2
#if LUA_VERSION_NUM >= 502
  luaL_setfuncs(L, mondelefant_conn_mt_functions, 0);
#else
  luaL_register(L, NULL, mondelefant_conn_mt_functions);
#endif
  lua_settop(L, 1);
  luaL_newmetatable(L, MONDELEFANT_RESULT_MT_REGKEY);  // 2
#if LUA_VERSION_NUM >= 502
  luaL_setfuncs(L, mondelefant_result_mt_functions, 0);
#else
  luaL_register(L, NULL, mondelefant_result_mt_functions);
#endif
  lua_setfield(L, 1, "result_metatable");
  luaL_newmetatable(L, MONDELEFANT_CLASS_MT_REGKEY);  // 2
#if LUA_VERSION_NUM >= 502
  luaL_setfuncs(L, mondelefant_class_mt_functions, 0);
#else
  luaL_register(L, NULL, mondelefant_class_mt_functions);
#endif
  lua_setfield(L, 1, "class_metatable");

  lua_newtable(L);  // 2
  lua_newtable(L);  // 3
#if LUA_VERSION_NUM >= 502
  luaL_setfuncs(L, mondelefant_object_methods, 0);
#else
  luaL_register(L, NULL, mondelefant_object_methods);
#endif
  lua_setfield(L, 2, "object");
  lua_newtable(L);  // 3
  lua_setfield(L, 2, "object_get");
  lua_newtable(L);  // 3
  lua_setfield(L, 2, "object_set");
  lua_newtable(L);  // 3
#if LUA_VERSION_NUM >= 502
  luaL_setfuncs(L, mondelefant_list_methods, 0);
#else
  luaL_register(L, NULL, mondelefant_list_methods);
#endif
  lua_setfield(L, 2, "list");
  lua_newtable(L);  // 3
  lua_setfield(L, 2, "references");
  lua_newtable(L);  // 3
  lua_setfield(L, 2, "foreign_keys");
  lua_pushvalue(L, 2);  // 3
  lua_setfield(L, LUA_REGISTRYINDEX, MONDELEFANT_CLASS_PROTO_REGKEY);
  lua_setfield(L, 1, "class_prototype");

  lua_newtable(L);  // 2
  lua_pushliteral(L, "k");  // 3
  lua_setfield(L, 2, "__mode");
  lua_newtable(L);  // 3
  lua_pushvalue(L, 2);  // 4
  lua_setmetatable(L, 3);
  lua_setfield(L, LUA_REGISTRYINDEX, MONDELEFANT_CONN_DATA_REGKEY);
  lua_settop(L, 1);

  luaL_newmetatable(L, MONDELEFANT_ERROROBJECT_MT_REGKEY);  // 2
#if LUA_VERSION_NUM >= 502
  luaL_setfuncs(L, mondelefant_errorobject_mt_functions, 0);
#else
  luaL_register(L, NULL, mondelefant_errorobject_mt_functions);
#endif
  lua_newtable(L);  // 3
#if LUA_VERSION_NUM >= 502
  luaL_setfuncs(L, mondelefant_errorobject_methods, 0);
#else
  luaL_register(L, NULL, mondelefant_errorobject_methods);
#endif
  lua_setfield(L, 2, "__index");
  lua_setfield(L, 1, "errorobject_metatable");

  return 1;
}
