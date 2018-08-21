#!/bin/bash

service mysql start
service rsyslog start
service nginx start
service cron start

/usr/sbin/sshd -D

