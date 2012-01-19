#!/bin/bash

prog=autossh
action=$1
remote_ip=$2
remote_port=$4
local_port=$3

start() {
	export AUTOSSH_PIDFILE="/var/run/autossh.$remote_ip.$remote_port.$local_port"
	$prog -M 0 -f -N -L $local_port:localhost:$remote_port root@$remote_ip

}

stop() {

	if [ $tun ]; then

		kill `ps axuwf|grep autossh|grep '8080:localhost:80 root@172.16.1.100'|awk '{print $2}'`
		exit;
	fi

	for i in `cat /var/run/autossh.*`

	do	
		kill $i
	done
	 
}

status() {
	
	stat=`ps axw|grep -v grep|grep -o "autossh.*"|sed -e 's/.* \([0-9]*:.\)/\1/g'`

        if [ -z "$stat" ]; then
		echo No tunnels are up
	        exit 2
	else 
		echo $stat
	fi
	
}

restart() {

	status
	st_file=/tmp/autossh.restart
	ps axw|grep -v grep|grep -o "autossh.*"|sed -e 's/.* \([0-9]*:.\)/\1/g'>$st_file
	stop
	cat $st_file | ( while read line
                do
                etmp=`echo $line|sed -e 's/\([0-9]*\):\(.*\):\([0-9]*\).*@\(.*\)/\4\.\1.\3/g'`
		export "AUTOSSH_PIDFILE=/var/run/autossh.$etmp"
		$prog -M 0 -f -N -L $line;        
	        done
                )
	unset AUTOSSH_PIDFILE
	rm $st_file
exit;
}


case "$1" in
        add)
                start
                ;;
        stop)
		tun=$2
                stop
                ;;
	status)
		status
		;;
	restart)
		restart
		;;
	*)
	echo -e "Tunnel creating script for autossh"
	echo -e "\n\t\tUsage: $0 (add|stop|status|restart)"
	echo -e "\t\t\tadd) requires extra arguments:"
	echo -e "\t\t\tremote ip address - address through which we will create tunnel" 
	echo -e "\t\t\tlocal port - to which you'll make requests locally"
	echo -e "\t\t\tremote port - port you want to forward from remote site"

        echo -e "\n\t\tExample: $0 add 172.16.1.100 4040 8080"
	echo -e "\n\t\t\tstop) - will kill all tunnels."
	echo -e "\t\t\tIf you need to stop only one - use stop and output of status command"
	echo -e "\n\t\tExample: $0 stop 8080:localhost:80 root@172.16.1.100 will stop only this tunnel" 
	echo -e "\n\t\t\trestart) - will restart all currently running tunnels"
	echo -e "\n\t\t\tstatus) - will show you all cuurently running tunnels\n"
	exit 2
	;;	
esac


