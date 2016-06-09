#!/bin/sh
RET=`ps aux | grep 'Event:send_notifications_loop()'|grep -v grep`

if [ "z${RET}" != "z" ]; then
	echo "Daemon already running.."
        rm nohup.out 2>/dev/null
	exit 1
else
	nohup  su - www-data -c 'cd /opt/liquid_feedback_frontend/;echo "Event:send_notifications_loop()" | ../webmcp/bin/webmcp_shell myconfig' 2>/dev/null&
        rm nohup.out 2>/dev/null
	echo "Daemon started"
fi 

exit 0
