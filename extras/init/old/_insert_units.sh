#!/bin/bash
psql_cmd="/usr/bin/psql -e"

if [ $# -lt 3 ];then
  echo "Usage: $0 <input_file> <root_unit_name> <db_name>"
  exit 1
fi

input_file=$1
root_unit_name=$2
db_name=$3

echo "SELECT id FROM unit WHERE name = '${root_unit_name}';" | psql -At ${db_name}
root_unit_id=`echo "SELECT id FROM unit WHERE name = '${root_unit_name}';" | psql -At ${db_name}`
echo "Found id:${root_unit_id} for root unit ${root_unit_name}"

cat ${input_file} | while read line; do
  unit_name=`echo ${line} | awk -F, '{print $1}'`
  parent_unit_name=`echo ${line} | awk -F, '{print $2}'`

  if [ "z${parent_unit_name}" == "z" ];then
    echo "INSERT INTO unit (name,parent_id,description) VALUES ('${unit_name}',${root_unit_id},'${unit_name}');" | ${psql_cmd} ${db_name}
  else
    echo "INSERT INTO unit (name,parent_id,description) VALUES ('${unit_name}',(SELECT id FROM unit WHERE name = '${parent_unit_name}' AND id > ${root_unit_id}) ,'${unit_name}');" | ${psql_cmd} ${db_name}
  fi
done
