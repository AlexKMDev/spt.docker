#!/bin/bash

if test -n "$(find /opt/server -maxdepth 0 -empty)"; then
	time cp -r /opt/srv/* /opt/server/

	CONTAINER_IP=0.0.0.0
	BACKEND_IP=$(curl -s ipv4.icanhazip.com)
	sed -ir 's/"ip": .*,/"ip": "'$CONTAINER_IP'",/' /opt/server/Aki_Data/Server/configs/http.json
	sed -ir 's/"backendIp": .*,/"backendIp": "'$BACKEND_IP'",/' /opt/server/Aki_Data/Server/configs/http.json
	chown -Rf $(id -u):$(id -g) /opt/server
	chmod -R g+rwx /opt/server
fi

/opt/server/Aki.Server.exe
