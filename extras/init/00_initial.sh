#!/bin/bash
if [ $# -lt 1 ];then
  echo "Usage: $0 <db_name>"
  exit 1
fi

db_name=$1
psql_cmd="/usr/bin/psql"

echo "INSERT INTO member (login, name, admin, invite_code, realname, lqfb_access, auditor) VALUES ('admin', 'Administrator', TRUE, 'admin', 'Administrator', TRUE, TRUE);"| ${psql_cmd} -q ${db_name}
echo "INSERT INTO system_setting (member_ttl,gui_preset) VALUES ('1 year','custom');"| ${psql_cmd} -q ${db_name}

zcat db_istat.sql.gz |${psql_cmd} -q ${db_name}
