#!/bin/bash
if [ $# -lt 1 ];then
  echo "Usage: $0 <db_name>"
  exit 1
fi

db_name=$1
psql_cmd="/usr/bin/psql"
assemblies="assemblies.list"
municipalities="municipalities.list"
min_resdidents=5000


subquery_province="(SELECT 'Regione '||b.nome_regione AS regione, 'Provincia di '||a.nome_provincia AS provincia FROM istat_province AS a JOIN istat_regioni AS b ON a.codice_regione = b.codice_regione)"
subquery_comuni="(SELECT 'Provincia di '||b.nome_provincia AS provincia, 'Comune di '||a.nome_comune AS comune FROM istat_comuni AS a JOIN istat_province AS b ON a.codice_provincia = b.codice_provincia AND replace(a.\"Popolazione residente al 31/12/2010\", '.', '')::integer >= ${min_resdidents})"

cat ${assemblies} | while read assembly; do
  # Country units
  echo "INSERT INTO unit (name,description) VALUES ('Italia','${assembly}');" | ${psql_cmd} -q ${db_name}
  # Regional units
  echo "INSERT INTO unit (name,parent_id,description) SELECT 'Regione '||nome_regione,(SELECT id FROM unit WHERE name = 'Italia' AND description = '${assembly}'),'${assembly}' FROM istat_regioni;" | ${psql_cmd} -q ${db_name}
  # Province units
  echo "INSERT INTO unit (name,parent_id,description) SELECT c.provincia, (SELECT id FROM unit WHERE name = c.regione AND description = '${assembly}'),'${assembly}' FROM ${subquery_province} AS c;"| ${psql_cmd} -q ${db_name}
  # City units
  echo "INSERT INTO unit (name,parent_id,description) SELECT c.comune, (SELECT min(id) FROM unit WHERE name = c.provincia AND description = '${assembly}' ),'${assembly}' FROM ${subquery_comuni} AS c;"| ${psql_cmd} -q ${db_name}
  # Special cases for municipality
  cat ${municipalities} | while read municipality;do
    echo "INSERT INTO unit (name,parent_id,description) SELECT '${municipality}', (SELECT id FROM unit WHERE name = 'Comune di Roma' and description = '${assembly}'),'${assembly}';"| ${psql_cmd} -q ${db_name}
  done
done

