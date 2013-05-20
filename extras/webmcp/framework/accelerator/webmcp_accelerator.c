#include <lua.h>
#include <lauxlib.h>
#include <stdlib.h>
#include <string.h>

static int webmcp_encode_html(lua_State *L) {
  const char *input;
  size_t input_len;
  size_t i;
  luaL_Buffer buf;
  input = luaL_checklstring(L, 1, &input_len);
  for (i=0; i<input_len; i++) {
    char c = input[i];
    if ((c == '<') || (c == '>') || (c == '&') || (c == '"')) break;
  }
  if (i == input_len) {
    lua_settop(L, 1);
    return 1;
  }
  luaL_buffinit(L, &buf);
  for (i=0; i<input_len; i++) {
    char c;
    size_t j = i;
    do {
      c = input[j];
      if ((c == '<') || (c == '>') || (c == '&') || (c == '"')) break;
      else j++;
    } while (j<input_len);
    if (j != i) {
      luaL_addlstring(&buf, input+i, j-i);
      i = j;
    }
    if (i<input_len) {
      if      (c == '<') luaL_addstring(&buf, "&lt;");
      else if (c == '>') luaL_addstring(&buf, "&gt;");
      else if (c == '&') luaL_addstring(&buf, "&amp;");
      else if (c == '"') luaL_addstring(&buf, "&quot;");
      else abort();  // should not happen
    }
  }
  luaL_pushresult(&buf);
  return 1;
}

static int webmcp_slot_put_into(lua_State *L) {
  int argc;
  int i;
  int j;
  luaL_checkany(L, 1);
  argc = lua_gettop(L);
  lua_getglobal(L, "slot");
  lua_getfield(L, -1, "_data");
  lua_pushvalue(L, 1);
  lua_gettable(L, -2);  // get table by reference passed as 1st argument
  lua_getfield(L, -1, "string_fragments");
#if LUA_VERSION_NUM >= 502
  j = lua_rawlen(L, -1);
#else
  j = lua_objlen(L, -1);
#endif
  for (i=2; i<=argc; i++) {
    lua_pushvalue(L, i);
    lua_rawseti(L, -2, ++j);
  }
  return 0;
}

static int webmcp_slot_put(lua_State *L) {
  int argc;
  int i;
  int j;
  argc = lua_gettop(L);
  lua_getglobal(L, "slot");
  lua_getfield(L, -1, "_data");
  lua_getfield(L, -2, "_active_slot");
  lua_gettable(L, -2);
  lua_getfield(L, -1, "string_fragments");
#if LUA_VERSION_NUM >= 502
  j = lua_rawlen(L, -1);
#else
  j = lua_objlen(L, -1);
#endif
  for (i=1; i<=argc; i++) {
    lua_pushvalue(L, i);
    lua_rawseti(L, -2, ++j);
  }
  return 0;
}

static int webmcp_ui_tag(lua_State *L) {
  int tag_given = 0;
  int j;
  lua_settop(L, 1);
  luaL_checktype(L, 1, LUA_TTABLE);
  lua_getglobal(L, "slot");       // 2
  lua_getfield(L, 2, "_data");    // 3
  lua_getfield(L, 2, "_active_slot");
  lua_gettable(L, 3);             // 4
  lua_getfield(L, 4, "string_fragments");  // 5
  lua_getfield(L, 1, "tag");      // 6
  lua_getfield(L, 1, "attr");     // 7
  lua_getfield(L, 1, "content");  // 8
  if (lua_toboolean(L, 7) && !lua_istable(L, 7)) {
    return luaL_error(L,
      "\"attr\" argument for ui.tag{...} must be nil or a table."
    );
  }
  if (lua_toboolean(L, 6)) {
    tag_given = 1;
  } else if (lua_toboolean(L, 7)) {
    lua_pushnil(L);
    if (lua_next(L, 7)) {
      lua_pop(L, 2);
      lua_pushliteral(L, "span");
      lua_replace(L, 6);
      tag_given = 1;
    }
  }
#if LUA_VERSION_NUM >= 502
  j = lua_rawlen(L, 5);
#else
  j = lua_objlen(L, 5);
#endif
  if (tag_given) {
    lua_pushliteral(L, "<");
    lua_rawseti(L, 5, ++j);
    lua_pushvalue(L, 6);
    lua_rawseti(L, 5, ++j);
    if (lua_toboolean(L, 7)) {
      for (lua_pushnil(L); lua_next(L, 7); lua_pop(L, 1)) {
        // key at position 9
        // value at position 10
        lua_pushliteral(L, " ");
        lua_rawseti(L, 5, ++j);
        lua_pushvalue(L, 9);
        lua_rawseti(L, 5, ++j);
        lua_pushliteral(L, "=\"");
        lua_rawseti(L, 5, ++j);
        if (!strcmp(lua_tostring(L, 9), "class") && lua_istable(L, 10)) {  // NOTE: lua_tostring(...) is destructive, will cause errors for numeric keys
          lua_getglobal(L, "table");  // 11
          lua_getfield(L, 11, "concat");  // 12
          lua_replace(L, 11);  // 11
          lua_pushvalue(L, 10);  // 12
          lua_pushliteral(L, " ");  // 13
          lua_call(L, 2, 1);  // 11
          lua_rawseti(L, 5, ++j);
        } else {
          lua_pushcfunction(L, webmcp_encode_html);
          lua_pushvalue(L, 10);
          lua_call(L, 1, 1);
          lua_rawseti(L, 5, ++j);
        }
        lua_pushliteral(L, "\"");
        lua_rawseti(L, 5, ++j);
      }
    }
  }
  if (lua_toboolean(L, 8)) {
    if (tag_given) {
      lua_pushliteral(L, ">");
      lua_rawseti(L, 5, ++j);
    }
    if (lua_isfunction(L, 8)) {
      // content function should be on last stack position 8
      lua_call(L, 0, 0);
      // stack is now at position 7, but we don't care
      // we assume that the active slot hasn't been exchanged or resetted
#if LUA_VERSION_NUM >= 502
      j = lua_rawlen(L, 5);  // but it may include more elements now
#else
      j = lua_objlen(L, 5);  // but it may include more elements now
#endif
    } else {
      lua_pushcfunction(L, webmcp_encode_html);  // 9
      lua_pushvalue(L, 8);  // 10
      lua_call(L, 1, 1);  // 9
      lua_rawseti(L, 5, ++j);
    }
    if (tag_given) {
      lua_pushliteral(L, "</");
      lua_rawseti(L, 5, ++j);
      lua_pushvalue(L, 6);
      lua_rawseti(L, 5, ++j);
      lua_pushliteral(L, ">");
      lua_rawseti(L, 5, ++j);
    }
  } else {
    if (tag_given) {
      lua_pushliteral(L, " />");
      lua_rawseti(L, 5, ++j);
    }
  }
  return 0;
}

int luaopen_webmcp_accelerator(lua_State *L) {
  lua_settop(L, 0);
  lua_getglobal(L, "encode");  // 1
  lua_pushcfunction(L, webmcp_encode_html);
  lua_setfield(L, 1, "html");
  lua_settop(L, 0);
  lua_getglobal(L, "slot");  // 1
  lua_pushcfunction(L, webmcp_slot_put_into);
  lua_setfield(L, 1, "put_into");
  lua_pushcfunction(L, webmcp_slot_put);
  lua_setfield(L, 1, "put");
  lua_settop(L, 0);
  lua_getglobal(L, "ui");  // 1
  lua_pushcfunction(L, webmcp_ui_tag);
  lua_setfield(L, 1, "tag");
  return 0;
}
