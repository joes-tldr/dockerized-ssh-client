#!/bin/bash

set -e

if [ -d '/ssh' ]; then
    mkdir -p /root/.ssh
    cp -rf /ssh/* /root/.ssh/
    find /root/.ssh -type d | xargs -n 1 chmod 700
    find /root/.ssh -type f | xargs -n 1 chmod 400
fi

if [ -f /root/.ssh/password ]; then
    echo '----------------------------------------------------------------------------'
    echo 'WARNING: Using password provided in file!'
    echo '         AND COMPLETELY IGNORING TAGET HOSTKEY!!!'
    echo '         THIS IS INSECURE!!!'
    echo '----------------------------------------------------------------------------'
    sshpass -p "$(cat /root/.ssh/password)" ${SSH_COMMAND} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $@
elif [ ! -z "${SSH_PASSWORD}" ]; then
    echo '----------------------------------------------------------------------------'
    echo 'WARNING: Using password provided in env ${SSH_PASSWORD}!'
    echo '         AND COMPLETELY IGNORING TAGET HOSTKEY!!!'
    echo '         THIS IS AN ENTIRELY DIFFERNT LEVEL OF INSECURE!!!'
    echo '----------------------------------------------------------------------------'
    sshpass -p "${SSH_PASSWORD}" ${SSH_COMMAND} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $@
else
    echo '----------------------------------------------------------------------------'
    echo 'WARNING: Using private key provided!'
    echo '         AND COMPLETELY IGNORING TAGET HOSTKEY!!!'
    echo '----------------------------------------------------------------------------'
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $@
fi
