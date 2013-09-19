#!/bin/bash
if [ $# -lt 1 ];then
  echo "Usage: $0 <db_name>"
  exit 1
fi

db_name=$1
psql_cmd="/usr/bin/psql -e"

inputfile='lazio.csv'
subunits="subunits.list"
subquery="(SELECT id FROM unit WHERE name = '${rootunit}')"

if [ ! -f ${subunits} ];then
  echo "Cannot find list of subunits to create: ${subunits}"
  exit 1
fi

cat ${subunits} | while read unit; do
  echo "SELECT id,name FROM unit WHERE name ;" | psql -At -F, ${db_name}
#  root_unit_id=`echo "SELECT id FROM unit WHERE name = '${root_unit_name}';" | psql -At ${db_name}`
done

