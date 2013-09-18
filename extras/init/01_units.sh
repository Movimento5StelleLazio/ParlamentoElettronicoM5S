#!/bin/bash
if [ $# -lt 1 ];then
  echo "Usage: $0 <db_name>"
  exit 1
fi

db_name=$1
psql_cmd="/usr/bin/psql -e"

rootunit='Regione Lazio'
inputfile='lazio.csv'
subunits="subunits.list"
subquery="(SELECT id FROM unit WHERE name = '${rootunit}')"

if [ ! -f ${subunits} ];then
  echo "Cannot find list of subunits to create: ${subunits}"
  exit 1
fi

echo "INSERT INTO unit (name,parent_id,description) VALUES ('${rootunit}',NULL,'');" | ${psql_cmd} ${db_name}

cat ${subunits} | while read unit; do
  echo "INSERT INTO unit (name,parent_id,description) VALUES ('${unit}',${subquery},'');" | ${psql_cmd} ${db_name}
  ./_insert_units.sh ${inputfile} "${unit}" ${db_name}
done

