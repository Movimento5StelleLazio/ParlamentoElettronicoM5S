#!/bin/bash
INSTANCE=liquid_feedback

if [ "$#" -lt 1 -o "$#" -gt 2 ];then
	echo "Utilizzo: $(basename $0) <invite code> [admin]"
	exit 1
fi

INVITE_CODE=\'$1\'

if [ "z$4" == "zadmin" ];then
	ADMIN=TRUE
else
	ADMIN=FALSE
fi

echo "INSERT INTO member (admin, invite_code) VALUES ( ${ADMIN}, ${INVITE_CODE});"|psql ${INSTANCE} -U www-data && echo "Utente creato"
