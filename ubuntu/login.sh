#!/bin/bash

ssh_host=localhost
ssh_port=2200
ssh_user=$1
ssh_password=123456

if [ -z "$ssh_user" ]; then
	ssh_user=dev
fi

# Install sshpass on macOS:
#
# brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
#
# Install sshpass on Ubuntu:
#
# apt-get install sshpass

if hash sshpass 2>/dev/null; then
	sshpass -p $ssh_password ssh -oStrictHostKeyChecking=no -p $ssh_port $ssh_user@$ssh_host
else
	ssh -p $ssh_port $ssh_user@$ssh_host
fi
