#!/bin/bash


if [ $# -lt 3 ];then
  echo "Usage: $0 <input_file> <root_unit_id> <db_name>"
  exit 1
fi

input_file=$1
root_unit_id=$2
db_name=$3
psql_cmd="/usr/bin/psql"

cat ${input_file} | while read line; do
  unit_name=`echo ${line} | awk -F, '{print $1}'`
  root_unit_name=`echo ${line} | awk -F, '{print $2}'`

  if [ "z${root_unit_name}" == "z" ];then
    echo "INSERT INTO unit (name,parent_id,description) VALUES ('${unit_name}',${root_unit_id},'Comune di ${unit_name}');" | ${psql_cmd} ${db_name}
  else
    echo "INSERT INTO unit (name,parent_id,description) VALUES ('${unit_name}',(SELECT id FROM unit WHERE name = '${root_unit_name}') ,'Comune di ${unit_name}');" | ${psql_cmd} ${db_name}
  fi

  
done
