#include <stdlib.h>
#include <stdio.h>
#include <libpq-fe.h>
#include <string.h>
#include <regex.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#ifndef GETPIC_CONNINFO
#define GETPIC_CONNINFO "dbname=liquid_feedback"
#endif

#ifndef GETPIC_DEFAULT_AVATAR
#define GETPIC_DEFAULT_AVATAR "/opt/liquid_feedback_testing/app/static/avatar.jpg"
#endif

int main(int argc, const char * const *argv) {

  char *args_string;
  char *member_id;
  char *image_type;
  const char *sql_member_image_params[2];

#ifndef PUBLIC_ACCESS
  char *cookies;
  regex_t session_ident_regex;
  ssize_t start, length;
  regmatch_t session_ident_regmatch[3];
  char *session_ident;
  const char *sql_session_params[1];
#endif

  PGconn *conn;
  PGresult *dbr;

  args_string = getenv("QUERY_STRING");
#ifdef PUBLIC_ACCESS
  if (!args_string) {
    fputs("Status: 403 Access Denied\n\n", stdout);
    return 0;
  }
#else
  cookies = getenv("HTTP_COOKIE");
  if (!args_string || !cookies) {
    fputs("Status: 403 Access Denied\n\n", stdout);
    return 0;
  }
#endif

  member_id   = strtok(args_string, "+");
  image_type  = strtok(NULL, "+");
  sql_member_image_params[0] = member_id;
  sql_member_image_params[1] = image_type;

#ifndef PUBLIC_ACCESS
  if (regcomp(&session_ident_regex, "(^|[; \t])liquid_feedback_session=([0-9A-Za-z]+)", REG_EXTENDED) != 0) {
    // shouldn't happen
    abort();
  }
  if (regexec(&session_ident_regex, cookies, 3, session_ident_regmatch, 0) != 0) {
    fputs("Status: 403 Access Denied\n\n", stdout);
    return 0;
  }
  start = session_ident_regmatch[2].rm_so;
  length = session_ident_regmatch[2].rm_eo - session_ident_regmatch[2].rm_so;
  session_ident = malloc(length + 1);
  if (!session_ident) abort();  // shouldn't happen
  strncpy(session_ident, cookies + start, length);
  session_ident[length] = 0;
  sql_session_params[0] = session_ident;
#endif

  conn = PQconnectdb(GETPIC_CONNINFO);
  if (!conn) {
    fputs("Could not create PGconn structure.\n", stderr);
    return 1;
  }
  if (PQstatus(conn) != CONNECTION_OK) {
    fputs(PQerrorMessage(conn), stderr);
    PQfinish(conn);
    return 1;
  }

#ifndef PUBLIC_ACCESS
  dbr = PQexecParams(conn,
    "SELECT NULL FROM session JOIN member ON member.id = session.member_id WHERE session.ident = $1 AND member.active",
    1, NULL, sql_session_params, NULL, NULL, 0
  );
  if (PQresultStatus(dbr) != PGRES_TUPLES_OK) {
    fputs(PQresultErrorMessage(dbr), stderr);
    PQfinish(conn);
    return 1;
  }
  if (PQntuples(dbr) != 1) {
    fputs("Status: 403 Access Denied\n\n", stdout);
    PQfinish(conn);
    return 0;
  }
#endif

  dbr = PQexecParams(conn,
    "SELECT content_type, data "
    "FROM member_image "
    "WHERE member_id = $1 "
    "AND image_type = $2 "
    "AND scaled "
    "LIMIT 1;",
    2, NULL, sql_member_image_params, NULL, NULL, 1
  );
  if (PQresultStatus(dbr) != PGRES_TUPLES_OK) {
    fputs(PQresultErrorMessage(dbr), stderr);
    PQfinish(conn);
    return 1;
  }
  if (PQntuples(dbr) == 0) {
    struct stat sb;
    PQclear(dbr);
    PQfinish(conn);
    fputs("Content-Type: image/jpeg\n\n", stdout);
    if (stat(GETPIC_DEFAULT_AVATAR, &sb)) return 1;
    fprintf(stdout, "Content-Length: %i\n", (int)sb.st_size);
    execl("/bin/cat", "cat", GETPIC_DEFAULT_AVATAR, NULL);
    return 1;
  } else {
    if (PQnfields(dbr) < 0) {
      fputs("Too few columns returned by database.\n", stderr);
      PQfinish(conn);
      return 1;
    }
    if (PQfformat(dbr, 0) != 1 || PQfformat(dbr, 1) != 1) {
      fputs("Database did not return data in binary format.\n", stderr);
      PQfinish(conn);
      return 1;
    }
    if (PQgetisnull(dbr, 0, 0) || PQgetisnull(dbr, 0, 1)) {
      fputs("Unexpected NULL in database result.\n", stderr);
      PQfinish(conn);
      return 1;
    }
    fprintf(stdout, "Content-Type: %s\n\n", PQgetvalue(dbr, 0, 0));
    fwrite(PQgetvalue(dbr, 0, 1), PQgetlength(dbr, 0, 1), 1, stdout);
  }
  PQfinish(conn);
  return 0;

}
