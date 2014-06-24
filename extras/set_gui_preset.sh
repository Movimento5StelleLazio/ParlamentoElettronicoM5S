#!/bin/bash

if [ $# -lt 2 ];then
  echo "Usage: $0 <dbname> <gui_preset>"
  echo " "
  echo "  This script set the gui_preset in the liquid_feedback system_setting"
  echo "  Example: ./set_gui_preset.sh liquid_feedback custom"
  echo " "
  echo "  The script must be run as your httpd server user (i.e. www-data)"
  exit 1
fi
echo "UPDATE system_setting SET gui_preset = '$(echo $2|sed "s/'/\&apos;/g")' "|psql -qe -d $1 -U www-data -W
