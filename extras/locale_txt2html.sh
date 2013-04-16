#!/bin/bash
HELPDIR=/opt/liquid_feedback_frontend/locale/help/
ROCKETWIKICMD=/opt/rocketwiki-lqfb/rocketwiki-lqfb

find ${HELPDIR} -name "*.txt" | while read file; do
	cat ${file} | ${ROCKETWIKICMD} >  ${file}.html
	echo "Converting file ${file}"
done
