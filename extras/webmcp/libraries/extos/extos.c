#include <lua.h>
#include <lauxlib.h>
#include <dirent.h>
#include <time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <poll.h>
#include <stdlib.h>

#define EXTOS_MAX_ERRLEN 80
#define EXTOS_EXEC_MAX_ARGS 64

static lua_Number extos_monotonic_start_time;

static int extos_pfilter(lua_State *L) {
  int i, result, exit_status, status_pipe_len;
  const char *in_buf;
  size_t in_len;
  size_t in_pos = 0;
  const char *filename;
  const char *args[EXTOS_EXEC_MAX_ARGS+2];
  int pipe_status[2];
  int pipe_in[2];
  int pipe_out[2];
  int pipe_err[2];
  pid_t child;
  char status_buf[1];
  char *out_buf = NULL;
  size_t out_len = 1024;
  size_t out_pos = 0;
  char *err_buf = NULL;
  size_t err_len = 1024;
  size_t err_pos = 0;
  void *old_sigpipe_action;
  struct pollfd fds[3];
  int in_closed = 0;
  int out_closed = 0;
  int err_closed = 0;
  void *newptr;
  char errmsg[EXTOS_MAX_ERRLEN+1];
  in_buf = luaL_optlstring(L, 1, "", &in_len);
  filename = luaL_checkstring(L, 2);
  args[0] = filename;
  for (i = 0; i < EXTOS_EXEC_MAX_ARGS; i++) {
    if (lua_isnoneornil(L, 3+i)) break;
    else args[i+1] = luaL_checkstring(L, 3+i);
  }
  if (!lua_isnoneornil(L, 3+i)) {
    return luaL_error(L, "Too many arguments for pfilter call.");
  }
  args[i+1] = 0;
  // status pipe for internal communication
  if (pipe(pipe_status) < 0) {
    strerror_r(errno, errmsg, EXTOS_MAX_ERRLEN+1);
    goto extos_pfilter_error_A0;
  }
  // stdin
  if (pipe(pipe_in) < 0) {
    strerror_r(errno, errmsg, EXTOS_MAX_ERRLEN+1);
    goto extos_pfilter_error_A1;
  }
  if (in_len) {
    do result = fcntl(pipe_in[1], F_SETFL, O_NONBLOCK); while (result < 0 && errno == EINTR);
  } else {
    do result = close(pipe_in[1]); while (result < 0 && errno == EINTR);
    in_closed = 1;
  }
  if (result < 0) {
    strerror_r(errno, errmsg, EXTOS_MAX_ERRLEN+1);
    goto extos_pfilter_error_A2;
  }
  // stdout
  if (pipe(pipe_out) < 0) {
    strerror_r(errno, errmsg, EXTOS_MAX_ERRLEN+1);
    goto extos_pfilter_error_A2;
  }
  do result = fcntl(pipe_out[0], F_SETFL, O_NONBLOCK); while (result < 0 && errno == EINTR);
  if (result < 0) {
    strerror_r(errno, errmsg, EXTOS_MAX_ERRLEN+1);
    goto extos_pfilter_error_A3;
  }
  // stderr
  if (pipe(pipe_err) < 0) {
    strerror_r(errno, errmsg, EXTOS_MAX_ERRLEN+1);
    goto extos_pfilter_error_A3;
  }
  do result = fcntl(pipe_err[0], F_SETFL, O_NONBLOCK); while (result < 0 && errno == EINTR);
  if (result < 0) {
    strerror_r(errno, errmsg, EXTOS_MAX_ERRLEN+1);
    goto extos_pfilter_error_A4;
  }
  // fork
  child = fork();
  if (child < 0) {
    strerror_r(errno, errmsg, EXTOS_MAX_ERRLEN+1);
    goto extos_pfilter_error_A4;
  }
  // skip error handling
  goto extos_pfilter_success_A;
  // error handling
  extos_pfilter_error_A4:
  do result = close(pipe_err[0]); while (result < 0 && errno == EINTR);
  do result = close(pipe_err[1]); while (result < 0 && errno == EINTR);  
  extos_pfilter_error_A3:
  do result = close(pipe_out[0]); while (result < 0 && errno == EINTR);
  do result = close(pipe_out[1]); while (result < 0 && errno == EINTR);  
  extos_pfilter_error_A2:
  do result = close(pipe_in[0]); while (result < 0 && errno == EINTR);
  do result = close(pipe_in[1]); while (result < 0 && errno == EINTR);
  extos_pfilter_error_A1:
  do result = close(pipe_status[0]); while (result < 0 && errno == EINTR);
  do result = close(pipe_status[1]); while (result < 0 && errno == EINTR);  
  extos_pfilter_error_A0:
  return luaL_error(L, "Unexpected error in pfilter: %s", errmsg);
  // end of error handling
  extos_pfilter_success_A:
  if (child) {  // parent
    old_sigpipe_action = signal(SIGPIPE, SIG_IGN);
    do result = close(pipe_status[1]); while (result < 0 && errno == EINTR);
    if (result < 0) goto extos_pfilter_error_B;
    do result = close(pipe_in[0]); while (result < 0 && errno == EINTR);
    if (result < 0) goto extos_pfilter_error_B;
    do result = close(pipe_out[1]); while (result < 0 && errno == EINTR);
    if (result < 0) goto extos_pfilter_error_B;
    do result = close(pipe_err[1]); while (result < 0 && errno == EINTR);
    if (result < 0) goto extos_pfilter_error_B;
    out_buf = malloc(out_len * sizeof(char));
    if (!out_buf) goto extos_pfilter_error_B;
    err_buf = malloc(err_len * sizeof(char));
    if (!err_buf) goto extos_pfilter_error_B;
    while (!in_closed || !out_closed || !err_closed) {
      i = 0;
      if (!in_closed) {
        fds[i].fd = pipe_in[1];
        fds[i].events = POLLOUT;
        i++;
      }
      if (!out_closed) {
        fds[i].fd = pipe_out[0];
        fds[i].events = POLLIN;
        i++;
      }
      if (!err_closed) {
        fds[i].fd = pipe_err[0];
        fds[i].events = POLLIN;
        i++;
      }
      do result = poll(fds, i, -1); while (result < 0 && errno == EINTR);
      if (result < 0) goto extos_pfilter_error_B;
      if (!in_closed) {
        do result = write(pipe_in[1], in_buf+in_pos, in_len-in_pos); while (result < 0 && errno == EINTR);
        if (result < 0) {
          if (errno == EPIPE) {
            do result = close(pipe_in[1]); while (result < 0 && errno == EINTR);
            in_closed = 1;
          } else if (errno != EAGAIN) {
            goto extos_pfilter_error_B;
          }
        } else {
          in_pos += result;
          if (in_pos == in_len) {
            do result = close(pipe_in[1]); while (result < 0 && errno == EINTR);
            in_closed = 1;
          }
        }
      }
      if (!out_closed) {
        do result = read(pipe_out[0], out_buf+out_pos, out_len-out_pos); while (result < 0 && errno == EINTR);
        if (result < 0) {
          if (errno != EAGAIN) goto extos_pfilter_error_B;
        } else if (result == 0) {
          do result = close(pipe_out[0]); while (result < 0 && errno == EINTR);
          out_closed = 1;
        } else {
          out_pos += result;
          if (out_pos == out_len) {
            out_len *= 2;
            newptr = realloc(out_buf, out_len * sizeof(char));
            if (!newptr) goto extos_pfilter_error_B;
            out_buf = newptr;
          }
        }
      }
      if (!err_closed) {
        do result = read(pipe_err[0], err_buf+err_pos, err_len-err_pos); while (result < 0 && errno == EINTR);
        if (result < 0) {
          if (errno != EAGAIN) goto extos_pfilter_error_B;
        } else if (result == 0) {
          do result = close(pipe_err[0]); while (result < 0 && errno == EINTR);
          err_closed = 1;
        } else {
          err_pos += result;
          if (err_pos == err_len) {
            err_len *= 2;
            newptr = realloc(err_buf, err_len * sizeof(char));
            if (!newptr) goto extos_pfilter_error_B;
            err_buf = newptr;
          }
        }
      }
    }
    lua_pushlstring(L, out_buf, out_pos);
    free(out_buf);
    out_buf = NULL;
    lua_pushlstring(L, err_buf, err_pos);
    free(err_buf);
    err_buf = NULL;
    do result = waitpid(child, &exit_status, 0); while (result < 0 && errno == EINTR);
    child = 0;
    if (result < 0) goto extos_pfilter_error_B;
    do status_pipe_len = read(pipe_status[0], status_buf, 1); while (status_pipe_len < 0 && errno == EINTR);
    if (status_pipe_len < 0) goto extos_pfilter_error_B;
    do result = close(pipe_status[0]); while (result < 0 && errno == EINTR);
    signal(SIGPIPE, old_sigpipe_action);
    if (status_pipe_len == 0) {
      if (WIFEXITED(exit_status)) lua_pushinteger(L, WEXITSTATUS(exit_status));
      else lua_pushinteger(L, -WTERMSIG(exit_status));
      return 3;
    } else if (status_buf[0] == 0) {
      return luaL_error(L, "Error in pfilter while reopening standard file descriptors in child process.");
    } else {
      strerror_r(status_buf[0], errmsg, EXTOS_MAX_ERRLEN+1);
      lua_pushnil(L);
      lua_pushfstring(L, "Could not execute \"%s\": %s", filename, errmsg);
      return 2;
    }
    extos_pfilter_error_B:
    signal(SIGPIPE, old_sigpipe_action);
    strerror_r(errno, errmsg, EXTOS_MAX_ERRLEN+1);
    if (out_buf) free(out_buf);
    if (err_buf) free(err_buf);
    if (!in_closed) {
      do result = close(pipe_in[1]); while (result < 0 && errno == EINTR);
    }
    if (!out_closed) {
      do result = close(pipe_out[0]); while (result < 0 && errno == EINTR);
    }
    if (!err_closed) {
      do result = close(pipe_err[0]); while (result < 0 && errno == EINTR);
    }
    if (child) do result = waitpid(child, &exit_status, 0); while (result < 0 && errno == EINTR);
    return luaL_error(L, "Unexpected error in pfilter: %s", errmsg);
  } else {  // child
    do result = close(pipe_status[0]); while (result < 0 && errno == EINTR);
    do result = close(pipe_in[1]); while (result < 0 && errno == EINTR);
    do result = close(pipe_out[0]); while (result < 0 && errno == EINTR);
    do result = close(0); while (result < 0 && errno == EINTR);
    do result = close(1); while (result < 0 && errno == EINTR);
    do result = close(2); while (result < 0 && errno == EINTR);
    do result = dup(pipe_in[0]); while (result < 0 && errno == EINTR);
    if (result != 0) goto extos_pfilter_error_fd_remapping;
    do result = dup(pipe_out[1]); while (result < 0 && errno == EINTR);
    if (result != 1) goto extos_pfilter_error_fd_remapping;
    do result = dup(pipe_err[1]); while (result < 0 && errno == EINTR);
    if (result != 2) goto extos_pfilter_error_fd_remapping;
    execvp(filename, args);
    status_buf[0] = errno;
    do result = write(pipe_status[1], status_buf, 1); while (result < 0 && errno == EINTR);
    _exit(0);
    extos_pfilter_error_fd_remapping:
    status_buf[0] = 0;
    do result = write(pipe_status[1], status_buf, 1); while (result < 0 && errno == EINTR);
    _exit(0);
  }
}

static int extos_listdir(lua_State *L) {
  DIR *dir;
  int i = 1;
  struct dirent entry_buffer;
  struct dirent *entry;
  dir = opendir(luaL_checkstring(L, 1));
  if (!dir) {
    lua_pushnil(L);
    lua_pushliteral(L, "Could not list directory.");
    return 2;
  }
  lua_settop(L, 0);
  lua_newtable(L);  // 1
  while (1) {
    readdir_r(dir, &entry_buffer, &entry);
    if (!entry) break;
    // Linux doesn't have d_namlen
    //lua_pushlstring(L, entry->d_name, entry->d_namlen);
    lua_pushstring(L, entry->d_name);
    lua_rawseti(L, 1, i++);
  }
  closedir(dir);
  return 1;
}

static int extos_crypt(lua_State *L) {
  char *key;
  char *salt;
  char *result;
  key = luaL_checkstring(L, 1);
  salt = luaL_checkstring(L, 2);
  result = crypt(key, salt);  // TODO: Call not thread safe
  if (result) lua_pushstring(L, result);
  else lua_pushnil(L);
  return 1;
}

static int extos_hires_time(lua_State *L) {
  struct timespec tp;
  if (clock_gettime(CLOCK_REALTIME, &tp)) {
    return luaL_error(L, "Could not access CLOCK_REALTIME.");
  }
  lua_pushnumber(L, tp.tv_sec + 0.000000001 * tp.tv_nsec);
  return 1;
}

// returns time in seconds since loading the library
static int extos_monotonic_hires_time(lua_State *L) {
  struct timespec tp;
  if (clock_gettime(CLOCK_MONOTONIC, &tp)) {
    return luaL_error(L, "Could not access CLOCK_MONOTONIC.");
  }
  lua_pushnumber(L,
    tp.tv_sec + 0.000000001 * tp.tv_nsec - extos_monotonic_start_time
  );
  return 1;
}

static const struct luaL_Reg extos_module_functions[] = {
  {"pfilter",              extos_pfilter},
  {"listdir",              extos_listdir},
  {"crypt",                extos_crypt},
  {"hires_time",           extos_hires_time},
  {"monotonic_hires_time", extos_monotonic_hires_time},
  {NULL, NULL}
};

int luaopen_extos(lua_State *L) {
  {
    struct timespec tp;
    if (clock_gettime(CLOCK_MONOTONIC, &tp)) {
      return luaL_error(L, "Could not access monotonic hires time.");
    }
    extos_monotonic_start_time = tp.tv_sec + 0.000000001 * tp.tv_nsec;
  }
#if LUA_VERSION_NUM >= 502
  lua_newtable(L);
  luaL_setfuncs(L, extos_module_functions, 0);
#else
  luaL_register(L, lua_tostring(L, 1), extos_module_functions);
#endif
  return 1;
}
