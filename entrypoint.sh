#!/bin/bash

set -e
if [ -d '/ssh' ]; then
    mkdir -p /root/.ssh
    cp -rf /ssh/* /root/.ssh/
    find /root/.ssh -type d | xargs -n 1 chmod 700
    find /root/.ssh -type f | xargs -n 1 chmod 400
fi
set +e

function main() {
    if [ -f /root/.ssh/password ]; then
        echo '----------------------------------------------------------------------------'
        echo 'WARNING: Using password provided in file!'
        echo '         AND COMPLETELY IGNORING TAGET HOSTKEY!!!'
        echo '         THIS IS INSECURE!!!'
        echo '----------------------------------------------------------------------------'
        sshpass -p "$(cat /root/.ssh/password)" ${SSH_COMMAND} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $@
        return $?
    elif [ ! -z "${SSH_PASSWORD}" ]; then
        echo '----------------------------------------------------------------------------'
        echo 'WARNING: Using password provided in env ${SSH_PASSWORD}!'
        echo '         AND COMPLETELY IGNORING TAGET HOSTKEY!!!'
        echo '         THIS IS AN ENTIRELY DIFFERNT LEVEL OF INSECURE!!!'
        echo '----------------------------------------------------------------------------'
        sshpass -p "${SSH_PASSWORD}" ${SSH_COMMAND} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $@
        return $?
    else
        echo '----------------------------------------------------------------------------'
        echo 'WARNING: Using private key provided!'
        echo '         AND COMPLETELY IGNORING TAGET HOSTKEY!!!'
        echo '----------------------------------------------------------------------------'
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $@
        return $?
    fi
}

function countdown() {
    COUNT=${2}
    while [ ${COUNT} -ne 0 ]; do
        echo "${1} ${COUNT}..."
        sleep 1
        COUNT=$((${COUNT} - 1))
    done
}

[ -z "${DELAY_START}" ] && DELAY_START=3
[ -z "${DELAY_RETRY}" ] && DELAY_RETRY=${DELAY_START}
[ -z "${MAX_RETRY}" ] && MAX_RETRY=3

RETRIES=0
while [ ${RETRIES} -le ${MAX_RETRY} ]; do
    if [ ${RETRIES} -eq 0 ]; then
        echo "Delaying start for ${DELAY_START} seconds..."
        countdown "Starting in" ${DELAY_START}
    else
        echo "Delaying retry #${RETRIES} for ${DELAY_RETRY} seconds..."
        countdown "Retrying in" ${DELAY_RETRY}
    fi
    echo 'Delay done!~'
    main $@
    if [ $? -eq 0 ]; then
        echo "Shutting down gracefully..."
        exit 0
    fi
    RETRIES=$((${RETRIES} + 1))
done
echo "Number of maximum retries (${MAX_RETRY}) has been reached... Bye bye!~"
