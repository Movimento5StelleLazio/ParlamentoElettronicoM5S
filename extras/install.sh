#!/usr/bin/env bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

FRONTENDSRC=..
CORESRC=../../ParlamentoElettronicoM5SCore
WEBMCPSRC=webmcp
FRONTENDDST=../../liquid_feedback_frontend
COREDST=../../liquid_feedback_core
WEBMCPDST=../../webmcp
HELPDIR=${FRONTENDDST}/locale/help
ROCKETWIKICMD=../../rocketwiki-lqfb/rocketwiki-lqfb
CONFIGFILE=myconfig.lua
INITFILE=init.lua
LFUPDATED=lf_updated
INITSCRIPT=lf_updated.initrd
NOTIFYD=start_notify.sh
HTTPDUSER=www-data

if [ "z$(id -u)" != "z0" ];then
	"$0: Must be run as root user"
	exit 1
fi

auto=no
fast=no
while [ $# -gt 0 ]
do
    case "$1" in
    (-a) auto=yes;;
    (-h) echo "Usage: $0 [-a] [-h]"; echo "  -a    :Non interactive installation"; echo "  -h    :Print this help message"; exit 0;;
    (-f) fast=yes;;
    (-*) echo "Unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
    esac
    shift
done

export LANG=en_US.UTF-8

if [ "z${fast}" == "yes" ]; then
   echo $FRONTENDSRC/{app,db,env,fastpath,locale,model,static,tmp,utils}
   cp -a $FRONTENDSRC/{app, db, env, fastpath, locale, model, static, utils} ${FRONTENDDST}/
   echo $?
   echo "Fast copy done"
   exit 0
fi

if [ "z${auto}" == "no" ];then
	echo ""
	echo "Ready to install ParlamentoElettronicoM5S"
	echo "Please confirm installation parameters"
	echo ""
	echo "-------------------------------------------------------------------------"
	echo -e "Frontend source: \t${FRONTENDSRC}"
	echo -e "Core source: \t\t${CORESRC}"
	echo -e "WebMCP source: \t\t${WEBMCPSRC}"
	echo -e "Frontend destination: \t${FRONTENDDST}"
	echo -e "Core destination: \t${COREDST}"
	echo -e "WebMCP destination: \t${WEBMCPDST}"
	echo -e "Rocketwiki binary: \t${ROCKETWIKICMD}"
	echo -e "Configuration file: \t${CONFIGFILE}"
	echo -e "Init file: \t${INITFILE}"
	echo -e "lf_updated script: \t${LFUPDATED}"
	echo -e "notifyd script: \t${NOTIFYD}"
	echo -e "Web server user: \t${HTTPDUSER}"
	echo "-------------------------------------------------------------------------"
	echo ""
	echo "Please review the following scripts before continuing:"
	echo "     * ${LFUPDATED}"
	echo "     * ${INITSCRIPT}"
	echo "     * ${NOTIFYD}"
	echo ""
	echo -n "Proceed with installation? [y/n]: "
	read answer
	if [ "z${answer}" != "zy" ];then
		echo "Installation terminated by user"
		exit 0
	fi
fi

if ! [ $(id -u ${HTTPDUSER}) ];then 
	echo "Cannot find web server user ${HTTPDUSER}"
	echo "Installation failed!"
        exit 1
fi	

if ! [ -d "${FRONTENDSRC}" ]; then
        echo "Missing frontend installation source ${FRONTENDSRC}"
	echo "Installation failed!"
        exit 1
fi

if ! [ -d "${CORESRC}" ]; then
        echo "Missing core installation source ${CORESRC}"
	echo "Installation failed!"
        exit 1
fi

if ! [ -d "${WEBMCPSRC}" ]; then
        echo "Missing WebMCP installation source ${WEBMCPSRC}"
        echo "Installation failed!"
        exit 1
fi

if ! [ -f "${CONFIGFILE}" ]; then
        echo "Missing configuration file ${CONFIGFILE}"
	echo "Installation failed!"
        exit 1
fi

if ! [ -f "${INITFILE}" ]; then
        echo "Missing init file ${INITFILE}"
        echo "Installation failed!"
        exit 1
fi

if ! [ -f "${ROCKETWIKICMD}" ]; then
        echo "Cannot find rocketwiki ${ROCKETWIKICMD}"
	echo "Installation failed!"
        exit 1
fi

rm -rf ${FRONTENDDST} 2>/dev/null
mkdir -p ${FRONTENDDST} 
if ! [ -d "${FRONTENDDST}" ]; then
	echo "Unable to create directory ${COREDST}"
	echo "Installation failed!"
	exit 1
fi	

rm -rf ${COREDST}  2>/dev/null
mkdir -p ${COREDST} 
if ! [ -d "${COREDST}" ]; then
	echo "Unable to create directory ${COREDST}"
	echo "Installation failed!"
	exit 1
fi	

rm -rf ${WEBMCPDST} 2>/dev/null
mkdir -p ${WEBMCPDST}
if ! [ -d "${WEBMCPDST}" ]; then
        echo "Unable to create directory ${WEBMCPDST}"
        echo "Installation failed!"
        exit 1
fi

echo "Installing Frontend..."
echo $FRONTENDSRC/{app,db,env,fastpath,locale,model,static,tmp,utils}
cp -a $FRONTENDSRC/{app,db,env,fastpath,locale,model,static,tmp,utils} ${FRONTENDDST}
echo $?
mkdir -p ${FRONTENDDST}/config/
cp ${FRONTENDSRC}/extras/init.lua ${FRONTENDDST}/config/

echo "Changing ownership of tmp directory..."
chown ${HTTPDUSER} ${FRONTENDDST}/tmp

echo "Installing Core..."
cp -a ${CORESRC}/* ${COREDST} 

echo "Installing configuration file..."
cp ${CONFIGFILE} ${FRONTENDDST}/config

echo "Installing init file..."
cp ${INITFILE} ${FRONTENDDST}/config

echo "Compiling WebMCP..."
cd ${WEBMCPSRC}
make clean 1>/dev/null
make 1>/dev/null
cd -

echo "Installing WebMCP..."
cp -RL ${WEBMCPSRC}/framework/* ${WEBMCPDST}/

echo "Converting help files with rocketwiki..."
find ${FRONTENDDST}/locale/help/ -name "*.txt" | while read file; do
        cat ${file} |iconv -f utf-8| ${ROCKETWIKICMD} >  ${file}.html
done

echo "Compiling lf_update and lf_update_suggestion_order..."
cd ${COREDST} 
make clean
make
cd -

echo "Installing lf_update and lf_update_suggestion deamon script..."
chmod +x ${LFUPDATED}
cp ${LFUPDATED} ${COREDST}

echo "Installing inittrd script into /etc/init.d..."
chmod +x ${INITSCRIPT}
cp ${INITSCRIPT} /etc/init.d/lf_updated

echo "Activating daemon..."
update-rc.d-insserv lf_updated defaults

echo "Restarting update daemon..."
/etc/init.d/lf_updated restart

echo "Starting notifyd..."
echo "Starting lf_notifyd (send_notification_loop)..."
sleep 2

${NOTIFYD} 
rm nohup.out 2>/dev/null

echo "Cleaining..."
cd ${WEBMCPSRC}
make clean 1>/dev/null
cd -

chown -R $(id -g -n $(who am i | awk '{print $1}')):$(who am i | awk '{print $1}') $FRONTENDDST
chown -R $(id -g -n $(who am i | awk '{print $1}')):$(who am i | awk '{print $1}') $COREDST
chown -R $(id -g -n $(who am i | awk '{print $1}')):$(who am i | awk '{print $1}') $WEBMCPDST
chown -R www-data $FRONTENDDST/tmp

echo "Installation complete..."
