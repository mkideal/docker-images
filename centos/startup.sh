#!/bin/bash

function main() {
	local _repo=centos-dev
	local _name=centos-dev
	local _hostname=$_name
	local _shared=$HOME

	mkdir -p $_shared

	if [ ! "$(docker ps -q -f name=${_name})" ]; then
		if [ "$(docker ps -aq -f status=exited -f name=${_name})" ]; then
			echo "start docker container ${_name}"
			docker start ${_name}
		else
			echo "run docker container ${_name}"
			docker run --platform linux/amd64 -h $_hostname --init --name $_name -d -v ${_shared}:/shared \
				-p 2222:22 \
				$_repo
		fi
	else
		echo "docker container ${_name} already started!"
	fi
}

main $@
