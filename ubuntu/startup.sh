#!/bin/bash

function main() {
	local _repo=ubuntu-dev
	local _name=ubuntu-dev
	local _hostname=$_name
	local _shared=$HOME

	mkdir -p $_shared

	if [ ! "$(docker ps -q -f name=${_name})" ]; then
		if [ "$(docker ps -aq -f status=exited -f name=${_name})" ]; then
			echo "start docker container ${_name}"
			docker start ${_name}
		else
			echo "run docker container ${_name}"
			docker run -h $_hostname --init --name $_name -d -v ${_shared}:/shared \
				-p 8800:80 \
				-p 4433:443 \
				-p 2200:22 \
				$_repo
		fi
	else
		echo "docker container ${_name} already started!"
	fi
}

main $@
