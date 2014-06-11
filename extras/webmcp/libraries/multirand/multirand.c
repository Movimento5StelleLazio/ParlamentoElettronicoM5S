#include <lua.h>
#include <lauxlib.h>

static FILE *multirand_dev;

static lua_Integer multirand_range(
  lua_State *L, lua_Integer from, lua_Integer to
) {
  lua_Integer range;
  int bits = 0;
  lua_Integer bit_mask = 0;
  if (to < from) return luaL_error(L, "Assertion failed in C.");
  range = to - from;
  {
    lua_Integer tmp;
    tmp = range;
    while (tmp) {
      bits++;
      bit_mask <<= 1;
      bit_mask |= 1;
      tmp >>= 1;
    }
  }
  while (1) {
    int i;
    lua_Integer rnd = 0;
    for (i = 0; i < (bits + 7) / 8; i++) {
      int b;
      b = getc(multirand_dev);
      if (b == EOF) {
        return luaL_error(L, "I/O error while reading random.");
      }
      rnd = (rnd << 8) | (unsigned char)b;
    }
    rnd &= bit_mask;
    if (rnd <= range) return from + rnd;
  }
}

static int multirand_integer(lua_State *L) {
  lua_Integer arg1, arg2;
  lua_settop(L, 2);
  arg1 = luaL_checkinteger(L, 1);
  if (lua_toboolean(L, 2)) {
    arg2 = luaL_checkinteger(L, 2);
    if (arg1 > arg2) {
      return luaL_error(L,
        "Upper boundary is smaller than lower boundary."
      );
    } else if (arg1 == arg2) {
      lua_pushinteger(L, arg1);
    } else {
      lua_pushinteger(L, multirand_range(L, arg1, arg2));
    }
  } else {
    luaL_argcheck(L, arg1 >= 1, 1, "smaller than 1");
    lua_pushinteger(L, multirand_range(L, 1, arg1));
  }
  return 1;
}

static int multirand_fraction(lua_State *L) {
  int i, j;
  lua_settop(L, 0);
  lua_Number rnd = 0.0;
  for (i = 0; i < 8; i++) {
    int b;
    unsigned char c;
    b = getc(multirand_dev);
    if (b == EOF) return luaL_error(L, "I/O error while reading random.");
    c = (unsigned char) b;
    for (j = 0; j < 8; j++) {
      rnd /= 2.0;
      if (c & 1) rnd += 0.5;
      c >>= 1;
    }
  }
  lua_pushnumber(L, rnd);
  return 1;
}

static int multirand_string(lua_State *L) {
  int length;
  const char *charset;
  size_t charset_size;
  luaL_Buffer buf;
  lua_settop(L, 2);
  length = luaL_checkint(L, 1);
  charset = luaL_optlstring(L, 2, "abcdefghijklmnopqrstuvwxyz", &charset_size);
  if (charset_size > 32767) {
    return luaL_error(L, "Set of chars is too big.");
  }
  luaL_buffinit(L, &buf);
  for (; length > 0; length--) {
    luaL_addchar(&buf,
      charset[multirand_range(L, 0, (lua_Integer)charset_size - 1)]
    );
  }
  luaL_pushresult(&buf);
  return 1;
}

static const struct luaL_Reg multirand_module_functions[] = {
  {"integer",  multirand_integer},
  {"fraction", multirand_fraction},
  {"string",   multirand_string},
  {NULL, NULL}
};

int luaopen_multirand(lua_State *L) {
  multirand_dev = fopen("/dev/urandom", "r");
  if (!multirand_dev) return luaL_error(L, "Could not open /dev/urandom.");
#if LUA_VERSION_NUM >= 502
  lua_newtable(L);
  luaL_setfuncs(L, multirand_module_functions, 0);
#else
  luaL_register(L, lua_tostring(L, 1), multirand_module_functions);
#endif
  return 1;
}
