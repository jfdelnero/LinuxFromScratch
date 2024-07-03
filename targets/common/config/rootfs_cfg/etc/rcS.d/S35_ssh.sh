#!/bin/sh

echo "---> Starting sshd..."

/sbin/sshd -f /etc/sshd_config
