#!/bin/bash
if [ $# -lt 1 ];then
  echo "Usage: $0 <db_name>"
  exit 1
fi

db_name=$1
psql_cmd="/usr/bin/psql"
assemblies="assemblies.list"

echo "INSERT INTO unit_group (name) SELECT name FROM unit WHERE description ='`head -1 ${assemblies}`' ;"| ${psql_cmd} -q ${db_name}
echo "INSERT INTO unit_group_member (unit_group_id,unit_id) SELECT a.id ,b.id FROM unit_group AS a JOIN unit AS b ON a.name=b.name;"| ${psql_cmd} -q ${db_name}

