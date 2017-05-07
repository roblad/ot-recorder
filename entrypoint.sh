#!/bin/bash -x

    LC_ALL=en_US.UTF-8 
    #LANG=en_US.UTF-8 
	LANG=pl_PL.UTF-8 
    #LANGUAGE=en_US.UTF-8
	LANGUAGE=pl_PL.UTF-8

#  $OTR_STORAGEDIR
#  $OTR_HOST		MQTT hostname
#  $OTR_PORT		MQTT port
#  $OTR_USER
#  $OTR_PASS

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi
	
#/usr/sbin/mosquitto -d -c /etc/mosquitto/mosquitto.conf
#sleep 10 
#/usr/sbin/sshd -f /etc/ssh/sshd_config
#sleep 5 
ot-recorder --initialize
sleep 15 
#ot-recorder
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
